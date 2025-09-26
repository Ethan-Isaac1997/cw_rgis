if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview,
               here)

library(sf)
library(dplyr)
library(ggplot2)
library(here)

# read/export vector ------------------------------------------------------

(sf_nc_county <- st_read(dsn = here("data/nc.shp"),
                         quiet = TRUE))
## export as shp file
st_write(sf_nc_county, 
         dsn = here("data/sf_nc_county.shp"),
         append = FALSE)

# export as a gpkg
st_write(sf_nc_county, 
         dsn = here("data/sf_nc_county.gpkg"),
         append = FALSE)

# export as a rds
# save as an RDS file (compact and efficient for use within R)
saveRDS(sf_nc_county,
        file = here("data/sf_nc_county.rds"))


# read from an RDS file
sf_nc_county <- readRDS(file = here("data/sf_nc_county.rds"))

# take the first 10 sites 
## first 10 sites
(sf_site_f10 <- sf_nc_county %>% 
    slice(1:10))


# point data
(sf_site <- readRDS(here("data/sf_finsync_nc.rds")))
mapview(sf_site,
        col.regions = "black", # point's fill color
        legend = FALSE) # disable legend

#line data
sf_str <- readRDS(here("data/sf_stream_gi.rds"))
mapview(sf_str,
        color = "steelblue", # line's color
        legend = FALSE) # disable legend


mapview(sf_nc_county,
        color = "tomato",
        legend = FALSE)


## first 10 line strings
(sf_str_f10 <- sf_str %>% 
    slice(1:10))

mapview(sf_str_f10,
        color = "red")

sf_nc_county
sf_nc_guilford <- sf_nc_county %>% 
  filter(county == "guilford")
mapview(sf_nc_guilford,
        color ="pink",
        legend = FALSE)
# use ggplot to visualize map
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site)
ggplot() +
  geom_sf(data = sf_nc_guilford) +
  geom_sf(data = sf_str)

# ex ----------------------------------------------------------------------


sf_str_as <- readRDS(file = here("data/sf_stream_as.rds"))

sf_str_as
sf_nc_county

ggplot() +
  geom_sf(data = sf_str_as) 
  
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str_as)

sf_nc_as <- sf_nc_county %>% filter(county == "ashe")

mapview(sf_nc_as,
        color ="pink",
        legend = FALSE)

mapview(sf_str_as,
        color ="pink",
        legend = FALSE)
