library(shiny)


# Define UI for my application
shinyUI(pageWithSidebar(
  
  # my Application title
  headerPanel("Web Analytics Dashboard with R Shiny"),
  
  # a sidebar with radio buttons to choose specific segments of web traffic
  
  sidebarPanel(
    
    
    radioButtons("radio", label="Segment Web Traffic by Device:",
                 choices=list("Desktop" = "desktop",
                   "Mobile" = "mobile",
                   "Tablet" = "tablet"),selected="mobile"),
    
    #Shiny app Documentation
    br(),

    helpText(p(("This Shiny app simulates a Web Analytics Dashboard. The objective of 
             a dashboard is to display the"),strong("current status of key web metrics"), 
             ("and arrange it on a single view so the information can be monitored 
             at a glance.")), 

             p("By clicking on radio buttons, you can decide to segment data 
             by a particular traffic device (desktop, mobile or tablet) 
             and spot differences in performance."),
             
             p(strong("Charts are interactive!"),(" Hover your mouse over them to see more 
                                                  details.")),

             p("Source of data: Google Analytics (web property is confidential)."),

             p("Timeframe: November 2014")),
    
    width= 3
    ),
  
  mainPanel(
    
    htmlOutput("dashboard")
     
  )
  
))
