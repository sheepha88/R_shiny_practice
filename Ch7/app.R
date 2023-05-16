
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

puppies <- tibble::tribble(
  ~breed, ~ id, ~author, 
  "corgi", "eoqnr8ikwFE","alvannee",
  "labrador", "KCdYn0xu2fU", "shaneguymon",
  "spaniel", "TzjMd7i5WQI", "_redo_"
)

ui <- fluidPage(
  selectInput("id", "Pick a breed", choices = setNames(puppies$id, puppies$breed)),
  htmlOutput("source"),
  imageOutput("photo")
)
server <- function(input, output, session) {
  output$photo <- renderImage({
    list(
      src = file.path("puppy-photos", paste0(input$id, ".jpg")),
      contentType = "image/jpeg",
      width = 500,
      height = 650
    )
  }, deleteFile = FALSE)
  
  output$source <- renderUI({
    info <- puppies[puppies$id == input$id, , drop = FALSE]
    HTML(glue::glue("<p>
      <a href='https://unsplash.com/photos/{info$id}'>original</a> by
      <a href='https://unsplash.com/@{info$author}'>{info$author}</a>
    </p>"))
  })
}

# Run the application
shinyApp(ui = ui, server = server)


