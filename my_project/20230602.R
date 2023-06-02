library(shiny)
library(shinyjs)
library(stringr)
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
      actionButton(inputId = paste0("upload_", i) ,
                   label = "UPLOAD",
                   class = "refresh-target",
                   onclick = "getUploadTarget('uploadInput_ID',this.id)"
      )
    ),
    
    column(
      width = 3,
      class = "align-self-center",
      actionButton(
        inputId = paste0("download_", i),
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




ui <- fluidPage(
  useShinyjs(),
  
  #HTML function 지정
  tags$head(tags$script(type = "text/javascript", 
                        HTML("function getUploadTarget(value , id) {
      Shiny.setInputValue(value,id)
      
       ;}"))
  ),
  
  
  tabPanel("Files",
           titlePanel("Files Upload"),
           h2("alert!!! you need to upload some images"),
           
           fluidRow(
             class = "ms-2 mt-2 mb-4",
             
             column(
               width = 10,
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
                            width = "100px"),
               
               actionButton(inputId = "refresh",
                            label = "REFRESH",
                            icon = icon("rotate" , class = "me-1"),
                            class="btn btn-outline-primary",
                            width = "100px")
             ),
             
             column(
               width = 2,
               
               fileInput(inputId = "upload_file", label = NULL) |> 
                 tagAppendAttributes(tag = _, class = "sr-only" ),
               
               downloadButton(outputId = "download_file", label = NULL, class = "sr-only")
             )

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
  ),
  
)


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
  
  
  observeEvent(input$refresh,{
    req(input$refresh, fileNum() > 0L)
    
    
    
    
    shinyjs::enable(
      selector = ".refresh-target") ## VERY VERY GOOD JOB

    
  })
  
  #업로드 버튼
  
  uploadIdCache <- reactiveVal(0L)
  
  observeEvent(input$uploadInput_ID, {
    req(input$uploadInput_ID)
    print(input$uploadInput_ID)
    
    id <- strsplit(x=input$uploadInput_ID, split = "_", fixed = TRUE)[[1L]][2L] |> 
      as.integer()
    
    uploadIdCache(id)

    shinyjs::click("upload_file")
    
    download_auto<-str_replace(input$uploadInput_ID,"upload","download")
    shinyjs::show(download_auto)
    
  })
  
  observeEvent(input$downloadInput_ID, {
    req(input$downloadInput_ID)
    print(input$downloadInput_ID)
    
    disable_input <- str_replace(input$downloadInput_ID,"download","upload")
    shinyjs::disable(disable_input)

  })
  
  
  observeEvent(input$upload_file, {
    
    cat("cache id =", uploadIdCache(), fill = TRUE)
    print(input$upload_file)
    
  })
  
  
  output$download_file <- downloadHandler(
    filename = function() {
      # filename needs be set reactively
    },
    content = function(file) {
      # content needs to be set reactively
    }
  )
  
}

shinyApp(ui = ui , server = server)