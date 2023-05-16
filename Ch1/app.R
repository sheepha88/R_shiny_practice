####기본####



# library(shiny)


# ui<-fluidPage(
#   selectInput("Dataset" , "Dataset" , choices = ls("package:datasets")),
#   verbatimTextOutput("summary"),
#   tableOutput("table")
# )
# 
# 
# 
# server<-function(input , output , session){
#   dataset<-reactive({
#     get(input$Dataset , "package:datasets")
#   })
#   
#   output$summary<- renderPrint({
#     summary(dataset())
#     })
#   
#   output$table <-renderTable({
#     dataset()
#     }) 
# }
# 
# 
# shinyApp(ui = ui , server = server)











# ui <- fluidPage(
#   selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
#   verbatimTextOutput("summary"),
#   tableOutput("table")
# )
# 
# server <- function(input, output, session) {
#   # Create a reactive expression
#   dataset <- reactive({
#     get(input$dataset, "package:datasets")
#   })
#   
#   output$summary <- renderPrint({
#     # Use a reactive expression by calling it like a function
#     summary(dataset())
#   })
#   
#   output$table <- renderTable({
#     dataset()
#   })
# }

# Run the application 
# shinyApp(ui = ui, server = server)


# exercise_1 --------------------------------------------------------------

# ui<-fluidPage(
#   textInput("name" , "what is your name" ,placeholder = "Hon gil dong"),
#   numericInput("age" , "what is your age"  , value = 0),
#   textOutput("greeting")
# )
# 
# server<-function(input , output , session){
#   
#   
#   
#   output$greeting <- reactive({
#     paste0("Hello ", input$name , input$age)
#   })
# }
# 
# shinyApp(ui = ui , server = server)



# exercise_2 --------------------------------------------------------------

# library(shiny)
# 
# ui <- fluidPage(
#   sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
#   "then x times 5 is",
#   textOutput("product")
# )
# 
# server <- function(input, output, session) {
#   output$product <- renderText({ 
#     input$x * 5
#   })
# }
# 
# shinyApp(ui, server)


# exercise_3 --------------------------------------------------------------

# library(shiny)
# 
# ui <- fluidPage(
#   sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
#   sliderInput("y", label = "and y is", min = 1, max = 50, value = 30),
#   "then x times y is",
#   textOutput("product")
# )
# 
# server <- function(input, output, session) {
#   output$product <- renderText({
#     input$x * input$y
#   })
# }
# 
# shinyApp(ui, server)



# exercise_4 --------------------------------------------------------------

# library(shiny)
# 
# ui <- fluidPage(
#   sliderInput("x", "If x is", min = 1, max = 50, value = 30),
#   sliderInput("y", "and y is", min = 1, max = 50, value = 5),
#   "then, (x * y) is", textOutput("product"),
#   "and, (x * y) + 5 is", textOutput("product_plus5"),
#   "and (x * y) + 10 is", textOutput("product_plus10")
# )
# 
# server <- function(input, output, session) {
#   product <- reactive({input$x * input$y})
#   
#   output$product <- renderText({ 
#     
#     product()
#   })
#   output$product_plus5 <- renderText({ 
#     
#     product() + 5
#   })
#   output$product_plus10 <- renderText({ 
#     
#     product() + 10
#   })
# }
# 
# shinyApp(ui, server)




# exercise_5 --------------------------------------------------------------
# library(shiny)
# library(ggplot2)
# 
# datasets <- c("economics", "faithfuld", "seals")
# ui <- fluidPage(
#   selectInput("dataset", "Dataset", choices = datasets),
#   verbatimTextOutput("summary"),
#   plotOutput("plot")
# )
# 
# server <- function(input, output, session) {
#   dataset <- reactive({
#     get(input$dataset, "package:ggplot2")
#   })
#   output$summary <- renderPrint({
#     summary(dataset())
#   })
#   output$plot <- renderPlot({
#     plot(dataset())
#   }, res = 96)
# }
# 
# shinyApp(ui, server)


# exercise_dev --------------------------------------------------------------

# 
library(shiny)

# 초진여부 목록
list_num = c("First" , "Second" , "Trird" , "Others")

ui<-fluidPage(

  textInput("name" , "what is your name" ,placeholder = "Hon gil dong"),
  selectInput("sex" , "SEX" , choices = c("Male" , "Female" , "Both") , multiple = TRUE  ),
  dateInput("birth" , "birth" , value = NULL , format = "yyyy-mm-dd"),
  verbatimTextOutput("age" ),
  radioButtons("First_or_again", "First / Extra" , choices = list_num ),
  htmlOutput("summary")
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
  output$age <- reactive({
    age()
  })
  
  #summary output 
  output$summary <- reactive({
    result <- paste0("Hello ", input$name ,",", "<br>"
                     , "Please check your profile berfore submit","<br>"
                     ,"Your name : " ,input$name ,
                     "<br>","Your age : " ,age() )

  HTML(result)

  })
}

shinyApp(ui = ui , server = server)
