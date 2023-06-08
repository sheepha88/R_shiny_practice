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


id_ext <- function(inputID){
  strsplit(x=inputID, split = "_", fixed = TRUE)[[1L]][2L] |>
    as.integer()
}




ui <- fluidPage(
  useShinyjs(),
  
  #HTML function 지정
  tags$head(tags$script(type = "text/javascript", 
                        HTML("function getUploadTarget(value , id) {
      
      Shiny.setInputValue(value,id, {priority: 'event'});
      
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
    
    print(id)
    
    uploadIdCache(id)
    shinyjs::click("upload_file")
    
    download_auto<-str_replace(input$uploadInput_ID,"upload","download")
    shinyjs::show(download_auto)
    
    delete_auto<-str_replace(input$uploadInput_ID,"upload","delete")
    shinyjs::show(delete_auto)
    
    shinyjs::disable(input$uploadInput_ID)

  })
  
  # tmp directory
  
  # 변수 초기설정
  isolate({
    tmpDir <- "data/tmp"
    fileInfo <- reactiveValues()
  })
  
  observeEvent(input$upload_file, {
    
    req(input$upload_file)
    
    if ( !dir.exists(tmpDir) ){
      dir.create(tmpDir, recursive = TRUE)
    }
    
    id <- uploadIdCache()
    rawName <- input$upload_file$name
    fileExt <- tools::file_ext(rawName)
    stdName <- sprintf("f%03d.%s", id, fileExt)
    tmpPath <- file.path(tmpDir, sprintf("f%03d.%s", id, fileExt))
    
    
    file.copy(
      from  = input$upload_file$datapath,
      to = tmpPath,
      overwrite = TRUE
    )
    
    fileInfo[[paste0("i", id)]] <- list(
      "rawName" = rawName,
      "tmpPath" = tmpPath,
      "stdName" = stdName
    )
  
  })
  
  
  # download ----------------------------------------------------------------
  downloadIdCache <- reactiveVal(0L)
  
  
  observeEvent(input$downloadInput_ID, {
    
    req(input$downloadInput_ID)
    
    download_id <- strsplit(x=input$downloadInput_ID, split = "_", fixed = TRUE)[[1L]][2L] |>
      as.integer()
 
    downloadIdCache(download_id)
    shinyjs::click("download_file")
    
    })
  
  output$download_file <- downloadHandler(
    
    filename = function() {
      # filename needs be set reactively
      id<-downloadIdCache()
      fileInfo[[paste0("i", id)]]$rawName
    },
    content = function(file) {
      id<-downloadIdCache()
      img_path <-fileInfo[[paste0("i", id)]]$tmpPath
      # content needs to be set reactively
      img_data <- readBin(con = img_path, what = "raw" , n = file.info(img_path)$size)
      writeBin(img_data , file)
    }
    
  )

  

# delete ------------------------------------------------------------------
 
  observeEvent(input$deleteInput_ID, {
    req(input$deleteInput_ID)
    
    #ID추출
    delete_id <- id_ext(inputID = input$deleteInput_ID)
    
    shinyjs::click("delete_file")
    
    #변수 설정
    file_path <- fileInfo[[paste0("i", delete_id)]]$tmpPath
    file_name <- fileInfo[[paste0("i", delete_id)]]$stdName
    
    #delete기능
    ##디렉토리에서 삭제
    file.remove(file_path)
    
    ##디렉토리에서 삭제 되었는지 확인
    if (file_name %in% list.files(path= dirname(file_path))){
      print(paste0(file_name,"이 삭제안됨"))
    }else{
      print(paste0(file_name,"이 삭제됨"))
    }
    
    
    ##fileinfo (reactiveVal)에서 삭제
    fileInfo[[paste0("i", delete_id)]] <- NULL
    print("===fileinfo삭제 확인====")
    print(fileInfo[[paste0("i", delete_id)]])
    
    
    #다운로드 버튼  hide
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