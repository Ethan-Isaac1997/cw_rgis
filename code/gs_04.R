if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars,
               here)




# read/export raster data -------------------------------------------------


(spr_ex <- rast(here("data/spr_example.tif")))


writeRaster(spr_ex, 
            filename = here("data/spr_elev.tif"),
            overwrite = TRUE)

ggplot() +
  geom_spatraster(data = spr_ex)


## mapview function

star_ex <- st_as_stars(spr_ex)
mapview(star_ex)



# raster data type --------------------------------------------------------

v_elev <- values(spr_ex)
head(v_elev, 10)
na.omit(v_elev) %>%
  mean()

extract(spr_ex, y = cbind(6.0000, 50.0000))


## extract dat from given location

## xy specifies lon/latt
xy <- cbind(6.0000, 50.0000)
extract(spr_ex, xy)

## xy can be multiple sites

(df_point <- tibble(lon = c(6, 5.9), lat = c(50, 49.96)))


extract(spr_ex, y = df_point)
## discrete raster

## load forest raster
(spr_for <- rast(here("data/spr_forest_nc.tif")))


ggplot() +
  geom_spatraster(data = spr_for)

unique(spr_for)

v_binary <- values(spr_for)
mean(v_binary)


## discrete coded  value
(spr_land <- rast(here("data/spr_land_reclass.tif")))
unique(spr_land)

extract(spr_land, cbind(-79.8063, 36.0701))


### reclassification
# write a conversion matrix
# left, original value
# right, value after conversion

(cm <- cbind(c(0, 1001, 1010, 1100),
             c(0, 1, 0, 0)))

spr_bin <- classify(spr_land,
                    rcl = cm)

v_bin <- values(spr_bin)
mean(v_bin)



# ex 4.2.5 ----------------------------------------------------------------
##### 1
spr_prec_ncne <- rast(here("data/spr_prec_ncne.tif"))


###### 2
#Number of rows and columns (i.e., the raster dimensions) 162, 532

#Resolution (size of each cell in degrees) 0.008333333, 0.008333333  (x, y)

#Spatial extent (minimum and maximum coordinates) x min -79.89181,  xmax -75.45847, ymin 35.24153, ymax 36.59153

# Coordinate Reference System lon/lat WGS 84

#Minimum and maximum precipitation values min value   :        1063.1  max value   :        1501.5 

### 3
ggplot() +
  geom_spatraster(data = spr_prec_ncne)

#### 4

sf_site <- readRDS(here("data/sf_finsync_nc.rds"))

df_xy <- as.data.frame(st_coordinates(sf_site))

head(df_xy)

df_land <- extract(spr_land, df_xy)
df_land

## Identify the most common land use type at these sampling sites.

# forest 1001 

### 5



(spr_urban <- cbind(c(0, 1001, 1010, 1100),
             c(0, 0, 0, 1)))

spr_urb <- classify(spr_land,
                    rcl = spr_urban)

v_bin <- values(spr_urb)
mean(v_bin)

### 3.169 %


