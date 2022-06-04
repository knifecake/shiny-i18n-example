library(shiny)
library(shiny.i18n)

i18n <- Translator$new(translation_json_path = paste0(getwd(), '/final-translation.json') )
i18n$set_translation_language("es")

dropdownChoices <- c('one', 'two', 'three')
names(dropdownChoices) <- c(i18n$t('Option 1'), i18n$t('Option 2'), i18n$t('Option 3'))


# Define UI for application that draws a histogram
ui <- fluidPage(
    # Application title
    titlePanel(i18n$t("Old Faithful Geyser Data")),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        i18n$t("Number of bins:"),
                        min = 1,
                        max = 50,
                        value = 30),
            selectInput('dropdown', label=i18n$t("Useless dropdown"), choices=dropdownChoices)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           textOutput('dropdown'),
           markdown(i18n$t("long_box_1")),
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
    
    output$dropdown <- renderText({
      if (input$dropdown == 'two') {
        i18n$t('You selected Option 2')
      } else {
        i18n$t('Some option other than 2 has been chosen')
      }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
