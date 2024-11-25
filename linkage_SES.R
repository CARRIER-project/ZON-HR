# The following line loads the package 'readxl' required to read in data from MS Excel files.
library(readxl)

# The following lines read in the SES data. 
# Before running these, change '...' to the correct path referring to the .xlsx file of the SES data. Do not remove the double quotation marks.   
data_SES <- cbind(read_xlsx("...",
                            sheet = 4,
                            range = "A5:A8121",
                            col_names = "year",
                            col_types = "numeric"),
                  read_xlsx("...",
                            sheet = 4,
                            range = "B5:B8121",
                            col_names = "PC4",
                            col_types = "numeric"),
                  read_xlsx("...",
                            sheet = 4,
                            range = "W5:W8121",
                            col_names = "SES",
                            col_types = "numeric")) 
# Warnings are due to the use of '.' for missing values in the .xlsx file, these are correctly converted to NA. 
                  
# The following lines read in the ZON-HR data.
# Before running these, change '...' to the correct path referring to the .xlsx file of the ZON-HR data. Do not remove the double quotation marks. 
data_ZONHR <- read_excel("...",
                         skip = 1,
                         col_names = c("ID",
                                       "date",
                                       "PC6"),
                         col_types = c("numeric",
                                       "date",
                                       "text"))

# The following line adds a variable 'year' to the object 'data_ZONHR' by extracting the year from the 'date' variable.
data_ZONHR$year <- format(data_ZONHR$date, "%Y")

# The following line defines the variable type of the 'year' variable as numeric.
data_ZONHR$year <- as.numeric(data_ZONHR$year)

# The following line adds a variable 'PC4' to the object 'data_ZONHR' consisting of the 4 digits of the postal code. These 4 digits are extracted from the variable 'PC6', which contains the 4 digits plus the 2 letters of the postal code as registered in the ZON-HR.
data_ZONHR$PC4 <- substring(data_ZONHR$PC6, 1, 4)  

# The following line defines the variable type of the 'PC4' variable as numeric.
data_ZONHR$PC4 <- as.numeric(data_ZONHR$PC4)

# The following line adds the 'SES' variable to the object 'data_ZONHR' by matching data objects 'data_ZONHR' and 'data_SES' on 'year' and 'PC4'.
data_ZONHR <- merge(data_ZONHR,
                    data_SES,
                    all.x = TRUE,
                    all.y = FALSE,
                    by = c("year",
                           "PC4"))

# The following line changes the order of the variables in the data object 'data_ZONHR' from 'year', 'PC4', 'ID', 'date', 'PC6', 'SES', to 'ID', 'date', 'year', 'PC6', 'PC4', 'SES'.  
data_ZONHR <- data_ZONHR[, c("ID",
                             "date",
                             "year",
                             "PC6",
                             "PC4",
                             "SES")]

# The following line writes a .csv file of the ZON-HR data which now includes the SES indicator. This file is named 'ZON-HR-incl-SES.csv'.
# Before running this, change '...' to the path referring to the folder in which you would like to store this new data file. Do not remove the double quotation marks.    
write.csv(data_ZONHR, ".../ZON-HR-incl-SES.csv")
