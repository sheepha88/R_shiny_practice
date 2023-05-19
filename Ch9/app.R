#### upload ####
# fluidpage에 filteinput추가->간단
# vector가 아닌 dataframe으로 반환
# 4개의 열을 지닌 datafrmae으로 반환  : name , size , type , datapath(서버의 일시적 경로 , 사용자가 다른 파일을 더 업로드하면 삭제됨)
# buttonlabel = 업로드 버튼 name , multiple = TRUE

# library(shiny)
# 
# ui <- fluidPage(
#   fileInput("upload", NULL, buttonLabel = "업로드.", multiple = TRUE),
#   tableOutput("files")
# )
# server <- function(input, output, session) {
#   output$files <- renderTable(input$upload)
# }
# # Run the application 
# shinyApp(ui = ui, server = server)


#### 데이터업로드 advance ver ####
# req의 필요성  : 첫번째 파일이 업로드되기 전까지 기다리기 위해 req 사용
# accept , tools::file_ext(): 입력제한 , ex. csv , xlxsx만 가능하게
# csv 나 tsv인 여러조합의 오류 이므로 validate와 if(switch)를 사용한다
# tools::file_ext : 파일의 확장자 추출 , 반환값 : "tsv"

# ui <- fluidPage(
#   fileInput("upload", NULL, accept = c(".csv", ".tsv")),
#   numericInput("n", "Rows", value = 5, min = 1, step = 1),
#   tableOutput("head")
# )
# 
# server <- function(input, output, session) {
#   data <- reactive({
#     req(input$upload)
#     
#     ext <- tools::file_ext(input$upload$name)
#     cat("extdsagdasgd:", ext, "\n")  # ext 값을 콘솔에 출력
#     switch(ext,
#            
#            csv = vroom::vroom(input$upload$datapath, delim = ","),
#            tsv = vroom::vroom(input$upload$datapath, delim = "\t"),
#            validate("Invalid file; Please upload a .csv or .tsv file")
#     )
#     
#   })
#   
#   output$head <- renderTable({
#     head(data(), input$n)
#   })
# }
# 
# # Run the application
# shinyApp(ui = ui, server = server)


#### 다운로드 ####
# downloadhandler ( filename , content)
# ㄴfilename = 사용자의 다운로드 다이얼로그 박스에 표시될 파일이름 생성(ex iris , 문자열 반환)
# ㄴcontent = 파일이 저장될 경로 지정하는 함수 ? 이해가 잘 가지 않음 , 사용자가 지정하는 파일경로에 파일을 생성해주는 함수?
# ui <- fluidPage(
#   selectInput("dataset", "Pick a dataset", ls("package:datasets")),
#   tableOutput("preview"),
#   downloadButton("download", "Download .tsv")
# )
# 
# server <- function(input, output, session) {
#   data <- reactive({
#     out <- get(input$dataset, "package:datasets")
#     if (!is.data.frame(out)) {
#       validate(paste0("'", input$dataset, "' is not a data frame"))
#     }
#     out
#   })
#   
#   output$preview <- renderTable({
#     head(data())
#   })
#   
#   output$download <- downloadHandler(
#     filename = function() {
#       paste0(input$dataset, ".tsv")
#     },
#     content = function(file) {
#       vroom::vroom_write(data(), file)
#     }
#   )
# }
# 
# shinyApp(ui = ui, server = server)



#### Downloading reports ####
# 인터랙티브한 리포트 생성 및 다운로드
# R마크다운 문서 사용


# ui <- fluidPage(
#   sliderInput("n", "Number of points", 1, 100, 50),
#   downloadButton("report", "Generate report")
# )
# 
# server <- function(input, output, session) {
#   output$report <- downloadHandler(
#     filename = "report.pdf",
#     content = function(file) {
#       params <- list(n = input$n)
#       
#       id <- showNotification(
#         "Rendering report...", 
#         duration = NULL, 
#         closeButton = FALSE
#       )
#       on.exit(removeNotification(id), add = TRUE)
#       
#       rmarkdown::render("report.pdf", 
#                         output_file = file,
#                         params = params,
#                         envir = new.env(parent = globalenv())
#       )
#     }
#   )
# }
# 
# shinyApp(ui = ui, server = server)




#### 사례####
# ui도 복잡하면 나눠서 진행하여 fluidpage에서 변수로 일괄진행 가능
# janitor::remove_constant : 모든 열 제거
# janitor::make_clean_names : 데이터프레임 열 이름을 깔끔 , 욀관된 형식으로 변환
# delim = null : 자동으로 추측한다.
# tools::file_path_sans_ext 와 tools::file_ext의 차이
# ㄴfile_path_sans_ext : 경로+확장자 "/path/to/file"
# ㄴtools::file_ext    : ".csv"

# vroom과 data.table의 fread차이
# ㄴvroom : 대용량 데이터를 효율적으로 메모리로 읽어들이는 빠른 파일 리더 , csv&tsv에 특화
# ㄴdata.table : 파일을 읽기 위한 fread 및 fread.auto 함수가 제공되지만, vroom과 같은 대용량 데이터 처리에 대한 성능을 제공X , 처리에 대한 프로세스는 빠르다.
# ㄴ파일 읽기만 하면 된다면 vroom , 읽고 기타 작업을 해야한다면 data.table이 강력


# ui_upload <- sidebarLayout(
#   sidebarPanel(
#     fileInput("file", "Data", buttonLabel = "Upload..."),
#     textInput("delim", "Delimiter (leave blank to guess)", ""),
#     numericInput("skip", "Rows to skip", 0, min = 0),
#     numericInput("rows", "Rows to preview", 10, min = 1)
#   ),
#   mainPanel(
#     h3("Raw data"),
#     tableOutput("preview1")
#   )
# )


# ui_clean <- sidebarLayout(
#   sidebarPanel(
#     checkboxInput("snake", "Rename columns to snake case?"),
#     checkboxInput("constant", "Remove constant columns?"),
#     checkboxInput("empty", "Remove empty cols?")
#   ),
#   mainPanel(
#     h3("Cleaner data"),
#     tableOutput("preview2")
#   )
# )

# ui_download <- fluidRow(
#   column(width = 12, downloadButton("download", class = "btn-block"))
# )


# ui <- fluidPage(
#   ui_upload,
#   ui_clean,
#   ui_download
# )


# server <- function(input, output, session) {
#   # Upload ---------------------------------------------------------
#   raw <- reactive({
#     req(input$file)
    
#     delim <- if (input$delim == "") NULL else input$delim
#     vroom::vroom(input$file$datapath, delim = delim, skip = input$skip)
#   })
#   output$preview1 <- renderTable(head(raw(), input$rows))
  
#   # Clean ----------------------------------------------------------
#   tidied <- reactive({
#     out <- raw()
#     if (input$snake) {
#       names(out) <- janitor::make_clean_names(names(out))
#     } else {
#       validate( "Please check the 'Snake case' option")
#     }
    
#     if (input$constant) {
#       out <- janitor::remove_constant(out)
#     }else{
#       validate( "Please check the 'constant case' option")
#     }
    
#     if (input$empty) {
#       out <- janitor::remove_empty(out, "cols")
#     }else{
#       validate( "Please check the 'empty case' option")
#     }
    
    
#     out
#   })
#   output$preview2 <- renderTable(head(tidied(), input$rows))
  
#   # Download -------------------------------------------------------
#   output$download <- downloadHandler(
#     filename = function() {
      
#       paste0(tools::file_path_sans_ext(input$file$name), ".tsv")
      
#     },
    
#     content = function(file) {
      
#       vroom::vroom_write(tidied(), file)
#     }
#   )
# }

# shinyApp(ui = ui, server = server)



# exercise_dev --------------------------------------------------------------

library(shiny)
library(shinyFeedback)

# 초진여부 목록
list_num = c("First" , "Second" , "Trird" , "Others")

#
ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  

  theme = bslib::bs_theme(
    version = 5,
    # bootswatch = "darkly",
    base_font = "Source Sans Pro"
    ),
    tags$head(tags$style(
      ".form-control-feedback i{
        display:none;
      }"
    )),

  tabsetPanel(
    tabPanel("HOME",
      #타이틀 bar
      titlePanel("Profile"),
      #name
      textInput("name" ,"Name",placeholder = "HONG GIL DONG"),
      #name_capitalerror
      textOutput("name_capitalerror"),
      
      #성별
      fluidRow(
        column(width = 4,
               fluidRow(
                 column(
                   width = 8
                 ),
                 column(
                   width = 4,
                 )
               ),
               selectInput("sex" , "Sex" , choices = c("","Male" , "Female" , "Both") , multiple = TRUE , selected = ""  )
                ),
        
      ),
      #생년월일 , 나이
      fluidRow(
        column(width = 3 ,dateInput("birth" , "Birth" , value = NULL , format = "yyyy-mm-dd")),
        column(width = 3 , tags$label("Age", id = "age"),uiOutput("age")),
        # Henry
        column(width = 3, tagAppendAttributes( textInput(inputId = "ageCal", label = "Age", width = "100%"), .cssSelector = "input", readonly = "" ))
      ),
      #초진여부
      radioButtons("First_or_again", "First / Extra", choices = list_num ,selected = NULL ),
      #환자정보 요약
      tags$hr(),
      uiOutput("summary_hk"),
      tags$hr(),
      #테이블 출력
      dataTableOutput("table"),
      #제출
      actionButton("submit", "Submit" , class = "btn-danger"),
      uiOutput("complete"),
      textOutput("submit_error")

    ),

    ###tab files
    tabPanel("Files",
      titlePanel("Files Upload"),
      h2("alert!!! you need to upload 2 images"),
      fileInput("upload_1" , "Upload a file_1"),
      tableOutput("file_1"),
      fileInput("upload_2" , "Upload a file_2"),
      h4("Image#1 you uploaded"),
      imageOutput("uploaded_1")
    )
  )
)


#### function #####
# birth에서 나이 구하는 함수
calculateAge <- function(date) {
  req(date)
  current_date <- format(Sys.Date() , "%Y")  # 현재 날짜
  birth_date <- format(as.Date(date), "%Y")  # 입력된 날짜
  age <- as.numeric(current_date) - as.numeric(birth_date)
  return(age)
}

# 대문자 판별 함수
is_uppercase <- function(string) {
  # 문자열이 비어있는 경우 FALSE 반환
  if (string == "") {
    return(TRUE)
  }
  # 모든 문자가 대문자인 경우 TRUE 반환, 그렇지 않으면 FALSE 반환
  all(toupper(string) == string)
}

#여러 변수 null값 판별함수
check_null <- function(...) {
  args <- list(...)
  if("" %in% args){
    return(TRUE)
  }else{
    return(FALSE)
  }
}



server <- function(input, output, session){
  #이름 대문자 error
  capital_error <- reactive({
    capital <- is_uppercase(input$name)
    shinyFeedback::feedbackDanger("name",!capital, "please write in capital letter")
    req(input$name , capital)
    "accepted"
  })

  output$name_capitalerror <- renderText(capital_error())

  # 나이 추출
  age <- reactive({
    date <- format(input$birth, "%Y-%m-%d")
    calculateAge(date)
  })
  # age output
  output$age <- renderUI({
    result <- tags$div(
      class = "form-control" , style ="margin-top: 8px",
      age()
    )
    result
  })

  observeEvent(input$birth, {
    req(input$birth)
    age_computed <- date <- format(input$birth, "%Y-%m-%d") |> calculateAge()

    updateTextInput(
      inputId = "ageCal",
      value = age_computed
    )

  })

  #summary output
  output$summary_hk <- renderUI({
    result_hk <- tags$div(
      class = "container-fluid",
      "Hello", input$name, tags$br(),
      "Your Name:", input$name, tags$br(),
      "Your sex:", paste0(input$sex, collapse = ", "), tags$br(),
      "Your age:", age()
    )
    result_hk
  })

  #table출력
  output$table <- renderDataTable(mtcars, options = list(pageLength = 5))

  # submit버튼 클릭 후 ,complete출력
  # print안 찍히는데 다른 방법?
  # output$complete <- eventReactive(input$submit, {
  #   print(input$name)
  #   if(input$name==""|  paste0(input$sex, collapse = ", ")=="" | as.Date(input$birth) ==Sys.Date() ){
  #     validate("you should fill all the input boxes")
  #     print(input$name)
  #   }else{
  #      "complete"
  #      }
  # })

  db_table <- reactiveVal(NULL) # reactiveValues()

  # henry
  observeEvent(input$submit, {

    db_table( "update logic ")

    print(input$submit)
    # validation
    if (input$name==""|  paste0(input$sex, collapse = ", ")=="" | as.Date(input$birth) ==Sys.Date() ){
      # validate("you should fill all the input boxes")

    output$complete <- renderUI({

      tags$div(
        class = "container-fluid",
        tags$p(
          class = "text-danger",
          tags$b("Error:"), "You did not enter all the information correctly."
        )
      )})

      print(input$name)
      return()
    }

    output$complete <- renderUI({

      tags$div(
        class = "container-fluid",
        tags$p(
          class = "text-success",
          tags$b("Success:"), "You enter all the information correctly."
        )
      )

    })



  })

  
  #업로드 파일 DB (local) 저장
  observeEvent(input$upload_1, {
    file_1 <- input$upload_1
    if (!is.null(file_1)) {
    # 파일을 로컬 경로에 저장
    save_directory <- "C:/R_Shiny_prac/R_shiny/Ch7/"
    save_path <- file.path(save_directory, file_1$name)
    file.copy(file_1$datapath, save_path)
    # 저장된 경로를 출력하거나 다른 처리를 수행할 수 있음
    print(paste("File saved at:", save_path))

  }
  })

  #사진 업로드시 사용자에게 업로드한 파일 render
  output$uploaded_1 <- renderImage({
    req(input$upload_1)
    list(
    src = file.path(paste0("C:/R_Shiny_prac/R_shiny/Ch7/",input$upload_1$name)))
  } , deleteFile = FALSE)
}



shinyApp(ui = ui , server = server)