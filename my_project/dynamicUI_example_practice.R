# function
library(shiny)
library(shinyjs)

getUploadTarget<-function(thisID){
  print(input[[thisID]])
  
}



ui <- fluidPage(
  
  fluidRow(
    actionButton(inputId = "upload_1" ,
                 label = "UPLOAD" ,
                 )
  ),
  
  
  shinyjs::runjs("
        
        $('.shiny-download-link').on('click', function(){
          Shiny.setInputValue('downIDs', this.id);
        });
            ")
  
  
  
  
  

  
)




server <- function(input, output, session){
  observeEvent(input$upload_1 ,{print(input$upload_1)})
  
  
}

shinyApp(ui = ui , server = server)