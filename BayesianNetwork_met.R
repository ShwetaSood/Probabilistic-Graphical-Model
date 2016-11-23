#package dependency
require(bnlearn)
require(igraph)
setwd("C:/Users/Shweta sood/Desktop/MET_Dummy_BN_Demo/")
source("C:/Users/Shweta sood/Desktop/Functions.R")
################################# Bayesian Network Modelling ##################################################33
load("shweta_data.Rdata")
bayesian_data_temp = met_data_final_no_date_com_27May
#Bayesian Data
bayesian_data = as.data.frame(lapply(bayesian_data_temp, factor))
rm(bayesian_data_temp)

#train test data

# Network Building Process
train = bayesian_data
rm(bayesian_data)
# Whitelist
wl = NULL
# blacklist
bl = NULL
#nodes
node_names = names(train)

# Learn network structure
print("Learning structure")

#Score Based Structure Learning
sc = "bde"
#different ways of structural learning
t0 <-Sys.time()
#net_tabu_optimised = tabu(train, whitelist=wl, blacklist=bl, score=sc, optimized = TRUE, debug = TRUE)
net_tabu = tabu(train, whitelist=wl, blacklist=bl, score=sc, debug = TRUE)
#save(net_tabu_optimised,file=paste("net_tabu_optimised_",Sys.time(),".Rdata",sep=""))
name=str_split_fixed(toString(Sys.time()), " ", 2)[ ,1]
strme<-paste("net_tabu_",name,".Rdata",sep="")
save(net_tabu,file=strme)
#net_hc = hc(train,whitelist=wl, blacklist=bl, score=sc, debug = TRUE)
t1 <- Sys.time()
print(t1-t0)
#net_hc = hc(train, whitelist=wl, blacklist=bl, score="bic", debug = TRUE)

# #network model
model = net_tabu
#model_optimised = net_tabu_optimised 

class(net_tabu)

# #markov balnket
data_markov_b = as.data.frame(model$arcs) # graph for markov blanket 
save(data_markov_b,file=paste("data_markov_b_",str_split_fixed(toString(Sys.time()), " ", 2)[ ,1],".Rdata",sep=""))

#data_markov_b_h = as.data.frame(model_hc$arcs)

node = "par_conv" # node whose markov blanket is to be generated

plot_markov_blanket(data_markov_b[markov_blanket(data_markov_b,node)$index,],node) # plots markov blanket of the selected node
#plot_markov_blanket(data_markov_b_op[markov_blanket(data_markov_b_op,node)$index,],node) # plots markov blanket of the selected node

#Conditional Probability Table of the built network
cpt_train = bn.fit(model,train,method="bayes", iss=10)
save(cpt_train,file=paste("cpt_train_",str_split_fixed(toString(Sys.time()), " ", 2)[ ,1],".Rdata",sep=""))

write.dsc(cpt_train,file=paste("MA_Ns_2014_conv",".dsc",sep=""))
