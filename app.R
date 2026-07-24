#amplio mida càrrega de dades a 32 MB (màxim shinyapps)
options(shiny.maxRequestSize = 32 * 1024^2)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(waiter) #fa el loading al clicar el link del web
library(readxl) #llegir excels
library(foreign) #read.spss
library(haven) #read_sas
library(dplyr, warn.conflicts = FALSE)
#library(purrr) #per al map()
#library(ggplot2)
library(medicaldata) #bbdd exemple
library(MedDataSets) #bbdd exemple
library(DT)
library(plotly)
library(shinyWidgets) #widgets més macos (botons, etc)
library(colourpicker) #colourInput (triar el color)
#library(doBy) #descriptiva numèrica respecte factor
library(compareGroups)
library(shinyhelper) #compila els markdowns d'ajuda
library(gvlma) #assumpcions models lineals
library(epiDisplay) #OR i IC
library(performance) #check_model
library(see) #gràfics check_model
library(shinycssloaders) #el check_model fa tardar molt la càrrega del model lineal. Mentre carrega, el shinycssloader avisa que està carregant



inici<-tabItem(tabName = "inici", h1("Inici"),
               h2("Descripció"),
               p(tags$a(href = "https://github.com/marcpurgimon/UABasicS", tags$b(tags$span(style = "color:green","UABasicS"))), "es tracta d'una aplicació web", tags$a(
                 href="https://shiny.posit.co/",
                 tags$img(src = "https://shiny.posit.co/images/shiny-solo.png", height = "15px")
               ), tags$b("d'anàlisi estadística bàsica per a professionals sanitaris,"), "com a projecte final del", tags$b("Grau en Estadística Aplicada,"), "de la", tags$a(href = "https://www.uab.cat/", "Universitat Autònoma de Barcelona (UAB)."),
               tags$br(),
               "Aquest web està programat de tal manera que puguis carregar unes dades — o utilitzar una base de dades d'exemple — i realitzar anàlisis estadístiques bàsiques sense la necessitat de saber programar, ni saber estadística. Els anàlisis els podràs dur a terme a través de clics, a més de disposar de petites ajudes sobre estadística."),
               "L'estructura de la pàgina és la següent:",
               tags$ul(
                 tags$li(tags$b("Base de dades:"), "Pàgina on carregar les dades. A més de l'opció de carregar un fitxer de dades, disposes de bases de dades mèdiques d'exemple. Podràs veure representades les dades a través d'una taula interactiva i un resum ràpid de les variables."),
                 tags$li(tags$b("Anàlisi univariant:"), "Tria la variable que desitgis estudiar, i en disposaràs d'una anàlisi descriptiva: la taula descriptiva i el gràfic interactiu corresponents al tipus de variable."),
                 tags$li(tags$b("Anàlisi bivariant:"), "Tria les dues variables que desitgis analitzar-ne la relació. Podràs fer una anàlisi descriptiva bivariant i el contrast corresponent al tipus de variables, amb la interpretació de cada test. A més a més tens la opció de fer una taula bivariada de diverses variables respecte una variable grup i descarregar la taula resultant."),
                 
                 tags$li(tags$b("Model Lineal General:"), "Si vols estudiar una variable resposta numèrica, respecte predictors tant factors com numèrics, tens a disposició un Model Lineal General."),
                 tags$li(tags$b("Model de Regressió Logística:"), "Si el teu objectiu és modelitzar una variable resposta binària, tens a disposició un Model de Regressió Logística, amb predictors tant factors com numèrics.")),
               tags$hr(),
               fluidRow(userBox(
                 title = userDescription(
                   title = "Marc Purgimon Serra",
                   subtitle = "Autor",
                   type = 1,
                   image = "https://avatars.githubusercontent.com/u/244218935?v=4",
                   backgroundImage = "https://estudis.uab.cat/doc/ima/fons-columnesverd01.png"
                 ), 
                 #status = "black",
                 "Estudiant d'Estadística Aplicada",
                 footer = tagList(
                   socialButton(href = "https://www.linkedin.com/in/marc-purgimon-serra", icon = icon("linkedin")),
                   socialButton(href = "https://github.com/marcpurgimon", icon = icon("github")),
                   icon("envelope-open"),
                   "mpurgimon@gmail.com"
                   
                 ) 
               ),userBox(
                 title = userDescription(
                   title = "Queralt Miró Catalina",
                   subtitle = "Tutora del TFG",
                   type = 1,
                   image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRywOd29JmMZGm2CeCWzCkp2AMv54FTClfV4uZa3z9eYQ&s=10",
                   backgroundImage = "https://estudis.uab.cat/doc/ima/fons-columnesverd01.png"
                 ),
                 "Estadística"
               )
               )
)


#PÀGINA CÀRREGA DE DADES

carrega<-tabItem(tabName = "basedades", h1("Càrrega de dades"),
                 fluidRow(
                   box(
                     width = 4,
                     title = "Càrrega de dades", icon = icon("upload"),
                     collapsible = TRUE, #que es pugui tancar el box
                     dropdownMenu = boxDropdown(icon = icon("database"),
                                                boxDropdownItem("medicaldata", href = "https://higgi13425.github.io/medicaldata", icon = icon("database")),
                                                boxDropdownItem("MedDataSets", href = "https://CRAN.R-project.org/package=MedDataSets",icon = icon("database"))
                     ),
                     helper(
                       span(), #posem el help en un element buit del box
                       icon = "info",
                       colour = "green",
                       type = "markdown",
                       buttonLabel = "Tanca", #botó de tancar
                       content = "info_bbdd",
                       fade = TRUE
                     ),
                     awesomeRadio(
                       inputId = "tria",
                       label = "Tria la base de dades",
                       choices = c("Carrega la teva base de dades" = "upload","Base de dades d'exemple" = "exemple"),
                       checkbox=TRUE, status = "success"
                     ),
                     conditionalPanel(condition = "input.tria == 'upload'",
                                      pickerInput(
                                        inputId = "fitxer", label = "Tipus de fitxer",
                                        choices = c(Tria = '',"csv/txt" = "csv",
                                                    "Excel (.xls/.xlsx)" = "excel",
                                                    "SPSS (.sav)" = "spss",
                                                    "SAS" = "sas")
                                      )
                     ),
                     conditionalPanel(condition = "input.fitxer == 'csv'",
                                      
                                      fileInput("fitxer_csv", "Carrega un fitxer .csv o .txt",
                                                buttonLabel = "Carrega...",
                                                placeholder = "No has carregat el fitxer",
                                                multiple = FALSE,
                                                accept = c("text/csv",
                                                           "text/comma-separated-values,text/plain",
                                                           ".csv")),
                                      
                                      tags$hr(),
                                      
                                      awesomeCheckbox("header", "Capçalera", TRUE, status = "success"),
                                      
                                      awesomeRadio("sep", "Separador",
                                                   choices = c("Coma" = ",",
                                                               "Punt i coma" = ";",
                                                               "Tabulador" = "\t"),
                                                   selected = ",", status = "success", checkbox = TRUE),
                                      
                                      awesomeRadio("quote", "Cometes",
                                                   choices = c("Sense" = "",
                                                               "Dobles" = '"',
                                                               "Simples" = "'"),
                                                   selected = '"', status = "success", checkbox = TRUE)
                     ),
                     
                     conditionalPanel(condition = "input.fitxer == 'excel'",
                                      
                                      fileInput(inputId = "fitxer_excel", 
                                                label = "Carrega un fitxer Excel (.xls/.xlsx)",
                                                multiple = FALSE,
                                                accept = c(".xls",".xlsx")),
                                      helpText("Assegura't que el rang de valors és correcte i que només tens un full de càlcul"),
                                      awesomeCheckbox("header_excel", "Capçalera", TRUE, status = "success")),
                     conditionalPanel(condition = "input.fitxer == 'spss'",
                                      fileInput(inputId = "fitxer_spss", 
                                                label = "Carrega un fitxer SPSS (.sav)",
                                                multiple = FALSE,
                                                accept = c(".sav"))
                     ),
                     
                     conditionalPanel(condition = "input.fitxer == 'sas'",
                                      fileInput(inputId = "fitxer_sas", 
                                                label = "Carrega un fitxer SAS (.sas7bdat)",
                                                multiple = FALSE,
                                                accept = c(".sas7bdat"))
                     ),
                     
                     conditionalPanel(condition = "input.tria == 'exemple'",
                                      pickerInput(
                                        inputId = "dataset_ex",
                                        label = "Tria la BBDD d'exemple",
                                        choices = list(
                                          Tria = '', 
                                          medicaldata = ls("package:medicaldata"),
                                          MedDatasets = ls("package:MedDataSets")
                                        )
                                      )
                     ) #final conditional panel exemple
                     
                   ), #final box
                   
                   ####################
                   #2n box: gestió de dades
                   #####################
                   
                   
                   box(
                     width = 4,
                     title = "Transformació de variables", icon = icon("gears"),
                     collapsible = TRUE,
                     helper(
                       span(), #posem el help en un element buit del box
                       icon = "info",
                       colour = "green",
                       type = "markdown",
                       buttonLabel = "Tanca", #botó de tancar
                       content = "info_canvi",
                       fade = TRUE
                     ),
                     #actionBttn(inputId = "help_canvi", label = "Info", icon = icon("info"), color = "primary", style = "simple"),
                     
                     pickerInput(inputId = "canvi_factor", label = "Convertir a factor", choices = NULL, multiple = TRUE, options = pickerOptions(title = "Selecciona les variables",container = "body", 
                                                                                                                                                  style = "btn-outline-primary", TRUE)),
                     pickerInput(inputId = "canvi_num", label = "Convertir a numèrica", choices = NULL, multiple = TRUE, options = pickerOptions(title = "Selecciona les variables",container = "body", 
                                                                                                                                                 style = "btn-outline-primary", actionsBox = TRUE)),
                     pickerInput(inputId = "logaritme", label = "Transformació logarítmica", choices = NULL, multiple = TRUE, options = pickerOptions(title = "Selecciona les variables",container = "body", 
                                                                                                                                                      style = "btn-outline-primary", actionsBox = TRUE))
                   ),
                   
                   
                   #########################################
                   ####seleccionar variables ###############
                   #########################################
                   
                   
                   box(
                     title = "Variables", icon = icon("arrow-pointer"),
                     collapsible = TRUE,
                     #collapsed = TRUE,
                     width = 4,
                     #seleccionem variables (pickerInput)
                     
                     pickerInput(
                       inputId = "variables",
                       label = "Tria les variables a representar",
                       choices = NULL,
                       multiple = TRUE,
                       options = pickerOptions(
                         actionsBox = TRUE,
                         title = "Selecciona les variables"
                       )
                     )
                     
                   )
                 ), #final fluidrow (1a fila)
                 
                 
                 #####################################
                 #####previsualització dades##########
                 #####################################
                 
                 fluidRow( #nova fila
                   tabBox(
                     width = 12,
                     title = tagList(shiny::icon("database"), "Previsualització dades"),
                     tabPanel(
                       title = "Taula",
                       downloadButton("download_dades", "Descarrega les dades (.csv)"),
                       #DTOutput per la taula interactiva
                       DTOutput("taula"), icon = icon("table")),
                     #resum ràpid de les variables
                     tabPanel(title = "Resum", 
                              #textOutput("dim"), 
                              #tags$br(),
                              verbatimTextOutput("resum")),
                     #mirar la classe de les variables
                     tabPanel(title = "Classe variables", verbatimTextOutput("tipus_var"))
                   )
                 )
                 
                 
)


univariant<-tabItem(
  tabName = "univariant", h1("Anàlisi univariant"),
  fluidRow(
    box(
      title = "Selecciona la variable a analitzar", icon = icon("arrow-pointer"),
      collapsible = TRUE,
      helper(
        span(), #posem el help en un element buit del box
        icon = "info",
        colour = "green",
        type = "markdown",
        buttonLabel = "Tanca", #botó de tancar
        content = "info_uni",
        size = "l", #mida pàgina
        fade = TRUE
      ),

      pickerInput(
        inputId = "var_uni",
        label = "Selecciona la variable a visualitzar", 
        choices = NULL,
        options = pickerOptions(title = "Selecciona la variable",container = "body", 
                                style = "btn-outline-primary"),
        width = "100%"
      )
    ),
    box(
      title = "Taula descriptiva", icon = icon("table"),
      collapsible = TRUE,
      tableOutput("taula_uni")
    )
  ),
  fluidRow(
    box(
      title = "Paràmetres gràfic", icon = icon("gears"), collapsible = TRUE,
      textInput(inputId = "titol_grafic1", label = "Insereix el títol del gràfic"),
      colourInput(inputId = "color_grafic1", label = "Seleccioni un color", value = "skyblue"),
      awesomeRadio(inputId = "disposicio_grafic1", label = "Disposició del gràfic",
                   choices = c("Vertical" = "vertical", "Horitzontal" = "horitzontal"), selected = "vertical", status = "success", checkbox = TRUE)
    ),
    box(
      title = "Gràfic", icon = icon("chart-simple"),
      collapsible = TRUE,
      plotlyOutput("grafic_uni")
    )
  )
)



bivariant<-tabItem(tabName = "bivariant", h1("Anàlisi bivariant"),
                   column(
                     width = 6,
                     tags$ul(h2("Anàlisi descriptiva")),
                     boxPad(
                       color = "gray",
                       fluidRow(
                         box(
                           width = 12,
                           title = "Selecciona les 2 variables a analitzar", icon = icon("arrow-pointer"),
                           collapsible = TRUE,
                           helper(
                             span(), #posem el help en un element buit del box
                             icon = "info",
                             colour = "green",
                             type = "markdown",
                             buttonLabel = "Tanca", #botó de tancar
                             content = "info_bivariant",
                             size = "l", #mida pàgina
                             fade = TRUE
                           ),
                           pickerInput(
                             inputId = "x",
                             label = "Variable independent: x // variable inicial: x1", 
                             choices = NULL,
                             options = pickerOptions(title = "Selecciona la variable x", container = "body", 
                                                     style = "btn-outline-primary"),
                             width = "100%"
                           ),

                           pickerInput(
                             inputId = "y",
                             label = "Variable resposta: y // variable final: x2", 
                             choices = NULL,
                             options = pickerOptions(title = "Selecciona la variable y", container = "body", 
                                                     style = "btn-outline-primary"),
                             width = "100%"
                           ),
                           awesomeRadio(inputId = "tipus_mostra", label = "Són mostres relacionades? (Ex: Inicial vs final)",
                                        choices = c("Sí" = "si", "No" = "no"), checkbox = TRUE,selected = "no", status = "success")
                         )
                       ),
                       fluidRow(
                         box(
                           width = 12,
                           title = "Taula descriptiva", icon = icon("table"),
                           collapsible = TRUE,
                           tableOutput("taula_bi")
                         )
                       ),
                       
                       fluidRow(
                         box(
                           width = 12,
                           title = "Gràfic", icon = icon("chart-simple"),
                           collapsible = TRUE,
                           sidebar = boxSidebar(
                             id = "parametres_grafic_bi",
                             startOpen = FALSE,
                             textInput(inputId = "titol_grafic2", label = "Insereix el títol del gràfic"),
                             #colourInput(inputId = "color_grafic1", label = "Seleccioni un color", value = "skyblue"),
                             awesomeRadio(inputId = "disposicio_grafic2", label = "Disposició del gràfic",
                                          choices = c("Vertical" = "vertical", "Horitzontal" = "horitzontal"), selected = "vertical", checkbox = TRUE, status = "success"),
                             uiOutput("color"),
                             uiOutput("opacitat"),
                             uiOutput("mida_punt")
                             #uiOutput("simbols"),
                             #uiOutput("fit")
                             
                           ),
                           plotlyOutput("grafic_bi")
                         )
                       )
                     )
                   ),
                   
                   
                   column(
                     width = 6,
                     tags$ul(h2("Inferència estadística")),
                     boxPad(
                       color = "gray",
                       fluidRow(
                         infoBoxOutput("test_bi", width = 12)
                       ),
                       fluidRow(
                         valueBoxOutput("pvalor_bi", width = 12)
                       ),
                       fluidRow(
                         uiOutput("interpretacio_bi")
                       ),
                       fluidRow(
                         box(
                           width = 12, title = "Resultats", collapsible = TRUE,
                           verbatimTextOutput("resultats_bi")
                         )
                       )
                       
                     )
                     
                   )
                   
)

comparar_grups<-tabItem(tabName = "comparegroups", h1("Comparació grups"),
                        fluidRow(
                          box(title = "Variables",
                              icon = icon("arrow-pointer"),
                              collapsible = TRUE,
                              helper(
                                span(), #posem el help en un element buit del box
                                icon = "info",
                                colour = "green",
                                type = "markdown",
                                buttonLabel = "Tanca", #botó de tancar
                                content = "info_compare",
                                size = "l", #mida pàgina
                                fade = TRUE
                              ),
                              
                              pickerInput(inputId = "grup", label = "Selecciona la variable grup",
                                          choices = NULL, multiple = FALSE,
                                          options = pickerOptions(
                                            actionsBox = TRUE,
                                            title = "Selecciona la variable grup (màxim 5 nivells)"
                                          )
                              ),
                              
                              pickerInput(
                                inputId = "variables_compare",
                                label = "Tria les variables a comparar",
                                choices = NULL,
                                multiple = TRUE,
                                options = pickerOptions(
                                  actionsBox = TRUE,
                                  title = "Selecciona les variables"
                                )
                              ),
                              #actionBttn(inputId = "help_compare", label = "Info", icon = icon("info"), color = "primary", style = "simple"),
                              actionBttn(inputId = "boto_compare", label = "Compilar", icon = icon("circle-play"), color ="success"),
                              downloadButton("download_taula","Descarrega la taula (word)"))
                        ),
                        fluidRow(
                          box(title = "Resultats", width = 12,
                              collapsible = TRUE,
                              verbatimTextOutput("resultat_compare"))
                        )
)




mod_lineal<-tabItem(tabName = "mod_lin", h1("Model Lineal General"),
                    column(
                      width = 6,
                      fluidRow(
                        box(
                          icon = icon("arrow-pointer"),
                          width = 12,
                          title = "Variables",
                          collapsible = TRUE,
                          helper(
                            span(), #posem el help en un element buit del box
                            icon = "info",
                            colour = "green",
                            type = "markdown",
                            buttonLabel = "Tanca", #botó de tancar
                            content = "info_lm",
                            size = "l", #mida pàgina
                            fade = TRUE
                          ),
                          pickerInput(inputId = "y_lin", label = "Selecciona la variable d'interès (numèrica)",
                                      choices = NULL, multiple = FALSE,
                                      options = pickerOptions(
                                        actionsBox = TRUE,
                                        title = "Selecciona la variable d'interès (numèrica)"
                                      )
                          ),
                      
                        pickerInput(
                          inputId = "pred_lin",
                          label = "Variables predictores",
                          choices = NULL,
                          multiple = TRUE,
                          options = pickerOptions(
                            actionsBox = TRUE,
                            title = "Selecciona les variables"
                          )
                        ),
                          #actionBttn(inputId = "help_glm", label = "Info", icon = icon("info"), color = "primary", style = "simple"),
                          actionBttn(inputId = "boto_lin", label = "Compilar", icon = icon("circle-play"), color ="success"))
                    ),
                    fluidRow(
                      box(
                        width = 12,
                        title = "Resultats",
                          collapsible = TRUE,
                        shinycssloaders::withSpinner(
                          verbatimTextOutput("res_mod_lin")
                        )
                      )
                    )
                    ),
                    column(
                      width = 6,
                      box(
                        icon = icon("chart-line"),
                        width = 12,
                        title = "Gràfics model",
                        shinycssloaders::withSpinner(
                        plotOutput("plot_lineal")
                        )
                      )
                           
                           )
)


logistica<-tabItem(tabName = "logit", h1("Model de Regressió Logística"),
                   fluidRow(
                     box(title = "Variables",
                         collapsible = TRUE,
                         icon = icon("arrow-pointer"),
                         helper(
                           span(), #posem el help en un element buit del box
                           icon = "info",
                           colour = "green",
                           type = "markdown",
                           buttonLabel = "Tanca", #botó de tancar
                           content = "info_logistica",
                           size = "l", #mida pàgina
                           fade = TRUE
                         ),
                         pickerInput(inputId = "y_logit", label = "Selecciona la variable resposta (binària)",
                                     choices = NULL, multiple = FALSE,
                                     options = pickerOptions(
                                       actionsBox = TRUE,
                                       title = "Selecciona la variable resposta (binària)"
                                     )
                         ),
                         pickerInput(
                           inputId = "pred_logit",
                           label = "Variables predictores",
                           choices = NULL,
                           multiple = TRUE,
                           options = pickerOptions(
                             actionsBox = TRUE,
                             title = "Selecciona les variables"
                           )
                         ),
                         #actionBttn(inputId = "help_logistica", label = "Info", icon = icon("info"), color = "primary", style = "simple"),
                         actionBttn(inputId = "boto_logit", label = "Compilar", icon = icon("circle-play"), color ="success"))
                   ),
                   fluidRow(
                     box(title = "Resultats", width = 12,
                         collapsible = TRUE,
                         verbatimTextOutput("res_mod_logit"))
                   )
)



#

header<-dashboardHeader(title=tags$b("UABasicS"), 
                        leftUi = tagList(socialButton(href = "https://github.com/marcpurgimon/UABasicS", icon = icon("github"))))
sidebar<-dashboardSidebar(
  sidebarMenu(
    tags$hr(), #salt de línia
    tags$a(
      href="https://www.uab.cat/", #al clicar al logo de la UAB se't dirigeix al web de la UAB
      tags$img(src = "https://www.uab.cat/Xcelerate/WAI/img/UAB-3linies-verd.svg"), #he posat la foto del logo de la UAB
    ),
    
    #tags$br(),
    tags$hr(), #per a fer un salt de línia posant una línia, seria hr
    menuItem("Inici",tabName = "inici",icon=icon("house"),selected = TRUE),
    menuItem("Càrrega de dades",tabName = "basedades", icon=icon("upload")),
    menuItem("Anàlisi univariant",tabName = "univariant",icon=icon("chart-simple")),
    menuItem("Anàlisi bivariant",tabName = "bivariant",icon=icon("chart-line"),
             startExpanded = TRUE,
             menuSubItem("Anàlisi bivariant", tabName = "bivariant"),
             menuSubItem("Comparació grups", tabName = "comparegroups")),
    menuItem("Models",tabName = "models",icon=icon("laptop-code"),
             startExpanded = TRUE,
             menuSubItem("Model Lineal General", tabName = "mod_lin"),
             menuSubItem("Regressió Logística", tabName = "logit"))
  )
  
)
body<-dashboardBody(
  tabItems(
    inici,
    carrega,
    univariant,
    bivariant,
    comparar_grups,
    mod_lineal,
    logistica)
  
)



ui<-
  dashboardPage(preloader = list(html = tagList(spin_1(),
                                                tags$img(src = "https://www.uab.cat/ca/identitatcorporativa/doc/logotip-versio-1-principal-negatiu.png", height = "100px"), br(), br(),
                                                h2("Carregant la pàgina ...")
  ), color = "green"), #això és del library(waiter)
  skin = "green-light",
  footer = dashboardFooter(left = "Aplicació d'anàlisi estadística bàsica",
                           right = tags$a(href = "https://www.linkedin.com/in/marc-purgimon-serra", "Marc Purgimon Serra, 2026")), 
  controlbar = dashboardControlbar(h4("Tria l'aparença de l'app"),collapsed = TRUE, skinSelector()), #seleccionar colors de la pàg a la barra d'eines
  header,sidebar,body)





#######################################
#######################################
###### SERVER #################
##############################
#############################


server<-function(input,output,session){
  
  #per als markdowns dels helps
  
  observe_helpers(session = shiny::getDefaultReactiveDomain(),
                  help_dir = "helpfiles", withMathJax = TRUE)
  
  
  dades<-reactive({
    if(input$tria == "exemple"){
      req(input$dataset_ex) #cridem l'input
      as.data.frame(get(input$dataset_ex)) #carreguem fitxer d'exemple (i per si de cas el convertim en data.frame si no)
      
    }
    else if(input$tria == "upload"){
      if(input$fitxer == "csv"){
        req(input$fitxer_csv) #cridem l'input
        read.csv(file = input$fitxer_csv$datapath, header = input$header, sep = input$sep, quote = input$quote) 
      }
      else if(input$fitxer == "excel"){
        req(input$fitxer_excel)
        read_excel(path = input$fitxer_excel$datapath,
                   col_names = input$header_excel)
      }
      
      else if(input$fitxer == "spss"){
        req(input$fitxer_spss)
        read.spss(file = input$fitxer_spss$datapath,to.data.frame = TRUE)
      }
      
      else if(input$fitxer == "sas"){
        req(input$fitxer_sas)
        read_sas(input$fitxer_sas$datapath)
      }
    }
  })
  
  
  observe({
    req(dades())
    
    updatePickerInput(session, inputId = "canvi_factor", choices = names(dades()),
                      selected = intersect(input$canvi_factor, setdiff(names(dades()), input$canvi_num)))
    updatePickerInput(session, inputId = "canvi_num", choices = names(dades()), selected = intersect(input$canvi_num, setdiff(names(dades()), input$canvi_factor)))
  })
  
  

  
  
  
  
  dades2<-reactive({
    
    #convertir a factor
    
    df<-dades()
    
    if (!is.null(input$canvi_factor)) {
      df[input$canvi_factor] <- lapply(df[input$canvi_factor], as.factor)
    }
    
    
    #convertir a numèrica
    
    if (!is.null(input$canvi_num)) {
      df[input$canvi_num] <- lapply(df[input$canvi_num], as.numeric)
    }
    
    df
  })
  
  
  observe({
    req(dades2())
    
    updatePickerInput(session, inputId = "logaritme",
                      choices = names(dades2())[sapply(dades2(),is.numeric)],
                      options = pickerOptions(
                        actionsBox = TRUE,
                        title = "Selecciona les variables"
                      ))
    
  })
  
  
  final_data <- reactive({
    
    req(dades2())
    
    df <- dades2()
    
    #if (is.null(input$logaritme) || length(input$logaritme) == 0) {
    #  return(df)
    #}
    
    df %>%
      mutate(
        across(
          all_of(input$logaritme),
          ~ log(.x),
          .names = "log_{.col}"
        )
      )
    
  })
  
  # actualitzo la selecció de variables
  
  observeEvent(final_data(), {
    updatePickerInput(session,
      inputId = "variables",
      choices = names(final_data()),
      selected = names(final_data()) #les selecciono totes per defecte
    )
  })
  
  
  
  
  
  
  ######################################
  ####taula interactiva de dades########
  ######################################
  
  output$taula<-renderDT({
    req(final_data())
    final_data() %>% dplyr::select(!!!input$variables)
  }, rownames = TRUE)
  
  
  ########################
  ## summary dades########
  ########################
  
  output$resum<-renderPrint({
    summary(final_data())
  })
  
  ##############################
  #####classe variables#########
  
  output$tipus_var<-renderPrint({
    #sapply(final_data(),class)
    str(final_data())
  })
  
  
  ##
  
  output$download_dades <- downloadHandler(
    filename = function() {
      "dades.csv"
    },
    content = function(file) {
      write.csv(final_data(), file, row.names = FALSE)
    }
  )
  
  ########
  #anàlisi univariant
  
  observe({
    updatePickerInput(
      session,
      inputId = "var_uni",
      choices = c(names(final_data())),
      choicesOpt = list(
        subtext = sapply(final_data(),function(i) class(i)[1])
      )
    )
  })
  
  #variable general (la fem reactiva per a estalviar codi)
  
  #UNIVARIANT
  
  
  #botó info bivariant
  observeEvent(input$help_uni, {
    showModal(
      modalDialog(
        includeMarkdown("info_uni.md"), size = "l"
      )
    )
  })
  
  v<-reactive({
    final_data()[[input$var_uni]]
  })
  
  
  output$taula_uni<-renderTable({
    if(is.numeric(v())) {
      taula<-round(c("N" = length(v()),summary(v()), "Std"
                     =sd(v())),2)
      taula<-as.matrix(taula)
      taula<-t(taula)
      taula<-as.data.frame(taula)
      #round(c(summary(final_data()[[input$var_uni]]), "Std"= sd(final_data()[[input$var_uni]])),2)
    }
    else if(is.factor(final_data()[[input$var_uni]])){
      taula<-table(final_data()[[input$var_uni]])
      taula<-round(100*prop.table(taula),2)
      taula<-c(taula, "Total" = sum(taula))
      taula<-as.matrix(taula)
      taula<-t(taula)
      taula<-as.data.frame(taula)
    }
    #else if(is.character(final_data()[[input$var_uni]])){
    #round(100*prop.table(table(as.factor(d_var()))),2)
    #}
  })
  output$grafic_uni<-renderPlotly({
    if(is.numeric(final_data()[[input$var_uni]])){
      #boxplot si és numèric
      if(input$disposicio_grafic1 == "vertical"){
        v<-final_data()[[input$var_uni]]
        p<-final_data() %>%
          plot_ly(y = ~v,
                  hoverinfo= "y") %>% #el hoverinfo="y" només mostra el text de la 2a coordenada. Si no especifiquem també posaria trace0 a part dels estadístics
          add_boxplot(color = I(input$color_grafic1)) %>%
          layout(xaxis = list(title = input$var_uni, showticklabels = FALSE),
                 yaxis = list(title = "N", tickformat = ".2f"),
                 title = input$titol_grafic1)
        
      }
      else if(input$disposicio_grafic1 == "horitzontal") {
        v<-final_data()[[input$var_uni]]
        p<-final_data() %>%
          plot_ly(x = ~v,
                  hoverinfo= "x") %>% 
          add_boxplot(color = I(input$color_grafic1)) %>%
          layout(yaxis = list(title = input$var_uni, showticklabels = FALSE),
                 xaxis = list(title = "N", tickformat = ".2f"),
                 title = input$titol_grafic1)
      }
      
    }
    else if(is.factor(final_data()[[input$var_uni]])){
      if(input$disposicio_grafic1 == "vertical"){
        
        #v<-final_data()[[input$var_uni]]
        p<-final_data() %>%
          count(.data[[input$var_uni]]) %>%
          mutate(pct = 100 * n / sum(n)) %>% #ho fem per percentatges
          plot_ly(x = ~.data[[input$var_uni]], y =~pct,
                  hoverinfo = "text",
                  text = ~paste("n:", n, "<br>",
                                round(pct,2), "%")) %>% 
          add_bars(color = I(input$color_grafic1)) %>%
          layout(xaxis = list(title = input$var_uni),
                 yaxis = list(title = "%"),
                 title = input$titol_grafic1)
      }
      else {
        p<-final_data() %>%
          count(.data[[input$var_uni]]) %>%
          mutate(pct = 100 * n / sum(n)) %>% #ho fem per percentatges
          plot_ly(x =~pct, y= ~.data[[input$var_uni]],
                  hoverinfo = "text",
                  text = ~paste("n:", n, "<br>",
                                round(pct,2), "%")) %>% 
          add_bars(color = I(input$color_grafic1)) %>%
          layout(yaxis = list(title = input$var_uni),
                 xaxis = list(title = "%"),
                 title = input$titol_grafic1)
      }
      
    }
    
  })
  
  ###
  ## bivariant
  
  

  
  
  #seleccionar variables
  
  observeEvent(final_data(), {
    updatePickerInput(
      session,
      inputId = "x",
      choices = c(names(final_data())),
      choicesOpt = list(
        subtext = sapply(final_data(),function(i) class(i)[1])
      )
    )

  })


  observe({
    updatePickerInput(
      inputId = "y",
      label = "Variable resposta: y // variable final: x2", 
      choices = c(names(final_data())),
      choicesOpt = list(
        subtext = sapply(final_data(),function(i) class(i)[1])
      )
    )
  })
  
  
  
  dy<-reactive({
    final_data()[[input$y]]
  })
  
  dx<-reactive({
    final_data()[[input$x]]
  })
  
  output$taula_bi<-renderTable({
    if(is.factor(final_data()[[input$x]]) && is.factor(final_data()[[input$y]])){ #si les 2 són factors, taula de contingència
      taula_bi<-table(final_data()[[input$x]],final_data()[[input$y]])
      taula_bi<-prop.table(taula_bi,1)
      taula_bi<-round(addmargins(taula_bi*100,2),2)
      taula_bi<-as.data.frame.matrix(taula_bi)
      noms_nivells<-c(levels(final_data()[[input$x]]))
      taula_bi<-cbind(noms_nivells,taula_bi)
      colnames(taula_bi)<-c(input$x, levels(final_data()[[input$y]]), "Total")
      taula_bi
    }
    else if(is.numeric(final_data()[[input$y]]) && is.factor(final_data()[[input$x]])){ #numèric segons grup
      
      df<-data.frame(x = final_data()[[input$x]], y = final_data()[[input$y]])
      
      df %>%
        group_by(Group = x) %>%
        summarise(
          "N" = n(),
          "Min." = round(min(y, na.rm = TRUE),2),
          "Q1" = round(quantile(y, 0.25, na.rm = TRUE),2),
          "Median" = round(median(y, na.rm = TRUE),2),
          "Mean" = round(mean(y, na.rm = TRUE),2),
          "Q3" = round(quantile(y, 0.75, na.rm = TRUE),2),
          "Max." = round(max(y, na.rm = TRUE),2),
          "Std." = round(sd(y, na.rm = TRUE),2)
        )
    }
    
    
    else if(is.numeric(final_data()[[input$y]]) && is.numeric(final_data()[[input$x]])){ #2 numèriques
      
      if(input$tipus_mostra == "si"){
        x <- final_data()[[input$x]]
        y <- final_data()[[input$y]]
        inicial<-c(input$x,
                   length(x), 
                   round(min(x, na.rm = TRUE),2),
                   round(quantile(x, 0.25, na.rm = TRUE),2),
                   round(median(x, na.rm = TRUE),2),
                   round(mean(x, na.rm = TRUE),2),
                   round(quantile(x, 0.75, na.rm = TRUE),2),
                   round(max(x, na.rm = TRUE),2),
                   round(sd(x, na.rm = TRUE),2)
        )
        final<-
          c(input$y,
            length(y), 
            round(min(y, na.rm = TRUE),2),
            round(quantile(y, 0.25, na.rm = TRUE),2),
            round(median(y, na.rm = TRUE),2),
            round(mean(y, na.rm = TRUE),2),
            round(quantile(y, 0.75, na.rm = TRUE),2),
            round(max(y, na.rm = TRUE),2),
            round(sd(y, na.rm = TRUE),2)
          )
        paired<-rbind(inicial,final)
        paired<-as.data.frame(paired)
        colnames(paired)<-c("Variable","N","Min.", "Q1", "Median", "Mean", "Q3", "Max.", "Std.")
        paired
      }
    }
    
  })
  
  
  
  # gràfics bivariants
  
  
  
  
  #per al scatterplot i boxplot: triar color
  
  output$color<-renderUI({
    colourInput(inputId = "color_grafic2", label = "Seleccioni un color", value = "skyblue")
  })
  
  
  output$opacitat<-renderUI({
    x<-final_data()[[input$x]]
    y<-final_data()[[input$y]]
    if(is.numeric(y) && is.numeric(x) && input$tipus_mostra == "no"){
      sliderInput("opacitat_grafic2",label = "Opacitat (0 = transparent)", min = 0, max = 1, value = 1)
      
    }
    
  })
  
  #output$simbols<-renderUI({
  #x<-final_data()[[input$x]]
  #y<-final_data()[[input$y]]
  #if(is.numeric(y) && is.numeric(x) && input$tipus_mostra == "no"){
  #awesomeRadio(inputId = "simbols_grafic2", label = "Símbols", choices = c("circle", "circle-open"), selected = "circle", checkbox = TRUE, status = "success")
  
  #}
  
  #})
  
  output$mida_punt<-renderUI({
    x<-final_data()[[input$x]]
    y<-final_data()[[input$y]]
    if(is.numeric(y) && is.numeric(x) && input$tipus_mostra == "no"){
      sliderInput(inputId = "mida_punts", label = "Mida dels punts", min = 1, max = 10, value = 5)
    }
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  output$grafic_bi<-renderPlotly({
    req(final_data())
    req(input$x, input$y)
    req(input$x %in% names(final_data()))
    req(input$y %in% names(final_data()))
    x<-final_data()[[input$x]]
    y<-final_data()[[input$y]]
    if(is.factor(y) && is.factor(x)){
      if(input$disposicio_grafic2 == "vertical"){
        p<-final_data() %>%
          count(.data[[input$x]], .data[[input$y]]) %>%
          group_by(.data[[input$x]]) %>%
          mutate(pct = 100 * n / sum(n)) %>% #ho fem per percentatges
          plot_ly(x = ~.data[[input$x]], y = ~pct, color = ~.data[[input$y]],
                  customdata = ~n,
                  hovertemplate =
                    paste0(
                      "%{fullData.name}<br>", #nom nivell
                      "n = %{customdata}<br>", #freq nivell
                      "%{y:.2f}%<extra></extra>")) %>% #percentatge
          add_bars() %>%
          layout(barmode = "stack",
                 xaxis = list(title = input$x),
                 yaxis = list(title = "%"),
                 title = input$titol_grafic2)
        return(p)
      }
      else if(input$disposicio_grafic2 == "horitzontal"){
        p<-final_data() %>%
          count(.data[[input$x]], .data[[input$y]]) %>%
          group_by(.data[[input$x]]) %>%
          mutate(pct = 100 * n / sum(n)) %>% #ho fem per percentatges
          plot_ly(y = ~.data[[input$x]], x = ~pct, color = ~.data[[input$y]],
                  customdata = ~n,
                  hovertemplate =
                    paste0(
                      "%{fullData.name}<br>",
                      "n = %{customdata}<br>",
                      "%{x:.2f}%<extra></extra>")) %>%
          add_bars() %>%
          layout(barmode = "stack",
                 yaxis = list(title = input$x),
                 xaxis = list(title = "%"),
                 title = input$titol_grafic2)
        
        return(p)
      }
    }
    
    #BOXPLOTS
    
    if(is.numeric(y) && is.factor(x)){ #boxplot per grups
      if(input$disposicio_grafic2 == "vertical"){
        p<-final_data() %>%
          plot_ly(x = ~.data[[input$x]], y= ~.data[[input$y]]) %>%
          add_boxplot(color = I(input$color_grafic2)) %>%
          layout(xaxis = list(title = input$x),
                 yaxis = list(title = "N"),
                 title = input$titol_grafic2)
        return(p)
      }
      else if(input$disposicio_grafic2 == "horitzontal"){
        p<-final_data() %>%
          plot_ly(x = ~.data[[input$y]], y= ~.data[[input$x]]) %>%
          add_boxplot(color = I(input$color_grafic2)) %>%
          layout(xaxis = list(title = "N"),
                 yaxis = list(title = input$x),
                 title = input$titol_grafic2)
        return(p)
        
      }
    }
    #si les 2 són numèriques
    if(is.numeric(y) && is.numeric(x)){
      #si són dades relacionades: boxplot de 2 grups (creo 1 boxplot i després un altre al costat)
      if(input$tipus_mostra == "si"){
        # també opció vertical i horitzontal (per defecte vertical)
        if(input$disposicio_grafic2 == "vertical"){
          
          #variable inicial
          
          p1<-final_data() %>%
            plot_ly(y = ~.data[[input$x]]) %>%
            add_boxplot(name = input$x, color = I(input$color_grafic2)) %>%
            layout(xaxis = list(title = ""),
                   yaxis = list(title = "N")
            )
          
          p2<-final_data() %>%
            plot_ly(y = ~.data[[input$y]]) %>%
            add_boxplot(name = input$y, color = I(input$color_grafic2)) %>%
            layout(
              xaxis = list(title = ""),
              yaxis = list(title = "N")
            )
          
          
          #ajuntem gràfics
          
          return(subplot(p1,p2, nrows = 1, shareX = FALSE, shareY = TRUE) %>%
                   layout(title = input$titol_grafic2, showlegend = FALSE,
                          yaxis = list(tickformat = ".2f")))
          
          
          
        }
        
        else if(input$disposicio_grafic2 == "horitzontal"){
          
          #variable inicial
          
          p1<-final_data() %>%
            plot_ly(x = ~.data[[input$x]]) %>%
            add_boxplot(name = input$x, color = I(input$color_grafic2))
          
          
          #variable final
          
          p2<-final_data() %>%
            plot_ly(x = ~.data[[input$y]]) %>%
            add_boxplot(name = input$y, color = I(input$color_grafic2))
          
          #ajuntem gràfics
          
          return(subplot(p1,p2, nrows = 2, shareX = TRUE, shareY = FALSE) %>%
                   layout(title = input$titol_grafic2, showlegend = FALSE,
                          yaxis = list(title = ""),
                          xaxis = list(title = "N", tickformat = ".2f")
                   ))
          
        }
        
      }
      
      else if(input$tipus_mostra == "no"){
        
        p<-final_data() %>%
          plot_ly(x = ~.data[[input$x]], y = ~.data[[input$y]]) %>%
          add_markers(marker = list(color = input$color_grafic2 ,opacity = input$opacitat_grafic2, size = input$mida_punts)) %>%
          layout(title = input$titol_grafic2,
                 xaxis = list(title = input$x),
                 yaxis = list(title = input$y))
        
        return(p)
      }
    }
    
    
  })
  
  
  
  
  test_norm_num<-reactive({
    t1<-shapiro.test(final_data()[[input$x]])
    t2<-shapiro.test(final_data()[[input$y]])
    
    return(list(p1=t1$p.value, p2=t2$p.value))
    
  })
  
  
  test_paired<-reactive({
    
    
    # si tant l'inicial com el final són normals (pval >=0.05): t-test paired
    df<-final_data()
    x<-final_data()[[input$x]]
    y<-final_data()[[input$y]]
    
    if(test_norm_num()$p1>=0.05 && test_norm_num()$p2>=0.05){
      return(t.test(x,y, paired = TRUE))
    }
    
    else {
      return(wilcox.test(x,y, paired = TRUE))
    }
  })
  
  
  test_norm_indep<-reactive({
    df<-final_data()
    x<-final_data()[[input$x]]
    y<-final_data()[[input$y]]
    f<-reformulate(input$x, response = input$y)
    test_norm<-df %>%
      rstatix::group_by(!!rlang::sym(input$x)) %>%
      rstatix::shapiro_test(!!rlang::sym(input$y))
    normal<-all(test_norm$p >= 0.05)
    return(
      list(
        test = test_norm,
        normal = normal
      )
    )
  })
  
  
  
  numeric_grup<-reactive({
    req(input$x, input$y)
    df<-final_data()
    req(input$x %in% names(df))
    req(input$y %in% names(df))
    x<-final_data()[[input$x]]
    y<-final_data()[[input$y]]
    f<-reformulate(input$x, response = input$y) #fórmula
    ng <- nlevels(df[[input$x]]) #nombre grups
    
    
    # si les dades són normals
    
    if(test_norm_indep()$normal == TRUE){
      # si té 2 grups: t-test
      if(ng == 2){
        variancia<-var.test(f, data = df)
        
        # t-test per a variàncies iguals
        
        if(variancia$p.value>=0.05){
          return(t.test(f,data = df, var.equal = TRUE))
          
        }
        #si les variàncies no són iguals, no assumim igualtat
        else{
          return(t.test(f, data = df, var.equal = FALSE))
        }
        
      }
      
      # si hi ha més de 2 grups: ANOVA
      
      else if(ng >2){
        #per a més de 2 grups, bartlett.test() per a la igualtat de variàncies
        variancia<-bartlett.test(f, data = df)
        
        # si no rebutgem h0: variàncies iguals (pval>=0.05)
        
        if(variancia$p.value>=0.05){
          sortida<-oneway.test(f, data = df, var.equal = TRUE)
          if (sortida$p.value < 0.10){
            return(list(
              global = sortida,
              "2 a 2" = pairwise.t.test(df[[input$y]], df[[input$x]], p.adjust.method = "bonferroni")
            ))
            
          }
          else if (sortida$p.value >= 0.10)  {
            return(list(
              global = sortida,
              "2 a 2" = "No es fa un contrast 2 a 2 perquè el p-valor global NO és estadísticament significatiu"
            ))
          }
        }
        
        # si rebutgem H0 (variàncies diferents)
        
        if(variancia$p.value<0.05){
          sortida<-oneway.test(f, data = df, var.equal = FALSE)
          if (sortida$p.value < 0.10){
            return(list(
              global = sortida,
              "2 a 2" = pairwise.t.test(df[[input$y]], df[[input$x]], p.adjust.method = "bonferroni")
            ))
            
          }
          else {
            return(
              list(
                global = sortida,
                "2 a 2" = "No es fa un contrast 2 a 2 perquè el p-valor global NO és estadísticament significatiu"
              )
            )
          }
        }
        
      }
    }
    else {
      if (test_norm_indep()$normal == FALSE) {
        if (ng == 2) {
          wilcox.test(f, data = df)
          
        }
        else {
          sortida<-kruskal.test(f, data = df)
          if (sortida$p.value < 0.10) {
            return(
              list(
                global = sortida,
                "2 a 2" = pairwise.wilcox.test(df[[input$y]], df[[input$x]], p.adjust.method = "bonferroni")
              )
            )
            
          }
          else {
            return(sortida)
          }
        }
      }
    }
  })
  
  
  
  cat_grup<-reactive({
    x<-final_data()[[input$x]]
    y<-final_data()[[input$y]]
    test_chi<-chisq.test(x, y) #test chi2
    taula_e<-test_chi$expected #valors esperats de la chi2
    n<-length(taula_e) #nombre cel·les taula chi2
    
    e5<-sum(taula_e<5) #compta el nº de cel·les amb freq<5
    
    c<-e5/n # proporció de cel·les amb freq<5
    
    # si com a mínim el 80% tenen més freq de 5 o més: chi2 <-> si menys d'un 20%: fisher
    #(segons Cochran)
    
    if (c<=0.20){
      return(chisq.test(x, y))
    }
    else {
      return(fisher.test(x, y))
    }
    
  })
  
  
  test_corr<-reactive({
    x<-final_data()[[input$x]]
    y<-final_data()[[input$y]]
    if(test_norm_num()$p1>=0.05 && test_norm_num()$p2>=0.05){
      return(cor.test(x,y, method = "pearson"))
    }
    else {
      return(cor.test(x,y, method = "spearman"))
    }
    
  })
  
  
  
  
  
  
  
  
  
  
  
  
  output$resultats_bi<-renderPrint({
    x<-final_data()[[input$x]]
    y<-final_data()[[input$y]]
    if(is.numeric(y) && is.factor(x)){
      numeric_grup()
    }
    else if(is.factor(y) && is.factor(x)){
      cat_grup()
    }
    else if(is.numeric(y) && is.numeric(x)){
      if(input$tipus_mostra == "si"){
        test_paired()
      }
      else {
        test_corr()
      }
    }
    
  })
  
  
  
  output$interpretacio_bi<-renderUI({
    
    x <- final_data()[[input$x]]
    y <- final_data()[[input$y]]
    
    if (is.numeric(y) && is.factor(x) && nlevels(x) == 2) {
      
      
      #####################
      # T-TEST / WILCOXON
      #####################
      
      res <- numeric_grup()
      
      
      pval_num_grup <- res$p.value
      
      if (pval_num_grup < 0.05) {
        
        box(title = "Interpretació", width = 12, collapsible = TRUE, background = "green",
            paste(
              "p-valor = ", round(pval_num_grup,3), ": Hi ha diferències estadísticament significatives a la variable",
              input$y,
              "respecte els nivells de la variable",
              input$x
            )
        )
        
      } else if (pval_num_grup < 0.10) {
        
        box(title = "Interpretació", width = 12,collapsible = TRUE, background = "yellow",
            paste(
              "p-valor = ", round(pval_num_grup,3), ": Considerant un nivell de significació del 10%, hi ha diferències estadísticament significatives a la variable",
              input$y,
              "respecte els nivells de la variable",
              input$x
            )
        )
        
      } else {
        
        box(title = "Interpretació", width = 12, collapsible = TRUE, background = "red",
            paste(
              "p-valor = ", round(pval_num_grup,3), ": No hi ha diferències estadísticament significatives a la variable",
              input$y,
              "respecte els nivells de la variable",
              input$x
            )
        )
        
      }
      
    }
    
    ##############################
    #### ANOVA / KRUSKAL##########
    ##############################
    
    
    
    else if (is.numeric(y) && is.factor(x) && nlevels(x) > 2) {
      
      res <- numeric_grup()
      
      pval_global <- res$global$p.value
      
      if (pval_global < 0.05) {
        
        box(title = "Interpretació global", width = 12,collapsible = TRUE, background = "green",
            paste(
              "p-valor = ", round(pval_global,3), ": Globalment, hi ha diferències estadísticament significatives a la variable",
              input$y,
              "respecte els nivells de la variable",
              input$x
            )
        )
        
      } else if (pval_global < 0.10) {
        
        box(title = "Interpretació global", width = 12,collapsible = TRUE, background = "yellow",
            paste(
              "p-valor = ", round(pval_global,3), ": Considerant un nivell de significació del 10%, globalment hi ha diferències estadísticament significatives a la variable",
              input$y,
              "respecte els nivells de la variable",
              input$x
            )
        )
        
      } else {
        
        box(title = "Interpretació global", width = 12, collapsible = TRUE, background = "red",
            paste(
              "p-valor = ", round(pval_global,3), ": No hi ha diferències estadísticament significatives a la variable",
              input$y,
              "respecte els grups",
              input$x
            )
        )
        
      }
      
      
    }
    else if(is.factor(y) && is.factor(x)){
      #cat_grup()
      pvalor_cat<-cat_grup()$p.value
      
      if (pvalor_cat < 0.05) {
        
        box(title = "Interpretació", width = 12, collapsible = TRUE, background = "green",
            paste(
              "p-valor = ", round(pvalor_cat,3), ": Hi ha diferències estadísticament significatives a la variable",
              input$y,
              "respecte els nivells de la variable",
              input$x
            )
        )
        
      } else if (pvalor_cat < 0.10) {
        
        box(title = "Interpretació", width = 12,collapsible = TRUE, background = "yellow",
            paste(
              "p-valor = ", round(pvalor_cat,3), ": Considerant un nivell de significació del 10%, hi ha diferències estadísticament significatives a la variable",
              input$y,
              "respecte els nivells de la variable",
              input$x
            )
        )
        
      } else if (pvalor_cat>=0.10){
        
        box(title = "Interpretació", width = 12, collapsible = TRUE, background = "red",
            paste(
              "p-valor = ", round(pvalor_cat,3), ": No hi ha diferències estadísticament significatives a la variable",
              input$y,
              "respecte els nivells de la variable",
              input$x
            )
        )
        
      }
      
    }
    else if(is.numeric(y) && is.numeric(x)){
      if(input$tipus_mostra == "si"){
        #test_paired()
        pval_paired<-test_paired()$p.value
        
        if (pval_paired < 0.05) {
          
          box(title = "Interpretació", width = 12, collapsible = TRUE, background = "green",
              paste(
                "p-valor = ", round(pval_paired,3), ": Hi ha diferències estadísticament significatives a la variable",
                input$y,
                "respecte els nivells de la variable",
                input$x
              )
          )
          
        } else if (pval_paired < 0.10) {
          
          box(title = "Interpretació", width = 12,collapsible = TRUE, background = "yellow",
              paste(
                "p-valor = ", round(pval_paired,3), ": Considerant un nivell de significació del 10%, hi ha diferències estadísticament significatives a la variable",
                input$y,
                "respecte els nivells de la variable",
                input$x
              )
          )
          
        } else if (pval_paired>=0.10){
          
          box(title = "Interpretació", width = 12, collapsible = TRUE, background = "red",
              paste(
                "p-valor = ", round(pval_paired,3), ": No hi ha diferències estadísticament significatives a la variable",
                input$y,
                "respecte els nivells de la variable",
                input$x
              )
          )
          
        }
        
        
        
        
      }
      else {
        #test_corr()
        pval_corr<-test_corr()$p.value
        
        if (pval_corr < 0.05) {
          
          box(title = "Interpretació", width = 12, collapsible = TRUE, background = "green",
              paste(
                "p-valor = ", round(pval_corr,3), ": El coeficient de correlació ", round(test_corr()$estimate,2), " és estadísticament diferent de 0."
              )
          )
          
        } else if (pval_corr < 0.10) {
          
          box(title = "Interpretació", width = 12,collapsible = TRUE, background = "yellow",
              paste(
                "p-valor = ", round(pval_corr,3), ": Considerant un nivell de significació del 10%, el coeficient de correlació ", round(test_corr()$estimate,2), " és estadísticament diferent de 0."
              )
          )
          
        } else if (pval_corr>=0.10){
          
          box(title = "Interpretació", width = 12, collapsible = TRUE, background = "red",
              paste(
                "p-valor = ", round(pval_corr,3), ": El coeficient de correlació ", round(test_corr()$estimate,2), " és estadísticament nul, és a dir, igual a 0."
              )
          )
          
        }
        
        
        
      }
    }
    
  }) 
  
  
  
  
  
  
  # compareGroups
  

  
  
  
  observeEvent(final_data(),{
    
    updatePickerInput(
      session,
      inputId = "grup",
      choices = names(final_data())[sapply(final_data(),function(x) is.factor(x) && nlevels(x) <=5)]
    )
    
  })
  
  
  observe({
    updatePickerInput(
      session,
      inputId = "variables_compare",
      choices = c(setdiff(names(final_data()), input$grup))
    )
  })
  
  
  model_compare<-eventReactive(
    input$boto_compare,{
      #req(input$grup)
      #req(input$variables_compare)
      formula<-as.formula(
        paste(
          input$grup, "~", paste(input$variables_compare, collapse = "+")
        )
      )
      compareGroups(formula, data = final_data(), method=NA)
      #method=NA calcula el test de Shapiro-Wilks per a decidir si són Normals o no. Per defecte, method=1 suposa normalitat en les dades
      
      
      
    })
  
  
  output$resultat_compare<-renderPrint({
    
    taula<-createTable(model_compare(), show.all = TRUE)
    taula
  })
  
  
  
  
  output$download_taula<-downloadHandler(
    filename = function() {"taula.docx"},
    content = function(file) {
      taula<-createTable(model_compare(), show.all = TRUE)
      export2word(taula, file)
    }
    
  )
  
  # MODELS
  
  # LINEAL
  

  
  
  
  observeEvent(final_data(),{
    updatePickerInput(
      session,
      inputId = "y_lin",
                choices = names(final_data())[sapply(final_data(),is.numeric)]
    )
    
  })
  
  
  observe({
    updatePickerInput(
      session,
      inputId = "pred_lin",
      choices = c(setdiff(names(final_data()), input$y_lin))
    )
    
  })
  
  
  
  model_lineal<-eventReactive(
    input$boto_lin,{
      req(input$y_lin)
      req(input$pred_lin)
      formula<-as.formula(
        paste(
          input$y_lin, "~", paste(input$pred_lin, collapse = "+")
        )
      )
      mod<-lm(formula, data = final_data())
      #return(summary(mod))
      #return(mod)
      #return(summary(gvlma(mod)))
      return(mod)
      
    })
  
  
  output$res_mod_lin<-renderPrint({
    #summary(gvlma(model_regressio()))
    summary(gvlma(model_lineal()))
  })
  
  
  output$plot_lineal<-renderPlot({
    check_model(model_lineal())
    
  })
  
  
  # LOGISTICA
  
  
  
  
  
  observeEvent(final_data(),{
    
    updatePickerInput(
      session,
      inputId = "y_logit",
                choices = names(final_data())[sapply(final_data(),function(x) is.factor(x) && nlevels(x) == 2)]
    )
    
  })
  
  observe({
    updatePickerInput(
      session,
      inputId = "pred_logit",
      choices = c(setdiff(names(final_data()), input$y_logit))
    )
  })
  
  
  model_logistica<-eventReactive(
    input$boto_logit,{
      req(input$y_logit)
      req(input$pred_logit)
      formula<-as.formula(
        paste(
          input$y_logit, "~", paste(input$pred_logit, collapse = "+")
        )
      )
      mod<-glm(formula, data = final_data(), family = "binomial")
      return(    
        list(
        model = summary(mod),
        OR = logistic.display(mod)          
      )
      )
      
    })
  
  
  output$res_mod_logit<-renderPrint({
    model_logistica()
    
  })
  
  output$plot_logistica<-renderPlot({
    
  })
  
  
  
  
  
  
  
  
  
}



shinyApp(ui,server)
