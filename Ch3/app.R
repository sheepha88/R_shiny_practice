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

# 연습
library(shiny)
library(ggplot2)

ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  string <- reactive(paste0("Hello ", input$name, "!"))
  
  output$greeting <- renderText(string())
  observeEvent(input$name, {
    message("Greeting tno performetd")
  })
}




shinyApp(ui ,server)


