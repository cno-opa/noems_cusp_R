library(purrr)
library(dplyr)

generate_availability_data <- function(unit_status_data) {
	unit_status_data %>% 
		filter(grepl("^3...$", Unit), 
					 TransactionType %in% c("UNIT STAT", "ON DUTY", "OFF DUTY")) %>%
		mutate(Unit = as.integer(Unit)) %>%
		arrange(Unit, UnitHistoryTime) %>%
		group_by(Unit) %>%
		mutate(NextUnitHistoryTime = lead(UnitHistoryTime)) %>% 
		ungroup() %>%
		filter(Status == '98', !is.na(NextUnitHistoryTime)) %>%
		transmute(Unit, TransactionType, AvailabilityStart = UnitHistoryTime,
							AvailabilityEnd = NextUnitHistoryTime)
}


load_availability <- function(unit_status_data) {
	availability_data <- generate_availability_data(unit_status_data)
	
	function(datetime) {
		availability_data %>% 
				filter( datetime >= AvailabilityStart & AvailabilityEnd > datetime) %>%   
				nrow()  
		}	
}
