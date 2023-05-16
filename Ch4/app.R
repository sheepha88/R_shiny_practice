# 프로토타입
# 하나의 입력 , 3개의 테이블 , 1개의 plot

# fluidrow(columns(n , tableoupput("something")))
# 1개의 로우를 지정해줌 , coumns에 숫자지정하여 크기 assign

# eventreactive이용시 이벤트반응인수에 2개이상의 이벤트가 동시에 반응해야하는 경우 혹은 둘중의 하나가 반응애햐나는 경우 각 이벤트를 리스트로 묶어서 진행한다.
# # ex)  narrative_sample <- eventReactive(
# list(input$story, selected()),
# selected() %>% pull(narrative) %>% sample(1)
# )
# output$narrative <- renderTable(narrative_sample())



library(dplyr)
library(ggplot2)
library(forcats)
library(vroom)
library(shiny)

if (!exists("injuries")) {
  injuries <- vroom::vroom("neiss/injuries.tsv.gz")
  products <- vroom::vroom("neiss/products.tsv")
  population <- vroom::vroom("neiss/population.tsv")
}



ui <- fluidPage(
  #<< first-row
  fluidRow(
    column(8,
           selectInput("code", "Product",
                       choices = setNames(products$prod_code, products$title),
                       width = "100%"
           )
    ),
    column(2, selectInput("y", "Y axis", c("rate", "count")))
  ),
  fluidRow(
    column(2,
           sliderInput("rows", "Number of Rows", min = 1, max = 10, value = 5)
    )
  ),
  #>>
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  #<< narrative-ui
  fluidRow(
    column(2, actionButton("story", "Tell me a story")),
    column(10, textOutput("narrative"))
  )
  #>>
)




server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
  
  # function
  count_top <- function(df, var, n = input$rows) {
    df %>%
      mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
      group_by({{ var }}) %>%
      summarise(n = as.integer(sum(weight)))
  }
  # function
  
  #<< tables
  output$diag <- renderTable({
    count_top(selected(), diag)
  }, width = "100%")
  
  output$body_part <- renderTable({
    count_top(selected(), body_part)
  }, width = "100%")
  
  output$location <- renderTable({
    count_top(selected(), location)
  }, width = "100%")
  #>>
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  #<< plot
  output$age_sex <- renderPlot({
    if (input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries")
    } else {
      summary() %>%
        ggplot(aes(age, rate, colour = sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Injuries per 10,000 people")
    }
  }, res = 96)
  #>>
  
  #<< narrative-server
  narrative_sample <- eventReactive(
    list(input$story, selected()),
    selected() %>% pull(narrative) %>% sample(1)
  )
  output$narrative <- renderText(narrative_sample())
  #>>
}

shinyApp(ui, server)


