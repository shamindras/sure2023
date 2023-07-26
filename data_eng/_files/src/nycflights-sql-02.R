# Install the RSQLite packages and the NYC flights data ----
REQ_PKGS <- c("dittodb", "RSQLite", "nycflights13", "tidyquery", "dbplyr")
# install.packages(REQ_PKGS)
# pak::pkg_install(REQ_PKGS)

# Load the required packages ----
library(RSQLite)
library(nycflights13)
library(dittodb)
library(tidyverse)
library(tidyquery)
library(dbplyr)

# Set up the connection to the NYC flights database ----
NYC_CONN <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

# Reads the database from the NYC data ----
dittodb::nycflights13_create_sql(NYC_CONN)

# Helper function to read from a given connection ----
# This removes a lot of the DBI::dbGetQuery code, and allows us to just focus
# directly on the SQL query
fetch_query <- function(query, con = NYC_CONN) {
  return(DBI::dbGetQuery(con, query))
}

# We can now run some custom queries on the NYC flights data ----
# fetch_query("SELECT * FROM flights;")
fetch_query("SELECT * FROM flights;")
fetch_query("SELECT * FROM flights LIMIT 10;")
fetch_query("SELECT * FROM weather LIMIT 10;")
fetch_query("SELECT * FROM planes LIMIT 10;")
fetch_query("SELECT * FROM airports LIMIT 10;")
fetch_query("SELECT * FROM airlines LIMIT 10;")

fetch_query(
  'SELECT dest, month, day,
MIN(arr_delay) AS mnd,
MAX(arr_delay) AS mxd,
AVG(arr_delay) AS avd
FROM flights
GROUP BY dest, month, day
LIMIT 10;')

tidyquery::query('SELECT dest, month, day,
MIN(arr_delay) AS mnd,
MAX(arr_delay) AS mxd,
AVG(arr_delay) AS avd
FROM nycflights13::flights
GROUP BY dest, month, day
LIMIT 10;')

tidyquery::show_dplyr('SELECT dest, month, day,
MIN(arr_delay) AS mnd,
MAX(arr_delay) AS mxd,
AVG(arr_delay) AS avd
FROM nycflights13::flights
GROUP BY dest, month, day
LIMIT 10;')

# This is the code returned from
flight_summ <-
  tbl(NYC_CONN, "flights") %>%
  group_by(dest, month, day) %>%
  summarise(mnd = min(arr_delay, na.rm = TRUE),
            mxd = max(arr_delay, na.rm = TRUE),
            avd = mean(arr_delay, na.rm = TRUE)) %>%
  ungroup() %>% head(10)

flight_summ %>% dbplyr::sql_render() %>% cat()


nycflights13::flights %>%
  filter(dest == "ALB", month == 12, day == 10)

fetch_query('SELECT DISTINCT * FROM flights;')
fetch_query('SELECT DISTINCT * FROM flights LIMIT 10;')
fetch_query('SELECT DISTINCT carrier, flight FROM flights ORDER BY carrier, flight;')

fetch_query('SELECT year, month, day, arr_delay,
            CASE WHEN arr_delay < 0 THEN "Early"
                 WHEN arr_delay = 0 THEN "On Time"
                 WHEN arr_delay > 0 THEN "Late"
                 ELSE "Unknown"
            END AS delay_type
            FROM flights
            LIMIT 10;')

fetch_query('SELECT * FROM planes LIMIT 10;')
fetch_query('SELECT manufacturer, COUNT(DISTINCT type) AS tot_uniq_types from planes GROUP BY manufacturer ORDER BY manufacturer;')
fetch_query('SELECT manufacturer, COUNT(*) AS tot_planes from planes GROUP BY manufacturer ORDER BY manufacturer;')


fetch_query('SELECT manufacturer, COUNT(*) AS tot_planes from planes GROUP BY manufacturer ORDER BY manufacturer;')

fetch_query('SELECT DISTINCT dest FROM flights ORDER BY dest;')
fetch_query('SELECT DISTINCT dest FROM flights WHERE dest LIKE "M%";')
fetch_query('SELECT DISTINCT dest FROM flights WHERE dest LIKE "M%" ORDER BY dest;')

fetch_query('SELECT dest, COUNT(*) as tot_flights
FROM flights
WHERE dest IN ("MIA", "MCO", "MSP", "MSY", "MKE", "MEM", "MYR", "MDW", "MHT", "MSN", "MCI", "MTJ", "MVY")
GROUP BY dest')

fetch_query('SELECT dest, COUNT(*) as tot_flights
FROM flights
WHERE dest IN (SELECT DISTINCT dest FROM flights WHERE dest LIKE "M%")
GROUP BY dest')

fetch_query('SELECT * FROM flights LIMIT 10;')
fetch_query('SELECT * FROM airlines;')


fetch_query(
  'SELECT carrier, COUNT(*) as tot_flights
   FROM flights
   WHERE month IN (6, 7)
   GROUP BY carrier
   ORDER BY carrier;') %>%
  view()


fetch_query(
  'SELECT al.name AS airline, COUNT(*) as tot_flights
  FROM flights AS fl
  LEFT JOIN airlines AS al
    ON al.carrier = fl.carrier
  WHERE month IN (6, 7)
  GROUP BY al.name;') %>%
  view()

# Close the connection to the database ----
DBI::dbDisconnect(NYC_CONN)
