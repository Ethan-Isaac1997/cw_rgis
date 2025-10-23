

# data_packages -----------------------------------------------------------


if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars,
               here)


# crop --------------------------------------------------------------------

#cropping specific area from the larger roster

(spr_prec <- rast(here("data/spr_prec_us.tif")))

#ggplot() +
 # geom_spatraster(data = spr_prec)

## retunrs the extewnt of the layer

ext(spr_prec)

## crop to:
## longitude range: -80 to -75 E and W extremes
## latitude range: 34 to 37 South and North extremes
spr_prec_crop <- crop(x = spr_prec,
                      y = c(-80, -75, 34, 37))

## load county vector 
sf_nc_county <- readRDS(here("data/sf_nc_county.rds"))

ggplot() +
  geom_spatraster(data = spr_prec_crop) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25) ## alpha = 0.25 makes the polygon layer transparent




## use vector layer as a mask layer 

spr_prec_nc <- crop(x = spr_prec,
                    y = sf_nc_county)

ggplot() +
  geom_spatraster(data = spr_prec_nc) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


# merge -------------------------------------------------------------------

spr_nw <- rast(here("data/spr_prec_ncnw.tif")) # Northwest NC
spr_ne <- rast(here("data/spr_prec_ncne.tif")) # Northeast NC
spr_sw <- rast(here("data/spr_prec_ncsw.tif")) # Southwest NC
spr_se <- rast(here("data/spr_prec_ncse.tif")) # Southeast NC


ggplot() +
  geom_spatraster(data = spr_nw) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)
## merge them

spr_n <- merge(spr_nw, spr_ne)

## visualize
ggplot() +
  geom_spatraster(data = spr_n) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


#### compare extent between nw and n
ext(spr_nw)
ext(spr_n)

###### merge multiple raster layers
## list step: create a list of raster layers
list_spr <- list(spr_ne,
     spr_nw,
     spr_se,
     spr_sw)


spr_col <- sprc(list_spr)

spr_merge <- merge(spr_col)
ggplot() +
  geom_spatraster(data = spr_merge) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)

writeRaster(spr_merge, 
            filename = here("data/spr_prec_nc.tif"),
            overwrite = TRUE)

# stack -------------------------------------------------------------------
####### cannot stack if the cells are different resolution. 


(spr_prec_nc <- rast(here("data/spr_prec_nc.tif")))
(spr_tmp_nc <- rast(here("data/spr_tmp_nc.tif")))

## stacking the rast layers

(spr_pt_nc <- c(spr_prec_nc,
                spr_tmp_nc))



# Re projection ------------------------------------------------------------

print(spr_prec_nc)


########## re projection it to a projected CRS using the project() function.
# for discreet nearest neighbor for land use types
## bi-linear for continues sampling taking average from original to new raster. 

(spr_prec_nc_proj <- project(x = spr_prec_nc,
                             y = "EPSG:32617",
  method = "bilinear"))




# ex. ---------------------------------------------------------------------

########### Part 1 Merge


#### Visualize
(spr_nw_t <- rast(here("data/spr_tmp_ncnw.tif")))
(spr_ne_t <- rast(here("data/spr_tmp_ncne.tif")))
(spr_sw_t <- rast(here("data/spr_tmp_ncsw.tif")))
(spr_se_t <- rast(here("data/spr_tmp_ncse.tif")))

### Merge
list_spr <- list(spr_nw_t,
                 spr_ne_t,
                 spr_sw_t,
                 spr_se_t)

spr_col <- sprc(list_spr)

spr_merge <- merge(spr_col)


writeRaster(spr_merge, 
            filename = here("data/spr_tmp_ncnw.tif"),
            overwrite = TRUE)


ggplot() +
  geom_spatraster(data = spr_merge) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)




############# Part 2 Crop
saveRDS(sf_nc_county,
        file = here("data/sf_nc_county.rds"))
sf_nc_county

sf_camden <- sf_nc_county %>%
  filter(county == "camden")


## inspect

ext(sf_camden)

##### Crop spr_merge to the extent of the camden county using sf_camden. Assign the cropped raster to spr_tmp_camden


## creating a spatvector compared to doing it with the coordinates

?vect()
camden_vect <- vect(sf_camden)

(spr_tmp_camden <- crop(spr_merge, camden_vect))

(spr_tmp_camden_2 <- crop(x = spr_merge, 
                         y = c(-76.5632550080924, -75.9568384754626, 36.1698027698011, 36.5561260977251)))


#### Visualize
ggplot() +
  geom_spatraster(data = spr_tmp_camden) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)



############ Part 3


(spr_tmp_camden_proj <- project(x = spr_tmp_camden,
                             y = "EPSG:32618",
                             method = "bilinear"))


