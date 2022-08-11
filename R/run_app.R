shiny::addResourcePath(prefix = "www", directoryPath = "./www")
#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
    # Your application server logic
    mod_main_server("main")
}

app_ui <- function(request) {
    shiny.quartz::Page(
        # "main",
        "",
        maxWidth = "lg",
        shiny.mui::Container(maxWidth = "lg",
        shiny.quartz::VStack(
            shiny.quartz::QCard(
                shiny.mui::Box(
                    width = "100%",
                    display = "flex",
                    justifyContent = "center",
                    shiny.mui::Box(
                        sx = list(width = list(xs = "100%", sm = "90%", md = "80%", lg = "70%")),
                        img(src='www/abstract.png', width = "100%")
                    )
                )
            ),
            mod_main_ui("main"),
            shiny.quartz::AcknowledgementCard(
                authors =
                 list(
                    list(name = "Jacob A. Clarke, MD",
                        src = "https://www.jacobaclarke.com/headshot_new_cropped.jpg",
                        href = "https://www.jacobaclarke.com/"),
                    list(name = "Timothy L. Wiemken, PhD",
                        src = "https://media-exp1.licdn.com/dms/image/C4E03AQE4JkLxHi1g7A/profile-displayphoto-shrink_400_400/0/1603549767246?e=1655337600&v=beta&t=mGGA7RxgQvdi0yIvbwiOJXiJ0uvM_YAm0-UuybyOp8g"),

                    list(name = "Kevin M. Korenblat, MD")
                )
            )
        )
        )
    )
}

#' Run App
#' Main function called in the app.R file to run the app
#' @export
run_app <- function() {
    shiny::shinyApp(
        server = app_server,
        ui = app_ui,
    )
}