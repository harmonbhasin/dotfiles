#==============================================================================
# THEME INFORMATION FOR GGPLOT2 FIGURES
#
# Adapted from work by Will Bradshaw, originally MIT-licensed.
# Source: https://github.com/willbradshaw/sampling-strategies
# Copyright (c) 2024 Will Bradshaw.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#==============================================================================

suppressMessages(library(ggplot2))

#------------------------------------------------------------------------------
# Auxiliary functions
#------------------------------------------------------------------------------

# Avoid always having to specify units
mmargin <- purrr::partial(ggplot2::margin, unit = "mm")
lmargin <- purrr::partial(ggplot2::margin, unit = "lines")
len <- purrr::partial(ggplot2::unit, units = "mm")
lines <- purrr::partial(ggplot2::unit, units = "lines")

# Avoid having to write "inherit.blank = TRUE" everywhere
element_text <- purrr::partial(ggplot2::element_text, inherit.blank = TRUE)
element_line <- purrr::partial(ggplot2::element_line, inherit.blank = TRUE)
element_rect <- purrr::partial(ggplot2::element_rect, inherit.blank = TRUE)

# Nice axis arrows (if needed)
axis_arrow <- purrr::partial(
  arrow,
  angle = 15,
  length = len(3.5),
  type = "closed"
)

#------------------------------------------------------------------------------
# Specify font information
#------------------------------------------------------------------------------

# Family
font <- "sans" # Figure font family

# Sizes
fontsize_base <- 12 # Basic figure font size
fontsize_title <- 12 # Axis-title font size
fontsize_label <- 12 # Font size for subfigure legends

# Function for scaling geom sizes to match theme sizes
rescale_font <- function(size_pts) size_pts * 5 / 14
fontsize_base_rescaled <- rescale_font(fontsize_base)

#------------------------------------------------------------------------------
# Specify parameters
#------------------------------------------------------------------------------

# Core element parameters
line_size_base <- 0.3

# Legend parameters
legend_item_padding <- 0.5 # Extra spacing between adjacent legend items (in mm)
legend_box_fill <- "grey97"
legend_box_margin <- lmargin(rep(0.5, 4))
legend_series_spacing <- 0.2 # (in lines)
legend_key_size <- lines(1.2)
legend_box_spacing <- lines(1)

# Text parameters (in lines by default)
axis_title_spacing_x <- 0.55 # Space between x-axis text and title
axis_title_spacing_y <- 0.55 # Space between y-axis text and title
axis_text_spacing <- 0.25 # Space between axis text and ticks
axis_tick_length <- lines(0.15) # Trying doing this in lines; might go back to mm

# Panel parameters
panel_spacing <- lines(1) # Provisional, tinker later

# Strip parameters
strip_margin <- lmargin(rep(0.5, 4)) # Provisional, tinker later
strip_panel_spacing <- lines(0.2) # Ditto

# High-level plot parameters
plot_title_spacing <- 0.7 # Space between plot titles and main plot (in lines)
plot_tag_margin <- lmargin(b = 0.6, r = 0.25)
plot_margin <- lmargin(0.1, 0.4, 0.4, 0.1)
plot_aspect_ratio_base <- 1 / sqrt(2)

# Additional parameters for internal-legend themes
legend_internal_plain_fill <- alpha("white", 0.5)
legend_internal_text_spacing <- 1.5 # (in lines)
legend_internal_title_margin <- lmargin(b = 0.5)
legend_internal_box_margin_scale <- 0.86
legend_internal_spacing_y <- lines(0)
legend_internal_just_default <- c("right", "top")
legend_internal_position_default <- c(0.95, 0.95)

#------------------------------------------------------------------------------
# Define reusable themes
#------------------------------------------------------------------------------

theme_core <- theme(
  text = element_text(
    family = font,
    face = "plain",
    colour = "black",
    size = fontsize_base,
    lineheight = 1
  ),
  title = element_text(size = fontsize_title),
  line = element_line(
    colour = "black",
    linewidth = line_size_base,
    linetype = 1,
    lineend = "butt"
  ),
  rect = element_rect(fill = "white", colour = NA, linewidth = 0.5)
)

theme_defaults <- theme_minimal(base_size = fontsize_base, base_family = font) +
  theme_core
