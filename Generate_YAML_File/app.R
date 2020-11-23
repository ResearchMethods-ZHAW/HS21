library(shiny)
library(DT)
library(yaml)
library(here)

rmdfiles <- read.csv(here("rmdfiles.csv")) # make this an input (todo)

folders <- unique(rmdfiles$Folder)

ui <- fluidPage(
    
    h1("Generate _bookdown.yaml"),
    div("This application helps create the List of RMD files in the '_bookdown.yaml' file."),
    
    # h2("Choose Entire Folder"),
    fluidRow(
        column(12, selectizeInput("variable", "Choose an entire Folder (or multiple Folders)",folders, multiple = TRUE))
    ),
    
    
    h2("Generatate '_bookdown.yaml'"),
    fluidRow(
        column(2, actionButton("writeyaml", "Write YAML File"))
    ),
    
    h2("Choose individual files"),
    fluidRow(
        # column(2, textInput("yamlfile", "Name of the YAML",value = "_bookdown.yml")), # This has no effect yet (todo)
        # column(3, verbatimTextOutput('x4')),
        column(4, DT::dataTableOutput('x3'))
    )
    
)


server <- shinyServer(function(input, output, session) {
    
    # server-side processing
    output$value <- renderText({rownames(rmdfiles)[which(rmdfiles$Folder %in% input$variable)]})
    
    rowids <- reactive({
        rownames(rmdfiles)[which(rmdfiles$Folder %in% input$variable)]
    })
    
    
    output$x3 = DT::renderDataTable(rmdfiles, server = TRUE,options = list(pageLength = 100),selection = list(target = "row",selected = rowids()))
    
    rmdfiles2 <- reactive({
        rmdfiles_sel <- rmdfiles[rownames(rmdfiles) %in% input$x3_rows_selected,]
        
        rmds_torender <- paste(rmdfiles_sel$Folder, rmdfiles_sel$File, sep = "/")
        rmds_torender <- c("index.Rmd",rmds_torender)
        
        rmds_torender
        
    })
    
    output$x4 <- renderPrint(rmdfiles2())
    
    observeEvent(input$writeyaml,{
        bookdown_yaml <- read_yaml(here("_bookdown.yml"))
        bookdown_yaml$rmd_files <- rmdfiles2()
        write_yaml(bookdown_yaml, here("_bookdown.yml"))
        
    })
    
})



# Run the application 
shinyApp(ui = ui, server = server)