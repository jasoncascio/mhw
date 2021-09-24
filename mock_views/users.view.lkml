view: demographics {
  derived_table: {
    sql:
      SELECT * FROM `looker-private-demo.ecomm.users`


    ;;
    persist_for: "1000 hours"
  }


# 2 Beer  Ale Half Hitch Brewing  4.5%
# 3 Champagne Brut  Montaudon Champagne 12.0%
# 4 Champagne Brut  Vallformosa Cava  12.0%
# 5 Liqueur Brandy  singani63 18.0%
# 6 Liqueur Herbal  Tubi 60 40.0%
# 7 Liqueur Triple Sec  Combier 15.0%
# 8 Liquor  Vodka Goral Vodka 46.0%
# 9 Liquor  Irish Whiskey Egans Irish Whiskey 46.0%
# 10  Liquor  Cognac  Chapters of Ampersand 40.0%
# 11  Liquor  Tequila Hacienda De Chihuahua 40.0%
# 12  Liquor  Liqueur Cocalero  29.0%
# 13  Liquor  Rum El Dorado Rum 47.0%
# 14  Liquor  Whiskey Stonecutter Spirits 46.0%
# 15  Liquor  Absinthe  Crillon Importers 40.0%
# 16  Liquor  Vodka Distille Quality Vodka  46.0%
# 17  Liquor  Vodka Wyborowa Wodka  46.0%
# 18  Liquor  Gin Zephyr Gin  40.0%
# 19  Liquor  Gin Amazzoni Gin  40.0%
# 20  Liquor  Absinthe  Absinthe Ordinaire  46.0%
# 21  Liquor  Whiskey DWD Whiskey 40.0%
# 22  Liquor  Scotch Whiskey  Compass Box 46.0%
# 23  Liquor  Whiskey Flaming Pig Whiskey 40.0%
# 24  Wine  Merlot  Babich Wines  14.0%
# 25  Wine  Chardonnay  Braveheart Beverage 13.0%
# 26  Wine  Malbec  CRU 13.0%
# 27  Wine  Zinfandel Santa Carolina  13.0%


  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name]
  }
}
