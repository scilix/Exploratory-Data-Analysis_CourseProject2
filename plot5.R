#
# Task 5: How have emissions from motor vehicle sources changed 
#         from 1999–2008 in Baltimore City?
#

# The data needs to be present in the directory: "exdata_data_NEI_data"

# 1. Load data and package dependencies

SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

require("tidyverse")

# 2. identify relevant SCC


scc_motor_vehicles <- SCC %>% filter(SCC.Level.One == "Mobile Sources" & grepl("highway vehicle", str_to_lower(SCC.Level.Two))) 

# 3. Filter and summarise data

emissons_mv_baltimore <- NEI %>%
    filter(fips == "24510") %>% 
    filter(SCC %in% scc_motor_vehicles$SCC) %>% 
    group_by(year) %>% 
    summarise(emissions = sum(Emissions))

# 4. Plot data 

png("plot5.png")

p1 <- emissons_mv_baltimore %>% ggplot(aes(x = year, y = emissions)) +
    geom_point() + 
    geom_line() + 
    ylab("Total emission (tons)") +
    scale_x_discrete("Year", limits = c(1999,2002,2005,2008)) +
    ggtitle("PM2.5 emissions from motor vehicles in Baltimore, Maryland",
            subtitle = paste("Using the source code classification,",
                             nrow(scc_motor_vehicles), "of" ,nrow(SCC),
                             "types of emission sources have been 
identified to be related to motor vehicle emissions."))
print(p1)
dev.off()
