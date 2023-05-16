
# exercise_2 --------------------------------------------------------------


# library(shiny)
# 
# # Define UI for application that draws a histogram
# ui <- fluidPage(
# 
#     sliderInput("When" , "When should we deliver?" , min = "2020-09-16" , max = "2020-09-23" , value = "2020-09-20" , timeFormat = )
# )
# 
# # Define server logic required to draw a histogram
# server <- function(input, output) {
# 
#     output$distPlot <- renderPlot({
#         # generate bins based on input$bins from ui.R
#         x    <- faithful[, 2]
#         bins <- seq(min(x), max(x), length.out = input$bins + 1)
# 
#         # draw the histogram with the specified number of bins
#         hist(x, breaks = bins, col = 'darkgray', border = 'white',
#              xlab = 'Waiting time to next eruption (in mins)',
#              main = 'Histogram of waiting times')
#     })
# }

# Run the application 
# shinyApp(ui = ui, server = server)
# 



# exercise_3 --------------------------------------------------------------
# ui <- fluidPage(
#   dataTableOutput("table")
# )
# 
# server <- function(input, output, session) {
#   output$table <- renderDataTable(
#     mtcars,
#     options = list(
#       pageLength = 5,
#       searching = FALSE,
#       ordering = FALSE,
#       orderingClasses = FALSE,
#       lengthChange = FALSE,
#       filter = "none",
#       info = FALSE,
#       paging = TRUE
#     )
#   )
# }
# 
# shinyApp(ui, server)


# exercise_dev --------------------------------------------------------------

#
library(shiny)

# 초진여부 목록
list_num = c("First" , "Second" , "Trird" , "Others")
#
ui<-fluidPage(

  textInput("name" , "what is your name" ,placeholder = "Hon gil dong"),
  selectInput("sex" , "SEX" , choices = c("Male" , "Female" , "Both") , multiple = TRUE  ),
  dateInput("birth" , "birth" , value = NULL , format = "yyyy-mm-dd"),
  verbatimTextOutput("age" ),
  radioButtons("First_or_again", "First / Extra" , choices = list_num ),
  htmlOutput("summary"),
  "---------------------------------------------------",
  dataTableOutput("table")

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
  
  output$table <- renderDataTable(mtcars, options = list(pageLength = 5))
}

shinyApp(ui = ui , server = server)
