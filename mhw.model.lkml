connection: "jasoncascio-bigquery"
include: "/views/*"
include: "/mock_views/*"


datagroup: ecommerce_etl {
  sql_trigger: SELECT max(created_at) FROM ecomm.events ;;
  max_cache_age: "24 hours"
}
persist_with: ecommerce_etl


##### (1) Orders & Retailers
explore: order_items {
  view_label: "Order Items"
  label: "(1) Orders & Retailers"

  join: inventory_items {
    #Left Join only brings in items that have been sold as order_item
    type: full_outer
    relationship: one_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${distribution_centers.id} = ${inventory_items.product_distribution_center_id} ;;
    relationship: many_to_one
  }

  join: retailers {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.retailer_id} = ${retailers.id} ;;
  }

  join: order_facts {
    type: left_outer
    view_label: "Orders"
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
  }

  join: retailer_order_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.retailer_id} = ${retailer_order_facts.retailer_id} ;;
  }

  join: repeat_purchase_facts {
    relationship: many_to_one
    type: full_outer
    sql_on: ${order_items.order_id} = ${repeat_purchase_facts.order_id} ;;
  }

  join: reference {}

}


##### (2) Demographics Insights
explore: demographics_records {
  label: "(2) Demographics Insights"

  join: affinity_by_age {
    type: left_outer
    relationship: many_to_one
    sql_on: ${demographics_records.age_bucket} = ${affinity_by_age.age_bucket} ;;
  }

  join: affinity_by_state {
    type: left_outer
    relationship: many_to_one
    sql_on: ${demographics_records.state} = ${affinity_by_state.state} ;;
  }

  join: affinity_by_income {
    type: left_outer
    relationship: many_to_one
    sql_on: ${demographics_records.income_tier} = ${affinity_by_income.income_tier} ;;
  }

  join: affinity_by_marital_status {
    type: left_outer
    relationship: many_to_one
    sql_on: ${demographics_records.marital_status} = ${affinity_by_marital_status.marital_status} ;;
  }

}




# order_items - inventory_items - product - retailer...
# relate to demographic using study level
# filter on fields from oi.date, retailer, demographic
explore: products_reference {}

view: goldmine_filters {

  parameter: study_level {
    type: unquoted
    default_value: "city_state"
    allowed_value: {
      label: "City"
      value: "city_state"
    }
    allowed_value: {
      label: "State"
      value: "state"
    }
    allowed_value: {
      label: "Zip"
      value: "zip"
    }
    allowed_value: {
      label: "Region"
      value: "region"
    }
    allowed_value: {
      label: "Sub Region"
      value: "sub_region"
    }
  }

  filter: category {
    suggest_explore: products_reference
    suggest_dimension: category
  }

  filter: sub_category {
    suggest_explore: products_reference
    suggest_dimension: sub_category
  }

}




# explore: brand_insights_demographics {
#   view_name: demographics_records
#   view_label: "Demographics"
#   label: "(3) Brand Insights"

#   join: retailers {
#     type: left_outer
#     relationship: many_to_many
#     sql_on:
#       {% if goldmine_filters._parameter_value }
#       ${order_items.retailer_id} = ${retailers.id}
#     ;;
#   }

#   join: order_items {
#     type: inner
#   }

#   join: inventory_items {
#     #Left Join only brings in items that have been sold as order_item
#     type: full_outer
#     relationship: one_to_one
#     sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
#   }

#   join: products {
#     type: left_outer
#     relationship: many_to_one
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#   }



#   join: goldmine_filters {}
#   join: reference {}

# }
