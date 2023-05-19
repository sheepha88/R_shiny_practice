library(shiny)
library(shinyFeedback)

# 초진여부 목록
list_num = c("First" , "Second" , "Trird" , "Others")

#
ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  
  
  theme = bslib::bs_theme(
    version = 5,
    # bootswatch = "darkly",
    base_font = "Source Sans Pro"
  ),
  tags$head(tags$style(
    ".form-control-feedback i{
        display:none;
      }"
  )),
  
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
               
             ),
             #생년월일 , 나이
             fluidRow(
               column(width = 3 ,dateInput("birth" , "Birth" , value = NULL , format = "yyyy-mm-dd")),
               column(width = 3 , tags$label("Age", id = "age"),uiOutput("age")),
               # Henry
               column(width = 3, tagAppendAttributes( textInput(inputId = "ageCal", label = "Age", width = "100%"), .cssSelector = "input", readonly = "" ))
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
             uiOutput("complete"),
             textOutput("submit_error")
             
    ),
    
    ###tab files
    tabPanel("Files",
             titlePanel("Files Upload"),
             h2("alert!!! you need to upload 2 images"),
             fileInput("upload_1" , "Upload a file_1"),
             tableOutput("file_1"),
             fileInput("upload_2" , "Upload a file_2"),
             h4("Image#1 you uploaded"),
             imageOutput("uploaded_1")
    )
  )
)


#### function #####
# birth에서 나이 구하는 함수
calculateAge <- function(date) {
  req(date)
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
  
  observeEvent(input$birth, {
    req(input$birth)
    age_computed <- date <- format(input$birth, "%Y-%m-%d") |> calculateAge()
    
    updateTextInput(
      inputId = "ageCal",
      value = age_computed
    )
    
  })
  
  #summary output
  
  output$summary_hk <- renderUI({
    result_hk <- tags$div(
      class = "container-fluid",
      "Hello", input$name, tags$br(),
      "Your Name:", input$name, tags$br(),
      "Your sex:", paste0(input$sex, collapse = ", ") , tags$br(),
      "Your age:", age()
    )
    result_hk
  })
  
  #table출력
  output$table <- renderDataTable(mtcars, options = list(pageLength = 5))
  
  # submit버튼 클릭 후 ,complete출력
  # print안 찍히는데 다른 방법?
  # output$complete <- eventReactive(input$submit, {
  #   print(input$name)
  #   if(input$name==""|  paste0(input$sex, collapse = ", ")=="" | as.Date(input$birth) ==Sys.Date() ){
  #     validate("you should fill all the input boxes")
  #     print(input$name)
  #   }else{
  #      "complete"
  #      }
  # })
  
  db_table <- reactiveVal(NULL) # reactiveValues()
  
  # henry
  observeEvent(input$submit, {
    
    db_table( "update logic ")
    
    print(input$submit)
    # validation
    if (input$name==""|  paste0(input$sex, collapse = ", ")=="" | as.Date(input$birth) ==Sys.Date() ){
      # validate("you should fill all the input boxes")
      
      output$complete <- renderUI({
        
        tags$div(
          class = "container-fluid",
          tags$p(
            class = "text-danger",
            tags$b("Error:"), "You did not enter all the information correctly."
          )
        )})
      
      print(input$name)
      return()
    }
    
    output$complete <- renderUI({
      
      tags$div(
        class = "container-fluid",
        tags$p(
          class = "text-success",
          tags$b("Success:"), "You enter all the information correctly."
        )
      )
      
    })
    
    
    
  })
  
  
  #업로드 파일 DB (local) 저장
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
  
  #사진 업로드시 사용자에게 업로드한 파일 render
  output$uploaded_1 <- renderImage({
    req(input$upload_1)
    list(
      src = file.path(paste0("C:/R_Shiny_prac/R_shiny/Ch7/",input$upload_1$name)))
  } , deleteFile = FALSE)
}



shinyApp(ui = ui , server = server)