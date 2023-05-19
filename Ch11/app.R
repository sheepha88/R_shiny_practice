#### 북마크 버튼#####

# UI에 bookmarkButton() 추가
# Shinyapps 호출시 , enableBookmarking = "url"추가
# url에 명시되지 않으며 자동으로 업데이트 되지도 않는다

library(shiny)
# 
# ui <- function(request) {
#   fluidPage(
#     sidebarLayout(
#       sidebarPanel(
#         sliderInput("omega", "omega", value = 1, min = -2, max = 2, step = 0.01),
#         sliderInput("delta", "delta", value = 1, min = 0, max = 2, step = 0.01),
#         sliderInput("damping", "damping", value = 1, min = 0.9, max = 1, step = 0.001),
#         numericInput("length", "length", value = 100),
#         bookmarkButton()
#       ),
#       mainPanel(
#         plotOutput("fig")
#       )
#     )
#   )
# }
# server <- function(input, output, session) {
#   t <- reactive(seq(0, input$length, length.out = input$length * 100))
#   x <- reactive(sin(input$omega * t() + input$delta) * input$damping ^ t())
#   y <- reactive(sin(t()) * input$damping ^ t())
#   
#   output$fig <- renderPlot({
#     plot(x(), y(), axes = FALSE, xlab = "", ylab = "", type = "l", lwd = 2)
#   }, res = 96)
# }
# 
# # Run the application 
# shinyApp(ui, server, enableBookmarking = "url")



####URL자동 업데이트 및 명시 ####
# 파라미터들이 자동으로 update
# 북마크 버튼 불필요
# url에 파라미터값들 명시됨

# ui <- function(request) {
#   fluidPage(
#     sidebarLayout(
#       sidebarPanel(
#         sliderInput("omega", "omega", value = 1, min = -2, max = 2, step = 0.01),
#         sliderInput("delta", "delta", value = 1, min = 0, max = 2, step = 0.01),
#         sliderInput("damping", "damping", value = 1, min = 0.9, max = 1, step = 0.001),
#         numericInput("length", "length", value = 100),
#         
#       ),
#       mainPanel(
#         plotOutput("fig")
#       )
#     )
#   )
# }
# 
# 
# server <- function(input, output, session) {
#   t <- reactive(seq(0, input$length, length = input$length * 100))
#   x <- reactive(sin(input$omega * t() + input$delta) * input$damping ^ t())
#   y <- reactive(sin(t()) * input$damping ^ t())
#   
#   output$fig <- renderPlot({
#     plot(x(), y(), axes = FALSE, xlab = "", ylab = "", type = "l", lwd = 2)
#   }, res = 96)
#   
#   observe({
#     reactiveValuesToList(input)
#     session$doBookmark()
#   })
#   onBookmarked(updateQueryString)
# }
# 
# shinyApp(ui, server, enableBookmarking = "url")


####서버에 저장 ####
# url이 길어지는 경우  , 사용자가 업로드한 파일을 함께 포함하지 못하는 경우 서버에 생성
# url을 짧게 처리하고 서버에 저장
# 페이지에서 다르게 지정할때마다 서버에 저장 -> 경우가 많아질 경우 저장공간에 대한 문제가 있을 수 있음
#그래서 결론적으로 뭘 쓰라는거????

ui <- function(request) {
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        sliderInput("omega", "omega", value = 1, min = -2, max = 2, step = 0.01),
        sliderInput("delta", "delta", value = 1, min = 0, max = 2, step = 0.01),
        sliderInput("damping", "damping", value = 1, min = 0.9, max = 1, step = 0.001),
        numericInput("length", "length", value = 100),

      ),
      mainPanel(
        plotOutput("fig")
      )
    )
  )
}


server <- function(input, output, session) {
  t <- reactive(seq(0, input$length, length = input$length * 100))
  x <- reactive(sin(input$omega * t() + input$delta) * input$damping ^ t())
  y <- reactive(sin(t()) * input$damping ^ t())

  output$fig <- renderPlot({
    plot(x(), y(), axes = FALSE, xlab = "", ylab = "", type = "l", lwd = 2)
  }, res = 96)

  observe({
    reactiveValuesToList(input)
    session$doBookmark()
  })
  onBookmarked(updateQueryString)
}


shinyApp(ui, server, enableBookmarking = "server")

