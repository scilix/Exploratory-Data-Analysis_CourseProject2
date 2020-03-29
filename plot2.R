#
# Task 2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
#         (fips == "24510") from 1999 to 2008? Use the base plotting system to 
#         make a plot answering this question.
#

# The data needs to be present in the directory: "exdata_data_NEI_data"

# 1. Load data

SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

require("tidyverse")

# 2. Summarise data

total_emissons_baltimore <- NEI %>% 
    filter(fips == "24510") %>% 
    group_by(year) %>% 
    summarise(Total.Emissions = sum(Emissions))

# 3. Plot data

png("plot2.png")
plot(total_emissons_baltimore$year, total_emissons_baltimore$Total.Emissions, 
     pch = 19,
     ylab = "Total emission (tons)",
     xlab = "Year")
lines(total_emissons_baltimore$year, total_emissons_baltimore$Total.Emissions)
dev.off()
