library(sf) #for vector data
library(data.table)
library(ggplot2)
library(tmap)
library(dplyr)

geojson <- "https://www.ogd.stadt-zuerich.ch/wfs/geoportal/Statistische_Quartiere?service=WFS&version=1.1.0&request=GetFeature&outputFormat=GeoJSON&typename=adm_statistische_quartiere_map"

quartiere <- st_read(geojson)

plot(quartiere)

# plot with tmap
tmap_options(check.and.fix = TRUE)
tm_shape(quartiere) + tm_fill(col = "qnr")

dogs <- fread("https://data.stadt-zuerich.ch/dataset/sid_stapo_hundebestand_od1001/download/KUL100OD1001.csv")
dogs <- dogs[StichtagDatJahr == 2023, .N, by = .(QuarSort, Rasse1Text)]

merged <- merge(quartiere, dogs, by.x = "qnr", by.y = "QuarSort", all.x = TRUE)

merged |>
  group_by(qnr, geometry) |>
  dplyr::summarize(N = sum(N), .groups = "drop") |>
ggplot() +
  aes(fill = N) + 
  geom_sf()
  

