#
# Task 4: Across the United States, how have emissions from coal 
#         combustion-related sources changed from 1999–2008?
#

# The data needs to be present in the directory: "exdata_data_NEI_data"

# 1. Load data and package dependencies

SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

require("tidyverse")

# 2. identify relevant SCC

scc_coal_combustion <- SCC %>% filter(
    grepl('coal', str_to_lower(Short.Name)) & grepl('comb', str_to_lower(Short.Name)))


# 3. Filter and summarise data

emissons_us <- NEI %>% 
    filter(SCC %in% scc_coal_combustion$SCC) %>% 
    group_by(year) %>% 
    summarise(emissions = sum(Emissions))

# 4. Plot data 

png("plot4.png")

emissons_us %>% ggplot(aes(x = year, y = emissions/1e3)) +
    geom_point() + 
    geom_line() + 
    ylab("Total emission (thousand tons)") +
    scale_x_discrete("Year", limits = c(1999,2002,2005,2008)) +
    ggtitle("Coal combustion related PM2.5 emissions, US-wide",
            subtitle = paste("Using the source code classification,",
                             nrow(scc_coal_combustion), "of" ,nrow(SCC),
                             "types of emission sources have been 
identified to be related to coa combustion."))

dev.off()
