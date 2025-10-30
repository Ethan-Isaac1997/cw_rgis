
# data packages -----------------------------------------------------------


if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               terra,
               tidyterra,
               exactextractr,
               here)


# Interactions between vector and raster data --------------------------------------------------------------



## finsync survey site
sf_site <- readRDS(here("data/sf_finsync_nc.rds"))

## county polygons
sf_nc_county <- readRDS(here("data/sf_nc_county.rds"))

## precipitation raster
spr_prec_nc <- rast(here("data/spr_prec_nc.tif"))



# Point-wise extraction ----------------------------------------------------------------


ggplot() +
  geom_spatraster(data = spr_prec_nc) +
  geom_sf(data = sf_site) +
  scale_fill_viridis_c() + # change color palette for raster
  theme_bw()



(sf_site_prec <- extract(x = spr_prec_nc,
                         y = sf_site,
                         bind = TRUE) %>% 
    st_as_sf())



##### visualize
ggplot() +
  geom_sf(data = sf_nc_county,       
          fill = "grey") + 
  geom_sf(data = sf_site_prec,       
          aes(color = precipitation)) +
  scale_color_viridis_c() +          
  theme_bw()                        






#  Zonal statistics -------------------------------------------------------

sf_nc_county_proj <- st_transform(sf_nc_county,
                                  crs = 32617)

spr_prec_nc_proj <- terra::project(x = spr_prec_nc, 
                                   y = crs(sf_nc_county_proj),
                                   method = "bilinear") 




(df_prec_county <- exact_extract(x = spr_prec_nc_proj,
                                 y = sf_nc_county_proj,
                                 fun = "mean",
                                 append_cols = TRUE,
                                 progress = FALSE) %>% 
    as_tibble() %>% 
    rename(precipitation = mean)) 



(sf_nc_county_prec <- sf_nc_county %>% 
    left_join(df_prec_county,
              by = "county"))

##### visualize
ggplot() +
  geom_sf(data = sf_nc_county_prec,
          aes(fill = precipitation)) +
  scale_fill_viridis_c() +
  theme_bw()


(df_prec_county_alt <- exact_extract(x = spr_prec_nc,
                                     y = sf_nc_county,
                                     fun = "weighted_mean",
                                     weights = "area",
                                     append_cols = TRUE,
                                     progress = FALSE) %>% 
    as_tibble() %>% 
    rename(precipitation = weighted_mean)) 




# Buffer based analysis ---------------------------------------------------


sf_site_proj <- sf_site %>%
  st_transform(crs = 32617)

(sf_site_buff_proj <- sf_site_proj %>%
  st_buffer(dist = 10000) )


(sf_site_buff <- sf_site_buff_proj %>%
  st_transform(crs = 4326))




ggplot() +
  geom_sf(data = sf_nc_county,
          fill = "grey") +
  geom_sf(data = sf_site_buff,
          fill = "salmon") +
  geom_sf(data = sf_site) +
  theme_bw()

##  get the mean precipitation for each site buffer
df_prec_buff <- exact_extract(x = spr_prec_nc_proj,
                              y = sf_site_buff_proj,
                              fun = "mean",
                              append_cols = TRUE,
                              progress = FALSE) %>%
  as_tibble() %>%
  rename(precipitation = mean)
## link these values to the site layer
(sf_site_prec_buff <- sf_site %>% 
    left_join(df_prec_buff,
              by = "site_id"))


###### map the precipitation value at each site 

ggplot() +
  geom_sf(data = sf_nc_county,
          fill = "grey") + 
  geom_sf(data = sf_site_prec_buff,
          aes(color = precipitation)) +
  scale_color_viridis_c() +
  theme_bw()




## identify top tree high-precipitation sites
sf_site_prec_buff %>% 
  arrange(desc(precipitation)) %>% 
  slice(1:3)
#1 finsync_usgs-03504000  (-83.61861 35.1275)         2110.
#2 finsync_nrs_nc-10027  (-83.69678 35.02467)         1799.
#3 finsync_usgs-03505550   (-83.65222 35.305)         1786.
