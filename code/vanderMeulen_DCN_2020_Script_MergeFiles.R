# -------------------------------------------------------
# SCRIPT TO MERGE DATAFILES      
# -------------------------------------------------------


# -------------------------------------------------------
# SET INPUTFOLDER       
# -------------------------------------------------------
setwd("J:/Workgroups/FSW/Zwaartekracht/Papers/Mara van der Meulen/2020_vanderMeulen_DCN/0. PublicationPackage/3. Raw data")

# -------------------------------------------------------
# READ IN  DATA                  
# -------------------------------------------------------

# Start with basic file: demographics & prosocial behavior outcomes
demodata = data.frame(read.table("vanderMeulen_DCN_2020_DATA_Demographics.csv",sep=",",header=TRUE))
head(demodata)
names(demodata)[1]<-"SU_ID"

# Open file with Freesurfer output
braindata = data.frame(read.table("vanderMeulen_DCN_2020_Data_sMRI_processed.csv",sep=",",header=TRUE))
head(braindata)

# Open file with parent reported prosocial behavior
behdata = data.frame(read.table("vanderMeulen_DCN_2020_DATA_Questionnaires_PROCESSED.csv",sep=",",header=TRUE))
head(behdata)
names(behdata)[1]<-"SU_ID"


# Merge datafiles - demographics and Freesurfer output
demobraindata <- merge(demodata, braindata, by="SU_ID", all = TRUE)

# Also merge parent report data
demobrainbehdata <- merge(demobraindata, behdata, by="SU_ID", all = TRUE)

head(demobrainbehdata)

write.csv(demobrainbehdata, file = "vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior_PROCESSED_complete.csv")

# -------------------------------------------------------
# SELECT RELEVANT  DATA                
# -------------------------------------------------------

#See column names
colnames(demobrainbehdata)

# Select variables of interest (demographics, surface area + thickness of ROIs, parent reported behavior)
data_VarOfInterest <- demobrainbehdata[c(1:13,16,18,26,28,36,38,46,48,56,58,66,68,98,135,172,209,81,115,152,189,86,123,160,197,425,426)]
colnames(data_VarOfInterest)
write.csv(data_VarOfInterest, file = "vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior.csv")

