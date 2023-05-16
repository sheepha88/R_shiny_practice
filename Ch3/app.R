# server함수는 input , output , session 3개의 인수를 갖는다

# input
# 1)
# output
# render를 항상 같이쓴다


#>Reactive programming
#>반응성이란 , 입력이 변경될 때 출력이 자동으로 업데이트

#>lazy ->출력을 위한 최소한의 작업수행
#>reactive dependency - ex) name이 바뀔때마다 greeting이 바뀐다. greeting은 name에 reactive dependency를 가진다.

#>reactive expressions
#>실행순서를 다르게 할 수 있듬 -> string이 먼저 생성된 후 session이 제일 마지막에 생성되기 때문

# reactive graph
#> input객체에 의죤하여 인렵값이 변경될때마다 다시 계산됨
#> 입력값의 변경을 감지
#> input$sum과 같은 reactive value는 reactive function을 통해서만 부를 수 있으며 , 외부에서 사용하려고 하면 error발생


# 시간제어 reactive
# reactive timer : 지정시간마다 update
# 
# 클릭시 reactive
# actionbutton 사용

# reactive()와 eventreactive의 차이
# reactive : 입력값의 변화에 따라 자동으로 계산
# eventreactive : 이벤트(버튼클릭 , 타이머)에 따라 자동으로 계산

# observevent
# 콘솔에 메세지 전송 , ex)로그기록 ...

# # 연습
# library(shiny)
# library(ggplot2)
# 
# ui <- fluidPage(
#   textInput("name", "What's your name?"),
#   textOutput("greeting")
# )
# 
# server <- function(input, output, session) {
#   string <- reactive(paste0("Hello ", input$name, "!"))
#   
#   output$greeting <- renderText(string())
#   observeEvent(input$name, {
#     message("Greeting tno performetd")
#   })
# }
# 
# 
# 
# 
# shinyApp(ui ,server)





# exercise_1 --------------------------------------------------------------
# ui <- fluidPage(
#   textInput("name", "What's your name?"),
#   textOutput("greeting")
# )
# 
# server <- function(input, output, session) {
#   c <- reactive(input$a + input$b)
#   e <- reactive(c() + input$d)
#   output$f <- renderText(e())
# }
# 
# 
# 
# shinyApp(ui ,server)

# exercise_dev --------------------------------------------------------------


library(shiny)

# 초진여부 목록
list_num = c("First" , "Second" , "Trird" , "Others")
#
ui<-fluidPage(
  fluidRow(
  textInput("name" , "what is your name" ,placeholder = "Hon gil dong"),
  selectInput("sex" , "SEX" , choices = c("Male" , "Female" , "Both") , multiple = TRUE  ),
  dateInput("birth" , "birth" , value = NULL , format = "yyyy-mm-dd"),
  verbatimTextOutput("age" ),
  radioButtons("First_or_again", "First / Extra" , choices = list_num ),
  ),
  
  htmlOutput("summary"),
  "---------------------------------------------------",
  dataTableOutput("table"),
  
  actionButton("submit" , "Submit" , class = "btn-danger"),
  textOutput("complete")
  

)


# function
# birth에서 나이 구하는 함수
calculateAge <- function(date) {
  current_date <- format(Sys.Date() , "%Y")  # 현재 날짜
  birth_date <- format(as.Date(date), "%Y")  # 입력된 날짜
  age <- as.numeric(current_date) - as.numeric(birth_date)
  return(age)
}


server<-function(input , output , session){

  # 나이 추출
  age<-reactive({
    date <- format(input$birth ,"%Y-%m-%d" )
    calculateAge(date)
  })

  # age output
  output$age <- renderText({
    age()
  })

  #summary output
  output$summary <- reactive({
    
    result <- paste0("Hello ", input$name ,",", "<br>"
                     , "Please check your profile berfore submit","<br>"
                     ,"Your name : " ,input$name ,
                     "<br>","Your sex : " ,input$sex,
                     "<br>","Your age : " ,age() )

    HTML(result)
    
    # selectinput에서 다중선택시에 값을 어떻게 받을지에 대한 고민이 있다.
    # print(input$sex)
  })

  output$table <- renderDataTable(mtcars, options = list(pageLength = 5))
  
  # complete
  output$complete <- eventReactive(input$submit , {
    "complete"
  })
}

shinyApp(ui = ui , server = server)
