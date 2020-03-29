#
# Task 6: Compare emissions from motor vehicle sources in Baltimore City with emissions 
#         from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
#         Which city has seen greater changes over time in motor vehicle emissions?
#

# The data needs to be present in the directory: "exdata_data_NEI_data"

# 1. Load data and package dependencies

SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

require("tidyverse")
require("gridExtra")

# 2. identify relevant SCC


scc_motor_vehicles <- SCC %>% filter(SCC.Level.One == "Mobile Sources" & grepl("highway vehicle", str_to_lower(SCC.Level.Two))) 

# 3. Filter and summarise data

emissons_mv_baltimore <- NEI %>%
    filter(fips == "24510") %>% 
    filter(SCC %in% scc_motor_vehicles$SCC) %>% 
    group_by(year) %>% 
    summarise(emissions = sum(Emissions)) %>% 
    mutate(em_rel_1999 = emissions/first(emissions)) %>% 
    mutate(region = "Baltimore City")


emissons_mv_losangeles <- NEI %>%
    filter(fips == "06037") %>% 
    filter(SCC %in% scc_motor_vehicles$SCC) %>% 
    group_by(year) %>% 
    summarise(emissions = sum(Emissions)) %>% 
    mutate(em_rel_1999 = emissions/first(emissions)) %>% 
    mutate(region = "Los Angeles County")

emissions_mv <- rbind(emissons_mv_baltimore,emissons_mv_losangeles)

# 4. Plot data 

png("plot6.png", width = 1100, height = 480)

p1 <- emissions_mv %>% ggplot(aes(x = year, y = emissions, color = region)) +
    geom_point() + 
    geom_line() + 
    ylab("Total emission (tons)") +
    scale_x_discrete("Year", limits = c(1999,2002,2005,2008)) +
    ggtitle("PM2.5 emissions from motor vehicles",
            subtitle = paste("Using the source code classification,",
                             nrow(scc_motor_vehicles), "of" ,nrow(SCC),
                             "types of emission sources have been 
identified to be related to motor vehicle emissions."))

p2 <- emissions_mv %>% ggplot(aes(x = year, y = em_rel_1999, color = region)) +
    geom_point() + 
    geom_line() + 
    ylab("Relative emissions, normalized to 1999") +
    scale_x_discrete("Year", limits = c(1999,2002,2005,2008)) +
    ggtitle("PM2.5 emissions from motor vehicles",
            subtitle = paste("Using the source code classification,",
                             nrow(scc_motor_vehicles), "of" ,nrow(SCC),
                             "types of emission sources have been 
identified to be related to motor vehicle emissions."))
grid.arrange(p1,p2,nrow = 1)
dev.off()
