# Beer Wine Liquor Champagne
view: demographics_records {
  derived_table: {
    sql:
      SELECT
        * EXCEPT(first_name, last_name, latitude, longitude, email)
      FROM `looker-private-demo.ecomm.users`
      WHERE country = 'USA'
    ;;
    persist_for: "1000 hours"
  }

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql:
      CASE
        WHEN ${TABLE}.age < 21 THEN ${TABLE}.age + 10
        ELSE ${TABLE}.age
       END
    ;;
  }

  dimension: age_bucket {
    type: number
    sql:
      CASE
        WHEN ${age} >= 21 AND ${age} <= 30 THEN '21-30'
        WHEN ${age} >= 31 AND ${age} <= 40 THEN '31-40'
        WHEN ${age} >= 41 AND ${age} <= 50 THEN '41-50'
        WHEN ${age} >= 51 AND ${age} <= 60 THEN '51-60'
        WHEN ${age} >= 61 AND ${age} <= 70 THEN '61-70'
        WHEN ${age} >= 71 AND ${age} <= 80 THEN '71-80'
        WHEN ${age} >= 81 AND ${age} <= 90 THEN '81-90'
        ELSE '91-100'
      END
    ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    drill_fields: [state,zip,city]
    html: <img @{SMALL_FLAG_STYLE} src="@{CF_MAP_URL_BASE}@{ISO3_TO_ISO2}@{CF_MAP_URL_SUFFIX}"/><span> {{ value }}</span> ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    drill_fields: [zip,city]
    map_layer_name: us_states
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
    drill_fields: [city]
    map_layer_name: us_zipcode_tabulation_areas
  }

  ## Measures
  measure: population_count {
    type: count
    drill_fields: [id, gender, age_bucket, city, state, zip, country]
  }

  measure: beer {
    group_label: "Category Affinities"
    type: sum
    sql: ${affinity_by_age.c_beer_aff} ;;
    value_format_name: decimal_0
  }

  measure: liquor {
    group_label: "Category Affinities"
    type: sum
    sql: ${affinity_by_age.c_liquor_aff} ;;
    value_format_name: decimal_0
  }

  measure: wine {
    group_label: "Category Affinities"
    type: sum
    sql: ${affinity_by_age.c_wine_aff} ;;
    value_format_name: decimal_0
  }

  measure: champagne {
    group_label: "Category Affinities"
    type: sum
    sql: ${affinity_by_age.c_champagne_aff} ;;
    value_format_name: decimal_0
  }

  measure: liqueur {
    group_label: "Category Affinities"
    type: sum
    sql: ${affinity_by_age.c_liqueur_aff} ;;
    value_format_name: decimal_0
  }

  measure: ale {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_ale_aff} ;;
    value_format_name: decimal_0
  }

  measure: brut {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_brut_aff} ;;
    value_format_name: decimal_0
  }

  measure: herbal {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_herbal_aff} ;;
    value_format_name: decimal_0
  }

  measure: triplesec {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_triplesec_aff} ;;
    value_format_name: decimal_0
  }

  measure: brandy {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_brandy_aff} ;;
    value_format_name: decimal_0
  }

  measure: vodka {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_vodka_aff} ;;
    value_format_name: decimal_0
  }

  measure: tequila {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_tequila_aff} ;;
    value_format_name: decimal_0
  }

  measure: gin {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_gin_aff} ;;
    value_format_name: decimal_0
  }

  measure: whiskey {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_whiskey_aff} ;;
    value_format_name: decimal_0
  }

  measure: absinthe {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_absinthe_aff} ;;
    value_format_name: decimal_0
  }

  measure: merlot {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_merlot_aff} ;;
    value_format_name: decimal_0
  }

  measure: chardonnay {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_chardonnay_aff} ;;
    value_format_name: decimal_0
  }

  measure: malbec {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_malbec_aff} ;;
    value_format_name: decimal_0
  }

  measure: zinfandel {
    group_label: "Sub Category Affinities"
    type: sum
    sql: ${affinity_by_age.s_zinfandel_aff} ;;
    value_format_name: decimal_0
  }

}
