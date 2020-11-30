library(shiny)
library(DT)
library(yaml)
library(here)
library(diffr)
library(purrr)
rmdfiles <- read.csv(here("rmdfiles.csv")) # make this an input (todo)
names(rmdfiles)[1] <- "Folder"


rmdfiles_list <-rmdfiles %>%
  split(.$Folder) %>%
  imap(function(df, folder){
    val <- paste(df$Folder,df$File,sep = "/")
    names(val) <- df$File
    val
  })




folders <- unique(rmdfiles$Folder)

ui <- fluidPage(

  
  titlePanel("Generate the yaml-File"),
  
  # sidebarLayout(
    
    # sidebarPanel(
    #   fluidRow(
    #     textInput("yamlfile", "Name of the YAML",value = "_bookdown.yml")
    #   )
    # ),
    mainPanel(
      tabsetPanel(
 
        tabPanel("1. Select Files",
                 column(6,selectInput("selector", 
                                      "Choose one or more topics to include",
                                      names(rmdfiles_list), 
                                      multiple = TRUE,
                                      selectize = FALSE,
                                      selected = names(rmdfiles_list)[1],
                                      size = length(rmdfiles_list),width = "100%")),
                 column(6, fluidRow(uiOutput("fileselector")))
                 
        ),

        tabPanel("2. Check difference and export",
                wellPanel(
                  actionButton("writeyaml", "Write to YAML"),
                  shiny::div("This writes the changes to '_output.yaml' and restarts the app")
                  ),
                 h3("Check the difference betweeen files"),
                 diffrOutput("diff")
        ),
        tabPanel("Readme",
                 helpText("I created this app to simplify the selection and deselection of rmd-files to be included in the '_bookdown.yaml'-file. The idea is, that we add ALL the files with their respective folder names in a csv (csvfiles.csv) and then use this file to individually select / deselect files and folders to inlcude"),
                 helpText("Once the files / folders have been selected, click on 'write to YAML' to export the resulting list into the '_bookdown.yaml-file'")
        )
      )
      
    )
    
  # ),
  
  
  
)



server <- shinyServer(function(input, output, session) {
  
  bookdown_yaml <- read_yaml(here("_bookdown.yml"))
  
  folders_reactive <- reactive({
    map(input$selector, function(x){rmdfiles_list[[x]]}) %>% 
      magrittr::set_names(input$selector)
    })
  folders_reactive_unlist <- reactive({unlist(folders_reactive())})


  output$x4 <- renderUI(HTML(c("- ", paste(folders_reactive_unlist(),collapse =  "<br/> - "))))
  
  
  output$fileselector <- renderUI({
    selectInput("fileselector","Remove specific Files from the chosen topic(s)", 
                choices = folders_reactive(),selected = folders_reactive_unlist(),multiple = TRUE,
                selectize = FALSE,
                size = length(folders_reactive_unlist())+length(folders_reactive()),
                width = "100%")
    })
  
  observeEvent(input$writeyaml,{
    
    # bookdown_yaml <- read_yaml(here("_bookdown.yml"))
    
    bookdown_yaml$rmd_files <- c("index.Rmd",input$fileselector)
    write_yaml(bookdown_yaml, here("_bookdown.yml"))
    
    session$reload()
  })
  
    output$diff <- renderDiffr({
      
      # bookdown_yaml <- read_yaml(here("_bookdown.yml"))

      bookdown_yaml$rmd_files <- c("index.Rmd",input$fileselector)
      
      file1 = here("_bookdown.yml")

      file2 = tempfile(fileext = ".yml")
      write_yaml(bookdown_yaml, file2)
      diffr(file1, file2, before = "before", after = "after")
    })
  
 
})



# Run the application 
shinyApp(ui = ui, server = server)