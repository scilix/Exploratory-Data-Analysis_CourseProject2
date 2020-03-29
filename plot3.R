#
# Task 3: Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
#         variable, which of these four sources have seen decreases in emissions from 
#         1999–2008 for Baltimore City? Which have seen increases in emissions from 
#         1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

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

p1 <- emissons_baltimore %>% ggplot(aes(x = year, y = emissions, color = type)) +
    geom_point() + 
    geom_line() + 
    ylab("Total emission per type (tons)") +
    scale_x_discrete("Year", limits = c(1999,2002,2005,2008)) +
    ggtitle("PM2.5 emissions in Baltimore")
print(p1)
dev.off()
