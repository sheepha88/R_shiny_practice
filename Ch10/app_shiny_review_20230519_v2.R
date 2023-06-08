library(shiny)
library(bslib)


# When to use isolate() -----------------------------------------------------------------------
# 
# ui <- fluidPage(
#     theme = bs_theme(version = 5),
#     
# 
#     titlePanel(
#         "Example of how to use isolate()"
#     ),
#     
#     fluidRow(
#         class = "mt-4",
#         column(
#             width = 4,
#             actionButton(
#                 inputId = "increment",
#                 label = "Click to Increase"
#             ),
#             actionButton(
#                 inputId = "decrease",
#                 label = "Click to Decrease"
#             )
#         )
#         
#         
#     ),
#     
#     fluidRow(
#         verbatimTextOutput("outputCache")
#     )
#     
#     
# )
# 
# server <- function(input, output, session){
#     
# 
#     isolate({
#         countCache <- reactiveVal(0L)
#     })
#     
#     observeEvent(input$increment, {
#         
#         countCache( countCache() + 1L )
#     })
#     
#     observeEvent(input$decrease, {
#         
#         req( countCache() > 0L )
#         countCache( countCache() - 1L )
#     })
#     
#     
#     output$outputCache <- renderText({
#         countCache()
#     })
# 
# }

# shinyApp(ui, server)


# Q) how map() works --------------------------------------------------------------------------
# $ vs [[]] 
library(data.table)

## answer
# list
# x <- list(abc = 1:3, xyz = letters[1:3])
# 
# # by employing "$" and name
# x$abc
# 
# # by employing "[[]]" and "string name"
# x[["abc"]]
# 
# var <- "xyz"
# x[[var]][1L]
# 
# # example of data.table (similar to data.frame)
# dt <- data.table(aaa = 1:10, bbb = letters[1:10])
# var <- "aaa"
# 
# dt[1L, aaa]
# dt[[var]][1L]
# 
# 
# ## extra:
# # map(): purrr
# # motivated by map( ) in python: map(lamda x: x, list()) ->
# # map() is almost equivalent to lapply()
# 
# xx <- as.list(1:10)
# lapply(xx, function(a){ a + 1L }) |> 
#     unlist(x =_, use.names = FALSE)
# 
# 
# fluidRow(
#     lapply(xx, function(id) tags$div(id))
# )


# confirmation window -------------------------------------------------------------------------
# In frontend (bootstrap), it's called "modal."
# ref: https://shiny.posit.co/r/reference/shiny/1.6.0/modaldialog

# ui <- fluidPage(
#     theme = bs_theme(version = 5),
# 
# 
#     titlePanel(
#         "Example of how to use isolate()"
#     ),
# 
#     fluidRow(
#         class = "mt-4",
#         column(
#             width = 4,
#             actionButton(
#                 inputId = "add",
#                 label = "Add a New Line"
#             )
#         ),
#         column(
#             width = 4,
#             actionButton(
#                 inputId = "delete",
#                 label = "Delete a Line"
#             )
#         )
#     ),
#     
#     fluidRow(
#         class = "mt-4 border-top",
#         verbatimTextOutput("result")
#     )
# )
# 
# 
# confirmUI <- function(){
#     
#     modalDialog(
#         title = "Confirmation: Add",
#         fluidRow(
#             tags$p(
#                 "Are you sure you really want to add a new line?"
#             )
#         ),
#         
#         size = "m",
#         easyClose = TRUE,
#         footer = tagList(
#             actionButton(
#                 inputId = "yes",
#                 label = "Yes",
#                 class = "btn-primary",
#             ),
#             modalButton("Close") # <- closing modal
#         )
#             
#     )
# }
# 
# server <- function(input, output, session){
# 
# 
#     observeEvent(input$add, {
#         
#         showModal( confirmUI() )
#         
#     })
#     
#     observeEvent(input$yes, {
#         
#         
#         removeModal()
#         
#         output$result <- renderText({
#             "'Yes' has been confirmed."
#         })
#         
#         
#     })
# 
#     
# }
# 
# shinyApp(ui, server)



# better answer to isolate --------------------------------------------------------------------
# ui <- fluidPage(
#     theme = bs_theme(version = 5),
# 
#     titlePanel(
#         'How "isolate()" Works'
#     ),
# 
#     fluidRow(
#         class = "ms-2 mt-4",
# 
#         actionButton(
#             inputId = "add",
#             label = "Add",
#             icon = icon("plus", class = "me-1"),
#             width = "100px",
#             class = "me-1"
#         ),
#         actionButton(
#             inputId = "del",
#             label = "Delete",
#             icon = icon("minus", class = "me-1"),
#             width = "100px",
#             class = "me-1"
#         )
#     ),
# 
#     fluidRow(
#         class = "ms-2 mt-4 border-top",
#         verbatimTextOutput("result")
#     )
# )
# 
# server <- function(input, output, session){
# 
#     observe({
#         input$add
#         input$del
# 
#         cat(rep("-", 40L), sep = "", fill = TRUE)
#         print("[Without isolate] Button clicked")
#     })
# 
#     observe({
#         input$add
#         input$del <- isolate(input$del) + 1L
# 
#         print("[With isolate] Button clicked")
#     })
# 
# }
# 
# shinyApp(ui, server)



# dynamic ui examples -------------------------------------------------------------------------

# global
confirmUI <- function(){

    modalDialog(
        title = "Confirmation: Done",
        fluidRow(
            tags$p(
                "Are you sure you really have added all the files?"
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
            modalButton("Close") # <- closing modal
        )
    )
}

addNewFile <- function(target_id, i){

    newFileUI <- fluidRow(
        
        id = paste0("addFile_", i),

        column(
            width = 1,
            tags$h4(i)
        ),
        
        column(
            width = 4,
            textInput(
                inputId = paste0("des_", i),
                label = "Description"
            )
        ),
        column(
            width = 4,
            fileInput(
                input = paste0("file_", i),
                label = "Upload file"
            )
        ),
        column(
            width = 3,
            class = "align-self-center",
            downloadButton(
                outputId =paste0("down_", i),
                label = "Download",
            )
        )
    )
    
    insertUI(
        selector = paste0("#", target_id), # target to be inserted; in jQuery, '#': 'id' and '.': 'class',
        where = "beforeEnd",
        ui = newFileUI
    )
    
}

# Example of beforeEnd 
# tags$div(
#     id = "ABC",
#     tags$p(
#         "I am Henry"
#     ),
#     tags$p(
#         "I am Yongbin"
#     )
# )

# ui
ui <- fluidPage(
    theme = bs_theme(version = 5),


    titlePanel(
        "Dynamic UI Examples"
    ),

    fluidRow(
        class = "ms-2 mt-4",

        actionButton(
            inputId = "add",
            label = "Add",
            icon = icon("plus", class = "me-1"),
            width = "100px",
            class = "me-1"
        ),
        actionButton(
            inputId = "del",
            label = "Delete",
            icon = icon("minus", class = "me-1"),
            width = "100px",
            class = "me-1"
        ),
        actionButton(
            inputId = "done",
            label = "Done",
            icon = icon("check", class = "me-1"),
            width = "100px",
            class = "btn-primary"
        )

        # icon: fontawesome
    ),

    # dynamic ui to be added
    fluidRow(
        class = "ms-2 mt-4 pb-3 border-top",
        fluidRow(
            id = "here"
        )

    ),

    fluidRow(
        class = "ms-2 mt-4 pt-3 border-top",
        uiOutput("result")
    )
)

# server
server <- function(input, output, session){

    isolate({
        fileNum <- reactiveVal(0L)
        msgOut <- reactiveVal(NULL)
    })
    
    # add button
    observeEvent(input$add, {
        
        req(input$add)
        
        fileNum( fileNum() + 1L )
        addNewFile(target_id = "here", i = fileNum())
    })
    
    # del button
    observeEvent(input$del, {
        
        req(input$del, fileNum() > 0L)
        
        removeUI(
            selector = paste0("#addFile_", fileNum())
        )
        
        fileNum( fileNum() - 1L )
    })

    # reflect the update on dynamic ui
    observe({
        
        if ( fileNum() == 0L ){
            output$result <-  renderUI({ "" })
            return()
        }
        
        textInputIds <- paste0("des_", seq_len( fileNum() ) ) 
        
        out <- list()
        for (j in seq_along(textInputIds) ){
            msg <- paste0("Description of File ", j, ": ", input[[ textInputIds[j] ]])
            out[[j]] <- tags$p(msg, class = "mt-1")
        }
        
        output$result <- renderUI({ out })
    })
    
    
    # confirm message modal
    observeEvent(input$done, {
        showModal( confirmUI() )
    })
    
    observeEvent(input$yes, {
        removeModal()

        #msgOut(NULL)
    })


}

shinyApp(ui, server)






