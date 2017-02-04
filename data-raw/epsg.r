epsg <- rgdal::make_EPSG()

library(tibble)
epsg <- as_tibble(lapply(epsg, as.character))
devtools::use_data(epsg)
