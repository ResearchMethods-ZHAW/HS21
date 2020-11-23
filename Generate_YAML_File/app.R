library(shiny)
library(DT)
library(yaml)
library(here)

rmdfiles <- read.csv(here("rmdfiles.csv")) # make this an input (todo)

folders <- unique(rmdfiles$Folder)

ui <- fluidPage(
    tags$head(
        tags$style(HTML("
      
      .dataTables_filter {visibility: hidden;}

    "))
    ),
    
    titlePanel("Generate the yaml-File"),
    
    sidebarLayout(
        
        sidebarPanel(
            fluidRow(
                selectInput("variable", 
                            "Choose one or more topics to include",
                            folders, 
                            multiple = TRUE,
                            selectize = FALSE,
                            # selected = folders,
                            size = 10),
                textInput("yamlfile", "Name of the YAML",value = "_bookdown.yml"),
                actionButton("writeyaml", "Write to YAML")
                
            )
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Select Files",
                    fluidRow(
                        column(12, DT::dataTableOutput('x3'))
                    )
                ),
                tabPanel("Check result",
                         column(12, div("Files to render:")),
                         column(12, shiny::htmlOutput('x4'))
                         ),
                tabPanel("Readme",
                         helpText("I created this app to simplify the selection and deselection of rmd-files to be included in the '_bookdown.yaml'-file. The idea is, that we add ALL the files with their respective folder names in a csv (csvfiles.csv) and then use this file to individually select / deselect files and folders to inlcude"),
                         helpText("Once the files / folders have been selected, click on 'write to YAML' to export the resulting list into the '_bookdown.yaml-file'")
                         )
            )
            
        )
        
    ),
    
   
   
)










server <- shinyServer(function(input, output, session) {
    
    # server-side processing
    output$value <- renderText({rownames(rmdfiles)[which(rmdfiles$Folder %in% input$variable)]})
    
    rowids <- reactive({
        rownames(rmdfiles)[which(rmdfiles$Folder %in% input$variable)]
    })
    
    
    output$x3 = DT::renderDataTable(rmdfiles, server = TRUE,filter = "top",options = list(pageLength = 100),selection = list(target = "row",selected = rowids()))
    
    rmdfiles2 <- reactive({
        rmdfiles_sel <- rmdfiles[rownames(rmdfiles) %in% input$x3_rows_selected,]
        
        rmds_torender <- paste(rmdfiles_sel$Folder, rmdfiles_sel$File, sep = "/")
        rmds_torender <- c("index.Rmd",rmds_torender)
        
        rmds_torender
        
    })
    
    output$x4 <- renderUI(HTML(c("- ", paste(rmdfiles2(),collapse =  "<br/> - "))))
    
    observeEvent(input$writeyaml,{
        bookdown_yaml <- read_yaml(here("_bookdown.yml"))
        bookdown_yaml$rmd_files <- rmdfiles2()
        write_yaml(bookdown_yaml, here("_bookdown.yml"))
        
    })
    
})



# Run the application 
shinyApp(ui = ui, server = server)