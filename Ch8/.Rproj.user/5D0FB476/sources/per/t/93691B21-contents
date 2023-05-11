####Validing input####

# return 안하는 함수 req

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  textInput("location", "location", value = ""),
  textOutput("error")
)

is_uppercase <- function(string) {
  # 문자열이 비어있는 경우 FALSE 반환
  if (string == "") {
    return(TRUE)
  }

  # 모든 문자가 대문자인 경우 TRUE 반환, 그렇지 않으면 FALSE 반환
  all(toupper(string) == string)
}


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  error <- reactive({
    location_input <- is_uppercase(input$location)
    shinyFeedback::feedbackWarning("location", !location_input, "Please select an even number")
    req(location_input)
    input$location
  })

  output$error <- renderText(error())
}

# Run the application
shinyApp(ui = ui, server = server)



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

