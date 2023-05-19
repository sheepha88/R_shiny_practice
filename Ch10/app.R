# 정리

# 1. 어제 배웠던 updateinput
# 2. freezeReactiveValue() - 
# 3. updatetabsetpanel
# 4. wizardinterface - 액션버튼으로 페이지 이동
# 5. uiOutput에서 isolate를 통해 값을 고정하여 기존값을 잃어버리지 않게 설정
# 6. 함수를 통해 더욱 동적으로 , map() , reduce()
#   ㄴmap사용 후 $이 아닌 [[]]으로 접근하는것에 대하여



# homework
# 추가버튼 누를떄 업로드가 추가됨
# 마지막에는 업로드했던 사진 모두 출력

#  isolate
# R은 반응 순으로 진행되기 때문에 초기값 설정하면 좋다 -> 불상사 방지가능
# initialize -초기값 설정 시 사용

#observeEvent & update function

# observeEvent에는 input$으로 받고 , update fucntion의 input id 는 string으로 받는다

#update function
# : 입력의 이름을 문자열로 받는다.


# # 계층형 셀렉트 박스 --------------------------------------------------------------
# 
# 
# library(shiny)
# library(dplyr, warn.conflicts = FALSE)
# 
# sales <- vroom::vroom("sales-dashboard/sales_data_sample.csv", col_types = list(), na = "")
# sales %>% 
#   select(TERRITORY, CUSTOMERNAME, ORDERNUMBER, everything()) %>%
#   arrange(ORDERNUMBER)
# 
# 
# 
# ui <- fluidPage(
#   selectInput("territory", "Territory", choices = unique(sales$TERRITORY)),
#   selectInput("customername", "Customer", choices = NULL),
#   selectInput("ordernumber", "Order number", choices = NULL),
#   tableOutput("data")
# )
# 
# server <- function(input, output, session) {
#   territory <- reactive({
#     filter(sales, TERRITORY == input$territory)
#   })
#   
#   
#   observeEvent(territory(), {
#     choices <- unique(territory()$CUSTOMERNAME)
#     updateSelectInput(inputId = "customername", choices = choices) 
#   })
#   
#   customer <- reactive({
#     req(input$customername)
#     filter(territory(), CUSTOMERNAME == input$customername)
#   })
#   observeEvent(customer(), {
#     choices <- unique(customer()$ORDERNUMBER)
#     updateSelectInput(inputId = "ordernumber", choices = choices)
#   })
#   
#   output$data <- renderTable({
#     req(input$ordernumber)
#     customer() %>% 
#       filter(ORDERNUMBER == input$ordernumber) %>% 
#       select(QUANTITYORDERED, PRICEEACH, PRODUCTCODE)
#   })
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)





# 반응형 입력 동결 ---------------------------------------------------------------
#freezereactvie를 잘 이해하지 못하겠음
# library(shiny)
# library(dplyr, warn.conflicts = FALSE)
# 
# ui <- fluidPage(
#   selectInput("dataset", "Choose a dataset", c("pressure", "cars")),
#   selectInput("column", "Choose column", character(0)),
#   verbatimTextOutput("summary")
# )
# 
# server <- function(input, output, session) {
#   dataset <- reactive(get(input$dataset, "package:datasets"))
# 
#   observeEvent(input$dataset, {
#     freezeReactiveValue(input, "column")
#     updateSelectInput(inputId = "column", choices = names(dataset()))
#   })
# 
#   output$summary <- renderPrint({
#     summary(dataset()[[input$column]])
#   })
# }
# 
# 
# 
# shinyApp(ui = ui, server = server)



# 순환참조Circular references -------------------------------------------------
# ui <- fluidPage(
#   numericInput("percentage", "percentage", NA, step = 1),
#   numericInput("value", "value", NA)
# )
# 
# server <- function(input, output, session) {
#   observeEvent(input$percentage, {
#     c <- round((input$temp_f - 32) * 5 / 9)
#     updateNumericInput(inputId = "temp_c", value = c)
#   })
#   
#   observeEvent(input$temp_c, {
#     f <- round((input$temp_c * 9 / 5) + 32)
#     updateNumericInput(inputId = "temp_f", value = f)
#   })
# }
# 
# shinyApp(ui = ui, server = server)  


# Dynamic visibility ------------------------------------------------------

# tabsetPanel
# id = 이름지정
# type = hidden 숨겨지는 탭을 사용한다

# updateTabsetPanel
# inputid = tabsetPanel ID 입력
# selected = selectinput
# 
# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       selectInput("controller", "Show", choices = paste0("panel", 1:3))
#     ),
#     mainPanel(
#       tabsetPanel(
#         id = "switcher",
#         type = "hidden",
#         tabPanelBody("panel1", "Panel 1 content"),
#         tabPanelBody("panel2", "Panel 2 content"),
#         tabPanelBody("panel3", "Panel 3 content")
#       )
#     )
#   )
# )
# 
# server <- function(input, output, session) {
#   observeEvent(input$controller, {
#     updateTabsetPanel(inputId = "switcher", selected = input$controller)
#   })
# }
# 
# shinyApp(ui = ui, server = server)  



# 조건부UI -------------------------------------------------------------------
# tab panel에 고유값들을 올린다. 사용자는 지정한 고유값에 대한 tab만 볼 수 있다.

# parameter_tabs <- tabsetPanel(
#   id = "params",
#   type = "hidden",
#   tabPanel("normal",
#            numericInput("mean", "mean", value = 1),
#            numericInput("sd", "standard deviation", min = 0, value = 1)
#   ),
#   tabPanel("uniform", 
#            numericInput("min", "min", value = 0),
#            numericInput("max", "max", value = 1)
#   ),
#   tabPanel("exponential",
#            numericInput("rate", "rate", value = 1, min = 0),
#   )
# )
# 
# 
# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       selectInput("dist", "Distribution", 
#                   choices = c("normal", "uniform", "exponential")
#       ),
#       numericInput("n", "Number of samples", value = 100),
#       parameter_tabs,
#     ),
#     mainPanel(
#       plotOutput("hist")
#     )
#   )
# )
# 
# 
# server <- function(input, output, session) {
#   observeEvent(input$dist, {
#     updateTabsetPanel(inputId = "params", selected = input$dist)
#   }) 
#   
#   sample <- reactive({
#     switch(input$dist,
#            normal = rnorm(input$n, input$mean, input$sd),
#            uniform = runif(input$n, input$min, input$max),
#            exponential = rexp(input$n, input$rate)
#     )
#   })
#   output$hist <- renderPlot(hist(sample()), res = 96)
# }
# 
# shinyApp(ui = ui, server = server)  


# wizard interface --------------------------------------------------------
# ui <- fluidPage(
#   tabsetPanel(
#     id = "wizard",
#     type = "hidden",
#     tabPanel("page_1", 
#              "Welcome!",
#              actionButton("page_12", "next")
#     ),
#     tabPanel("page_2", 
#              "Only one page to go",
#              actionButton("page_21", "prev"),
#              actionButton("page_23", "next")
#     ),
#     tabPanel("page_3", 
#              "You're done!",
#              actionButton("page_32", "prev")
#     )
#   )
# )
# 
# server <- function(input, output, session) {
#   switch_page <- function(i) {
#     updateTabsetPanel(inputId = "wizard", selected = paste0("page_", i))
#   }
#   
#   observeEvent(input$page_12, switch_page(2))
#   observeEvent(input$page_21, switch_page(1))
#   observeEvent(input$page_23, switch_page(3))
#   observeEvent(input$page_32, switch_page(2))
# }
# 
# shinyApp(ui = ui, server = server) 


# Creating UI with code ---------------------------------------------------
# ui <- fluidPage(
#   textInput("label", "label"),
#   selectInput("type", "type", c("slider", "numeric")),
#   uiOutput("numeric")
# )
# 
# server <- function(input, output, session) {
#   
#   output$numeric <- renderUI({
#     value <- isolate(input$dynamic)
#     print(input$dynamic)
#     if (input$type == "slider") {
#       sliderInput("dynamic", input$label, value = ifelse(is.null(value),0,value), min = 0, max = 10)
#     } else {
#       numericInput("dynamic", input$label, value = ifelse(is.null(value),0,value), min = 0, max = 10)
#     }
#   })
#   
#   
#   
# }
# 
# shinyApp(ui = ui, server = server) 


# multiple controls --------------------------------------------------------

# library(purrr)
# 
# ui <- fluidPage(
#   numericInput("n", "Number of colours", value = 5, min = 1),
#   uiOutput("col"),
#   textOutput("palette")
# )
# 
# server <- function(input, output, session) {
#   col_names <- reactive(paste0("col", seq_len(input$n)))
# 
#   #input$n 이 5라면
#   # col_names = c("col1", "col2", "col3", "col4", "col5")
#   # 벡터안의 모든 값을 textinput 아이디로 지정하고 , label = NULL 로한다.
#   #그러면 5개의 컬럼이 생기고 각각 col1 , 2 , 3, 4 ,5 의 id를 갖는다.
#   output$col <- renderUI({
#     map(col_names(), ~ textInput(.x, NULL))
# 
#   })
# 
#   output$palette <- renderText({
# 
#     # input[[col1]]으로 접근하여 text값 출력 = input$col1
#     # 와 여기 모르겠다....
#     # 접근하는 방식이 $와 [[]]이 같은데 map과 "col1" string을 사용하기 위해서는 [[]]접근해야해서?
#     map_chr(col_names(), ~ input[[.x]] %||% "")
#     print(input$col1)
# 
#   })
# }
# 
# 
# 
# shinyApp(ui = ui, server = server)



# dev ---------------------------------------------------------------------


# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       numericInput("n", "Number of colours", value = 5, min = 1),
#       uiOutput("col"),
#     ),
#     mainPanel(
#       plotOutput("plot")  
#     )
#   )
# )
# 
# server <- function(input, output, session) {
#   col_names <- reactive(paste0("col", seq_len(input$n)))
#   
#   output$col <- renderUI({
#     map(col_names(), ~ textInput(.x, NULL, value = isolate(input[[.x]])))
#   })
#   
#   output$plot <- renderPlot({
#     cols <- map_chr(col_names(), ~ input[[.x]] %||% "")
#     # convert empty inputs to transparent
#     cols[cols == ""] <- NA
#     
#     barplot(
#       rep(1, length(cols)), 
#       col = cols,
#       space = 0, 
#       axes = FALSE
#     )
#   }, res = 96)
# }
# 
# shinyApp(ui = ui, server = server) 



# dynamic filtering -------------------------------------------------------

# make_ui <- function(x, var) {
#   if (is.numeric(x)) {
#     rng <- range(x, na.rm = TRUE)
#     sliderInput(var, var, min = rng[1], max = rng[2], value = rng)
#   } else if (is.factor(x)) {
#     levs <- levels(x)
#     selectInput(var, var, choices = levs, selected = levs, multiple = TRUE)
#   } else {
#     # Not supported
#     NULL
#   }
# }
# 
# 
# filter_var <- function(x, val) {
#   if (is.numeric(x)) {
#     !is.na(x) & x >= val[1] & x <= val[2]
#   } else if (is.factor(x)) {
#     x %in% val
#   } else {
#     # No control, so don't filter
#     TRUE
#   }
# }
# 
# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       make_ui(iris$Sepal.Length, "Sepal.Length"),
#       make_ui(iris$Sepal.Width, "Sepal.Width"),
#       make_ui(iris$Species, "Species")
#     ),
#     mainPanel(
#       tableOutput("data")
#     )
#   )
# )
# server <- function(input, output, session) {
#   selected <- reactive({
#     filter_var(iris$Sepal.Length, input$Sepal.Length) &
#       filter_var(iris$Sepal.Width, input$Sepal.Width) &
#       filter_var(iris$Species, input$Species)
#   })
#   
#   output$data <- renderTable(head(iris[selected(), ], 12))
# }
# 
# shinyApp(ui = ui, server = server) 




# 동적필터링 -------------------------------------------------------------------


# library(shiny)
# library(purrr)
# 
# make_ui <- function(x, var) {
#   if (is.numeric(x)) {
#     rng <- range(x, na.rm = TRUE)
#     sliderInput(var, var, min = rng[1], max = rng[2], value = rng)
#   } else if (is.factor(x)) {
#     levs <- levels(x)
#     selectInput(var, var, choices = levs, selected = levs, multiple = TRUE)
#   } else {
#     # Not supported
#     NULL
#   }
# }
# 
# 
# filter_var <- function(x, val) {
#   if (is.numeric(x)) {
#     !is.na(x) & x >= val[1] & x <= val[2]
#   } else if (is.factor(x)) {
#     x %in% val
#   } else {
#     # No control, so don't filter
#     TRUE
#   }
# }
# 
# 
# 
# dfs <- keep(ls("package:datasets"), ~ is.data.frame(get(.x, "package:datasets")))
# 
# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       selectInput("dataset", label = "Dataset", choices = dfs),
#       uiOutput("filter")
#     ),
#     mainPanel(
#       tableOutput("data")
#     )
#   )
# )
# server <- function(input, output, session) {
#   data <- reactive({
#     get(input$dataset, "package:datasets")
#   })
#   vars <- reactive(names(data()))
#   
#   output$filter <- renderUI(
#     map(vars(), ~ make_ui(data()[[.x]], .x))
#   )
#   
#   selected <- reactive({
#     each_var <- map(vars(), ~ filter_var(data()[[.x]], input[[.x]]))
#     reduce(each_var, `&`)
#   })
#   
#   output$data <- renderTable(head(data()[selected(), ], 12))
# }
# 
# 
# shinyApp(ui = ui, server = server)


