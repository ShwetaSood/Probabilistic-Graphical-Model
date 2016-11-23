### Classification tree with rpart
library(rpart)
setwd("~")
metdata<-read.csv("Documents//CART//Demo Results BN//Shwetadata.csv")
summary(metdata)
table(is.na(metdata))
learning<-metdata
summary(learning)

View(learning)
fit <- rpart(Part_Bucket ~ COMPANY_STATE + AE_REGION + PROGRAM_TYPE + ACCOUNT_STATUS + OPEN_TO_NEW_BIZ_ + PD_AVAIL_ + MARKET_SEGMENT + 
               ELIGIBILITY_FILE_ + Zone + Region + Market_Size + Operational_Size + Employer_USD + Tenure_Years + MA_2013 + MA_2014 + MA_2015 + 
               NS_Mail_status_ind_2013 + NS_Mail_status_ind_2014 + NS_Mail_status_ind_2015 + 
               ES_Mail_status_ind_2013 + ES_Mail_status_ind_2014 + ES_Mail_status_ind_2015 + 
               Mail_status_ind_2013 + Mail_status_ind_2014 + Mail_status_ind_2015 + 
               Email_status_ind_2013 + Email_status_ind_2014 + Email_status_ind_2015 + 
               Onsite_Event_ind_2013 + Onsite_Event_ind_2014 + Onsite_Event_ind_2015 + 
               Microsite_Activity_ind_2013 + Microsite_Activity_ind_2014 + Microsite_Activity_ind_2015 +
               ES_Supp_Mail_ind_2013 + ES_Supp_Mail_ind_2014 + ES_Supp_Mail_ind_2015 + 
               ES_Reg_Mail_ind_2013 + ES_Reg_Mail_ind_2014 + ES_Reg_Mail_ind_2015 + 
               Comm_status_2013 + Comm_status_2014 + Comm_status_2015 + 
               Comm_status_change_ind + INDUSTRY_TYPES_bin, method="class",data=learning)
fit
printcp(fit) # Display the results
plotcp(fit) # visualize cross-validation results
summary(fit) # Detailed summary of splits


# Plot tree
plot(fit,uniform=TRUE,main="Classification tree sample")
text(fit,use.n=TRUE,all=TRUE,cex=.8)

# Create alternative postscript plot of tree
post(fit,file="c:/tree.ps",title="Classification tree sample")

# prune the tree
pfit<-prune(fit, cp=fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"])

# plot the pruned tree
plot(pfit, uniform=TRUE,
     main="Pruned Classification Tree sample")
text(pfit, use.n=TRUE, all=TRUE, cex=.8)
post(pfit, file = "c:/ptree.ps",
     title = "Pruned Classification Tree sample")


### Regression tree

# grow tree
fitReg <- rpart(Part_Bucket ~ COMPANY_STATE + AE_REGION + PROGRAM_TYPE + ACCOUNT_STATUS + OPEN_TO_NEW_BIZ_ + PD_AVAIL_ + MARKET_SEGMENT + 
                  ELIGIBILITY_FILE_ + Zone + Region + Market_Size + Operational_Size + Employer_USD + Tenure_Years + MA_2013 + MA_2014 + MA_2015 + 
                  NS_Mail_status_ind_2013 + NS_Mail_status_ind_2014 + NS_Mail_status_ind_2015 + 
                  ES_Mail_status_ind_2013 + ES_Mail_status_ind_2014 + ES_Mail_status_ind_2015 + 
                  Mail_status_ind_2013 + Mail_status_ind_2014 + Mail_status_ind_2015 + 
                  Email_status_ind_2013 + Email_status_ind_2014 + Email_status_ind_2015 + 
                  Onsite_Event_ind_2013 + Onsite_Event_ind_2014 + Onsite_Event_ind_2015 + 
                  Microsite_Activity_ind_2013 + Microsite_Activity_ind_2014 + Microsite_Activity_ind_2015 +
                  ES_Supp_Mail_ind_2013 + ES_Supp_Mail_ind_2014 + ES_Supp_Mail_ind_2015 + 
                  ES_Reg_Mail_ind_2013 + ES_Reg_Mail_ind_2014 + ES_Reg_Mail_ind_2015 + 
                  Comm_status_2013 + Comm_status_2014 + Comm_status_2015 + 
                  Comm_status_change_ind + INDUSTRY_TYPES_bin,
                  method="anova", data=learning)

printcp(fitReg) # display the results
plotcp(fitReg) # visualize cross-validation results
summary(fitReg) # detailed summary of splits

# create additional plots
par(mfrow=c(1,2)) # two plots on one page
rsq.rpart(fitReg) # visualize cross-validation results  

# plot tree
plot(fitReg, uniform=TRUE,
     main="Regression Tree sample")
text(fitReg, use.n=TRUE, all=TRUE, cex=.8)

# create attractive postcript plot of tree
post(fitReg, file = "c:/tree2.ps",
     title = "Regression Tree sample")



# prune the tree
pfitReg<- prune(fitReg, cp=0.01160389) # from cptable   

# plot the pruned tree
plot(pfitReg, uniform=TRUE,
     main="Pruned Regression Tree sample")
text(pfitReg, use.n=TRUE, all=TRUE, cex=.8)
post(pfitReg, file = "c:/ptree2.ps",
     title = "Pruned Regression Tree")
