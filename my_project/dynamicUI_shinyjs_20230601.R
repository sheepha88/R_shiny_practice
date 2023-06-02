library(shiny)
library(shinyjs)


# Function ----------------------------------------------------------------
addNewFile <- function(wrap_id, i){
  
  newFileUI <- fluidRow(
    id = paste0("addFile_",i),
    
    column(
      width = 1,
      tags$h4(i)
    ),
    
    column(
      width = 4,
      textInput(
        inputId = paste0("des_", i),
        label = "Description",
        value = ""
      )
    ),
    
    column(
      width = 4,
      class = "align-self-center",
      actionButton(inputId = "upload" ,
                   label = "UPLOAD" ,
                   onclick = "getUploadTarget('uploadInput_ID',this.id)"
      )
    ),
    
    column(
      width = 3,
      class = "align-self-center",
      actionButton(
        inputId = "download",
        label = "Download File",
        onclick = "getUploadTarget('downloadInput_ID',this.id)"
  
      ) |> shinyjs::hidden()
    )
  )
  
  insertUI(
    selector = paste0("#", wrap_id),
    where = "beforeEnd",
    ui = newFileUI
  )
}


# UI ----------------------------------------------------------------------

ui <- fluidPage(
  useShinyjs(),
  
  #HTML function 지정
  tags$head(tags$script(type = "text/javascript", 
  HTML("function getUploadTarget(value , id) {
      Shiny.setInputValue(value,id)
       ;}"))
  ),
  
  
  
  
  
  #다운로드 Row 삽입         
   fluidRow(
     class = "ms-2 mt-2",
     
     actionButton(inputId = "add",
                  label = "ADD",
                  icon = icon("plus" , class = "me-1"),
                  class="btn btn-outline-success me-1",
                  width = "100px"),
     
     actionButton(inputId = "delete",
                  label = "DELETE",
                  icon = icon("minus" , class = "me-1"),
                  class="btn btn-outline-danger me-1",
                  width = "120px"),
     
     actionButton(inputId = "done",
                  label = "DONE",
                  icon = icon("check" , class = "me-1"),
                  class="btn btn-outline-primary",
                  width = "100px")
   ),
   
   fluidRow(
     class = "ms-2 mt-4 mb-3 border-top",
     fluidRow(
       id = "here",
       class = "mt-4"
     )
   ),
   
   fluidRow(
     class = "ms-2 mt-4 pt-3 border-top",
     uiOutput("result")
   )

  
  
)


# Server ------------------------------------------------------------------
server <- function(input, output, session) {
  
  #업로드 row추가
  isolate({
    fileNum <- reactiveVal(0L)
  })
  
  observeEvent(input$add,{
    req(input$add)
    fileNum(fileNum()+1L)
    addNewFile(wrap_id = "here" , i=fileNum())
  })
  
  observeEvent(input$delete,{
    req(input$delete, fileNum() > 0L)
    removeUI( selector = paste0("#addFile_",fileNum()) )
    fileNum( fileNum() - 1L )
  })
  
  #업로드 버튼
  observeEvent(input$uploadInput_ID, {
    req(input$uploadInput_ID)
    print(input$uploadInput_ID)
    shinyjs::show("download")
  })
  
  observeEvent(input$downloadInput_ID, {
    req(input$downloadInput_ID)
    print(input$downloadInput_ID)
    
    hide("uploadInput_ID")
  })
  
  
  
  
  
  
}
  
shinyApp(ui = ui , server = server)