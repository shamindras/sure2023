# Install the RSQLite packages and the NYC flights data ----
REQ_PKGS <- c("dittodb", "RSQLite", "nycflights13")
install.packages(REQ_PKGS)
# pak::pkg_install(REQ_PKGS)

# Load the required packages ----
library(RSQLite)
library(nycflights13)
library(dittodb)
library(tidyverse)

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
fetch_query("SELECT * FROM flights LIMIT 10;")
fetch_query("SELECT * FROM weather LIMIT 10;")
fetch_query("SELECT * FROM planes LIMIT 10;")
fetch_query("SELECT * FROM airports LIMIT 10;")
fetch_query("SELECT * FROM airlines LIMIT 10;")

# Fetch specific columns from flights
fetch_query("SELECT dep_time, arr_time, flight FROM flights LIMIT 10;")
flights %>%
  select(dep_time, arr_time, flight) %>%
  head(10)

# Let's get speed of flights
fetch_query("SELECT flight, distance/(air_time/60) AS speed FROM flights LIMIT 10;")
flights %>%
  mutate(speed = distance / (air_time / 60)) %>%
  select(flight, speed) %>%
  head(10)

fetch_query("SELECT MIN(air_time) AS min_ar, MAX(air_time) AS max_ar from flights;")
fetch_query("SELECT COUNT(*) from flights;")

fetch_query('SELECT * FROM flights WHERE origin = "JFK" LIMIT 10;')

fetch_query('SELECT COUNT(*) FROM flights WHERE dest != "JFK";')

fetch_query('SELECT * FROM flights WHERE tailnum IN ("N593JB", "N532UA") LIMIT 20;')

fetch_query("SELECT * FROM flights WHERE month NOT IN (1, 12) AND arr_delay > 120 LIMIT 10;")
flights %>%
  filter(!(month %in% c(1, 12)) & arr_delay > 120) %>%
  head(20)

fetch_query("SELECT * FROM weather WHERE wind_gust IS NOT NULL;")
weather %>%
  filter(!is.na(wind_gust)) %>%
  head(20)
weather %>%
  drop_na(wind_gust) %>%
  head(20)

fetch_query("SELECT origin, AVG(arr_delay) AS avd FROM flights GROUP BY origin;")
flights %>%
  group_by(origin) %>%
  summarize(vcd = mean(arr_delay, na.rm = TRUE))

fetch_query(
  "SELECT dest, month, day,
MIN(arr_delay) AS mnd,
MAX(arr_delay) AS mxd,
AVG(arr_delay) AS avd
FROM flights
GROUP BY dest, month, day
LIMIT 10;"
)

fetch_query("SELECT flight, distance/(air_time/60) AS speed FROM flights ORDER BY distance/(air_time/60) DESC LIMIT 10;")

fetch_query("SELECT engines, COUNT(*) AS tot_num FROM planes GROUP BY engines HAVING tot_num < 200;")
planes %>%
  count(engines, name = "tot_num") %>%
  filter(tot_num < 200)

# Or we can do this the more manual way
planes %>%
  group_by(engines) %>%
  summarize(tot_num = n()) %>%
  filter(tot_num < 200)

fetch_query(
  "SELECT dest, month, day,
MIN(arr_delay) AS mnd,  MAX(arr_delay) AS mxd,
AVG(arr_delay) AS avd
FROM flights
GROUP BY dest, month, day
ORDER BY dest, month DESC, day
LIMIT 10;"
)

# Close the connection to the database ----
DBI::dbDisconnect(NYC_CONN)
