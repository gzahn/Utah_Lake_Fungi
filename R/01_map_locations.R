# Site map ####
library(ggmap)
library(maps)
library(tidyverse)
library(readxl)
library(geosphere)

# Load google maps API key from .Renviron
GoogleAPIKey <- Sys.getenv("GGMAP_GOOGLE_API_KEY")

# load metadata ####
meta <- read_xlsx("./Data/metadata.xlsx")
names(meta) <- c("SampleID","lat","lon","pH","temp")

# add sampletype
grepl("W",meta$SampleID)
meta <- meta %>% 
  mutate(sampletype = case_when(str_detect(pattern = "W",string = SampleID) ~ "Water",
                                TRUE ~ "Sediment"))


ggplot(meta,aes(x=sampletype,y=pH)) +
  geom_point()

# add mill location (point source pollution?)

mill_dist <- function(x,y){
  distm(c(x, y), c(-111.76412270758757, 40.32128720408934), fun = distHaversine)
}

l <- list()
for(i in seq_along(meta$SampleID)){
  l[[i]] <- mill_dist(meta$lon[i],meta$lat[i])
}
meta$dist_from_geneva <- unlist(l)



# build map of sample locations ####
ggmap::register_google(key = GoogleAPIKey) # Key kept private

mapstyle = 'feature:all|element:labels|visibility:off&style=feature:water|element:labels|visibility:on&style=feature:road|visibility:off'

lake <- get_googlemap(center = c(lon = -111.85, lat = 40.2),
                zoom = 10, scale = 2,
                maptype='terrain',
                style = mapstyle)
ggmap(lake)



lakemap <- ggmap(lake) +
  scale_x_continuous(limits = c(-112, -111.5), expand = c(0, 0)) +
  scale_y_continuous(limits = c(40, 40.4), expand = c(0, 0))

lakemap
ggsave("./Output/sitemap.png")

# add sampling locations ####
lakemap +
  geom_point(aes(x = lon, y = lat,color = dist_from_geneva), data = meta, size = 3,alpha=.5) +
  scale_color_viridis_c(option = "magma",end = .8) +
  theme(legend.position="right")
ggsave("./Output/sitemap_pH.png")
?geom_label
