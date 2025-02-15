view: inventory_items {
  derived_table: {
    sql:
      SELECT
          i.*
      FROM  looker-private-demo.ecomm.inventory_items i
      LEFT JOIN looker-private-demo.ecomm.order_items o ON (i.id = o.inventory_item_id)
      LEFT JOIN looker-private-demo.ecomm.users u ON (o.user_id = u.id)
      WHERE u.country = 'USA'
    ;;
    persist_for: "1000 hours"
  }
  # sql_table_name: looker-private-demo.ecomm.inventory_items ;;

  dimension: id {
    label: "Inventory Item ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    value_format_name: usd
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month, raw]
    sql: CAST(${TABLE}.created_at AS TIMESTAMP) ;;
  }

  dimension: product_id {
    type: number
    hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.sold_at ;;
  }

  dimension: is_sold {
    type: yesno
    sql: ${sold_raw} IS NOT NULL ;;
  }

  dimension: is_sold_pending_shipping {
    type: yesno
    sql: ${order_items.status} = 'Processing' ;;
  }

  dimension: days_in_inventory {
    group_label: "Durations"
    description: "Days between arrived in inventory and sold date"
    type: number
    sql: TIMESTAMP_DIFF(coalesce(${sold_raw}, CURRENT_TIMESTAMP()), ${created_raw}, DAY) ;;
  }

  dimension: days_in_inventory_tier {
    group_label: "Durations"
    type: tier
    sql: ${days_in_inventory} ;;
    style: integer
    tiers: [0, 5, 10, 20, 40, 80, 160, 360]
  }

  dimension: days_since_arrival {
    group_label: "Durations"
    description: "Days since arrived in inventory"
    type: number
    sql: TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), ${created_raw}, DAY) ;;
  }

  dimension: days_since_arrival_tier {
    group_label: "Durations"
    type: tier
    sql: ${days_since_arrival} ;;
    style: integer
    tiers: [0, 5, 10, 20, 40, 80, 160, 360]
  }

  dimension: product_distribution_center_id {
    hidden: yes
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  ## MEASURES ##

  measure: sold_count {
    type: count
    drill_fields: [detail*]

    filters: {
      field: is_sold
      value: "Yes"
    }
  }

  measure: sold_percent {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${sold_count} / ( CASE WHEN ${count} = 0 THEN NULL ELSE ${count} END ) ;;
  }

  measure: total_cost {
    type: sum
    value_format_name: usd
    sql: ${cost} ;;
  }

  measure: average_cost {
    type: average
    value_format_name: usd
    sql: ${cost} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: number_on_hand {
    type: count
    drill_fields: [detail*]

    filters: {
      field: is_sold
      value: "No"
    }
  }

  # measure: stock_coverage_ratio {
  #   type:  number
  #   description: "Stock on Hand vs Trailing 28d Sales Ratio"
  #   sql:  1.0 * ${number_on_hand} / nullif(${order_items.count_last_28d} * 20.0, 0) ;;
  #   value_format_name: decimal_2
  #   html: <p style="color: black; background-color: rgba({{ value | times: -100.0 | round | plus: 250 }},{{value | times: 100.0 | round | plus: 100}},100,80); font-size:100%; text-align:center">{{ rendered_value }}</p> ;;
  # }

  set: detail {
    fields: [id, products.category, products.sub_category, products.name, cost, created_time, sold_time]
  }
}
