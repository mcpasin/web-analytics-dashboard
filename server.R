library(shiny)
library(googleVis)
library(devtools)

# Source my datasets .csv from Google Analytics)

visits<-read.csv("visits-bounce-conv-LastMonth.csv")
channels<-read.csv("channels-LastMonth.csv")
countries<- read.csv("newusers-country-LastMonth.csv")

# CLEANING

# Clean dataset 1
head(visits)
#visits<-head(visits,-1)
colnames(visits)<- tolower(colnames(visits))
str(visits)
colnames(visits)<- c("date", "device","sessions","bounce.rate","signup")
visits$bounce.rate <- gsub("%","",visits$bounce.rate)
visits$sessions <- gsub(",","",visits$sessions)
visits$bounce.rate <- as.numeric(visits$bounce.rate)
visits$sessions <- as.numeric(visits$sessions)
visits$signup <- as.numeric(visits$signup)
head(visits)

# Clean Dataset 2
head(channels)
colnames(channels)<- tolower(colnames(channels))
colnames(channels)<- c("channel", "device","sessions","new.users","bounce.rate","pages.sessions","avg.session.duration","revenue")
### START BACK FROM HERE
channels$sessions <- gsub(",","",channels$sessions)
channels$sessions <- as.numeric(as.character(channels$sessions))

# Clean dataset 3
head(countries)
colnames(countries)<- tolower(colnames(countries))
colnames(countries)<- c("device", "country","sessions","new.sessions","new.users","bounce.rate","pages/sessions","avg.session.duration")
countries$new.users <- gsub(",","",countries$new.users)
countries$new.users <- as.numeric(as.character(countries$new.users))


# Define server logic 
shinyServer(function(input,output){
    
  output$dashboard<- renderGvis({
    
    # Make a Line Chart with primary axis for Sessions and secondary axis for Signups
    dataDevice<- subset(visits, device==input$radio)
    Line2axis <- gvisLineChart(dataDevice, "date", c("sessions","signup"),
                           options=list(
                             series="[{targetAxisIndex: 0},
                                 {targetAxisIndex:1}]",
                             vAxes="[{title:'Sessions'}, {title:'Signups'}]", 
                             title="Visits & Sign-up Trend Last Month",
                             width=500, height=300
                           ))
    
    # Make a Bubble Chart to see Channels Performance
    channelsDevice<- subset(channels, device==input$radio)
    Bubble <- gvisBubbleChart(channelsDevice, idvar="channel", 
                            xvar="sessions", yvar="pages.sessions",
                            colorvar="channel", sizevar="revenue",
                            options=list( 
                              title="Channels Performance (Revenue = Size of the Bubble)",
                              vAxis="{title: 'Pages per Session'}",
                              hAxis="{title: 'Sessions'}",
                              width=500, height=300,
                              legend = 'none'))
    
    #Merge first two charts horizontally
    D12 <- gvisMerge(Line2axis,Bubble, horizontal=TRUE)
    
    
    # Line chart to plot Bounce Rate evolution
    #dataDevice<- subset(visits, device==input$radio)
    Bounce<- gvisLineChart(dataDevice, xvar="date", yvar="bounce.rate", 
                           options = list(title="Bounce Rate Trend Last Month",
                                     vAxis="{title: 'Bounce Rate %'}",
                                     width=500, height=300,
                                     legend = 'none'))
    
    # Map chart to analyse new users by country
    countriesDevice<- subset(countries, device==input$radio)
    C <- gvisGeoChart(countriesDevice, "country", "new.users",
                           options = list(title="New Users by Country",
                                   width=500, height=300,
                                   legend = 'none'))
    
    #Merge the other two charts horizontally
    D34 <- gvisMerge(Bounce,C, horizontal=TRUE)
    #Merge two pairs of charts vertically
    D1234<- gvisMerge(D12,D34, horizontal=FALSE)
    
    #Plot entire Dashboard
    D1234
    
  })
  
})
