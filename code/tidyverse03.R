if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)

## read fish data
df_fish <- read_csv (here::here("data/data_finsync_nc.csv"))


sf_site <- df_fish %>% 
  distinct(site_id, lon, lat) %>%
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)

print(sf_site)
df_fish
sf_site

#data on a map
mapview(sf_site,
        legend = FALSE )
## export the data

saveRDS(sf_site,
        file = "data/sf_finsync_nc.rds")
## conversion from geometric data to projected 
sf_ft_wgs <- sf_site %>% slice(c(1, 2))

sf_ft_utm <- sf_ft_wgs %>% 
  st_transform(crs = 32617)

print(sf_ft_utm)

mapview(sf_ft_utm)

st_distance(sf_ft_utm)



# ex 1
df_quakes <- as_tibble(quakes)

df_quakes

sf_quakes <- df_quakes %>% 
  distinct(long, lat) %>%
  st_as_sf(coords = c("long", "lat"),
           crs = 4326)

mapview(sf_quakes)


sf_ft_quakes <- sf_quakes %>% slice(c(1, 2))
sf_ft_quakes



sf_ft_quakes_proj <- sf_ft_quakes %>% 
  st_transform(crs = 32760)


mapview(sf_ft_quakes_proj)

st_distance(sf_ft_quakes_proj)
st_distance(sf_ft_quakes)

saveRDS(sf_quakes, file = here::here("data/sf_quakes.rds"))



