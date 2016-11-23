shinyUI(fluidPage(
  tabPanel("Bayesian Networks",
           sidebarPanel(
             fileInput('choose_csv_to_markovify', 'CSV File',
                       accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
             actionButton("waitbutton", "Create Network"),
             numericInput('noOfVariables', label='No of Columns', value=0),
             numericInput('noOfRows', label='No of Rows', value=0),
             selectInput("columnname",
                         label="Variable Name",choices=list(),                  
                         selected=0),
             selectizeInput(
               'node_list', 'NodeList', choices = list(), multiple = TRUE
             )
             #numericInput("sample_size", label = ("Stratified Sample Size"),value = 0),
             #submitButton("Create markov Blanket")
             #submitButton("goButton", "Create markov Blanket")
           ),
           mainPanel(
             #verbatimTextOutput("nText")
             plotOutput("network_plot"),
             plotOutput("markov_plot_output")
           ),
           
           #plotOutput("markov_plot_output"),
           plotOutput("relationship_plot_output")
           #,  
           #mainPanel(
          #   textOutput('master_contents')
          # )
  )
)
)