view: order_items {
  derived_table: {
    sql:
      SELECT
          o.*
        , SUBSTR(u.first_name, 1, 1) || SUBSTR(u.last_name, 1, 1) AS retailer_id
      FROM looker-private-demo.ecomm.order_items o
      LEFT JOIN looker-private-demo.ecomm.users u ON (o.user_id = u.id)
      WHERE 1=1
      AND u.country = 'USA'
      AND o.id IS NOT NULL
      AND o.order_id IS NOT NULL
    ;;
    # needed to join only to the retailers considered (US)
    persist_for: "1000 hours"
  }

  ########## IDs, Foreign Keys, Counts ###########

  dimension: id {
    label: "Order Item ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: no
    sql: ${TABLE}.inventory_item_id ;;
  }

  # dimension: user_id {
  #   type: number
  #   hidden: yes
  #   sql: ${TABLE}.user_id ;;
  # }

  dimension: retailer_id {
    hidden: yes
    type: string
    sql: ${TABLE}.retailer_id ;;
  }

  ## MTD
  dimension: current_date {
    group_label: "MTD"
    hidden: yes
    sql: CURRENT_DATE() ;;
  }

  dimension: current_day_number {
    group_label: "MTD"
    type: number
    hidden: yes
    sql: EXTRACT(DAY FROM ${current_date}) ;;
  }

  dimension: days_in_previous_month {
    group_label: "MTD"
    type: number
    hidden: yes
    sql:
      CASE
        WHEN EXTRACT(MONTH FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)) IN (1,3,5,7,8,10,12) THEN 31
        WHEN EXTRACT(MONTH FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)) = 2 THEN 28
        ELSE 30
      END
    ;;
  }

  dimension: is_current_month_to_date {
    group_label: "MTD"
    type: yesno
    hidden: yes
    sql: DATE(DATE_TRUNC(${created_raw}, MONTH)) = DATE_TRUNC(CURRENT_DATE(), MONTH) ;;
  }

  dimension: previous_month_to_date_days {
    group_label: "MTD"
    hidden: yes
    sql:
      CASE
        WHEN ${current_day_number} > ${days_in_previous_month} THEN ${days_in_previous_month}
        ELSE ${current_day_number}
      END
    ;;
  }

  dimension: is_previous_month_to_date {
    group_label: "MTD"
    hidden: yes
    type: yesno
    sql:
      DATE(${created_raw}) <= DATE_ADD(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH), INTERVAL ${previous_month_to_date_days} - 1 DAY)
      AND
      DATE_TRUNC(DATE(${created_raw}), MONTH) = DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH)
    ;;
  }
  ## /MTD

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: mtd_count {
    label: "Current MTD Count"
    group_label: "MTD"
    type: count
    filters: [is_current_month_to_date: "Yes"]
    drill_fields: [detail*]
  }

  measure: prev_mtd_count {
    label: "Previous MTD Count"
    group_label: "MTD"
    type: count
    filters: [is_previous_month_to_date: "Yes"]
    drill_fields: [detail*]
  }


  measure: count_last_28d { #fix
    label: "Count Sold in Trailing 28 Days"
    type: count_distinct
    sql: ${id} ;;
    hidden: yes
    filters: {
      field:created_date
      value: "28 days"
    }
  }

  measure: order_count {
    view_label: "Orders"
    type: count_distinct
    drill_fields: [detail*]
    sql: ${order_id} ;;
  }

  measure: first_purchase_count { #fix
    view_label: "Orders"
    type: count_distinct
    sql: ${order_id} ;;
    filters: {
      field: order_facts.is_first_purchase
      value: "Yes"
    }
    drill_fields: [retailer_id, retailers.name, retailers.email, order_id, created_date, retailers.traffic_source]
  }

  dimension: order_id_no_actions {
    type: number
    hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_id {
    view_label: "Orders"
    type: number
    sql: ${TABLE}.order_id ;;
    action: {
      label: "Send this to slack channel"
      url: "https://hooks.zapier.com/hooks/catch/1662138/tvc3zj/"
      param: {
        name: "user_dash_link"
        value: "/dashboards/ayalascustomerlookupdb?Email={{ retailers.email._value}}"
      }
      form_param: {
        name: "Message"
        type: textarea
        default: "Hey,
        Could you check out order #{{value}}. It's saying its {{status._value}},
        but the customer is reaching out to us about it.
        ~{{ _user_attributes.first_name}}"
      }
      form_param: {
        name: "Recipient"
        type: select
        default: "zevl"
        option: {
          name: "zevl"
          label: "Zev"
        }
        option: {
          name: "slackdemo"
          label: "Slack Demo User"
        }
      }
      form_param: {
        name: "Channel"
        type: select
        default: "cs"
        option: {
          name: "cs"
          label: "Customer Support"
        }
        option: {
          name: "general"
          label: "General"
        }
      }
    }
    action: {
      label: "Create Order Form"
      url: "https://hooks.zapier.com/hooks/catch/2813548/oosxkej/"
      form_param: {
        name: "Order ID"
        type: string
        default: "{{ order_id._value }}"
      }

      form_param: {
        name: "Name"
        type: string
        default: "{{ retailers.name._value }}"
      }

      form_param: {
        name: "Email"
        type: string
        default: "{{ _user_attributes.email }}"
      }

      form_param: {
        name: "Item"
        type: string
        default: "{{ products.item_name._value }}"
      }

      form_param: {
        name: "Price"
        type: string
        default: "{{ order_items.sale_price._rendered_value }}"
      }

      form_param: {
        name: "Comments"
        type: string
        default: " Hi {{ retailers.first_name._value }}, thanks for your business!"
      }
    }
  }

  ########## Time Dimensions ##########

  dimension_group: returned {
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.returned_at ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [date, week, month, raw]
    sql: CAST(${TABLE}.shipped_at AS TIMESTAMP) ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [date, week, month, raw]
    sql: CAST(${TABLE}.delivered_at AS TIMESTAMP) ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, hour, date, week, month, year, hour_of_day, day_of_week, month_num, raw, week_of_year,month_name]
    sql: ${TABLE}.created_at ;;
  }

  dimension: reporting_period {
    group_label: "Order Date"
    sql: CASE
        WHEN EXTRACT(YEAR from ${created_raw}) = EXTRACT(YEAR from CURRENT_TIMESTAMP())
        AND ${created_raw} < CURRENT_TIMESTAMP()
        THEN 'This Year to Date'

        WHEN EXTRACT(YEAR from ${created_raw}) + 1 = EXTRACT(YEAR from CURRENT_TIMESTAMP())
        AND CAST(FORMAT_TIMESTAMP('%j', ${created_raw}) AS INT64) <= CAST(FORMAT_TIMESTAMP('%j', CURRENT_TIMESTAMP()) AS INT64)
        THEN 'Last Year to Date'

      END
       ;;
  }

  dimension: days_since_sold {
    hidden: yes
    sql: TIMESTAMP_DIFF(${created_raw},CURRENT_TIMESTAMP(), DAY) ;;
  }

  dimension: months_since_signup {
    view_label: "Orders"
    type: number
    sql: CAST(FLOOR(TIMESTAMP_DIFF(${created_raw}, ${retailers.created_raw}, DAY)/30) AS INT64) ;;
  }

########## Logistics ##########

  dimension: status {
    sql: ${TABLE}.status ;;
  }

  dimension: days_to_process {
    type: number
    sql: CASE
        WHEN ${status} = 'Processing' THEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), ${created_raw}, DAY)*1.0
        WHEN ${status} IN ('Shipped', 'Complete', 'Returned') THEN TIMESTAMP_DIFF(${shipped_raw}, ${created_raw}, DAY)*1.0
        WHEN ${status} = 'Cancelled' THEN NULL
      END
       ;;
  }

  dimension: shipping_time {
    description: "Shipping time in days"
    type: number
    sql: TIMESTAMP_DIFF(${delivered_raw}, ${shipped_raw}, DAY) * 1.0 ;;
  }

  measure: average_days_to_process {
    group_label: "Order Processing Measures"
    type: average
    value_format_name: decimal_2
    sql: ${days_to_process} ;;
  }

  measure: average_shipping_time {
    group_label: "Order Processing Measures"
    type: average
    value_format_name: decimal_2
    sql: ${shipping_time} ;;
  }

########## Financial Information ##########

  dimension: sale_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.sale_price ;;
  }

  dimension: gross_margin {
    group_label: "Gross Margin"
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  dimension: item_gross_margin_percentage {
    group_label: "Gross Margin"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${gross_margin} / NULLIF(${sale_price}, 0) ;;
  }

  dimension: item_gross_margin_percentage_tier {
    group_label: "Gross Margin"
    type: tier
    sql: 100.0 * ${item_gross_margin_percentage} ;;
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90]
    style: interval
  }

  measure: total_sale_price {
    group_label: "Sale Price Measures"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: mtd_total_sale_price {
    label: "Current MTD Sales"
    group_label: "MTD"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: [is_current_month_to_date: "Yes"]
    drill_fields: [detail*]
  }

  measure: prev_mtd_total_sale_price {
    label: "Previous MTD Sales"
    group_label: "MTD"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: [is_previous_month_to_date: "Yes"]
    drill_fields: [detail*]
  }

  measure: mtd_total_sale_price_differential {
    label: "Total Revenue Delta $ (This - Last)"
    group_label: "MTD"
    type: number
    value_format_name: usd
    sql: ${mtd_total_sale_price} - ${prev_mtd_total_sale_price} ;;
    drill_fields: [detail*]
    html:
      {% if value >= 500 %}
        <div style="width: 100%; background: darkgreen; color:white">{{ rendered_value }}</div>
      {% elsif value >= 100 and value < 500 %}
        <div style="width: 100%; background: lime; color:black">{{ rendered_value }}</div>
      {% elsif value > 0 and value < 100 %}
        <div style="width: 100%; background: palegreen; color:black">{{ rendered_value }}</div>
      {% elsif value > -100 and value < 0 %}
        <div style="width: 100%; background: lightyellow; color:black">{{ rendered_value }}</div>
      {% elsif value <= -100 and value > -500 %}
        <div style="width: 100%; background: orange; color:black">{{ rendered_value }}</div>
      {% else %}
        <div style="width: 100%; background: red; color:white">{{ rendered_value }}</div>
      {% endif %}
    ;;
  }


  measure: mtd_filter_measure {
    description: "Current MTD Total Sale Price + Previous MTD Total Sale Price"
    group_label: "MTD"
    type: number
    value_format_name: usd
    sql: ${mtd_total_sale_price} + ${prev_mtd_total_sale_price} ;;
  }

  measure: mtd_total_sale_price_differential_percent {
    description: "Total Revenue Delta % (This - Last)"
    label: "Revenue Delta %"
    group_label: "MTD"
    type: number
    sql: 1.0 * (${mtd_total_sale_price} - ${prev_mtd_total_sale_price}) / NULLIF(${prev_mtd_total_sale_price}, 0) ;;
    value_format_name: percent_1
    html:
      {% if value >= 0.2 %}
        <div style="width: 100%; background: darkgreen; color:white">{{ rendered_value }}</div>
      {% elsif value >= 0.05 and value < 0.2 %}
        <div style="width: 100%; background: lightgreen; color:black">{{ rendered_value }}</div>
      {% elsif value > -0.05 and value < 0.05 %}
        <div style="width: 100%; color:black">{{ rendered_value }}</div>
      {% elsif value <= -0.05 and value > -0.2 %}
        <div style="width: 100%; background: orange; color:black">{{ rendered_value }}</div>
      {% else %}
        <div style="width: 100%; background: red; color:white">{{ rendered_value }}</div>
      {% endif %}
    ;;
  }

  ## Dynamic Measure
  parameter: dynamic_measure_selector {
    description: "Use with Dynamic Measure"
    type: unquoted
    default_value: "total_revenue"
    allowed_value: {
      label: "Total Units Sold"
      value: "total_units_sold"
    }
    allowed_value: {
      label: "Total Revenue"
      value: "total_revenue"
    }
    # allowed_value: {
    #   label: "Total Revenue This Month"
    #   value: "total_revenue_this_month"
    # }
    allowed_value: {
      label: "Total Gross Margin Percentage"
      value: "total_gross_margin_percentage"
    }
  }

  measure: dynamic_measure {
    description: "Use with Dynamic Measure Selector"
    label_from_parameter: dynamic_measure_selector
    type: number
    sql:
      {% if dynamic_measure_selector._parameter_value == "total_units_sold" %}
        ${count}
      {% elsif dynamic_measure_selector._parameter_value == "total_revenue" %}
        ${total_sale_price}
      {% elsif dynamic_measure_selector._parameter_value == "total_revenue_this_month" %}
        ${mtd_total_sale_price}
      {% elsif dynamic_measure_selector._parameter_value == "total_gross_margin_percentage" %}
        ${total_gross_margin_percentage}
      {% else %}
        ${count}
      {% endif %}
    ;;
    html:
      {% if dynamic_measure_selector._parameter_value == "total_units_sold" %}
        {{ count._value }}
      {% elsif dynamic_measure_selector._parameter_value == "total_revenue" %}
        ${{ total_sale_price._value | round: 2 }}
      {% elsif dynamic_measure_selector._parameter_value == "total_revenue_this_month" %}
        ${{ mtd_total_sale_price._value | round: 2 }}
      {% elsif dynamic_measure_selector._parameter_value == "total_gross_margin_percentage" %}
        {{ total_gross_margin_percentage._value | round: 2 }}%
      {% else %}
        {{ count }}
      {% endif %}
    ;;
  }
  ##

  ## Dynamic Measure
  parameter: dynamic_pivot_selector {
    description: "Use with Dynamic Measure"
    type: unquoted
    default_value: "total_revenue"
    allowed_value: {
      label: "Total Units Sold"
      value: "total_units_sold"
    }
    allowed_value: {
      label: "Total Revenue"
      value: "total_revenue"
    }
    # allowed_value: {
    #   label: "Total Revenue This Month"
    #   value: "total_revenue_this_month"
    # }
    allowed_value: {
      label: "Total Gross Margin Percentage"
      value: "total_gross_margin_percentage"
    }
  }

  # measure: dynamic_dimension {
  #   description: "Use with Dynamic Measure Selector"
  #   label_from_parameter: dynamic_measure_selector
  #   type: number
  #   sql:
  #     {% if dynamic_measure_selector._parameter_value == "total_units_sold" %}
  #       ${count}
  #     {% elsif dynamic_measure_selector._parameter_value == "total_revenue" %}
  #       ${total_sale_price}
  #     {% elsif dynamic_measure_selector._parameter_value == "total_revenue_this_month" %}
  #       ${mtd_total_sale_price}
  #     {% elsif dynamic_measure_selector._parameter_value == "total_gross_margin_percentage" %}
  #       ${total_gross_margin_percentage}
  #     {% else %}
  #       ${count}
  #     {% endif %}
  #   ;;
  #   html:
  #     {% if dynamic_measure_selector._parameter_value == "total_units_sold" %}
  #       {{ count._value }}
  #     {% elsif dynamic_measure_selector._parameter_value == "total_revenue" %}
  #       ${{ total_sale_price._value | round: 2 }}
  #     {% elsif dynamic_measure_selector._parameter_value == "total_revenue_this_month" %}
  #       ${{ mtd_total_sale_price._value | round: 2 }}
  #     {% elsif dynamic_measure_selector._parameter_value == "total_gross_margin_percentage" %}
  #       {{ total_gross_margin_percentage._value | round: 2 }}%
  #     {% else %}
  #       {{ count }}
  #     {% endif %}
  #   ;;
  # }


  measure: total_gross_margin {
    group_label: "Gross Margin Measures"
    type: sum
    value_format_name: usd
    sql: ${gross_margin} ;;
    drill_fields: [detail*]
  }

  measure: average_sale_price {
    group_label: "Sale Price Measures"
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: median_sale_price {
    group_label: "Sale Price Measures"
    type: median
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: average_gross_margin {
    group_label: "Gross Margin Measures"
    type: average
    value_format_name: usd
    sql: ${gross_margin} ;;
    drill_fields: [detail*]
  }

  measure: total_gross_margin_percentage {
    group_label: "Gross Margin Measures"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${total_gross_margin}/ nullif(${total_sale_price},0) ;;
  }

  measure: average_spend_per_retailer {
    group_label: "Retailer Measures"
    type: number
    value_format_name: usd
    sql: 1.0 * ${total_sale_price} / nullif(${retailers.count},0) ;;
    drill_fields: [detail*]
  }

########## Return Information ##########

  dimension: is_returned {
    type: yesno
    sql: ${returned_raw} IS NOT NULL ;;
  }

  measure: returned_count {
    group_label: "Returned Measures"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: is_returned
      value: "yes"
    }
    drill_fields: [detail*]
  }

  measure: returned_total_sale_price {
    group_label: "Returned Measures"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: {
      field: is_returned
      value: "yes"
    }
  }

  measure: return_rate {
    group_label: "Returned Measures"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${returned_count} / nullif(${count},0) ;;
  }


########## Repeat Purchase Facts ##########

  dimension: days_until_next_order {
    type: number
    view_label: "Repeat Purchase Facts"
    sql: TIMESTAMP_DIFF(${created_raw}, ${repeat_purchase_facts.next_order_raw}, DAY) ;;
  }

  dimension: repeat_orders_within_30d {
    type: yesno
    view_label: "Repeat Purchase Facts"
    sql: ${days_until_next_order} <= 30 ;;
  }

  dimension: repeat_orders_within_15d{
    type: yesno
    sql:  ${days_until_next_order} <= 15;;
  }

  measure: count_with_repeat_purchase_within_30d {
    type: count_distinct
    sql: ${id} ;;
    view_label: "Repeat Purchase Facts"

    filters: {
      field: repeat_orders_within_30d
      value: "Yes"
    }
  }

  measure: 30_day_repeat_purchase_rate {
    description: "The percentage of customers who purchase again within 30 days"
    view_label: "Repeat Purchase Facts"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_with_repeat_purchase_within_30d} / (CASE WHEN ${count} = 0 THEN NULL ELSE ${count} END) ;;
    drill_fields: [products.name, order_count, count_with_repeat_purchase_within_30d]
  }

  set: detail {
    fields: [id, order_id, status, created_date, sale_price, products.name, retailers.name, retailers.email]
  }
  set: return_detail {
    fields: [id, order_id, status, created_date, returned_date, sale_price, products.name, retailers.name, retailers.email]
  }
}
