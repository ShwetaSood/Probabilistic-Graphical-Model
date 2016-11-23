options(shiny.maxRequestSize=2000*1024^2)
library(bnlearn)
library(igraph)

shinyServer(function(input, output,session) {
  
  observe({
    csvfile <- input$choose_csv_to_markovify
    if (is.null(csvfile))
      return(NULL)
    
    else 
    {
      dt <- read.csv(csvfile$datapath, header=TRUE, sep=",")#,nrow=2)
      #dt = dt[,-1]
    }
    
progress <- shiny::Progress$new()
progress$set(message = "Bayesian Network", detail = 'Reading CSV file', value = 3)   

################################################

updateNumericInput(session,'noOfVariables',
                  label = paste("No of Columns"),
                  value = ncol(dt))
updateNumericInput(session,'noOfRows',
                  label = paste("No of Rows"),
                  value = nrow(dt))


########## Bayesian Network #################

updateSelectInput(session,'columnname',
                      label = paste("Variable Name"),
                      choices = names(dt),
                      selected = 1
    )
    
  updateSelectInput(session,'node_list',
                  label = paste("NodeList"),
                  choices = names(dt),
                  selected = 1
  )

progress$set(message = "Bayesian Network", detail = 'Building Network', value = 3)   

#Build relationship 

output$relationship_plot_output<-renderPlot({
  if(is.null(csvfile) || is.null(input$node_list))
    return()
  
  nodelist = input$node_list
  model = net
  source("/home/spuser/Ashish/Bayesian Network//Codes/Functions.R")
  view_user_network(model,nodelist)
})


output$network_plot <- renderPlot({
  if (input$waitbutton == 0)
  {
    print("returning")
    return()
  }
    
  print("here")
  isolate({
    # Your logic here
    wl = NULL
    bl = NULL
    data = as.data.frame(lapply(dt, factor))
    net <<- tabu(data, whitelist=wl, blacklist=bl, score='bde',debug=TRUE)
    class(net)
    plot(net,type="lines")
    
    #"Network Built"
  })
})
progress$set(message = "Bayesian Network", detail = 'Network Building Complete', value = 3)
on.exit(progress$close())    
    output$markov_plot_output<-renderPlot({
      if(is.null(csvfile) || is.null(input$columnname) || input$columnname == "")
        return()
      
       source("Functions.R")
       model = net
       data_markov_b = as.data.frame(model$arcs)
       node = input$columnname
       plot_markov_blanket(data_markov_b[markov_blanket(data_markov_b,node)$index,],node)
    })
    })
}
)
