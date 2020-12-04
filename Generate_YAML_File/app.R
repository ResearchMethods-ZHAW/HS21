require(shiny)
require(shinyWidgets)
require(yaml)
require(here)
require(diffr)
require(purrr)
rmdfiles <- read.csv(here("rmdfiles.csv")) # make this an input (todo)
# names(rmdfiles)[1] <- "Folder"

rmdfiles_missing <- rmdfiles[!rmdfiles %>% pmap_lgl(function(Folder, Files){file.exists(here(Folder,Files))}),]


rmd_existing <- list.files(here(),pattern = ".Rmd",recursive = TRUE)

rmd_notlisted <- rmd_existing[!rmd_existing %in% paste(rmdfiles$Folder,rmdfiles$File, sep = "/")]

rmdfiles_list <-rmdfiles %>%
  split(.$Folder) %>%
  imap(function(df, folder){
    val <- paste(df$Folder,df$File,sep = "/")
    names(val) <- df$File
    val
  })




folders <- unique(rmdfiles$Folder)

ui <- fluidPage(
  
  fluidRow(
    wellPanel(
      fluidRow(
        column(4, h1("Generate YAML")),
        column(5,helpText("This app helps including removing Rmd Files in the '_bookdown.yml'")),
        column(3, actionButton("writeyaml", "Write to YAML (restarts App)",width = "100%"))
      ))
  ),
  fluidRow(
    tabsetPanel(
      
      tabPanel("Select Topics / Files",
               column(6,{
                 selectInput("selector",
                             "Choose one or more topics to include",
                             names(rmdfiles_list), 
                             multiple = TRUE,
                             selectize = FALSE,
                             # selected = names(rmdfiles_list)[1],
                             size = length(rmdfiles_list),width = "100%")
               },
               
               ),
               column(6, 
                      fluidRow(uiOutput("fileselector")),
                      radioButtons("showall", "display...",
                                   inline = TRUE,
                                   choices = list("all topics" = TRUE, "selected topics" = FALSE),
                                   selected = TRUE),
               )
               
      ),
      
      tabPanel("Check difference",
               
               h3("Check the difference betweeen files"),
               diffrOutput("diff")
      ),
      tabPanel("Help",
               column(5,
                      helpText("I created this app to simplify the selection and deselection of rmd-files to be included in the '__bookdown.yml'-file. The idea is, that we add ALL the files with their respective folder names in a csv (csvfiles.csv) and then use this file to individually select / deselect files and folders to inlcude"),
                      helpText("Once the files / folders have been selected, click on 'write to YAML' to export the resulting list into the '__bookdown.yml-file'")
               ),
      ),
      tabPanel("Sanitize",
               tabsetPanel(
                 tabPanel("Missing Files",tableOutput("missingdf")),
                 tabPanel("Unlisted Files",tableOutput("unlisteddf"))
               )
               )
    )
    
  )
  
  
)



server <- shinyServer(function(input, output, session) {
  
  bookdown_yaml <- read_yaml(here("_bookdown.yml"))
  
  folders_reactive <- reactive({
    map(input$selector, function(x){rmdfiles_list[[x]]}) %>% 
      magrittr::set_names(input$selector)
  })
  folders_reactive_unlist <- reactive({unlist(folders_reactive())})
  
  
  output$fileselector <- renderUI({
    pickerInput(
      inputId = "fileselector",
      label = "Add / remove specific Files from the chosen topic(s)",
      choices = if(input$showall){rmdfiles_list}else{folders_reactive()},
      selected = folders_reactive_unlist(),
      multiple = TRUE,
      width = "100%",
      options = list(`actions-box` = TRUE,
                     `selected-text-format` = "count",
                     size = "auto") # set size to FALSE to see all items
    )
    
  })
  
  output$missingdf <- renderTable(rmdfiles_missing)
  output$unlisteddf <- renderTable(data.frame(files = rmd_notlisted))
  
  observeEvent(input$writeyaml,{
    
    bookdown_yaml$rmd_files <- c("index.Rmd",input$fileselector)
    write_yaml(bookdown_yaml, here("_bookdown.yml"))
    
    session$reload()
  })
  
  output$diff <- renderDiffr({
    
    bookdown_yaml$rmd_files <- c("index.Rmd",input$fileselector)
    
    file1 = here("_bookdown.yml")
    
    file2 = tempfile(fileext = ".yml")
    write_yaml(bookdown_yaml, file2)
    diffr(file1, file2, before = "before", after = "after")
  })
  
  
})



# Run the application 
shinyApp(ui = ui, server = server)