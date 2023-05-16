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


ui_upload <- sidebarLayout(
  sidebarPanel(
    fileInput("file", "Data", buttonLabel = "Upload..."),
    textInput("delim", "Delimiter (leave blank to guess)", ""),
    numericInput("skip", "Rows to skip", 0, min = 0),
    numericInput("rows", "Rows to preview", 10, min = 1)
  ),
  mainPanel(
    h3("Raw data"),
    tableOutput("preview1")
  )
)


ui_clean <- sidebarLayout(
  sidebarPanel(
    checkboxInput("snake", "Rename columns to snake case?"),
    checkboxInput("constant", "Remove constant columns?"),
    checkboxInput("empty", "Remove empty cols?")
  ),
  mainPanel(
    h3("Cleaner data"),
    tableOutput("preview2")
  )
)

ui_download <- fluidRow(
  column(width = 12, downloadButton("download", class = "btn-block"))
)


ui <- fluidPage(
  ui_upload,
  ui_clean,
  ui_download
)


server <- function(input, output, session) {
  # Upload ---------------------------------------------------------
  raw <- reactive({
    req(input$file)
    
    delim <- if (input$delim == "") NULL else input$delim
    vroom::vroom(input$file$datapath, delim = delim, skip = input$skip)
  })
  output$preview1 <- renderTable(head(raw(), input$rows))
  
  # Clean ----------------------------------------------------------
  tidied <- reactive({
    out <- raw()
    if (input$snake) {
      names(out) <- janitor::make_clean_names(names(out))
    } else {
      validate( "Please check the 'Snake case' option")
    }
    
    if (input$constant) {
      out <- janitor::remove_constant(out)
    }else{
      validate( "Please check the 'constant case' option")
    }
    
    if (input$empty) {
      out <- janitor::remove_empty(out, "cols")
    }else{
      validate( "Please check the 'empty case' option")
    }
    
    
    out
  })
  output$preview2 <- renderTable(head(tidied(), input$rows))
  
  # Download -------------------------------------------------------
  output$download <- downloadHandler(
    filename = function() {
      
      paste0(tools::file_path_sans_ext(input$file$name), ".tsv")
      
    },
    
    content = function(file) {
      
      vroom::vroom_write(tidied(), file)
    }
  )
}

shinyApp(ui = ui, server = server)
