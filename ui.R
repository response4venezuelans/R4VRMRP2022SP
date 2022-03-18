dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(disable = TRUE),
  skin = "black",
  dashboardBody(
    img(src = "r4v.png", height = 80),
    tabsetPanel(
      tabPanel(title = "1. Carga de datos",br(),
               p("Aplicacion para control de calidad y traduccion de datos para el RMRP 2022 Espanol al ingles", style="color: #fff; background-color: #672D53"),
               
               
               column(8,shinydashboard::box(id="box_2", title = "Por favor, copiar y pegar los datos desde un archivo xls, en el mismo formato que el template que le haya sido entregado", solidHeader = T,collapsible = T,collapsed = F,
                                            width = 12,status = "primary",
                                            
                                            
                                            fluidRow(
                                              column(
                                                width = 6,
                                                import_copypaste_ui("myid", title = "Pegar con la linea de titulos de columna"),
                                                
                                              ),
                                              
                                              
                                              
                                            ))),
               br(),
               fluidRow(column(12,shinydashboard::box(id="box_9", title = "Previsualizar datos", solidHeader = T,collapsible = T,collapsed = F,
                                                      width = 12,status = "primary",
                                                      DT::dataTableOutput("Preview_Data")
               ))),
               
               
               fluidRow(column(1,shinydashboard::box(id="box_15", title = "Control", solidHeader = T,collapsible = T,collapsed = F,
                                                     width = 12,status = "primary",
                                                     tags$b("Imported data:"),
                                                     verbatimTextOutput(outputId = "status"),
                                                     verbatimTextOutput(outputId = "data")
               )))
               
               
               
      ),
      ##### Page 2. Data Quality Check ############
      tabPanel(title = "2. Control de calidad de los datos",br(),
               p("Aplicacion para control de calidad y traduccion de datos para el RMRP 2022 Espanol al ingles", style="color: #fff; background-color: #672D53"),
               
               fluidRow(
                 
                 column(3,shinydashboard::box(id="box_2", title = "Reporte de actividad para revisar", solidHeader = T,collapsible = T,collapsed = F,
                                              width = 16,status = "primary",
                                              p("Por favor, seleccionar el pais para el cual quiere verificar los datos y correr el script"),
                                              fluidRow(
                                                column(4,selectInput("country_name",label = "Country Name",choices = c("NULL")))),
                                              actionButton("run_err_report",label = "Correr Script",icon = icon("black-tie"), style="color: #fff; background-color: #00AAAD"), 
                                              downloadButton("downloadprecleaned", "Download Error report", style="color: #fff; background-color: #672D53"),
                 )),
                 column(3,shinydashboard::box(id="box_3", title = "Resumen", solidHeader = T,collapsible = T,collapsed = F,
                                              width = 16,status = "warning",
                                              p("Number or Activities"),
                                              h2(textOutput("Number_of_Activities")),
                                              p("Number of activities to review"),
                                              h2(textOutput("Number_of_Errors_Pre")),
                                              p("Percentage of errors"),
                                              h2(textOutput("Percentage_of_Errors")),
                 ))),
               
               fluidRow(
                 column(12,shinydashboard::box(id="box_14", title = "Errores por organizacion y pais", solidHeader = T,collapsible = T,collapsed = F,
                                               width = 12,status = "primary",
                                               fluidRow(  column(6,plotlyOutput("plot")),
                                                          column(6,plotlyOutput("plot2"))
                                                          
                                               ))) ,
                 
                 
                 
                 
                 column(12,shinydashboard::box(id="box_4", title = "Previsualizar tabla de reporte de revision", solidHeader = T,collapsible = T,collapsed = F,
                                               width = 12,status = "primary",
                                               DT::dataTableOutput("Preview_Error_Report")
                 )))),
               ##### Page 3. Translation ############
               tabPanel(title = "3.Traduccion",br(),
                        p("Aplicacion para control de calidad y traduccion de datos para el RMRP 2022 Espanol al ingles", style="color: #fff; background-color: #672D53"),
                        fluidRow(column(4,shinydashboard::box(id="box_5", title = "Traduccion al ingles", solidHeader = T,collapsible = T,collapsed = F,
                                                              width = 12,status = "primary",
                                                              p("Correr script de traduccion"),
                                                              
                                                              actionButton("run_translate",label = "Correr script",icon = icon("battle-net"), style="color: #fff; background-color: #00AAAD"),
                                                              
                                                              downloadButton("downloadengdb", "Descargar 5W traducida", style="color: #fff; background-color: #672D53"))))
                        
               ))))