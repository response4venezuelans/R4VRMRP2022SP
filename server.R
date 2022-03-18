#add upload capacity to shiny to 30MB

options(shiny.maxRequestSize=30*1024^2)

shinyServer(function(input, output, session) {
  
  ## Declaring Variables
  Data <- reactiveVal()
  Error_Download <- reactiveVal()
  Translate <- reactiveVal()


imported <- import_copypaste_server("myid")

output$status <- renderPrint({
  imported$status() })

    output$data <- renderPrint({
    source("R/1b_read_data_rmrp.R")
      Data(r4v_pull_xlsdata(imported$data()))
    showNotification("Data Processing Complete",duration = 10, type = "error")
  updateSelectInput(session,"country_name",choices = c("All",unique(Data()$Country)))
  updateSelectInput(session,"country_name_agg",choices = c("All",unique(Data()$Country)))


  })

    ## Data Preview
    output$Preview_Data <- DT::renderDataTable({Data()},extensions = c("Buttons"), options = list(
      dom = 'lfrtip', 
      # add B for button
      paging = TRUE,
      ordering = TRUE,
      lengthChange = TRUE,
      pageLength = 10,
      scrollX = TRUE,
      autowidth = TRUE,
      rownames = TRUE
    ))
    
    
    ##### 2. Data Quality Check ###### 
    
    observeEvent(input$run_err_report,{
      source("R/2_data_quality_checkSP.R")
      Error_report <- r4v_error_report(data = Data(),
                                       countryname = input$country_name)
      
      
      Error_Download(Error_report$ErrorReportclean)
      
      # To output number of activities and error 
      
      output$Number_of_Activities <- renderText({nrow(Error_report$ErrorReportclean)})
      output$Number_of_Errors_Pre <- renderText({sum(!is.na(Error_report$ErrorReportclean$Review))})
      output$Percentage_of_Errors <- renderText(round({sum(!is.na(Error_report$ErrorReportclean$Review))}/{nrow(Error_report$ErrorReportclean)}*100, digits = 1))
      
      # PLOTLY section
      
      output$plot <- renderPlotly({
        Error_report$ErrorReportclean %>%
          filter(!is.na(Review)) %>%
          ggplot() +
          aes(x = Appealing_org, size = Review) +
          geom_bar(fill = "#0c4c8a") +
          coord_flip() +
          theme_minimal()})
      
      output$plot2 <- renderPlotly({
        Error_report$ErrorReportclean %>%
          filter(!is.na(Review)) %>%
          ggplot() +
          aes(x = Country, size = Review) +
          geom_bar(fill = "#0c4c8a") +
          coord_flip() +
          theme_minimal()})
      
      showNotification("Successful",duration = 10, type = "error")
    })
    
    ## Download Error report
    output$downloadprecleaned <- downloadHandler(
      filename = function() {
        paste("Error Report", ".xlsx", sep = "")
      },
      content = function(file) {
        write_xlsx(Error_Download(), file)
      }
    )
    
    output$Preview_Error_Report <- DT::renderDataTable({Error_Download()},extensions = c("Buttons"), options = list(
      dom = 'lfrtip',
      paging = TRUE,
      ordering = TRUE,
      lengthChange = TRUE,
      pageLength = 10,
      scrollX = TRUE,
      autowidth = TRUE,
      rownames = TRUE))
    
    ## Pagina 3 traduccion
    
    observeEvent(input$run_translate,{
      source("R/3_export_db_eng.R")
      Translate(rmrptranslate(Data()))
      showNotification("Successful",duration = 10, type = "error")
    })
    
    
    output$downloadengdb <- downloadHandler(
      filename = function() {
        paste("RMRP20225WEnglish", ".xlsx", sep = "")
      },
      content = function(file) {
        write_xlsx(Translate(), file)
      }
    )
    
    
})