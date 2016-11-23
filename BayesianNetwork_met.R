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

# p = 70 # percentage of data to be kept in train
# index = sample((1:nrow(bayesian_data)),p/100*nrow(bayesian_data),replace = FALSE)
# train_bayesian_data = bayesian_data[index,]
# test_bayesian_data = bayesian_data[-index,]

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
#score = c("bde","aic","bic","k2")
sc = "bde"
#-------check# setwd("GAF_final_models_data/")
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
#class(net_tabu_optimised)
#plot(net_tabu,type="lines")

# #markov balnket
data_markov_b = as.data.frame(model$arcs) # graph for markov blanket 
save(data_markov_b,file=paste("data_markov_b_",str_split_fixed(toString(Sys.time()), " ", 2)[ ,1],".Rdata",sep=""))

# data_markov_b_op = as.data.frame(model_optimised$arcs) # graph for markov blanket 
# save(data_markov_b_op,file=paste("data_markov_b_op_",Sys.time(),".Rdata",sep=""))


#data_markov_b_h = as.data.frame(model_hc$arcs)

node = "par_conv" # node whose markov blanket is to be generated

plot_markov_blanket(data_markov_b[markov_blanket(data_markov_b,node)$index,],node) # plots markov blanket of the selected node
#plot_markov_blanket(data_markov_b_op[markov_blanket(data_markov_b_op,node)$index,],node) # plots markov blanket of the selected node

#Conditional Probability Table of the built network
cpt_train = bn.fit(model,train,method="bayes", iss=10)
save(cpt_train,file=paste("cpt_train_",str_split_fixed(toString(Sys.time()), " ", 2)[ ,1],".Rdata",sep=""))

# cpt_train_optimised = bn.fit(model_optimised,train,method="bayes", iss=10)
# save(cpt_train_optimised,file=paste("cpt_train_optimised_",Sys.time(),".Rdata",sep=""))

# #cpt_train_hc = bn.fit(model_hc,train,method="bayes", iss=10)
write.dsc(cpt_train,file=paste("MA_Ns_2014_conv",".dsc",sep=""))
#write.dsc(cpt_train_optimised,file=paste("GAF_FINAL_optimised_removing_irrelevant_similar_",Sys.time(),".dsc",sep=""))

# # 
# out_new = c()
# j = 1
# #validation_bayes_data_overall = as.data.frame(lapply(validation_bayes_data_overall, factor))
# inference_data = train
# node = "part_perc_bin"
# for(i in 1:nrow(inference_data)){
#   #pv = inference_data[i,""]
#   #evidence = as.list(pv[1,setdiff(colnames(pv), node)])
#   prob = cpquery(cpt_train, event = (part_per == c(1,2,3)), evidence = (COMPANY_STATE == "AL"), method="lw")
#   out_new = c(out_new,prob)
#   if(i > 1000*j){print(i); j = j+1}
#   print(i)
# }
# 
# predict = out
