library(tigris)
library(dplyr)
data(fips_codes)
library(stringr)
library(leaflet)
library(ggplot2)
library(biscale)
library(cowplot)
library(ggmap)
library(tidyverse)
library(sf)
load("./EM_ALL.rdata")
options(tigris_use_cache = T)
ggquartz::apply_theme()

tigris::counties(cb = T, resolution = "20m")

tigris::states(cb = T, resolution = "20m") %>%
    rename(state = STUSPS, state_long = NAME) %>%
    st_transform(5070) %>%
    select(state, state_long) %>%
    shift_geometry() -> states

max_elapsed_months <- 20

sot <- EM_ALL %>%
    subset(GROUP == "GROUP14" & elapsed_months == max_elapsed_months) %>%
    rename(
        sot = `Cumulative excess deaths 10k`,
        state = "SUBGROUP"
    ) %>%
    select(state, sot)


cdc <- EM_ALL %>%
    subset(SOURCE == "CDC" & GROUP == "GROUP1" & elapsed_months == max_elapsed_months) %>%
    mutate(state_long = gsub("GROUP1", "", SUBGROUP)) %>%
    rename(cdc = `Cumulative excess deaths 10k`) %>%
    select(state_long, cdc)

combined <- cdc %>%
    right_join(states) %>%
    select(state, cdc, geometry) %>%
    st_as_sf() %>%
    merge(sot, by = "state")

data <- bi_class(combined, x = sot, y = cdc, style = "quantile", dim = 3)

map <- ggplot() +
    geom_sf(
        data = data,
        mapping = aes(fill = bi_class),
        color = "white",
        size = 0.1,
        show.legend = FALSE
    ) +
    bi_scale_fill(pal = "GrPink", dim = 3) +
    bi_theme()


legend <- bi_legend(
    pal = "GrPink",
    dim = 3,
    xlab = "Higher SOT Mortality ",
    ylab = "Higher US Mortality ",
    size = 7
)

ggdraw() +
    draw_plot(map, 0.05, 0.05, 0.95, 0.95) +
    draw_plot(legend, 0.82, .1, 0.2, 0.25)


ggsave("biscale_mapv2.tiff", width = 10, height = 6)
