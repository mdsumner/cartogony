#' Create PROJ.4 string
#'
#' @param x contextual object, or central x value for default method
#' @param y central y value, for default method
#' @param family projection family to use
#' @param ... arguments passed to methods
#'
#'
#'
#' @return character PROJ.4 string
#' @export
#'
#' @examples
#' prjmaker(100, -10)
#' prjmaker(100, -10, family = "laea")
#' prjmaker()
prjmaker <- function(x, ...) {
  UseMethod("prjmaker")
}
#' @export
#' @rdname prjmaker
prjmaker.Extent <- function(x, family = "ortho") {
  xm <- mean(c(xmin(x), xmax(x)))
  ym <- mean(c(ymin(x), ymax(x)))
  prjmaker(x = xm, y = ym, family = family)
}

#' @export
#' @rdname prjmaker
prjmaker.Spatial <- prjmaker.Extent

#' @export
#' @rdname prjmaker
prjmaker.default <- function(x, y, family = "ortho") {
  sprintf("+proj=%s +ellps=WGS84 +lon_0=%f +lat_0=%f", family, x, y)
}


#' Transform data frame columns.
#'
#' Source and target names (input/output) may be identical to replace the inputs.
#' @param x data frame
#' @param proj target PROJ.4 string
#' @param input names of source coordinates, default \code{c("x_", "y_")}
#' @param output names of target coordinates, added to data frame (or modified if they exist)
#'
#' @return
#' @export
#'
#' @examples
projDFcolumns <- function(x, proj, input = c("x_", "y_"),
                          output = c("X", "Y"), densify = FALSE) {
  if (densify) x <- densifyDF(x)
  xy <- project(as.matrix(x[, input]), proj)
  x[[output[1]]] <- xy[,1]
  x[[output[2]]] <- xy[,2]
  x
}

densifyDF <- function(x) {
  ll <- split(x, x$branch_)
  for (i in seq_along(ll)) {
    xy <- do.call(cbind, approx(ll[[i]]$x_, ll[[i]]$y_, n = nrow(ll[[i]]) * 10))
    d <- data.frame(x_ = xy[,1], y_ = xy[,2],
                    branch_ = ll[[i]]$branch_[i],
                    object_ = ll[[i]]$object_[i],
                    order_ = seq(nrow(xy)),
                    island_ = ll[[i]]$island_[i])

    ll[[i]] <- d
  }
  ll
}
