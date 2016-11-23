library(dplyr)
library(tidyr)
library(stringr)
library(sqldf)
### MET Dummy Data ########
setwd("C:/Users/Shweta sood/Desktop/MET_Dummy_BN_Demo/")

# nrow = 4986
# ncol = 80
# No of na values = 2849
met_data_temp<-read.csv("GAF_Master_Metrics_50.csv")
#table(is.na(met_data_temp))

## removing the participants which are greater than eligible count
#met_dummy<-met_dummy[!((met_dummy$participants) > (met_dummy$ELIGIBLE_COUNT)),]

table(is.na(met_data_temp))
#table(met_dummy$Captured_Business,useNA = "ifany")
# imputing blank or na's with 0 (This is done only when the 0 value is not available 
# in the column if that so impute with any other value)

remove_columns <- c("PCIS","COMPANY_NAME","GPC","COMPANY_STREET_1","COMPANY_ZIP","COMPANY_CITY","BROKER_NAME",
                    "DATE_NEWBUS_AVAIL","BROKER_CONTACT","COMPANY_STREET_2","AE","RD","Marketer","WHOLESALER","RVP_CUVP","DIRECTOR","flag_add","flag_ae",
                    "flag_emp_usd_mod","flag_market_seg")

#date_cols <- c("ORIG_EFF","CANCEL_DATE","Orig_Eff_Year","Contract_Start_Date","Relation_Start_Timestamp","Contract_End_Date","Relation_End_Timestamp")


met_data_temp<-met_data_temp[,-which(names(met_data_temp) %in% remove_columns)]





#################################### Date columns conversion ####################################################

# "ORIG_EFF","CANCEL_DATE","Orig_Eff_Year","Contract_Start_Date","Relation_Start_Timestamp","Contract_End_Date","Relation_End_Timestamp"

##----------------------- Converting "ORIG_EFF" to 5 bins Quantile approach -------------------------------------------------

ORIG_EFF_Week <-difftime(strptime(met_data_temp$ORIG_EFF,format ="%d/%m/%Y"),strptime("01/01/1990", format = "%d/%m/%Y"), units="weeks")


  temp = as.vector(ORIG_EFF_Week)
  ORIG_EFF_Week = ifelse(temp=="",0,temp)
  temp = as.vector(ORIG_EFF_Week)
  ORIG_EFF_Week = ifelse(is.na(temp),0,temp)

min(ORIG_EFF_Week)

met_data_temp["ORIG_EFF_Week_bin"] <- cut(ORIG_EFF_Week,breaks=quantile(ORIG_EFF_Week, probs=seq(0,1, by=0.2)),include.lowest=TRUE)
table(met_data_temp$ORIG_EFF_Week_bin,useNA="ifany")
levels(met_data_temp$ORIG_EFF_Week_bin) <- seq(1:5)

met_data_temp$ORIG_EFF<-NULL
table(is.na(met_data_temp$ORIG_EFF_Week_bin))
rm(ORIG_EFF_Week)
##----------------------- Converting "CANCEL_DATE" to 5 bins Quantile approach -------------------------------------------------

CANCEL_DATE_Week <-difftime(strptime(met_data_temp$CANCEL_DATE,format ="%d/%m/%Y"),strptime("01/02/1990", format = "%d/%m/%Y"), units="weeks")

  temp = as.vector(CANCEL_DATE_Week)
  CANCEL_DATE_Week = ifelse(temp=="",0,temp)
  temp = as.vector(CANCEL_DATE_Week)
  CANCEL_DATE_Week = ifelse(is.na(temp),0,temp)

min(CANCEL_DATE_Week)

met_data_temp["CANCEL_DATE_Week_bin"] <- cut(CANCEL_DATE_Week,breaks=c(-5,0,500,900,1400),include.lowest=TRUE)
table(met_data_temp$CANCEL_DATE_Week_bin,useNA="ifany")
levels(met_data_temp$CANCEL_DATE_Week_bin) <- seq(1:4)
table(met_data_temp$CANCEL_DATE_Week_bin,useNA="ifany")

met_data_temp$CANCEL_DATE<-NULL
table(is.na(met_data_temp$CANCEL_DATE_Week_bin))
rm(CANCEL_DATE_Week)

##----------------------- Converting "Orig_Eff_Year" to 5 bins Quantile approach -------------------------------------------------

  temp = as.vector(met_data_temp$Orig_Eff_Year)
  met_data_temp$Orig_Eff_Year = ifelse(temp=="",0,temp)
  temp = as.vector(met_data_temp$Orig_Eff_Year)
  met_data_temp$Orig_Eff_Year = ifelse(is.na(temp),0,temp)

#min(met_data_temp$Orig_Eff_Year)

met_data_temp["Orig_Eff_Year_bin"] <- cut(met_data_temp$Orig_Eff_Year,breaks=quantile(met_data_temp$Orig_Eff_Year, probs=seq(0,1, by=0.2)),
                                          include.lowest=TRUE)
table(met_data_temp$Orig_Eff_Year_bin,useNA="ifany")
levels(met_data_temp$Orig_Eff_Year_bin) <- seq(1:5)
table(met_data_temp$Orig_Eff_Year_bin,useNA="ifany")

met_data_temp$Orig_Eff_Year<-NULL
table(is.na(met_data_temp$Orig_Eff_Year_bin))
##----------------------- Converting "Contract_Start_Date" to 5 bins Quantile approach -------------------------------------------------

Contract_Start_Date_Week <-difftime(strptime(met_data_temp$Contract_Start_Date,format ="%d/%m/%Y"),strptime("01/02/1990", format = "%d/%m/%Y"), 
                                    units="weeks")

  temp = as.vector(Contract_Start_Date_Week)
  Contract_Start_Date_Week = ifelse(temp=="",0,temp)
  temp = as.vector(Contract_Start_Date_Week)
  Contract_Start_Date_Week = ifelse(is.na(temp),0,temp)

met_data_temp["Contract_Start_Date_Week_bin"] <- cut(Contract_Start_Date_Week,breaks=c(-240,0,591,999,1400),include.lowest=TRUE)

table(met_data_temp$Contract_Start_Date_Week_bin,useNA="ifany")
levels(met_data_temp$Contract_Start_Date_Week_bin) <- seq(1:4)
table(met_data_temp$Contract_Start_Date_Week_bin,useNA="ifany")

met_data_temp$Contract_Start_Date<-NULL
table(is.na(met_data_temp$Contract_Start_Date_Week_bin))
rm(Contract_Start_Date_Week)

##----------------------- Converting "Relation_Start_Timestamp" to 4 bins Quantile approach -------------------------------------------------

Relation_Start_Timestamp_Week <-difftime(strptime(met_data_temp$Relation_Start_Timestamp,format ="%d/%m/%Y"),strptime("01/02/1960", format = "%d/%m/%Y"), 
                                         units="weeks")
  temp = as.vector(Relation_Start_Timestamp_Week)
  Relation_Start_Timestamp_Week = ifelse(temp=="",0,temp)
  temp = as.vector(Relation_Start_Timestamp_Week)
  Relation_Start_Timestamp_Week = ifelse(is.na(temp),0,temp)

met_data_temp["Relation_Start_Timestamp_Week_bin"] <- cut(Relation_Start_Timestamp_Week,breaks=c(-1830,0,1,2600,2900),include.lowest=TRUE)

table(met_data_temp$Relation_Start_Timestamp_Week_bin,useNA="ifany")
levels(met_data_temp$Relation_Start_Timestamp_Week_bin) <- seq(1:4)
table(met_data_temp$Relation_Start_Timestamp_Week_bin,useNA="ifany")

met_data_temp$Relation_Start_Timestamp<-NULL
table(is.na(met_data_temp$Relation_Start_Timestamp_Week_bin))
rm(Relation_Start_Timestamp_Week)

##----------------------- Converting "Contract_End_Date" to 5 bins Quantile approach -------------------------------------------------

Contract_End_Date_Week <-difftime(strptime(met_data_temp$Contract_End_Date,format ="%d/%m/%Y"),strptime("01/02/2014", format = "%d/%m/%Y"), 
                                  units="weeks")

  temp = as.vector(Contract_End_Date_Week)
  Contract_End_Date_Week = ifelse(temp=="",0,temp)
  temp = as.vector(Contract_End_Date_Week)
  Contract_End_Date_Week = ifelse(is.na(temp),0,temp)

met_data_temp["Contract_End_Date_Week_bin"] <- cut(Contract_End_Date_Week,breaks=quantile(unique(Contract_End_Date_Week)),include.lowest=TRUE)

table(met_data_temp$Contract_End_Date_Week_bin,useNA="ifany")
levels(met_data_temp$Contract_End_Date_Week_bin) <- seq(1:4)
table(met_data_temp$Contract_End_Date_Week_bin,useNA="ifany")

met_data_temp$Contract_End_Date<-NULL
table(is.na(met_data_temp$Contract_End_Date_Week_bin))
rm(Contract_End_Date_Week)

##############################################################################################################################33

impute_miss_zero <- c("PROGRAM_TYPE","Operational_Size","Tenure_Years","MARKET_SEGMENT","AE_REGION","REPORT_ACCOUNT_AS","ELIGIBLE_COUNT","participants",
                      "participant_band","Market_Size","ACCOUNT_STATUS","OPEN_TO_NEW_BIZ_","PD_AVAIL_","ELIGIBILITY_FILE_","EXISTING_NEW_FLAG",
                      "Employer_USD","Comm_status_change_ind","MA_2013","MA_2014","MA_2015",
                      "NS_Mail_status_ind_2013","NS_Mail_status_ind_2014","NS_Mail_status_ind_2015","ES_Mail_status_ind_2013","ES_Mail_status_ind_2014",
                      "ES_Mail_status_ind_2015","Mail_status_ind_2013","Mail_status_ind_2014","Mail_status_ind_2015","Email_status_ind_2013",
                      "Email_status_ind_2014","Email_status_ind_2015","Onsite_Event_ind_2013","Onsite_Event_ind_2014","Onsite_Event_ind_2015",
                      "Microsite_Activity_ind_2013","Microsite_Activity_ind_2014","Microsite_Activity_ind_2015","ES_Supp_Mail_ind_2013",
                      "ES_Supp_Mail_ind_2014","ES_Supp_Mail_ind_2015","ES_Reg_Mail_ind_2013","ES_Reg_Mail_ind_2014","ES_Reg_Mail_ind_2015",
                      "Comm_status_2013","Comm_status_2014","Comm_status_2015","Win_Indicator","part_perc",
                      "Zone","COMPANY_STATE","Relation_End_Timestamp","INDUSTRY_TYPES","Region")

for(var in impute_miss_zero){
  #print(var)
  temp = as.vector(met_data_temp[,var])
  met_data_temp[,var] = as.factor(ifelse(temp=="",0,temp))
  temp = as.vector(met_data_temp[,var])
  met_data_temp[,var] = as.factor(ifelse(is.na(temp),0,temp))
}

### Finally check that if null values have been removed from the data or not
table(is.na(met_data_temp))

# covert part_perc column to bin
met_data_temp["part_perc_bin"] <- as.numeric(as.vector(met_data_temp$part_perc))

met_data_temp["part_perc_bin"] <- with(met_data_temp, cut(met_data_temp$part_perc_bin,
                                                                    breaks=quantile(met_data_temp$part_perc_bin, probs=seq(0,1, by=1/3),na.rm=TRUE),
                                                                    include.lowest=TRUE))
table(met_data_temp$part_perc_bin,useNA="ifany")
levels(met_data_temp$part_perc_bin) <- seq(1:3)
table(met_data_temp$part_perc_bin,useNA="ifany")

met_data_temp$part_perc<-NULL


industry_types<-str_split_fixed(met_data_temp$INDUSTRY_TYPES, "_", 2)
met_data_temp[,"INDUSTRY_TYPES_bin"]<-industry_types[,1]
met_data_temp$INDUSTRY_TYPES<-NULL
rm(industry_types)
#no.of.uniques<-sapply(met_data_temp,function(x){length(unique(x))})
#View(no.of.uniques)

#######################################################################

met_data_temp_filter<-sqldf("select * from met_data_temp where ELIGIBLE_COUNT > 100")

eligible_count<-as.numeric(as.vector(met_data_temp_filter$ELIGIBLE_COUNT))
participants<-as.numeric(as.vector(met_data_temp_filter$participants))
met_data_temp_filter["perc_participants"]<-ifelse(eligible_count !=0,participants/eligible_count,0)

###################### Binning participants/eligible_count

met_data_temp_filter["par_conv"] <- met_data_temp_filter["perc_participants"] 

floor_perc<-mean(met_data_temp_filter$perc_participants)-2*sd(met_data_temp_filter$perc_participants)
floor_perc
min_perc<-min(met_data_temp_filter$perc_participants)
min_perc
mean_perc<-mean(met_data_temp_filter$perc_participants)
mean_perc
capp_perc<-mean(met_data_temp_filter$perc_participants)+2*sd(met_data_temp_filter$perc_participants)
capp_perc
max_perc<-max(met_data_temp_filter$perc_participants)
max_perc

met_data_temp_filter["par_conv"] <- with(met_data_temp_filter, cut(met_data_temp_filter$perc_participants,
                                                     breaks=c(floor_perc,min_perc,mean_perc,capp_perc,max_perc),
                                                     labels=c("low","medium","high","extra_high"),
                                                     include.lowest=TRUE))
table(met_data_temp_filter$par_conv,useNA="ifany")
#levels(met_data_temp_filter$par_conv) <- seq(1:5)  
table(is.na(met_data_temp_filter))
no.of.uniques<-sapply(met_data_temp_filter,function(x){length(unique(x))})
View(no.of.uniques)

##############################

remove_columns_eligibles <- c("ELIGIBLE_COUNT","participants","perc_participants")

met_data_final<-met_data_temp_filter[,-which(names(met_data_temp_filter) %in% remove_columns_eligibles)]
table(is.na(met_data_final))
no.of.uniques<-sapply(met_data_final,function(x){length(unique(x))})
View(no.of.uniques)


############################## Remove Binned Date Variables, Comm_status, win_indicator #################

remove_extra_cols<-c("ORIG_EFF_Week_bin","CANCEL_DATE_Week_bin","Orig_Eff_Year_bin","Contract_Start_Date_Week_bin","Relation_Start_Timestamp_Week_bin",
                     "Contract_End_Date_Week_bin","Comm_status_2013","Comm_status_2014","Comm_status_2015","Win_Indicator")

met_data_final_no_date_com_27May<-met_data_final[,-which(names(met_data_final) %in% remove_extra_cols)]
table(is.na(met_data_final_no_date_com_27May))
no.of.uniques<-sapply(met_data_final_no_date_com_27May,function(x){length(unique(x))})
View(no.of.uniques)

save(met_data_final_no_date_com_27May,file="shweta_data.Rdata")
dummy_met<-met_data_final[,c(19,22,59)]
