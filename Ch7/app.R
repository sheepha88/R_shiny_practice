
####plot_click & req()####
## plot_click
# 클릭한 위치 x, y 값으로 반환

##req()
# if 와 비슷하지만 return값이 없는 조건절 함수
# 마우스가 클릭이 되기 전까지는 아무일도 수행하지 않으며 반환값이 없다
# 
# library(shiny)
# library(ggplot2)
# 
# ui <- fluidPage(
#   plotOutput("plot", click = "plot_click"),
#   verbatimTextOutput("info")
# )
# 
# server <- function(input, output) {
#   output$plot <- renderPlot({
#     plot(mtcars$wt, mtcars$mpg)
#   }, res = 96)
#   
#   output$info <- renderPrint({
#     req(input$plot_click)
#     x <- round(input$plot_click$x, 2)
#     y <- round(input$plot_click$y, 2)
#     cat("[", x, ", ", y, "]", sep = "")
#   })
# }

# # Run the application 
# shinyApp(ui = ui, server = server)


####nearpoints()####
# nearpoints : 해당되는 위치에서만 값을 반환하는 클릭
# library(shiny)
# library(ggplot2)
# 
# ui <- fluidPage(
#   plotOutput("plot", click = "plot_click"),
#   tableOutput("data")
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot({
#     ggplot(mtcars, aes(wt, mpg)) + geom_point()
#   }, res = 96)
#   
#   output$data <- renderTable({
#     req(input$plot_click)
#     nearPoints(mtcars, input$plot_click)
#   })
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)


####brushing####
# 마우스로 drag한 사각형 공간에 대한 정보제공 

# ui <- fluidPage(
#   plotOutput("plot", brush = "plot_brush"),
#   tableOutput("data")
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot({
#     ggplot(mtcars, aes(wt, mpg)) + geom_point()
#   }, res = 96)
#   
#   output$data <- renderTable({
#     brushedPoints(mtcars, input$plot_brush )
#   })
# }
# 
# # Run the application
# shinyApp(ui = ui, server = server)


####brushing####
# ui <- fluidPage(
#   plotOutput("plot", brush = "plot_brush"),
#   tableOutput("data")
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot({
#     ggplot(mtcars, aes(wt, mpg)) + geom_point()
#   }, res = 96)
#   
#   output$data <- renderTable({
#     brushedPoints(mtcars, input$plot_brush)
#   })
# }
# 
# # Run the application
# shinyApp(ui = ui, server = server)


####reactiveVal()####

# not easy one...
# selected() = True | False값으로 그래프에 반환
# brushed() $selected_ = brushedpoints를 통해서 얻은 columns값 중 드래그로 선택된 값을 나타내는 selected_컬럼을 반환(TRuE , False로 구성)
# dbclick = 더블클릭하면 selected(rep(FALSE, nrow(mtcars))를 통해 초기화(모두 False로 변환)

# ui <- fluidPage(
#   plotOutput("plot", brush = "plot_brush", dblclick = "plot_reset")
# )
# server <- function(input, output, session) {
#   selected <- reactiveVal(rep(FALSE, nrow(mtcars)))
#   
#   
#   observeEvent(input$plot_brush, {
#     
#     brushed <- brushedPoints(mtcars, input$plot_brush, allRows = TRUE)$selected_
#     
#     
#     selected(brushed | selected())
#     
#   })
#   observeEvent(input$plot_reset, {
#     selected(rep(FALSE, nrow(mtcars)))
#   })
#   
#   output$plot <- renderPlot({
#     mtcars$sel <- selected()
#     ggplot(mtcars, aes(wt, mpg)) + 
#       geom_point(aes(colour = sel)) +
#       scale_colour_discrete(limits = c("TRUE", "FALSE"))
#   }, res = 96)
# }
# 
# # Run the application
# shinyApp(ui = ui, server = server)

####Dynamic height and width####
# plot의 크기 정의 : renderplot에서 인수로 정하는것으로 server에서 정의
# ui <- fluidPage(
#   sliderInput("height", "height", min = 100, max = 500, value = 250),
#   sliderInput("width", "width", min = 100, max = 500, value = 250),
#   plotOutput("plot", width = 250, height = 250)
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot(
#     width = function() input$width,
#     height = function() input$height,
#     res = 96,
#     {
#       plot(rnorm(20), rnorm(20))
#     }
#   )
# }
# 
# # Run the application
# shinyApp(ui = ui, server = server)


####image####
# 왜 안되는거야 ......

library(shiny)
library(ggplot2)

library(data.table) ## 가능하면 data.table

# puppies <- tibble::tribble(
#   ~breed, ~ id, ~author, 
#   "corgi", "eoqnr8ikwFE","alvannee",
#   "labrador", "KCdYn0xu2fU", "shaneguymon",
#   "spaniel", "TzjMd7i5WQI", "_redo_"
# )
# 
# #puppies <- data.table(
# # breed = c("corgi", "labrador", "spaniel"))
# 
# # puppies <- as.data.table(puppies) ##
# 
# 
# ui <- fluidPage(
#   
#   selectInput("id", "Pick a breed", choices = setNames(puppies$id, puppies$breed)),
#   
#   htmlOutput("source"),
#   imageOutput("photo")
# )
# server <- function(input, output, session) {
#   output$photo <- renderImage({
#     
#     list(
#       src = file.path("puppy-photos", paste0(input$id, ".jpg")),
#       
#       contentType = "image/jpeg",
#       width = 500,
#       height = 650
#     )
#   }, deleteFile = FALSE)
#   
#   output$source <- renderUI({
#     
#     info <- puppies[puppies$id == input$id, , drop = FALSE]
#     
#     HTML(glue::glue("<p>
#       <a href='https://unsplash.com/photos/{info$id}'>original</a> by
#       <a href='https://unsplash.com/@{info$author}'>{info$author}</a>
#     </p>"))
#   })
# }

# puppies <- tibble::tribble(
#   ~breed, ~ id, ~author, 
#   "corgi", "eoqnr8ikwFE","alvannee",
#   "labrador", "KCdYn0xu2fU", "shaneguymon",
#   "spaniel", "TzjMd7i5WQI", "_redo_"
# )

# ui <- fluidPage(
#   selectInput("id", "Pick a breed", choices = setNames(puppies$id, puppies$breed)),
#   htmlOutput("source"),
#   imageOutput("photo")
# )
# server <- function(input, output, session) {
#   output$photo <- renderImage({
#     list(
#       src = file.path("puppy-photos", paste0(input$id, ".jpg")),
#       contentType = "image/jpeg",
#       width = 500,
#       height = 650
#     )
#   }, deleteFile = FALSE)
  
#   output$source <- renderUI({
#     info <- puppies[puppies$id == input$id, , drop = FALSE]
#     HTML(glue::glue("<p>
#       <a href='https://unsplash.com/photos/{info$id}'>original</a> by
#       <a href='https://unsplash.com/@{info$author}'>{info$author}</a>
#     </p>"))
#   })
# }

# # Run the application
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
