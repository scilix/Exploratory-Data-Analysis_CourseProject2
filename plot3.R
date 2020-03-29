#
# Task 1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#         Using the base plotting system, make a plot showing the total PM2.5 emission from 
#         all sources for each of the years 1999, 2002, 2005, and 2008.
#

# The data needs to be present in the directory: "exdata_data_NEI_data"

# 1. Load data and package dependencies

SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

require("tidyverse")

# 2. Summarise data

emissons_baltimore <- NEI %>% 
    filter(fips == "24510") %>% 
    group_by(year, type) %>% 
    summarise(emissions = sum(Emissions))

# 3. Plot data 

png("plot3.png")

emissons_baltimore %>% ggplot(aes(x = year, y = emissions, color = type)) +
    geom_point() + 
    geom_line() + 
    ylab("Total emission per type (tons)") +
    scale_x_discrete("Year", limits = c(1999,2002,2005,2008)) +
    ggtitle("PM25 emissions in Baltimore")

dev.off()
