constant: IMG_LOGO_MHW {
  value: "https://www.mhwltd.com/wp-content/uploads/2020/05/mhw-logo.jpg"
}

constant: IMG_PRODUCT_URL_BASE {
  value: "https://www.mhwltd.com/wp-content/uploads/2020/07/"
}


#### COUNTRY FLAGS ####
# Flag URL Components
constant: CF_MAP_URL_BASE { #Cloudflare Flags
  value: "https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/3.4.6/flags/4x3/"
}
constant: CF_MAP_URL_SUFFIX {
  value: ".svg"
}
constant: SMALL_FLAG_SIZE {
  value: "20px"
}
constant: SMALL_FLAG_STYLE {
  value: "style=\"width: @{SMALL_FLAG_SIZE}\""
}
constant: BIG_FLAG_SIZE {
  value: "20px"
}
constant: BIG_FLAG_STYLE {
  value: "style=\"width: @{BIG_FLAG_SIZE}\""
}

# ISO3 TO ISO2 Liquid Resolver
constant: ISO3_TO_ISO2 {
  value:"{% if value == \"AFG\" %}af{% elsif value == \"ALB\" %}al{% elsif value == \"DZA\" %}dz{% elsif value == \"ASM\" %}as{% elsif value == \"AND\" %}ad{% elsif value == \"AGO\" %}ao{% elsif value == \"AIA\" %}ai{% elsif value == \"ATA\" %}aq{% elsif value == \"ATG\" %}ag{% elsif value == \"ARG\" %}ar{% elsif value == \"ARM\" %}am{% elsif value == \"ABW\" %}aw{% elsif value == \"AUS\" %}au{% elsif value == \"AUT\" %}at{% elsif value == \"AZE\" %}az{% elsif value == \"BHS\" %}bs{% elsif value == \"BHR\" %}bh{% elsif value == \"BGD\" %}bd{% elsif value == \"BRB\" %}bb{% elsif value == \"BLR\" %}by{% elsif value == \"BEL\" %}be{% elsif value == \"BLZ\" %}bz{% elsif value == \"BEN\" %}bj{% elsif value == \"BMU\" %}bm{% elsif value == \"BTN\" %}bt{% elsif value == \"BOL\" %}bo{% elsif value == \"BES\" %}bq{% elsif value == \"BIH\" %}ba{% elsif value == \"BWA\" %}bw{% elsif value == \"BVT\" %}bv{% elsif value == \"BRA\" %}br{% elsif value == \"IOT\" %}io{% elsif value == \"BRN\" %}bn{% elsif value == \"BGR\" %}bg{% elsif value == \"BFA\" %}bf{% elsif value == \"BDI\" %}bi{% elsif value == \"CPV\" %}cv{% elsif value == \"KHM\" %}kh{% elsif value == \"CMR\" %}cm{% elsif value == \"CAN\" %}ca{% elsif value == \"CYM\" %}ky{% elsif value == \"CAF\" %}cf{% elsif value == \"TCD\" %}td{% elsif value == \"CHL\" %}cl{% elsif value == \"CHN\" %}cn{% elsif value == \"CXR\" %}cx{% elsif value == \"CCK\" %}cc{% elsif value == \"COL\" %}co{% elsif value == \"COM\" %}km{% elsif value == \"COD\" %}cd{% elsif value == \"COG\" %}cg{% elsif value == \"COK\" %}ck{% elsif value == \"CRI\" %}cr{% elsif value == \"HRV\" %}hr{% elsif value == \"CUB\" %}cu{% elsif value == \"CUW\" %}cw{% elsif value == \"CYP\" %}cy{% elsif value == \"CZE\" %}cz{% elsif value == \"CIV\" %}ci{% elsif value == \"DNK\" %}dk{% elsif value == \"DJI\" %}dj{% elsif value == \"DMA\" %}dm{% elsif value == \"DOM\" %}do{% elsif value == \"ECU\" %}ec{% elsif value == \"EGY\" %}eg{% elsif value == \"SLV\" %}sv{% elsif value == \"GNQ\" %}gq{% elsif value == \"ERI\" %}er{% elsif value == \"EST\" %}ee{% elsif value == \"SWZ\" %}sz{% elsif value == \"ETH\" %}et{% elsif value == \"FLK\" %}fk{% elsif value == \"FRO\" %}fo{% elsif value == \"FJI\" %}fj{% elsif value == \"FIN\" %}fi{% elsif value == \"FRA\" %}fr{% elsif value == \"GUF\" %}gf{% elsif value == \"PYF\" %}pf{% elsif value == \"ATF\" %}tf{% elsif value == \"GAB\" %}ga{% elsif value == \"GMB\" %}gm{% elsif value == \"GEO\" %}ge{% elsif value == \"DEU\" %}de{% elsif value == \"GHA\" %}gh{% elsif value == \"GIB\" %}gi{% elsif value == \"GRC\" %}gr{% elsif value == \"GRL\" %}gl{% elsif value == \"GRD\" %}gd{% elsif value == \"GLP\" %}gp{% elsif value == \"GUM\" %}gu{% elsif value == \"GTM\" %}gt{% elsif value == \"GGY\" %}gg{% elsif value == \"GIN\" %}gn{% elsif value == \"GNB\" %}gw{% elsif value == \"GUY\" %}gy{% elsif value == \"HTI\" %}ht{% elsif value == \"HMD\" %}hm{% elsif value == \"VAT\" %}va{% elsif value == \"HND\" %}hn{% elsif value == \"HKG\" %}hk{% elsif value == \"HUN\" %}hu{% elsif value == \"ISL\" %}is{% elsif value == \"IND\" %}in{% elsif value == \"IDN\" %}id{% elsif value == \"IRN\" %}ir{% elsif value == \"IRQ\" %}iq{% elsif value == \"IRL\" %}ie{% elsif value == \"IMN\" %}im{% elsif value == \"ISR\" %}il{% elsif value == \"ITA\" %}it{% elsif value == \"JAM\" %}jm{% elsif value == \"JPN\" %}jp{% elsif value == \"JEY\" %}je{% elsif value == \"JOR\" %}jo{% elsif value == \"KAZ\" %}kz{% elsif value == \"KEN\" %}ke{% elsif value == \"KIR\" %}ki{% elsif value == \"PRK\" %}kp{% elsif value == \"KOR\" %}kr{% elsif value == \"KWT\" %}kw{% elsif value == \"KGZ\" %}kg{% elsif value == \"LAO\" %}la{% elsif value == \"LVA\" %}lv{% elsif value == \"LBN\" %}lb{% elsif value == \"LSO\" %}ls{% elsif value == \"LBR\" %}lr{% elsif value == \"LBY\" %}ly{% elsif value == \"LIE\" %}li{% elsif value == \"LTU\" %}lt{% elsif value == \"LUX\" %}lu{% elsif value == \"MAC\" %}mo{% elsif value == \"MDG\" %}mg{% elsif value == \"MWI\" %}mw{% elsif value == \"MYS\" %}my{% elsif value == \"MDV\" %}mv{% elsif value == \"MLI\" %}ml{% elsif value == \"MLT\" %}mt{% elsif value == \"MHL\" %}mh{% elsif value == \"MTQ\" %}mq{% elsif value == \"MRT\" %}mr{% elsif value == \"MUS\" %}mu{% elsif value == \"MYT\" %}yt{% elsif value == \"MEX\" %}mx{% elsif value == \"FSM\" %}fm{% elsif value == \"MDA\" %}md{% elsif value == \"MCO\" %}mc{% elsif value == \"MNG\" %}mn{% elsif value == \"MNE\" %}me{% elsif value == \"MSR\" %}ms{% elsif value == \"MAR\" %}ma{% elsif value == \"MOZ\" %}mz{% elsif value == \"MMR\" %}mm{% elsif value == \"NAM\" %}na{% elsif value == \"NRU\" %}nr{% elsif value == \"NPL\" %}np{% elsif value == \"NLD\" %}nl{% elsif value == \"NCL\" %}nc{% elsif value == \"NZL\" %}nz{% elsif value == \"NIC\" %}ni{% elsif value == \"NER\" %}ne{% elsif value == \"NGA\" %}ng{% elsif value == \"NIU\" %}nu{% elsif value == \"NFK\" %}nf{% elsif value == \"MNP\" %}mp{% elsif value == \"NOR\" %}no{% elsif value == \"OMN\" %}om{% elsif value == \"PAK\" %}pk{% elsif value == \"PLW\" %}pw{% elsif value == \"PSE\" %}ps{% elsif value == \"PAN\" %}pa{% elsif value == \"PNG\" %}pg{% elsif value == \"PRY\" %}py{% elsif value == \"PER\" %}pe{% elsif value == \"PHL\" %}ph{% elsif value == \"PCN\" %}pn{% elsif value == \"POL\" %}pl{% elsif value == \"PRT\" %}pt{% elsif value == \"PRI\" %}pr{% elsif value == \"QAT\" %}qa{% elsif value == \"MKD\" %}mk{% elsif value == \"ROU\" %}ro{% elsif value == \"RUS\" %}ru{% elsif value == \"RWA\" %}rw{% elsif value == \"REU\" %}re{% elsif value == \"BLM\" %}bl{% elsif value == \"SHN\" %}sh{% elsif value == \"KNA\" %}kn{% elsif value == \"LCA\" %}lc{% elsif value == \"MAF\" %}mf{% elsif value == \"SPM\" %}pm{% elsif value == \"VCT\" %}vc{% elsif value == \"WSM\" %}ws{% elsif value == \"SMR\" %}sm{% elsif value == \"STP\" %}st{% elsif value == \"SAU\" %}sa{% elsif value == \"SEN\" %}sn{% elsif value == \"SRB\" %}rs{% elsif value == \"SYC\" %}sc{% elsif value == \"SLE\" %}sl{% elsif value == \"SGP\" %}sg{% elsif value == \"SXM\" %}sx{% elsif value == \"SVK\" %}sk{% elsif value == \"SVN\" %}si{% elsif value == \"SLB\" %}sb{% elsif value == \"SOM\" %}so{% elsif value == \"ZAF\" %}za{% elsif value == \"SGS\" %}gs{% elsif value == \"SSD\" %}ss{% elsif value == \"ESP\" %}es{% elsif value == \"LKA\" %}lk{% elsif value == \"SDN\" %}sd{% elsif value == \"SUR\" %}sr{% elsif value == \"SJM\" %}sj{% elsif value == \"SWE\" %}se{% elsif value == \"CHE\" %}ch{% elsif value == \"SYR\" %}sy{% elsif value == \"TWN\" %}tw{% elsif value == \"TJK\" %}tj{% elsif value == \"TZA\" %}tz{% elsif value == \"THA\" %}th{% elsif value == \"TLS\" %}tl{% elsif value == \"TGO\" %}tg{% elsif value == \"TKL\" %}tk{% elsif value == \"TON\" %}to{% elsif value == \"TTO\" %}tt{% elsif value == \"TUN\" %}tn{% elsif value == \"TUR\" %}tr{% elsif value == \"TKM\" %}tm{% elsif value == \"TCA\" %}tc{% elsif value == \"TUV\" %}tv{% elsif value == \"UGA\" %}ug{% elsif value == \"UKR\" %}ua{% elsif value == \"ARE\" %}ae{% elsif value == \"GBR\" %}gb{% elsif value == \"UMI\" %}um{% elsif value == \"USA\" %}us{% elsif value == \"URY\" %}uy{% elsif value == \"UZB\" %}uz{% elsif value == \"VUT\" %}vu{% elsif value == \"VEN\" %}ve{% elsif value == \"VNM\" %}vn{% elsif value == \"VGB\" %}vg{% elsif value == \"VIR\" %}vi{% elsif value == \"WLF\" %}wf{% elsif value == \"ESH\" %}eh{% elsif value == \"YEM\" %}ye{% elsif value == \"ZMB\" %}zm{% elsif value == \"ZWE\" %}zw{% elsif value == \"ALA\" %}ax{% else %}unKNOWN{% endif %}"
  # Its just a big liquid expression that resolves ISO3 cap to ISO2 lower
  # {% if value == \"AFG\" %}af
  # {% elsif value == \"ALB\" %}al
  #  .
  #  .
  #  .
  # {% else value == \"ALA\" %}ax
  # {% else %}UNKNOWN{% endif %}
}

constant: SQL_SUB_REGION {
  value: "CASE
              WHEN state IN ('Connecticut','Maine','Massachusetts','Vermont','New Hampshire','Rhode Island') THEN 'New England'
              WHEN state IN ('New Jersey','New York','Pennsylvania') THEN 'Mid-Atlantic'
              WHEN state IN ('Indiana','Illinois','Michigan','Ohio','Wisconsin') THEN 'East North Central'
              WHEN state IN ('Iowa','Kansas','Minnesota','Missouri','Nebraska','North Dakota','South Dakota') THEN 'West North Central'
              WHEN state IN ('Delaware','Florida','Georgia','Maryland','North Carolina','South Carolina','Virginia','District of Columbia','West Virginia') THEN 'South Atlantic'
              WHEN state IN ('Alabama','Kentucky','Mississippi','Tennessee') THEN 'East South Central'
              WHEN state IN ('Arkansas','Louisiana','Oklahoma','Texas') THEN 'West South Central'
              WHEN state IN ('Arizona','Colorado','Idaho','Montana','Nevada','New Mexico','Utah','Wyoming') THEN 'Mountain'
              WHEN state IN ('Alaska','California','Hawaii','Montana','Oregon','Washington') THEN 'Pacific'
            END"
}

constant: SQL_REGION {
  value: "CASE
              WHEN sub_region IN ('New England','Mid-Atlantic') THEN 'Northeast'
              WHEN sub_region IN ('East North Central','West North Central') THEN 'Midwest'
              WHEN sub_region IN ('South Atlantic','East South Central','West South Central') THEN 'South'
              WHEN sub_region IN ('Mountain','Pacific') THEN 'West'
            END"
}



# ****Categories
# Beer
# Champagne
# Liquor
# Liqueur
# Wine


# ***Sub Categories
# Ale
# Brut
# Brandy
# Triple Sec
# Herbal
# Absinthe
# Liqueur
# Tequila
# Rum
# Irish Whiskey
# Gin
# Scotch Whiskey
# Vodka
# Cognac
# Whiskey
# Malbec
# Merlot
# Chardonnay
# Zinfandel
