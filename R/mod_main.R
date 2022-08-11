#' main UI Function
#'
#' @noRd
#' @importFrom shiny NS tagList
mod_main_ui <- function(id) {
    opts <- data %>%
        .$SUBGROUP %>%
        unique()
    ns <- NS(id)


    shiny.quartz::QCard(
        shiny.quartz::VStack(
            shiny.mui::Alert(severity = "info", "Select subgroups from below to visualize excess mortality during the pandemic."),
            shiny.mui::Autocomplete.shinyInput(
                    ns("subgroup"),
                    groupBy = shiny.react::JS('(d) => d.slice(1).split(")")[0]'),
                    options = opts,
                    inputProps = list(label = "Subgroup"),
                    disableCloseOnSelect = T,
                    value = opts[1:4] %>% as.list(),
                    multiple = T
    ),

        plotly::plotlyOutput(ns("plot")),
        shiny.mui::Typography(variant = "body2", "Elapsed Months", textAlign = "center")
        
    ))
}


#' main Server Funciton
#'
#' @noRd
#' @import ggsci
#' @import ggplot2
#' @import dplyr
mod_main_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        output$plot <- plotly::renderPlotly({
            req(input$subgroup)

            (data %>%
                subset(SOURCE != "CDC") %>%
                filter(
                    # GROUP == "GROUP1",
                    between(elapsed_months, 1, 20),
                    SUBGROUP %in% input$subgroup
                    # SUBGROUP %in% c("United StatesGROUP1", "ORGAN HR", "ORGAN KI", "ORGAN LI", "ORGAN LU")
                ) %>%
                ggplot(aes(x = elapsed_months, y = `Cumulative excess deaths 10k`, color = SUBGROUP)) +
                geom_point(size = 1.6) +
                geom_line(size = 1, alpha = 0.8) +
                scale_color_jama() +
                scale_fill_jama() +
                ylab("Cumulative excess \nmortality (per 10,000)") +
                scale_x_continuous(limits = c(1, 20), breaks = seq(1, 20, 1)) +
                scale_y_continuous(limits = c(-10, 200), breaks = seq(0, 200, 25)) +
                xlab("") +
                theme(
                    legend.position = "top",
                )) %>%
                plotly::ggplotly() %>%
                plotly::layout(legend = list(
                    orientation = "h"
                ))
        })
    })
}

