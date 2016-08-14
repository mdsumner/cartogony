
Globey globes in R
------------------

These are hard to do for several reasons:

-   topology is not present in most map data and tools for them
-   'sp::spTransform' will not return a result with missing coordinates
-   'rgdal::project' only works on raw coordinates
-   individual plot frames take time, so need to be cached (or the preparation cached)

This readme shows a couple of ways to get around all but the topology problems, and may in time become a way to explore solutions for the topology as well. I think the best way will be to use RTriangle, which has the bonus that that's also the way to plot stuff in 3D.

For the animation I used the approach in the 'gganimate' package README. NOTE: as well as ImageMagick for a standalone GIF, you need **named chunks** in the RMarkdown for this to work.

``` r
## to snapshot the frame loop
library(animation)
## for PROJ4
library(rgdal)  
## for a simple world coastline
library(maptools) 
## for longlat lines 
library(graticule) 
 ## for working with spatial in a  generic way
library(spbabel) 
## for functions to project coordinates in a data frame version of Spatial
library(cartogony)  
library(rworldmap)
data(countriesLow)
wrldtab <- sptable(countriesLow)

grat0 <- sptable(graticule())
```

``` r
rotseq <- head(seq(-180, 180, length = 36), -1L)
lat <- -42
for (i in seq_along(rotseq)) {
grat <- projDFcolumns(grat0 , prjmaker(rotseq[i], lat))
p <- par(mar = rep(0, 4))
plot(grat$X, grat$Y, pch = ".", asp = 1, axes = FALSE, xlab = "", ylab = "")
lapply(split(grat, grat$branch_), function(x) lines(x$X, x$Y))


wrld0 <- projDFcolumns(wrldtab, prjmaker(rotseq[i], lat))
junk <- lapply(split(wrld0, wrld0$branch_), function(x) try(polygon(x$X, x$Y, col = "grey"), silent = TRUE))

par(p)

}
```

![anim](README/README-fig-anim-.gif)

``` r
rotseq <- head(seq(-180, 180, length = 36), -1L)
lat <- 42
for (i in seq_along(rotseq)) {
grat <- projDFcolumns(grat0, prjmaker(rotseq[i], lat))
p <- par(mar = rep(0, 4))
plot(grat$X, grat$Y, pch = ".", asp = 1, axes = FALSE, xlab = "", ylab = "")
lapply(split(grat, grat$branch_), function(x) lines(x$X, x$Y))


wrld0 <- projDFcolumns(wrldtab, prjmaker(rotseq[i], lat))
junk <- lapply(split(wrld0, wrld0$branch_), function(x) try(polygon(x$X, x$Y, col = "grey"), silent = TRUE))

par(p)

}
```

![anim2](README/README-fig-anim2-.gif)
