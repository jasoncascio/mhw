# group products by first letter of brand
view: products_cleansed {
  derived_table: {
    sql:
      SELECT
          * EXCEPT(brand, department, category, name, sku)
        , CASE
            WHEN UPPER(SUBSTR(TRIM(brand), 1, 1)) IN ('0','1','2','3','4','5','6','7','8','9','\'','!','','[') THEN 'X'
            ELSE UPPER(SUBSTR(TRIM(brand), 1, 1))
          END AS cleansed_initial
      FROM `looker-private-demo.ecomm.products`
    ;;
    persist_for: "1000 hours"
  }
}

# join in new brand information by first letter
view: brand_joined_products {
  derived_table: {
    sql:
      SELECT
          *
      FROM ${products_cleansed.SQL_TABLE_NAME} bc
      LEFT JOIN `jasoncascio.mhw.brands` b ON (bc.cleansed_initial = b.initial)
    ;;
    persist_for: "1000 hours"
  }
}

# persist new products, removing initials used for grouping
view: products {
  derived_table: {
    sql:
      SELECT
          * EXCEPT(cleansed_initial, initial)
        , CASE
            WHEN image_name LIKE '%.jpg' THEN '@{IMG_PRODUCT_URL_BASE}' || image_name
            ELSE '@{IMG_PRODUCT_URL_BASE}' || image_name || '.jpg'
          END AS image_url
      FROM ${brand_joined_products.SQL_TABLE_NAME}
    ;;
    persist_for: "1000 hours"
  }

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
    value_format_name: usd
  }

  dimension: distribution_center_id {
    hidden: yes
    type: number
    sql: CAST(${TABLE}.distribution_center_id AS INT64) ;;
  }

  dimension: image_url {
    type: string
    sql: ${TABLE}.image_url ;;
  }

  dimension: image {
    type: string
    sql: ${image_url} ;;
    html: <img style="height: 150px;" src="{{ value }}" /> ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    # link: {
    #   label: "{{value}} Analytics Dashboard"
    #   url: "/dashboards/CRMxoGiGJUv4eGALMHiAb0?Brand%20Name={{ value | encode_uri }}"
    #   icon_url: "http://www.looker.com/favicon.ico"
    # }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: sub_category {
    type: string
    sql: ${TABLE}.sub_category ;;
  }

  dimension: alcohol_percent {
    group_label: "Proof"
    type: number
    sql: CAST(${TABLE}.alcohol_percent AS NUMERIC) / 100.0 ;;
    value_format_name: percent_1
  }

  dimension: alcohol_percent_tier {
    group_label: "Proof"
    type: tier
    sql: ${alcohol_percent} ;;
    style: integer
    tiers: [10,20,30,40,50]
  }

  dimension: proof {
    group_label: "Proof"
    type: number
    sql: 2.0 * ${alcohol_percent} ;;
  }

  dimension: proof_tier {
    group_label: "Proof"
    type: tier
    sql: ${proof} ;;
    style: integer
    tiers: [10,20,30,40,50,60,70,80,90]
  }

  ## Measures

  measure: count {
    group_label: "Counts"
    type: count_distinct
    sql: ${name} ;;
    drill_fields: [detail*]
  }

  measure: category_count {
    group_label: "Counts"
    type: count_distinct
    sql: ${category} ;;
    drill_fields: [detail*]
  }

  measure: sub_category_count {
    group_label: "Counts"
    type: count_distinct
    sql: ${category} ;;
    drill_fields: [detail*]
  }

  set: detail {
    fields: [name, category, sub_category, proof, retail_price]
  }
}

view: products_reference {
  derived_table: {
    sql:
      SELECT DISTINCT
          category
        , sub_category
      FROM ${products.SQL_TABLE_NAME}
    ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: sub_category {
    type: string
    sql: ${TABLE}.sub_category ;;
  }
}
