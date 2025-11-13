# data packages -----------------------------------------------------------


if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               terra,
               tidyterra,
               exactextractr,
               here)




if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               ggeffects,
               sf,
               terra,
               tidyterra,
               exactextractr,
               mapview)

install.packages("ggeffects")
library(ggeffects)

# Linking gis to ecology 6.2 ---------------------------------------------------------

(df_finsync <- read_csv(here("data/data_finsync_nc.csv")))
(df_st1 <- df_finsync %>% 
    filter(site_id == "finsync_nrs_nc-10013"))


df_finsync %>% 
  mutate(presence = 1) %>% # all recorded species are "presence" = 1
  pivot_wider(id_cols = c(site_id, lon, lat),
              names_from = latin,
              values_from = presence)


df_finsync %>% 
  mutate(presence = 1) %>% # all recorded species are "presence" = 1
  pivot_wider(id_cols = c(site_id, lon, lat),
              names_from = latin,
              values_from = presence,
              values_fill = 0)


## assign df_rbs
(df_rbs <- df_finsync %>% 
    mutate(presence = 1) %>% # all recorded species are "presence" = 1
    pivot_wider(id_cols = c(site_id, lon, lat),
                names_from = latin,
                values_from = presence,
                values_fill = 0) %>% 
    select(site_id,
           lon,
           lat,
           "Lepomis auritus") %>% 
    rename(y = "Lepomis auritus")) # rename column "Lepomis auritus" to y



# Linking to the environment -----------------------------------------------

sf_rbs <- df_rbs %>% 
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)
## read temperature raster
spr_tmp_nc <- rast(here("data/spr_tmp_nc.tif"))

## extract values at the survey sites
(sf_rbs_tmp <- extract(x = spr_tmp_nc,
                       y = sf_rbs,
                       bind = TRUE) %>% 
    st_as_sf())


(df_rbs_tmp <- as_tibble(sf_rbs_tmp) %>% 
    select(-geometry))

# visualization -----------------------------------------------------------

ggplot() +
  # Add the air temperature raster layer as a background map
  geom_spatraster(data = spr_tmp_nc) + 
  # Overlay survey sites (sf object), colored by presence (1) or absence (0) of Redbreast Sunfish
  geom_sf(data = sf_rbs,
          aes(color = factor(y))) + 
  # Use a perceptually uniform color scale for the raster layer
  scale_fill_viridis_c() +   
  # Apply a clean black-and-white theme for better contrast and readability
  theme_bw()   


df_rbs_tmp %>%
  # Start ggplot using temperature as x and species presence/absence as y
  ggplot(aes(y = y, 
             x = precipitation)) +
  # Add individual points for each survey site
  geom_point() +
  # Apply a clean black-and-white theme for readability
  theme_bw()

###### There was no temp just precipitation in the df
# Analysis ----------------------------------------------------------------


(m <- glm(y ~ precipitation,
          data = df_rbs_tmp,
          family = "binomial"))
summary(m)

df_pred <- ggpredict(m,
                     terms = "precipitation [all]")

ggplot() +
  geom_point(data = df_rbs_tmp,
             aes(x = precipitation,
                 y = y)) +
  geom_line(data = df_pred,
            aes(x = x,
                y = predicted)) +
  geom_ribbon(data = df_pred,
              aes(x = x,
                  ymin = conf.low,
                  ymax = conf.high),
              fill = "grey",
              alpha = 0.2) +
  labs(x = "Air temperature",
       y = "Probability of occurrence") +
  theme_bw()
