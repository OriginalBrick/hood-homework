# J. Jedediah Smith
# BIFX 548

# Load Packages
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(forcats)
library(stringr)

# Earth Lab
library(leaflet)
library(RCurl)

# Map View
library(mapview)


###############################
### PART 1: DATA PROCESSING ###
###############################

# Read in data
fulldata <- read_csv('THOR_WWII_DATA_CLEAN.csv')

# Subset variables we want to use
vars <- c("MSNDATE","THEATER","COUNTRY_FLYING_MISSION",
          "TGT_COUNTRY","TGT_LOCATION","TGT_TYPE","LATITUDE","LONGITUDE",
          "TONS_OF_HE","TONS_OF_IC","TONS_OF_FRAG","TOTAL_TONS")

subdata <- fulldata[vars] %>%

# Fix N/A where applicable, then remove remaining N/A.
##### Preserves entries where country target is known, but target type or city is not.
##### Preserves entries where some of the bomb load is N/A, as 0 and N/A appear to have been used interchangeably.
##### Preserves entries with unknown country flying mission, theater, or target country so they are counted where applicable.

mutate(TGT_LOCATION = case_when(TGT_LOCATION == "UNIDENTIFIED TARGET" ~ "UNIDENTIFIED",
                                is.na(TGT_LOCATION) ~ "UNIDENTIFIED",
                                !is.na(TGT_LOCATION) ~ TGT_LOCATION)) %>%

mutate(TGT_TYPE = case_when(TGT_TYPE == "UNIDENTIFIED TARGET" ~ "UNIDENTIFIED",
                                is.na(TGT_TYPE) ~ "UNIDENTIFIED",
                                !is.na(TGT_TYPE) ~ TGT_TYPE)) %>%

mutate(TGT_COUNTRY = case_when(TGT_COUNTRY == "UNKNOWN OR NOT INDICATED" ~ "UNIDENTIFIED",
                              is.na(TGT_COUNTRY) ~ "UNIDENTIFIED",
                              !is.na(TGT_COUNTRY) ~ TGT_COUNTRY)) %>%

mutate(COUNTRY_FLYING_MISSION = case_when(is.na(COUNTRY_FLYING_MISSION) ~ "Unidentified",
                               COUNTRY_FLYING_MISSION == "GREAT BRITAIN" ~ "Great Britain",
                               COUNTRY_FLYING_MISSION == "USA" ~ "United States",
                               COUNTRY_FLYING_MISSION == "NEW ZEALAND" ~ "New Zealand",
                               COUNTRY_FLYING_MISSION == "AUSTRALIA" ~ "Australia",
                               COUNTRY_FLYING_MISSION == "SOUTH AFRICA" ~ "South Africa",
                               !is.na(COUNTRY_FLYING_MISSION) ~ COUNTRY_FLYING_MISSION)) %>%

mutate(THEATER = case_when(is.na(THEATER) ~ "Unidentified",
                                !is.na(THEATER) ~ THEATER)) %>%

mutate(TONS_OF_HE = case_when(is.na(TONS_OF_HE) ~ 0.0,
                                !is.na(TONS_OF_HE) ~ TONS_OF_HE)) %>%

mutate(TONS_OF_IC = case_when(is.na(TONS_OF_IC) ~ 0.0,
                                !is.na(TONS_OF_IC) ~ TONS_OF_IC)) %>%

mutate(TONS_OF_FRAG = case_when(is.na(TONS_OF_FRAG) ~ 0.0,
                                !is.na(TONS_OF_FRAG) ~ TONS_OF_FRAG)) %>%

mutate(TOTAL_TONS = case_when(is.na(TOTAL_TONS) ~ 0.0,
                                !is.na(TOTAL_TONS) ~ TOTAL_TONS)) %>%
  
mutate(MSNDATE = as.Date(MSNDATE, format = "%m/%d/%Y")) %>%
  
mutate(THEATER = case_when(THEATER == "ETO" ~ "Europe",
                           THEATER == "PTO" ~ "Pacific",
                           THEATER == "MTO" ~ "Mediterranean",
                           THEATER == "CBI" ~ "China",
                           THEATER == "EAST AFRICA" ~ "East Africa",
                           is.na(THEATER) ~ "Unidentified")) %>%

na.omit()

# Percent of data omitted.
percent_omit <-  as.numeric((count(fulldata) - count(subdata))/count(fulldata))*100

# Set up colorblind pallete
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


###############################
#### PART 2: SIMPLE GRAPHS ####
###############################

# Number of Missions by Country
ggplot(subdata, aes(x = fct_infreq(COUNTRY_FLYING_MISSION))) +
  geom_bar() +
  geom_text(aes(label = ..count..), stat = 'count', vjust = -0.5) +
  labs(x = 'Country Flying Mission', y = 'Number of Missions') +
  ggtitle("Number of Missions by Country Flying") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5)
  )

# Number of Missions by Theater
ggplot(subdata, aes(x = fct_infreq(THEATER))) +
  geom_bar() +
  geom_text(aes(label = ..count..), stat = 'count', vjust = -0.5) +
  labs(x = 'Theater of Operations', y = 'Number of Missions') +
  ggtitle("Number of Missions by Theater") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5)
  )

# Number of Missions by Target Country
table(subdata$TGT_COUNTRY) %>%
  as.data.frame() %>% 
  arrange(desc(Freq))
# Clearly sorting by Target Country isn't going to do anything good, since a lot of this stuff aren't countries...

# Number of Missions by Time and Country Flying Mission
subdata$COUNTRY_FLYING_MISSION <- factor(subdata$COUNTRY_FLYING_MISSION, levels = c("United States", "Unidentified", "Great Britain", "Australia", "New Zealand", "South Africa"))
ggplot(subdata, aes(x = MSNDATE, color=COUNTRY_FLYING_MISSION)) +
  geom_line(stat="bin", binwidth = 96, linewidth = 1) +
  scale_x_date(breaks = "1 year", date_labels = "%Y") +
  labs(x = 'Year', y = 'Number of Missions', col = 'Country Flying Mission') +
  ggtitle("Number of Missions by Time") +
  scale_colour_manual(values=cbbPalette) +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5)
  )

# Number of Missions by Time
ggplot(subdata, aes(x = MSNDATE)) +
  geom_line(stat="bin", binwidth = 96, linewidth = 1) +
  scale_x_date(breaks = "1 year", date_labels = "%Y") +
  labs(x = 'Year', y = 'Number of Missions') +
  ggtitle("Number of Missions by Time") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5)
  )


###############################
#### PART 3: COMPLEX GRAPHS ###
###############################

# Tons of Bombs by Time
Tons_by_Year <- subdata %>%
  mutate(MSNDATE = format(as.Date(MSNDATE, format="%d/%m/%Y"),"%Y")) %>%
  group_by(MSNDATE) %>%
  summarise(TOTAL_TONS = sum(TOTAL_TONS))

ggplot(Tons_by_Year, aes(x = MSNDATE, y = TOTAL_TONS, group = 1)) +
  geom_line() +
  labs(x = 'Year', y = 'Tons of Bombs') +
  ggtitle("Tons of Bombs by Time") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5)) +
  scale_y_continuous(labels = function(y) format(y, scientific = FALSE))

# Tons of Bombs by Target Country
Tons_by_Target <- group_by(subdata, TGT_COUNTRY) %>%
  summarise(TOTAL_TONS = sum(TOTAL_TONS)) %>%
  arrange(desc(TOTAL_TONS)) %>%
  top_n(10)

ggplot(Tons_by_Target) +
  geom_bar(aes(reorder(x = TGT_COUNTRY, -TOTAL_TONS), y = TOTAL_TONS), stat="identity") +
  labs(x = 'Targert Country', y = 'Tons of Bombs') +
  ggtitle("Tons of Bombs by Target Country") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5),
    axis.text.x = element_text(angle=45, hjust=1)) +
  scale_y_continuous(labels = function(y) format(y, scientific = FALSE))
  
# Tons of Bombs by Theater
Tons_by_Theater <- group_by(subdata, THEATER) %>%
  summarise(TOTAL_TONS = sum(TOTAL_TONS)) %>%
  arrange(desc(TOTAL_TONS))

ggplot(Tons_by_Theater) +
  geom_bar(aes(reorder(x = THEATER, -TOTAL_TONS), y = TOTAL_TONS), stat="identity") +
  labs(x = 'Targert Country', y = 'Tons of Bombs') +
  ggtitle("Tons of Bombs by Theater") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5)) +
  scale_y_continuous(labels = function(y) format(y, scientific = FALSE))



# World Map Test
select_location <- subdata %>%
  select(THEATER,COUNTRY_FLYING_MISSION,LATITUDE,LONGITUDE) %>%
  # filter(THEATER == "China" | THEATER == "Pacific")
  filter(THEATER == "Europe" | THEATER == "Mediterranean"| THEATER == "East Africa")

mapview(select_location, xcol = "LONGITUDE", ycol = "LATITUDE", zcol="COUNTRY_FLYING_MISSION", crs = 4269, grid = FALSE, maxpoints = 1, maxpolygons = 1, maxlines = 1)


