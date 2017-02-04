library(maptools)
data(wrld_simpl)

country <- sf::st_as_sf(wrld_simpl)
for (i in seq_len(ncol(country))) if (is.factor(country[[i]])) country[[i]] <- levels(country[[i]])[country[[i]]]
ok <- sf::st_is_valid(country)
which(!ok)
library(sfct)
x <- ct_triangulate(country)
world <- sf::st_union(x, by_feature = TRUE)
devtools::use_data(world, compress = "xz")
