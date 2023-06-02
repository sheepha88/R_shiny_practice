


# dynamic UIs

# each row:


# 
# description (textInput)
# upload button (actionButton)
#   inputId = "upload_1",
#   onclick = "getUploadTarget(this.id)"
#   getUploadTarget() needs to be defined in head in advance
#
# download button (actionButton) - closed; will open once upload is done.



# ui
# tags$head(tags$script(HTML(
#  "function getUploadTarget(clicked_id){
#   Shiny.setInputValue('uploadTargetId', clicked_id);
#  }
#  "
# )
# ))

# server
# observe({
# print(input$uploadTargetId)
#})