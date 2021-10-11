

get_articles <- function(dir){
  list.files(dir, "\\.Rmd$", recursive = TRUE, full.names = TRUE)
}

# render_all <- function(dir){
#   rmd_files <- get_articles(dir)
#   
#   err <- purrr::map_lgl(rmd_files, function(x){
#     tryCatch(
#       {rmarkdown::render(x)
#       return(FALSE)}, 
#       error = function(y){return(TRUE)})
#   })
#   
#   data.frame(rmd_files, error = err)
# }


