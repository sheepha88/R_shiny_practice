x <- c("upload_1", "upload_2")

id <- strsplit(x, split = "_", fixed = TRUE)[[1L]][2L] |> 
  as.integer()
  

new_download_id <- paste0("download_", id)
new_download_id


library(shiny)

actionButton("aa", "AA", class = "qwert123 asdasdasdsa")
# one shiny gadget -> one html tag

textInput("bb", "BB")
# one shiny gadget -> a group of html tags

textInput("bb", "BB") |> 
  tagAppendAttributes(tag = _,  .cssSelector = "input", class = "additional")



test<-"a_b_cd"
aa <- strsplit(x = test , fixed = TRUE , split = "_")[[1]] |> as.
aa
