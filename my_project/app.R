library(shiny)
library(shinyFeedback)
library(tools)

#reactiveConsole(TRUE)


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



#R에도 상속의 개념이 있나? -> modal을 2개 써야하는데 똑같이 복붙해야되는 상황, 가독성 떨어짐
modal_ui<-function(){
  modalDialog(
    title = "Submit",
  
    fluidRow(
      tags$p(
        "want to submit?"
      )
    ),
    size = "m",
    easyClose = TRUE,
    footer = tagList(
      actionButton(
        inputId = "yes",
        label = "Yes",
        class = "btn-primary",
      ),
      modalButton("Close")
    )
  )
}


#row추가 함수
addNewFile <- function(wrap_id, i){
  
  newFileUI <- fluidRow(
    id = paste0("addFile_",i),

    column(
      width = 1,
      tags$h4(i)
    ),

    column(
      width = 4,
      textInput(
        inputId = paste0("des_", i),
        label = "Description",
        value = ""
      )
    ),

    column(
      width = 4,
      fileInput(
        inputId = paste0("file_", i),
        label = "Upload File"
      )
    ),

    column(
      width = 3,
      class = "align-self-center",
      downloadButton(
        outputId = paste0("down_",i),
        label = "Download File" ,
        class = "disabled"
      )
    )
  )
    
      insertUI(
        selector = paste0("#", wrap_id),
        where = "beforeEnd",
        ui = newFileUI
      )
}



#다운로드 링크 함수?

add_down <- function(i){
    output[[paste0("down_",i)]] <- downloadHandler(
        filename = function(){
          paste0("donwload_",i,".PNG")
        },
        
        content = function(file){
          #print(paste0("확인 : ",image_local))
          img_path<-paste0("www/imgs/img_", i, ".PNG")
          print(img_path)
          img_data <- readBin(con = img_path, what = "raw" , n = file.info(img_path)$size)
          writeBin(img_data , file)
        }
      )
}


# 초진여부 목록
list_num = c("First" , "Second" , "Trird" , "Others")

#
ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  shinyjs::useShinyjs(),
  
  theme = bslib::bs_theme(
    version = 5,
    # bootswatch = "darkly",
    base_font = "Source Sans Pro"
  ),
  tags$head(tags$style(
    ".form-control-feedback i{
        display:none;
      }"
  ),
  
  tags$script(HTML("
                    
                   
                   
                   "))
  
  
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
               
             ),
             #생년월일 , 나이
             fluidRow(
               column(width = 3 ,dateInput("birth" , "Birth" , value = NULL , format = "yyyy-mm-dd")),
               column(width = 3 , #tags$label("Age", `for` = "age", id = paste0("age", "-label")),
               uiOutput("age")),
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
             h2("alert!!! you need to upload some images"),

             fluidRow(
              class = "ms-2 mt-2",

              actionButton(inputId = "add",
                            label = "ADD",
                            icon = icon("plus" , class = "me-1"),
                            class="btn btn-outline-success me-1",
                            width = "100px"),

              actionButton(inputId = "delete",
                            label = "DELETE",
                            icon = icon("minus" , class = "me-1"),
                            class="btn btn-outline-danger me-1",
                            width = "120px"),

              actionButton(inputId = "done",
                            label = "DONE",
                            icon = icon("check" , class = "me-1"),
                            class="btn btn-outline-primary",
                            width = "100px")
             ),

             fluidRow(
              class = "ms-2 mt-4 mb-3 border-top",
              fluidRow(
                id = "here",
                class = "mt-4"
              )
             ),

             fluidRow(
              class = "ms-2 mt-4 pt-3 border-top",
              uiOutput("result")
            )
    )
  )
)



server <- function(input, output, session){

  # henrykye
  isolate({
    modal_loc <- reactiveVal(NULL)
  })
  
  
  
  
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
  result <- 
      tags$div(
        class = "form-group",
        tags$label(
          class = "control-label",
          id = "ouput-age-label",
          `for` = "output-age",
          "Age"
        ),
        tags$input(
          class = "form-control-plaintext",
          type = "text",
          id = "output-age",
          readonly = "",
          value = age() |> as.character()
        )
      )
  
  # tags$div(
  #   class = "form-control" , style ="margin-top: 8px",
  #   age()
  # )
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
  
  modal_loc("profile") #set
  modal_loc() |> print() # get
  showModal(modal_ui())
  
  # output$complete <- renderUI({
  #   
  #   
  # 
  #   
  # })
})

#모든 입력 완료시 , modal popup -> yes입력 ->submit complete
observeEvent(input$yes,{
  
  req(modal_loc()) # the same modal function but different process
  
  removeModal()
  
  out <- switch(
    modal_loc(),
    
    "profile" = {
      output$complete <- renderUI({
        tags$div(
          class = "container-fluid",
          tags$p(
            class = "text-success",
            tags$b("Complete:"), "Submit complete"
          )
        )
      })
      # TRUE
    },
    
    "file" = {
      
      yes_modal_file()
      
      # download_file()
      
      # TRUE
    }
    
  )
  
  req(out)
  
  modal_loc(NULL)
  

})


#file tab

##파일넘버 초기값 설정
isolate({
  fileNum <- reactiveVal(0L)
})

observeEvent(input$add,{
    req(input$add)
    fileNum(fileNum()+1L)
    addNewFile(wrap_id = "here" , i=fileNum())
})

  observeEvent(input$delete,{
    req(input$delete, fileNum() > 0L)
    removeUI( selector = paste0("#addFile_",fileNum()) )
    fileNum( fileNum() - 1L )
})
      
##file modal
observeEvent(input$done,{
  req(input$done)
  
  modal_loc("file")
  showModal(modal_ui())
})

observeEvent(input$downIDs, {
  req(input$downIDs)
  cat("clicked: ", input$downIDs, "\n")
  
  # output[[input$downIDS]]
  
})

# modal if yes -> upload summary 제공
isolate({
    
  yes_modal_file <- function(){
      
      render_des <- list()
      
      shinyjs::runjs("
        
        $('.shiny-download-link').on('click', function(){
          Shiny.setInputValue('downIDs', this.id);
        });
            ")
      
      #{번호 : 번호에 해당하는 msg}
      for ( i in seq_len(fileNum()) ){
        
        ## enable download button
        downId <- paste0("down_", i)
        shinyjs::runjs(glue::glue(
          
          "$('#{{downId}}').removeClass('disabled'); ",
          .open = "{{", .close = "}}"
        )
        
        
          
        )
          
          
          

          #description
          ##descriptioon의 내용 msg변수에 지정
          des_content <- input[[paste0("des_",i)]]
          
          #image저장
          ##로컬저장
          image_upload <- input[[paste0("file_",i)]]
          
          
          # image 업로드가 안되있는 경우 다음 번호로로
          if (is.null(image_upload)){
              next
          }
          
          # 파일을 로컬 경로에 저장
          # shiny에서 javascript의 working directory: www
          # 하지만 shiny의 working directory는 app.R이 위치한 폴더
          save_directory <- "www/imgs"
          file_ext <- tools::file_ext(image_upload$name)
          file_name <- paste0("img_", i, ".", file_ext)
          save_path <- file.path(save_directory, file_name)
        
          file.copy(image_upload$datapath, save_path)
          
          # 저장된 경로를 출력하거나 다른 처리를 수행할 수 있음
          print(paste("File saved at:", save_path))
          
          
          
          
          ##message지정
          msg <- paste0("(No. ", i ,") ", "Description : " , des_content, " | File Path: ", save_path)

          ##image 지정
          image_render <- tags$img(
              src = file.path("imgs", file_name),
              class = "img-fluid"
          )
          
          
    
          render_des[[i]] <- fluidRow(
              class = "ms-4 w-75",
              column( width = 6, tags$p(class = "mt-1", msg) ),
              column( width = 3, image_render )
          )
          
          
          
      }
      
      print(render_des)
      output$result <- renderUI({ render_des })
      
  }
  
 
})


# ###donwload
# MAXLINE <- 10L

# lapply(
#   seq_len(MAXLINE), function(j){
    
#     filename <-  paste0("download_", j, ".PNG")
#     img_path<-paste0("www/imgs/img_", j, ".PNG")
    
    
#     output[[paste0("down_",j)]]<-downloadHandler(
      
#       filename = function(){filename},
#       content = function(file){
#         print(img_path)
#         img_data <- readBin(con = img_path, what = "raw" , n = file.info(img_path)$size)
#         writeBin(img_data , file)
#       }
#     )
    
#   }
# )




# download
##원본


download_file <- function(){

for ( j in seq_len(fileNum()) ){
  filename

    filename <-  paste0("download_", j, ".PNG")
    img_path<-paste0("www/imgs/img_", j, ".PNG")

output[[paste0("down_",i)]]<-downloadHandler(
  print(i),
  filename = filename,

  content = function(file){
    img_path<-img_path
    img_data <- readBin(con = img_path, what = "raw" , n = file.info(img_path)$size)
    writeBin(img_data , file)
  }
)

}
}




}


shinyApp(ui = ui , server = server)