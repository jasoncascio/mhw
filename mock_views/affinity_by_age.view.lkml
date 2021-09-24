view: affinity_by_age {
  sql_table_name: `jasoncascio.mhw.affinity_by_age`
    ;;

  dimension: age_bucket {
    hidden: yes
    type: string
    sql: ${lower_age} || '-' || ${upper_age} ;;
  }

  dimension: c_beer_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.c_beer_aff ;;
  }

  dimension: c_champagne_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.c_champagne_aff ;;
  }

  dimension: c_liqueur_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.c_liqueur_aff ;;
  }

  dimension: c_liquor_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.c_liquor_aff ;;
  }

  dimension: c_total_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.c_total_aff ;;
  }

  dimension: c_wine_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.c_wine_aff ;;
  }

  dimension: lower_age {
    hidden: yes
    type: number
    sql: ${TABLE}.lower_age ;;
  }

  dimension: s_absinthe_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_absinthe_aff ;;
  }

  dimension: s_ale_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_ale_aff ;;
  }

  dimension: s_brandy_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_brandy_aff ;;
  }

  dimension: s_brut_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_brut_aff ;;
  }

  dimension: s_chardonnay_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_chardonnay_aff ;;
  }

  dimension: s_gin_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_gin_aff ;;
  }

  dimension: s_herbal_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_herbal_aff ;;
  }

  dimension: s_malbec_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_malbec_aff ;;
  }

  dimension: s_merlot_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_merlot_aff ;;
  }

  dimension: s_tequila_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_tequila_aff ;;
  }

  dimension: s_total_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_total_aff ;;
  }

  dimension: s_triplesec_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_triplesec_aff ;;
  }

  dimension: s_vodka_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_vodka_aff ;;
  }

  dimension: s_whiskey_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_whiskey_aff ;;
  }

  dimension: s_zinfandel_aff {
    hidden: yes
    type: number
    sql: ${TABLE}.s_zinfandel_aff ;;
  }

  dimension: upper_age {
    hidden: yes
    type: number
    sql: ${TABLE}.upper_age ;;
  }

}
