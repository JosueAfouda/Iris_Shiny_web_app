library(shiny)
library(DT)
library(shinythemes)

# Interface Utilisateur
ui <- fluidPage(
   
   # Liste déroulante de thèmes
   themeSelector(),
   
   # Nom de l'application
   titlePanel("Application Iris"),
   
   h2("Auteur : Josué AFOUDA"),
   
   # Ajout d'un lien web
   tags$a("Linkedin", href = "https://www.linkedin.com/in/josu%C3%A9-a-741693217/"),

    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "var", 
                        label = "Choisis une variable :", 
                        choices = names(iris[, -5]))
        ),
        mainPanel(
            tabsetPanel(
                # Onglet des données iris
                
                tabPanel(title = "Data Iris", 
                         DTOutput(outputId = "iris_data"),
                         
                         # Ajout d'un bouton de téléchargement
                         downloadButton('save_data', 'Save to CSV')
                         ), 
                
                # Onglet accueillant le résumé statistique
                
                tabPanel(title = "Statistiques", 
                         verbatimTextOutput(outputId = "summary")),
                
                # Onglet accueillant les histogrammes
                
                tabPanel(title = "Histogramme", 
                         plotOutput(outputId = "hist"))
            ) 
        )
    )
)

# Serveur
server <- function(input, output) {
    
   # Création d'une dataframe réactive stockant les données iris
   
   df <- reactive({
      
      iris
      
   })
   
   # Sauvegarde de la dataframe au format CSV
   # équivaut à la création de la sortie dont l'identifiant est "save_data"
   
   output$save_data <- downloadHandler(
      filename <- function(){
         paste("data_", Sys.Date(), ".csv", sep = ",")
      },
      content <- function(filename){
         write.csv(df(), filename)
      }
   )
   
   
    # Construction de la sortie dont l'identifiant est "iris_data"
   output$iris_data <- renderDT({
       
       df()
       
   })
   
   # Construction de la sortie dont l'identifiant est "summary"
   output$summary <- renderPrint({
       
       summary(df())
       
   })
   
   # Construction de la sortie dont l'identifiant est "hist"
   output$hist <- renderPlot({
       
       hist(df()[, input$var], 
            main = "Histogramme", 
            xlab = input$var)
       
   })
}

# Exécution de l'application 
shinyApp(ui = ui, server = server)

