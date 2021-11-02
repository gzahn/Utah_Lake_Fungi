# Site map ####
library(ggmap)
library(maps)
library(tidyverse)

# load metadata ####



# build map of sample locations ####
ggmap::register_google(key = "---") # Key kept private

mapstyle = 'feature:all|element:labels|visibility:off&style=feature:water|element:labels|visibility:on&style=feature:road|visibility:off'

lake <- get_googlemap(center = c(lon = -111.85, lat = 40.2),
                zoom = 10, scale = 2,
                maptype='terrain',
                style = mapstyle)
ggmap(lake)

lakemap <- ggmap(lake) +
  scale_x_continuous(limits = c(-112, -111.5), expand = c(0, 0)) +
  scale_y_continuous(limits = c(40, 40.4), expand = c(0, 0))

lakemap +
  geom_point(aes(x = Longitude, y = Latitude, colour = BurnYear), data = df2, size = 4) +
  theme(legend.position="right")

+ 
   +
  scale_colour_viridis_c() +
  borders("state", colour = "dark blue", region = "utah", size = 2) +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())
