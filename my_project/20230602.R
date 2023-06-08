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
      width = 3,
      textInput(
        inputId = paste0("des_", i),
        label = "Description",
        value = ""
      )
    ),
    
    column(
      width = 3,
      class = "align-self-center",
      actionButton(inputId = paste0("upload_", i) ,
                   label = "UPLOAD",
                   class = "refresh-target",
                   onclick = "getUploadTarget('uploadInput_ID',this.id)",
                   style = "margin-top: 25px"
      )
    ),
    
    column(
      width = 3,
      class = "align-self-center",
      actionButton(
        inputId = paste0("download_", i),
        label = "Download File",
        onclick = "getUploadTarget('downloadInput_ID',this.id)",
        style = "margin-top: 25px"
        
      ) |> shinyjs::hidden()
    ),
    
    column(
      width = 2,
      class = "align-self-center",
      actionButton(
        inputId = paste0("delete_", i),
        label = "Delete File",
        onclick = "getUploadTarget('deleteInput_ID',this.id)",
        style = "margin-top: 25px"
        
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
             
             #숨겨진 업로드 & 다운로드 버튼
             column(
               width = 2,
               
               fileInput( inputId = "upload_file", label = NULL) |> 
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
  


# upload ------------------------------------------------------------------

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
    
    delete_auto<-str_replace(input$uploadInput_ID,"upload","delete")
    shinyjs::show(delete_auto)
    
    shinyjs::disable(input$uploadInput_ID)
    
    
    observeEvent(input$upload_file, {
      cat("cache id =", uploadIdCache(), fill = TRUE)
      #upload file 조회
      print(input$upload_file)
      
    })
    
  })
  
  
  # download ----------------------------------------------------------------
 
  
  observeEvent(input$downloadInput_ID, {
    
    
    req(input$downloadInput_ID)
    shinyjs::click("download_file")
    
    
    })
  
  output$download_file <- downloadHandler(
    filename = function() {
      # filename needs be set reactively
      filetype <- tools::file_ext(input$upload_file$datapath)
      paste0(input$upload_file$name,".",filetype )
    },
    content = function(file) {
      img_path <-input$upload_file$datapath
      # content needs to be set reactively
      img_data <- readBin(con = img_path, what = "raw" , n = file.info(img_path)$size)
      writeBin(img_data , file)
    }
  )

  

# delete ------------------------------------------------------------------
  observeEvent(input$deleteInput_ID, {
    req(input$deleteInput_ID)
    shinyjs::click("delete_file")
    
    #delete기능
    file.remove(input$upload_file$datapath)
    
    #delete 되었는지 reactive하게 확인
    #delete 성공 -> empty , delete complete 출력
    file_check <- strsplit(x = input$upload_file$datapath , split = "/",fixed = TRUE)[[1L]]
    file_check_list <- paste0(file_check[1L] ,"/", file_check[2L])
    list_check <-file.size(file_check_list)
    
    if (list_check==0){
      print("empty, delete complete")
    }
    
    
    #다운로드 버튼  hide
    print(input$downloadInput_ID)
    download_hidden<-str_replace(input$deleteInput_ID,"delete","download")
    shinyjs::hide(download_hidden)
    
    # delete버튼 hide
    shinyjs::hide(input$deleteInput_ID)
    
    #upload버튼 활성화
    upload_enable<-str_replace(input$deleteInput_ID,"delete","upload")
    shinyjs::enable(upload_enable)
    
  })
  
  
}

shinyApp(ui = ui , server = server)