####Validing input####

# return 안하는 함수 req

# library(shiny)

# # Define UI for application that draws a histogram
# ui <- fluidPage(
#   shinyFeedback::useShinyFeedback(),
#   textInput("location", "location", value = ""),
#   textOutput("error")
# )

# is_uppercase <- function(string) {
#   # 문자열이 비어있는 경우 FALSE 반환
#   if (string == "") {
#     return(TRUE)
#   }

#   # 모든 문자가 대문자인 경우 TRUE 반환, 그렇지 않으면 FALSE 반환
#   all(toupper(string) == string)
# }


# # Define server logic required to draw a histogram
# server <- function(input, output, session) {
#   error <- reactive({
#     location_input <- is_uppercase(input$location)
#     shinyFeedback::feedbackWarning("location", !location_input, "Please select an even number")
#     req(location_input)
#     input$location
#   })

#   output$error <- renderText(error())
# }

# # Run the application
# shinyApp(ui = ui, server = server)



####req()####
# 사용자가 타이핑 , 선택 , 업로드 전까지 아무런 수행하지 않음
# req(input$a > 0)와 같이 논리연산자를 이용가능

# Run the application

# ui <- fluidPage(
#   selectInput("language", "Language", choices = c("", "English", "Maori")),
#   textInput("name", "Name"),
#   textOutput("greeting")
# )
# 
# server <- function(input, output, session) {
#   greetings <- c(
#     English = "Hello", 
#     Maori = "Kia ora"
#   )
#   output$greeting <- renderText({
#     req(input$language, input$name)
#     paste0(greetings[[input$language]], " ", input$name, "!")
#   })
# }
# 
# shinyApp(ui = ui, server = server)


###req() in validation####
# input에서 errormessage
# cancelouput : True면 , req의 값이 False일 시 출력이 취소됨
# ui <- fluidPage(
#   shinyFeedback::useShinyFeedback(),
#   textInput("dataset", "Dataset name"), 
#   tableOutput("data")
# )
# 
# server <- function(input, output, session) {
#   data <- reactive({
#     req(input$dataset)
#     
#     exists <- exists(input$dataset, "package:datasets")
#     shinyFeedback::feedbackDanger("dataset", !exists, "Unknown dataset")
#     req(exists, cancelOutput = TRUE)
#     
#     get(input$dataset, "package:datasets")
#   })
#   
#   output$data <- renderTable({
#     head(data())
#   })
# }
# 
# shinyApp(ui = ui, server = server)


####Validate output####
# ouput에서 error message
# if문 사용
# ui <- fluidPage(
#   numericInput("x", "x", value = 0),
#   selectInput("trans", "transformation", 
#               choices = c("square", "log", "square-root")
#   ),
#   textOutput("out")
# )
# 
# server <- function(input, output, session) {
#   output$out <- renderText({
#     if (input$x < 0 && input$trans %in% c("log", "square-root")) {
#       validate("x can not be negative for this transformation")
#     }
#     
#     switch(input$trans,
#            square = input$x ^ 2,
#            "square-root" = sqrt(input$x),
#            log = log(input$x)
#     )
#   })
# }
# 
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
    bootswatch = "darkly",
    base_font = "Source Sans Pro"
    ),
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
        column(8,actionButton("sex_submit",  "submit", class = "btn-outline-danger mt-4")),
      ),
      #생년월일 , 나이
      fluidRow(
        column(width = 3 ,dateInput("birth" , "Birth" , value = NULL , format = "yyyy-mm-dd")),
        column(width = 3 , tags$label("Age", id = "age"),uiOutput("age"))
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
      textOutput("complete"),
      textOutput("submit_error")

    ),

    ###tab files
    tabPanel("Files",
      titlePanel("Files Upload"),
      h2("alert!!! you need to upload 2 images"),
      tags$h3("example"),
      fileInput("upload_1" , "Upload a file_1"),
      tableOutput("file_1"),
      fileInput("upload_2" , "Upload a file_2"),
      h4("Image#1 you uploaded"),
      imageOutput("uploaded_1")
      
    )
  )
)


### function
# birth에서 나이 구하는 함수
calculateAge <- function(date) {
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

  #성별 eventreactive
  sex <- eventReactive(input$sex_submit, {
    input$sex
  })
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
  #summary output
  output$summary_hk <- renderUI({
    result_hk <- tags$div(
      class = "container-fluid",
      "Hello", input$name, tags$br(),
      "Your Name:", input$name, tags$br(),
      "Your sex:", paste0(sex(), collapse = ", "), tags$br(),
      "Your age:", age()
    )
    result_hk
  })
  #table출력
  output$table <- renderDataTable(mtcars, options = list(pageLength = 5))
  # submit버튼 클릭 후 ,complete출력
  
  output$complete <- eventReactive(input$submit, {
       "complete"
  })
  
  
  
  output$submit_error <- renderText({
    if(input$name=="" | input$birth ==Sys.Date() ){
      validate("you should fill all the input boxes")
    }
  })

  
  output$file_1 <- renderTable(input$upload_1)
  


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

  
  
  
  output$uploaded_1 <- renderImage({
    list(
    src = file.path(paste0("C:/R_Shiny_prac/R_shiny/Ch7/",input$upload_1$name)))
  } , deleteFile = FALSE)
}



shinyApp(ui = ui , server = server)