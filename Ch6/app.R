# #
# # fixed page
# # has a fixed minimu width
# # stops from becoming unreasonable wide on bigger screens
# 
# # fillpage
# # fills the full height -> when make a plot to occupies whole screen
# 
# 
# # ui비교
# # fluidpage > titlepanel = {sidebarlayout > ( (sidebarpanel = mainpanel) > columns)}
# 
# 
# # exercies
# # 1 . sidebarlayout 크기조절 하는 방법
# # A: mainpanel , 또는 sidepanel의 width매개변수를 사용
# 
# # 2.panel 위치변경
# # A: position 매개변수를 통해 (right or leff지정)
# 
# 
# # 다중페이지 레이아웃
# # 텝 세트
# # 크기비교
# # tabsetpanel > tabpanel >input | output
# 
# # id인수제공
# 
# # tab과 다르게 세로로 더 긴 탭을 사용할 수 있는 기능 : navbarPage().navbarMenu() navlistpanel() , 
# 
# # bootstrap 적용방법
# # theme = bslib::bs_theme(bootswatch = "darkly")
# # theme <- bslib::bs_theme(bg = "#0b3d91", fg = "white", base_font = "Source Sans Pro")
# 
# # HTML
# 
# 
# # library(shiny)
# # 
# # library(ggplot2)
# # library(bslib)
# # 
# # ui <- fluidPage(
# #   h1("This is a heading"),
# #   p("This is some text", class = "my-class"),
# #   tags$ul(
# #     tags$li("First bullet"), 
# #     tags$li("Second bullet")
# #   ),
# #   tags$p(
# #     "You made ", 
# #     tags$b("$", textInput("amount" , "ll")),
# #     " in the last ", 
# #     textOutput("days", inline = TRUE),
# #     " days " 
# #   )
# # )
# # 
# # server <- function(input, output, session) {
# #   
# # }
# # # Run the application 
# # shinyApp(ui = ui, server = server)
# 
# 
# 
# 
# # exercise_dev --------------------------------------------------------------
# 
# 
# library(shiny)
# 
# # 초진여부 목록
# list_num = c("First" , "Second" , "Trird" , "Others")
# 
# #
# ui <- fluidPage(
#   theme = bslib::bs_theme(
#     version = 5,
#     bootswatch = "darkly",
#     base_font = "Source Sans Pro"
#     ),
#   tabsetPanel(
#     tabPanel("HOME",
#       #타이틀 bar
#       titlePanel("Profile"),
#       #name
#       textInput("name" , "what is your name" ,placeholder = "Hon gil dong"),
#       #성별
#       fluidRow(
#         column(width = 4,
#                fluidRow(
#                  column(
#                    width = 8
#                  ),
#                  column(
#                    width = 4,
#                  )
#                ),
#                selectInput("sex" , "SEX" , choices = c("Male" , "Female" , "Both") , multiple = TRUE  )
#                 ),
#         column(8,actionButton("sex_submit",  "submit", class = "btn-outline-danger mt-4"))
#       ),
#       #생년월일 , 나이
#       fluidRow(
#         column(width = 3 ,dateInput("birth" , "birth" , value = NULL , format = "yyyy-mm-dd")),
#         column(width = 3,textOutput("age"),label = "Age" , class = "form-control" )
#       ),
#       #초진여부
#       radioButtons("First_or_again", "First / Extra", choices = list_num),
#       #환자정보 요약
#       tags$hr(),
#       uiOutput("summary_hk"),
#       tags$hr(),
#       #테이블 출력
#       dataTableOutput("table"),
#       #제출
#       actionButton("submit", "Submit" , class = "btn-danger"),
#       textOutput("complete")
#     ),
#     tabPanel("Preparing")
#   )
# )
# 
# 
# # function
# # birth에서 나이 구하는 함수
# calculateAge <- function(date) {
#   current_date <- format(Sys.Date() , "%Y")  # 현재 날짜
#   birth_date <- format(as.Date(date), "%Y")  # 입력된 날짜
#   age <- as.numeric(current_date) - as.numeric(birth_date)
#   return(age)
# }
# 
# 
# server <- function(input, output, session){
#   #성별 eventreactive
#   sex <- eventReactive(input$sex_submit, {
#     input$sex
#   })
#   # 나이 추출
#   age <- reactive({
#     date <- format(input$birth, "%Y-%m-%d")
#     calculateAge(date)
#   })
#   # age output
#   output$age <- renderText({
#     age()
#   })
#   #summary output
#   output$summary_hk <- renderUI({
#     result_hk <- tags$div(
#       class = "container-fluid",
#       "Hello", input$name, tags$br(),
#       "Your Name:", input$name, tags$br(),
#       "Your sex:", paste0(sex(), collapse = ", "), tags$br(),
#       "Your age:", age()
#     )
#     result_hk
#   })
#   #table출력
#   output$table <- renderDataTable(mtcars, options = list(pageLength = 5))
#   # submit버튼 클릭 후 ,complete출력
#   output$complete <- eventReactive(input$submit, {
#     "complete"
#   })
# }
# 
# shinyApp(ui = ui , server = server)




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
                      selectInput("sex" , "Sex" , choices = c("Male" , "Female" , "Both") , multiple = TRUE  )
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
             tags$h3("example")
             
             
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
  for (arg in args) {
    if (is.null(arg)) {
      return(FALSE)  # null 값이 하나라도 존재하면 TRUE 반환
    }else {
      return(TRUE)  # 모든 변수가 null 값이 아닐 경우 FALSE 반환
    }
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
    if (check_null(input$name, input$sex)) {
      validate(need(FALSE, "You should fill all the input boxes"))
    }
    
    "complete"
    
    
    
  })