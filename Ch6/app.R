#
# fixed page
# has a fixed minimu width
# stops from becoming unreasonable wide on bigger screens

# fillpage
# fills the full height -> when make a plot to occupies whole screen


# ui비교
# fluidpage > titlepanel = {sidebarlayout > ( (sidebarpanel = mainpanel) > columns)}


# exercies
# 1 . sidebarlayout 크기조절 하는 방법
# A: mainpanel , 또는 sidepanel의 width매개변수를 사용

# 2.panel 위치변경
# A: position 매개변수를 통해 (right or leff지정)


# 다중페이지 레이아웃
# 텝 세트
# 크기비교
# tabsetpanel > tabpanel >input | output

# id인수제공

# tab과 다르게 세로로 더 긴 탭을 사용할 수 있는 기능 : navbarPage().navbarMenu() navlistpanel() , 

# bootstrap 적용방법
# theme = bslib::bs_theme(bootswatch = "darkly")
# theme <- bslib::bs_theme(bg = "#0b3d91", fg = "white", base_font = "Source Sans Pro")

# HTML


library(shiny)

library(ggplot2)
library(bslib)

ui <- fluidPage(
  h1("This is a heading"),
  p("This is some text", class = "my-class"),
  tags$ul(
    tags$li("First bullet"), 
    tags$li("Second bullet")
  ),
  tags$p(
    "You made ", 
    tags$b("$", textInput("amount" , "ll")),
    " in the last ", 
    textOutput("days", inline = TRUE),
    " days " 
  )
)

server <- function(input, output, session) {
  
}
# Run the application 
shinyApp(ui = ui, server = server)
