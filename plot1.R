#
# Task 1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#         Using the base plotting system, make a plot showing the total PM2.5 emission from 
#         all sources for each of the years 1999, 2002, 2005, and 2008.
#

# The data needs to be present in the directory: "exdata_data_NEI_data"

# 1. Load data

SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

require("tidyverse")

total_emissons <- NEI %>% 
    group_by(year) %>% 
    summarise(Total.Emissions = sum(Emissions))

png("plot1.png")
plot(total_emissons$year, total_emissons$Total.Emissions/1e6, 
     pch = 19,
     ylab = "Total emission (million tons)",
     xlab = "Year")
lines(total_emissons$year, total_emissons$Total.Emissions/1e6)
dev.off()
