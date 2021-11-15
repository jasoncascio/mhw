# Beer Wine Liquor Champagne
view: demographics_records {
  derived_table: {
    sql:
      WITH base AS (
        SELECT
            * EXCEPT(first_name, last_name, latitude, longitude, email)
          , CASE
              WHEN age < 21 THEN 21 + CAST(ROUND(age + 10 * RAND()) AS INT)
              WHEN age > 100 THEN 21 + CAST(ROUND(age / 3  + 10 * RAND()) AS INT)
              ELSE age
            END AS adjusted_age
          , @{SQL_SUB_REGION} AS sub_region
        FROM `looker-private-demo.ecomm.users`
        WHERE country = 'USA'
      ),
      region_added AS (
        SELECT
            *
          , @{SQL_REGION} AS region
        FROM base
      ),
      income_added AS (
        SELECT
            *
          , CASE
              WHEN adjusted_age >= 21 AND adjusted_age <= 30 THEN ROUND(((1 - 0.4 * RAND()) - 0.4 * RAND() ) * (1 + 4 * RAND() * RAND() ) * 50000)
              WHEN adjusted_age >= 31 AND adjusted_age <= 40 THEN ROUND(((1 - 0.4 * RAND()) - 0.4 * RAND() ) * (1 + 5 * RAND() * RAND() ) * 80000)
              WHEN adjusted_age >= 41 AND adjusted_age <= 50 THEN ROUND(((1 - 0.4 * RAND()) - 0.4 * RAND() ) * (1 + 6 * RAND() * RAND() ) * 100000)
              WHEN adjusted_age >= 51 AND adjusted_age <= 60 THEN ROUND(((1 - 0.4 * RAND()) - 0.4 * RAND() ) * (1 + 7 * RAND() * RAND() ) * 110000)
              WHEN adjusted_age >= 61 AND adjusted_age <= 70 THEN ROUND(((1 - 0.4 * RAND()) - 0.4 * RAND() ) * (1 + 7 * RAND() * RAND() ) * 90000)
              WHEN adjusted_age >= 71 AND adjusted_age <= 80 THEN ROUND(((1 - 0.4 * RAND()) - 0.4 * RAND() ) * (1 + 6 * RAND() * RAND() ) * 70000)
              WHEN adjusted_age >= 81 AND adjusted_age <= 90 THEN ROUND(((1 - 0.4 * RAND()) - 0.4 * RAND() ) * (1 + 5 * RAND() * RAND() ) * 60000)
              WHEN adjusted_age >= 91 AND adjusted_age <= 100 THEN ROUND(((1 - 0.4 * RAND()) - 0.4 * RAND() ) * (1 + 5 * RAND() * RAND() ) * 60000)
            END AS income
        FROM region_added
      ),
      marriage_added AS (
        SELECT
            *
          , CASE
              WHEN adjusted_age >= 21 AND adjusted_age <= 30 THEN CASE WHEN RAND() > 0.9 THEN 'married' ELSE 'single' END
              WHEN adjusted_age >= 31 AND adjusted_age <= 40 THEN CASE WHEN RAND() > 0.3 THEN 'married' ELSE 'single' END
              WHEN adjusted_age >= 41 AND adjusted_age <= 50 THEN CASE WHEN RAND() > 0.35 THEN 'married' ELSE 'single' END
              WHEN adjusted_age >= 51 AND adjusted_age <= 60 THEN CASE WHEN RAND() > 0.4 THEN 'married' ELSE 'single' END
              WHEN adjusted_age >= 61 AND adjusted_age <= 70 THEN CASE WHEN RAND() > 0.5 THEN 'married' ELSE 'single' END
              WHEN adjusted_age >= 71 AND adjusted_age <= 80 THEN CASE WHEN RAND() > 0.8 THEN 'married' ELSE 'single' END
              WHEN adjusted_age >= 81 AND adjusted_age <= 90 THEN CASE WHEN RAND() > 0.95 THEN 'married' ELSE 'single' END
              WHEN adjusted_age >= 91 AND adjusted_age <= 100 THEN CASE WHEN RAND() > 0.95 THEN 'married' ELSE 'single' END
            END AS marital_status
        FROM income_added
      )
      SELECT * FROM marriage_added
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
    sql: ${TABLE}.adjusted_age ;;
  }

  dimension: sub_region {
    type: string
    sql: ${TABLE}.sub_region ;;
    drill_fields: [state]
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
    drill_fields: [sub_region,state]
  }

  dimension: age_bucket {
    type: string
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
    drill_fields: [region,sub_region,state,zip,city]
    # html: <img @{SMALL_FLAG_STYLE} src="@{CF_MAP_URL_BASE}@{ISO3_TO_ISO2}@{CF_MAP_URL_SUFFIX}"/><span> {{ value }}</span> ;;
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

  dimension: income {
    type: number
    sql: ${TABLE}.income ;;
  }

  dimension: income_tier {
    type: string
    sql:
      CASE
        WHEN ${income} < 60000  THEN '0-59999'
        WHEN ${income} >= 60000 AND ${income} < 99999 THEN '60000-99999'
        WHEN ${income} >= 100000 AND ${income} < 149999 THEN '100000-149999'
        WHEN ${income} >= 150000 AND ${income} < 199999 THEN '150000-199999'
        WHEN ${income} >= 200000 AND ${income} < 249999 THEN '200000-249999'
        WHEN ${income} >= 250000 THEN '250000-1000000'
      END
    ;;
    order_by_field: affinity_by_income.income_low
  }

  dimension: marital_status {
    type: string
    sql: ${TABLE}.marital_status ;;
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

  ## Population Weighted Affinity
  measure: beer {
    group_label: "Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.c_beer_aff} *
      ${affinity_by_income.c_beer_aff} *
      ${affinity_by_state.c_beer_aff} *
      ${affinity_by_marital_status.c_beer_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: liquor {
    group_label: "Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.c_liquor_aff} *
      ${affinity_by_income.c_liquor_aff} *
      ${affinity_by_state.c_liquor_aff} *
      ${affinity_by_marital_status.c_liquor_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: wine {
    group_label: "Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.c_wine_aff} *
      ${affinity_by_income.c_wine_aff} *
      ${affinity_by_state.c_wine_aff} *
      ${affinity_by_marital_status.c_wine_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: champagne {
    group_label: "Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.c_champagne_aff} *
      ${affinity_by_income.c_champagne_aff} *
      ${affinity_by_state.c_champagne_aff} *
      ${affinity_by_marital_status.c_champagne_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: liqueur {
    group_label: "Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.c_liqueur_aff} *
      ${affinity_by_income.c_liqueur_aff} *
      ${affinity_by_state.c_liqueur_aff} *
      ${affinity_by_marital_status.c_liqueur_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: ale {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_ale_aff} *
      ${affinity_by_income.s_ale_aff} *
      ${affinity_by_state.s_ale_aff} *
      ${affinity_by_marital_status.s_ale_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: brut {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_brut_aff} *
      ${affinity_by_income.s_brut_aff} *
      ${affinity_by_state.s_brut_aff} *
      ${affinity_by_marital_status.s_brut_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: herbal {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_herbal_aff} *
      ${affinity_by_income.s_herbal_aff} *
      ${affinity_by_state.s_herbal_aff} *
      ${affinity_by_marital_status.s_herbal_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: triplesec {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
     ${affinity_by_age.s_triplesec_aff} *
      ${affinity_by_income.s_triplesec_aff} *
      ${affinity_by_state.s_triplesec_aff} *
      ${affinity_by_marital_status.s_triplesec_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: brandy {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_brandy_aff} *
      ${affinity_by_income.s_brandy_aff} *
      ${affinity_by_state.s_brandy_aff} *
      ${affinity_by_marital_status.s_brandy_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: vodka {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_vodka_aff} *
      ${affinity_by_income.s_vodka_aff} *
      ${affinity_by_state.s_vodka_aff} *
      ${affinity_by_marital_status.s_vodka_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: tequila {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_tequila_aff} *
      ${affinity_by_income.s_tequila_aff} *
      ${affinity_by_state.s_tequila_aff} *
      ${affinity_by_marital_status.s_tequila_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: gin {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_gin_aff} *
      ${affinity_by_income.s_gin_aff} *
      ${affinity_by_state.s_gin_aff} *
      ${affinity_by_marital_status.s_gin_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: whiskey {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_whiskey_aff} *
      ${affinity_by_income.s_whiskey_aff} *
      ${affinity_by_state.s_whiskey_aff} *
      ${affinity_by_marital_status.s_whiskey_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: absinthe {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_absinthe_aff} *
      ${affinity_by_income.s_absinthe_aff} *
      ${affinity_by_state.s_absinthe_aff} *
      ${affinity_by_marital_status.s_absinthe_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: merlot {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_merlot_aff} *
      ${affinity_by_income.s_merlot_aff} *
      ${affinity_by_state.s_merlot_aff} *
      ${affinity_by_marital_status.s_merlot_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: chardonnay {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_chardonnay_aff} *
      ${affinity_by_income.s_chardonnay_aff} *
      ${affinity_by_state.s_chardonnay_aff} *
      ${affinity_by_marital_status.s_chardonnay_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: malbec {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_malbec_aff} *
      ${affinity_by_income.s_malbec_aff} *
      ${affinity_by_state.s_malbec_aff} *
      ${affinity_by_marital_status.s_malbec_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: zinfandel {
    group_label: "Sub Category Population Weighted Affinities"
    type: sum
    sql:
      ${affinity_by_age.s_zinfandel_aff} *
      ${affinity_by_income.s_zinfandel_aff} *
      ${affinity_by_state.s_zinfandel_aff} *
      ${affinity_by_marital_status.s_zinfandel_aff}
    ;;
    value_format_name: decimal_3
  }

  ## Average Affinities
  measure: avg_beer {
    group_label: "Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.c_beer_aff} *
      ${affinity_by_income.c_beer_aff} *
      ${affinity_by_state.c_beer_aff} *
      ${affinity_by_marital_status.c_beer_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_liquor {
    group_label: "Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.c_liquor_aff} *
      ${affinity_by_income.c_liquor_aff} *
      ${affinity_by_state.c_liquor_aff} *
      ${affinity_by_marital_status.c_liquor_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_wine {
    group_label: "Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.c_wine_aff} *
      ${affinity_by_income.c_wine_aff} *
      ${affinity_by_state.c_wine_aff} *
      ${affinity_by_marital_status.c_wine_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_champagne {
    group_label: "Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.c_champagne_aff} *
      ${affinity_by_income.c_champagne_aff} *
      ${affinity_by_state.c_champagne_aff} *
      ${affinity_by_marital_status.c_champagne_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_liqueur {
    group_label: "Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.c_liqueur_aff} *
      ${affinity_by_income.c_liqueur_aff} *
      ${affinity_by_state.c_liqueur_aff} *
      ${affinity_by_marital_status.c_liqueur_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_ale {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_ale_aff} *
      ${affinity_by_income.s_ale_aff} *
      ${affinity_by_state.s_ale_aff} *
      ${affinity_by_marital_status.s_ale_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_brut {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_brut_aff} *
      ${affinity_by_income.s_brut_aff} *
      ${affinity_by_state.s_brut_aff} *
      ${affinity_by_marital_status.s_brut_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_herbal {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_herbal_aff} *
      ${affinity_by_income.s_herbal_aff} *
      ${affinity_by_state.s_herbal_aff} *
      ${affinity_by_marital_status.s_herbal_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_triplesec {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
     ${affinity_by_age.s_triplesec_aff} *
      ${affinity_by_income.s_triplesec_aff} *
      ${affinity_by_state.s_triplesec_aff} *
      ${affinity_by_marital_status.s_triplesec_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_brandy {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_brandy_aff} *
      ${affinity_by_income.s_brandy_aff} *
      ${affinity_by_state.s_brandy_aff} *
      ${affinity_by_marital_status.s_brandy_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_vodka {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_vodka_aff} *
      ${affinity_by_income.s_vodka_aff} *
      ${affinity_by_state.s_vodka_aff} *
      ${affinity_by_marital_status.s_vodka_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_tequila {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_tequila_aff} *
      ${affinity_by_income.s_tequila_aff} *
      ${affinity_by_state.s_tequila_aff} *
      ${affinity_by_marital_status.s_tequila_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_gin {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_gin_aff} *
      ${affinity_by_income.s_gin_aff} *
      ${affinity_by_state.s_gin_aff} *
      ${affinity_by_marital_status.s_gin_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_whiskey {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_whiskey_aff} *
      ${affinity_by_income.s_whiskey_aff} *
      ${affinity_by_state.s_whiskey_aff} *
      ${affinity_by_marital_status.s_whiskey_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_absinthe {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_absinthe_aff} *
      ${affinity_by_income.s_absinthe_aff} *
      ${affinity_by_state.s_absinthe_aff} *
      ${affinity_by_marital_status.s_absinthe_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_merlot {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_merlot_aff} *
      ${affinity_by_income.s_merlot_aff} *
      ${affinity_by_state.s_merlot_aff} *
      ${affinity_by_marital_status.s_merlot_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_chardonnay {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_chardonnay_aff} *
      ${affinity_by_income.s_chardonnay_aff} *
      ${affinity_by_state.s_chardonnay_aff} *
      ${affinity_by_marital_status.s_chardonnay_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_malbec {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_malbec_aff} *
      ${affinity_by_income.s_malbec_aff} *
      ${affinity_by_state.s_malbec_aff} *
      ${affinity_by_marital_status.s_malbec_aff}
    ;;
    value_format_name: decimal_3
  }

  measure: avg_zinfandel {
    group_label: "Sub Category Average Affinities"
    type: average
    sql:
      ${affinity_by_age.s_zinfandel_aff} *
      ${affinity_by_income.s_zinfandel_aff} *
      ${affinity_by_state.s_zinfandel_aff} *
      ${affinity_by_marital_status.s_zinfandel_aff}
    ;;
    value_format_name: decimal_3
  }
}
