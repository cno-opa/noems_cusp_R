# Setup -------------------------------------------------------------------
library(readr)
library(lubridate)

source('code/availability.R')

unit_status <- read_csv("data/2016_11_unit_status.csv",   
												col_types = cols(Unit = col_character(),
																				 Status = col_character(),
																				 Seconds = col_integer(),
																				 IncidentNumber = col_character(),
																				 TransactionType = col_character(),
																				 Comment = col_character(),
																				 BeatName = col_integer(),
																				 UnitHistoryTime = col_datetime(format = "")))



##This loads the functions for counting the number of available ambulances at a given time
count_available_ambulances <- load_availability(unit_status)



# Example calculations -----------------------------------------------
t1 <- ymd_hms('2016-11-05 12:00:00')

count_available_ambulances(t1)

t2 <- ymd_hms('2016-11-05 12:10:00')

count_available_ambulances(t2)

# Add Available Ambulance Count to Incident Dataset -----------------------
incidents <- read_csv("data/2016_11_Incidents.csv", )

incidents <- incidents %>% 
	mutate(available_count = map_int(IncidentDate, count_available_ambulances))






