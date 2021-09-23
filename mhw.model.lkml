connection: "jasoncascio-bigquery"
include: "/views/*"
include: "/mock_views/*"

explore: retailers {}
explore: products {}
explore: retailers_p2 {}
explore: retailer_order_facts {}

datagroup: ecommerce_etl {
  sql_trigger: SELECT max(created_at) FROM ecomm.events ;;
  max_cache_age: "24 hours"
}
persist_with: ecommerce_etl

explore: order_items {
  view_label: "Order Items"
  label: "(1) Orders & Retailers"

  join: inventory_items {
    #Left Join only brings in items that have been sold as order_item
    type: full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
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

}