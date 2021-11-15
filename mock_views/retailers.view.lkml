# add initials
view: retailers_p1 {
  derived_table: {
    sql:
      SELECT
          *
        , UPPER(SUBSTR(u.first_name, 1, 1) || SUBSTR(u.last_name, 1, 1)) AS retailer_id
      FROM `looker-private-demo.ecomm.users` u
      WHERE country = 'USA'
      ORDER BY id ASC
    ;;
    persist_for: "1000 hours"
  }
}

# add retailer names, type
view: retailers_p2 {
  derived_table: {
    sql:
      SELECT
         *
      FROM ${retailers_p1.SQL_TABLE_NAME} rp1
      JOIN `jasoncascio.mhw.retailers` r ON (rp1.retailer_id = r.initials)
      ORDER BY id ASC
    ;;
    persist_for: "1000 hours"
  }
}


# smash down retailers by initials
view: retailers {
  derived_table: {
    sql:
      WITH
        base AS (
          SELECT DISTINCT
              name
            , retailer_id AS id
            , FIRST_VALUE(type) OVER (PARTITION BY name ORDER BY name ASC) AS type
            , FIRST_VALUE(first_name) OVER (PARTITION BY name ORDER BY name ASC) AS first_name
            , FIRST_VALUE(last_name) OVER (PARTITION BY name ORDER BY name ASC) AS last_name
            , FIRST_VALUE(city) OVER (PARTITION BY name ORDER BY name ASC) AS city
            , FIRST_VALUE(state) OVER (PARTITION BY name ORDER BY name ASC) AS state
            , FIRST_VALUE(zip) OVER (PARTITION BY name ORDER BY name ASC) AS zip
            , FIRST_VALUE(country) OVER (PARTITION BY name ORDER BY name ASC) AS country
            , FIRST_VALUE(email) OVER (PARTITION BY name ORDER BY name ASC) AS email
            , FIRST_VALUE(longitude) OVER (PARTITION BY name ORDER BY name ASC) AS longitude
            , FIRST_VALUE(latitude) OVER (PARTITION BY name ORDER BY name ASC) AS latitude
            , FIRST_VALUE(created_at) OVER (PARTITION BY name ORDER BY created_at ASC) AS created_at
            , FIRST_VALUE(traffic_source) OVER (PARTITION BY name ORDER BY created_at ASC) AS traffic_source
          FROM ${retailers_p2.SQL_TABLE_NAME}
        ),
        sub_region_added AS (
          SELECT
              *
            , @{SQL_SUB_REGION} AS sub_region
          FROM base
        ),
        region_added AS (
          SELECT
              *
            , @{SQL_REGION} AS region
          FROM sub_region_added
        )
      SELECT * FROM region_added
    ;;
    persist_for: "1000 hours"
  }

  dimension: id {
    hidden: no
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    link: {
      label: "Retailer Dashboard"
      # url: "/dashboards-next/8?Name={{ value | encode_uri }}&Product+Name={{ products.name._value | encode_uri }}"
      url: "/dashboards-next/8?Name={{ value | encode_uri }}"
      icon_url: "https://freesvg.org/img/bar-15.png"
      # icon_url: "http://www.looker.com/favicon.ico"
    }
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: first_name {
    group_label: "Contact Info"
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    group_label: "Contact Info"
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: contact_name {
    group_label: "Contact Info"
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
  }


  dimension: email {
    group_label: "Contact Info"
    sql: ${TABLE}.email ;;
    tags: ["email"]
    action: {
      label: "Email Promotion to Customer"
      url: "https://desolate-refuge-53336.herokuapp.com/posts"
      # icon_url: "https://sendgrid.com/favicon.ico"
      icon_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/Aiga_mail.svg/480px-Aiga_mail.svg.png"
      param: {
        name: "some_auth_code"
        value: "abc123456"
      }
      form_param: {
        name: "Subject"
        required: yes
        default: "Thank you {{ first_name._value }}"
      }
      form_param: {
        name: "Body"
        type: textarea
        required: yes
        default:
        "Dear {{ first_name._value }},

        Thanks for your loyalty to the Look.  We'd like to offer you a 10% discount
        on your next purchase!  Just use the code LOYAL when checking out!

        Your friends at the Look"
      }
    }
    action: {
      label: "Send Purchase Inquiry"
      url: "https://desolate-refuge-53336.herokuapp.com/posts"
      # icon_url: "https://sendgrid.com/favicon.ico"
      icon_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/Aiga_mail.svg/480px-Aiga_mail.svg.png"
      param: {
        name: "some_auth_code"
        value: "abc123456"
      }
      form_param: {
        name: "Subject"
        required: yes
        default: "Hey {{ first_name._value }}, checking in..."
      }
      form_param: {
        name: "Body"
        type: textarea
        required: yes
        default:
        "Dear {{ first_name._value }},

        I noticed that you're ordering less this month.
        How can we win more of your business?

        -{{ _user_attributes['first_name'] }}"
      }
    }
    required_fields: [first_name]
  }

  dimension: city {
    group_label: "Location"
    sql: ${TABLE}.city ;;
    drill_fields: [zip]
  }

  dimension: state {
    group_label: "Location"
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
    drill_fields: [zip, city]
  }

  dimension: zip {
    group_label: "Location"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: city_state_zip {
    label: "City / State / Zip"
    group_label: "Location"
    sql: ${city} || ' ' || ${state} || ', ' || ${zip} ;;
  }

  dimension: country {
    group_label: "Location"
    map_layer_name: countries
    drill_fields: [state, city]
    sql: ${TABLE}.country ;;
    html: <img @{SMALL_FLAG_STYLE} src="@{CF_MAP_URL_BASE}@{ISO3_TO_ISO2}@{CF_MAP_URL_SUFFIX}"/><span> {{ value }}</span> ;;
  }

  dimension: latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    group_label: "Lat / Lng Location"
    description: "Use for mapping"
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
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

  dimension: map_location {
    sql: 1 ;;
    html: <img src="https://maps.googleapis.com/maps/api/staticmap?center={{ city._value }},{{ state._value }},{{ zip._value }}&zoom=6&size=400x250&maptype=roadmap&markers=color:blue%7Clabel:*%7C{{ latitude._value }},{{ longitude._value }}&key=AIzaSyDTq2FzYgyTH6skQl1JidyzqVcDizH2mJU" /> ;;
  }
  # https://maps.googleapis.com/maps/api/staticmap?center=Norfolk,Virginia,23529&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:*%7C36.96373295775046,-76.23564786665561&key=AIzaSyDTq2FzYgyTH6skQl1JidyzqVcDizH2mJU
  # AIzaSyDTq2FzYgyTH6skQl1JidyzqVcDizH2mJU


  # https://maps.googleapis.com/maps/api/staticmap?center={{ city._value }},{{ state._value }},{{ zip._value }}&zoom=13&size=600x300&maptype=roadmap
  # &markers=color:blue%7Clabel:S%7C{{ latitude._value }},{{ longitude._value }}&key=AIzaSyDTq2FzYgyTH6skQl1JidyzqVcDizH2mJU




  dimension: approx_latitude {
    group_label: "Lat / Lng Location"
    type: number
    sql: round(${TABLE}.latitude,1) ;;
  }

  dimension: approx_longitude {
    group_label: "Lat / Lng Location"
    type: number
    sql:round(${TABLE}.longitude,1) ;;
  }

  dimension: approx_location {
    group_label: "Lat / Lng Location"
    description: "Use for mapping"
    type: location
    drill_fields: [location]
    sql_latitude: ${approx_latitude} ;;
    sql_longitude: ${approx_longitude} ;;
    link: {
      label: "Google Directions from {{ distribution_centers.name._value }}"
      url: "{% if distribution_centers.location._in_query %}https://www.google.com/maps/dir/'{{ distribution_centers.latitude._value }},{{ distribution_centers.longitude._value }}'/'{{ approx_latitude._value }},{{ approx_longitude._value }}'{% endif %}"
      icon_url: "http://www.google.com/s2/favicons?domain=www.google.com"
    }
  }

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.created_at ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  measure: count {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [detail*]
  }

  set: detail {
    fields: [name, type, city, state, country]
  }

}
