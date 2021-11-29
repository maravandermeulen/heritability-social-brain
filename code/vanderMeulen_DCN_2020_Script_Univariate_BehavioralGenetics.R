## Script for univariate behavioral genetics analyses in 
## "Genetic and environmental influences on structure of the social brain in childhood"
## Published in Developmental Cognitive Neuroscience (2020)

## Original script by Jizzo Bosdriesz 
## adapted by Mara van der Meulen - 2020 

#Load path to files for genetic modelling
setwd("J:/Workgroups/FSW/Zwaartekracht/Papers/Mara van der Meulen/2020_vanderMeulen_DCN/0. PublicationPackage/5. Processed data files")

## Load OpenMX
#install.packages("OpenMx")
library(OpenMx)

##Use SLSQP instead of CSOLNP
mxOption(NULL,"Default optimizer","SLSQP")

### LOADING DATA ###
# Please note: In order to take into account effects of age, sex, and IQ on behavior and structuralmeasures of the social brain, 
# we performed regression analyses on all outcome measures, with age, sex, and IQ as predictor variables.
# We then used the unstandardized residuals as variables in our subsequent analyses.


# For univariate analyses on heritability of behavior, use file "vanderMeulen_DCN_2020_Data_BehGen_Behavior.csv"
## variable for analyses on prosocial behavior
### Parent_Prosocial_WINS_RES
## variable for analyses on empathy
### Parent_Empathy_RES

# For univariate analyses on heritability of bilateral brain structure, use file "vanderMeulen_DCN_2020_Data_BehGen_Univariate_Brain.csv"
## variables for surface area
### mPFC_SA_WINS_RES 
### TPJ_SA_RES
### pSTS_SA_RES 
### Precuneus_SA_RES 
### Cuneus_SA_RES
### Lingual_SA_RES

## variables for cortical thickness
### mPFC_CT_RES 
### TPJ_CT_WINS_RES 
### pSTS_CT_RES 
### Precuneus_CT_RES
### Cuneus_CT_RES 
### Lingual_CT_WINS_RES 

#Note: variables for analyses on separate left and right hemisphere brain regions are also included in this file. Results were reported
# in the supplementary files.

## Open csv-file in R-studio, turn into data frame
dataTwinR<- read.csv2("vanderMeulen_DCN_2020_Data_BehGen_Behavior.csv", header=T, sep=",", dec=".")
dataTwinR<-data.frame(dataTwinR)

## Check headers
head(dataTwinR)


### SELECT RELEVANT DATA ###

## Select relevant variables (zygosity, child1Variable (with suffix "_C1") and child2Variable (with suffix "_C2")).
# Change these variables for every analysis.
dataTwinR.short<-dataTwinR[,c("Zygosity", "Parent_Prosocial_WINS_RES_C1", "Parent_Prosocial_WINS_RES_C2")]

## Create a new, short datafile with only the three selected variables for each family (=row in the datafile).
colnames(dataTwinR.short)<- c("zygosity", "CHILD1", "CHILD2")
selVars = c("CHILD1", "CHILD2")
aceVars = c("A1", "C1", "E1", "A2", "C2", "E2")

## Splits file in mono en dizygotic twins
## If zygosity is 1, select column 2:3 (so child1Var en child2Var) and add to MZ file
## If zygosity is 2, select column 2:3 (so child1Var en child2Var) and add to DZ file
mzTwinData<- dataTwinR.short [dataTwinR.short$zygosity==1, 2:3]
dzTwinData<- dataTwinR.short [dataTwinR.short$zygosity==2, 2:3]
colMeans(mzTwinData)
cov(mzTwinData, use="complete")
colMeans(dzTwinData)
cov(dzTwinData)


### RUNNING MODELS ###

#ACE model##################################################################
myModel<-mxModel()
mxModelRun<-mxRun(myModel)
latVariances<-mxPath(from=aceVars, arrows=2, free=FALSE, values=1)
latMeans<-mxPath(from="one", to=aceVars, arrows=1, free=FALSE, values=0)
obsMeans<-mxPath(from="one", to=selVars, arrows=1, free=TRUE, values=20, labels="mean")
#alles is nu free, dus alle paden worden geschat (T=true, F=False)
pathAceT1 <- mxPath(from=c("A1","C1","E1"), to="CHILD1", arrows=1,free=TRUE, values=.5,
                    label=c("a","c","e"))
pathAceT2 <- mxPath(from=c("A2","C2","E2"), to="CHILD2", arrows=1,free=TRUE, values=.5,
                    label=c("a","c","e"))
covC1C2 <- mxPath( from="C1", to="C2", arrows=2,free=FALSE, values=1)
covA1A2_MZ <- mxPath(from="A1", to="A2", arrows=2, free=FALSE, values=1)
covA1A2_DZ <- mxPath(from="A1", to="A2", arrows=2, free=FALSE, values=.5 )
dataMZ <- mxData(observed=mzTwinData, type="raw")
dataDZ <- mxData(observed=dzTwinData, type="raw")
paths <- list(latVariances, latMeans, obsMeans, pathAceT1, pathAceT2, covC1C2)
modelMZ <- mxModel(model="MZ", type="RAM", manifestVars=selVars,latentVars=aceVars, paths,
                   covA1A2_MZ, dataMZ)
modelDZ <- mxModel(model="DZ", type="RAM", manifestVars=selVars,latentVars=aceVars, paths,
                   covA1A2_DZ, dataDZ)
minus2ll <- mxAlgebra( expression=MZ.fitfunction + DZ.fitfunction,name="minus2loglikelihood")
obj <- mxFitFunctionAlgebra( "minus2loglikelihood")
aceMat <- mxMatrix(type="Full",nrow=3,ncol=1,free=T,values=.5,labels=c("a","c","e"),name="ace")
StdVarCompAlg <- mxAlgebra( (ace%^%2) %x% solve(t(ace)%*%ace), name="StdVarComp",
                            dimnames=list(c("a2","c2","e2"),NULL))
#mxCI("StdVarComp")
modelACE <- mxModel(model="ACE", modelMZ, modelDZ, minus2ll, obj, aceMat, StdVarCompAlg,
                    mxCI("StdVarComp"))
fitACE <- mxRun(modelACE, intervals = TRUE)
#printACE <- print(fitACE)
sumACE <- summary(fitACE)

# Fit ACE model
A <- mxEval(a*a, fitACE)
C <- mxEval(c*c, fitACE)
E <- mxEval(e*e, fitACE)
V <- (A+C+E)
a2 <- A/V
c2 <- C/V
e2 <- E/V
estACE <- rbind(cbind(A,C,E),cbind(a2,c2,e2))
LL_ACE <- mxEval(fitfunction, fitACE)
LL_ACE <- mxEval(fitfunction, fitACE)
estACE

#AE model##################################################################
myModel<-mxModel()
mxModelRun<-mxRun(myModel)
latVariances <- mxPath( from=aceVars, arrows=2, free=FALSE, values=1)
latMeans <- mxPath( from="one", to=aceVars, arrows=1,free=FALSE, values=0)
obsMeans <- mxPath( from="one", to=selVars, arrows=1,free=TRUE, values=20, labels="mean" )
#free is nu restricted voor C (T=true, F=False)
pathAceT1 <- mxPath( from=c("A1","C1","E1"), to="CHILD1", arrows=1,free=c(T,F,T),
                     values=c(.6,0,.6), label=c("a","c","e"))
pathAceT2 <- mxPath( from=c("A2","C2","E2"), to="CHILD2", arrows=1,free=c(T,F,T),
                     values=c(.6,0,.6), label=c("a","c","e"))
covC1C2 <- mxPath( from="C1", to="C2", arrows=2,free=FALSE, values=1)
covA1A2_MZ <- mxPath( from="A1", to="A2", arrows=2, free=FALSE, values=1)
covA1A2_DZ <- mxPath( from="A1", to="A2", arrows=2, free=FALSE, values=.5)
dataMZ <- mxData( observed=mzTwinData, type="raw")
dataDZ <- mxData( observed=dzTwinData, type="raw")
paths <- list( latVariances, latMeans, obsMeans, pathAceT1, pathAceT2, covC1C2)
modelMZ <- mxModel(model="MZ", type="RAM", manifestVars=selVars,latentVars=aceVars,
                   paths, covA1A2_MZ, dataMZ)
modelDZ <- mxModel(model="DZ", type="RAM", manifestVars=selVars,latentVars=aceVars, paths,
                   covA1A2_DZ, dataDZ)
twinAEModel <- mxModel(model="AE", modelMZ, modelDZ, minus2ll, obj)
aceMat <- mxMatrix(type="Full",nrow=3,ncol=1,free=T,values=.5,labels=c("a","c","e"),name="ace")
StdVarCompAlg <- mxAlgebra( (ace%^%2) %x% solve(t(ace)%*%ace), name="StdVarComp",
                            dimnames=list(c("a2","c2","e2"),NULL))
#mxCI("StdVarComp") computation of CIs for AE model still problematic
modelACE <- mxModel(model="ACE", modelMZ, modelDZ, minus2ll, obj, aceMat, StdVarCompAlg,
                    mxCI("StdVarComp"))
fitACE <- mxRun(modelACE, intervals = TRUE)

#printACE <- print(fitACE)
sumACE <- summary(fitACE)
#sumACE
# Run AE Model
twinAEFit <- mxRun(twinAEModel, intervals=TRUE)
SumAE <- summary(twinAEFit, verbose=T)
#twinAESum
# Fit AE model
M <- mxEval(mean, twinAEFit)
A <- mxEval(a*a, twinAEFit)
C <- mxEval(c*c, twinAEFit)
E <- mxEval(e*e, twinAEFit)
V <- (A+C+E)
a2 <- A/V
c2 <- C/V
e2 <- E/V
estAE <- rbind(cbind(A, C, E),cbind(a2, c2, e2))
LL_AE <- mxEval(fitfunction, twinAEFit)

#CE model########################################################################
myModel<-mxModel()
mxModelRun<-mxRun(myModel)
latVariances <- mxPath( from=aceVars, arrows=2, free=FALSE, values=1)
latMeans <- mxPath( from="one", to=aceVars, arrows=1,free=FALSE, values=0)
obsMeans <- mxPath( from="one", to=selVars, arrows=1,free=TRUE, values=20, labels="mean" )
#free is nu restricted voor A (T=true, F=False)
pathAceT1 <- mxPath( from=c("A1","C1","E1"), to="CHILD1", arrows=1,free=c(F,T,T),
                     values=c(0,.6,.6), label=c("a","c","e"))
pathAceT2 <- mxPath( from=c("A2","C2","E2"), to="CHILD2", arrows=1,free=c(F,T,T),
                     values=c(0,.6,.6), label=c("a","c","e"))
covC1C2 <- mxPath( from="C1", to="C2", arrows=2,free=FALSE, values=1)
covA1A2_MZ <- mxPath( from="A1", to="A2", arrows=2, free=FALSE, values=1)
covA1A2_DZ <- mxPath( from="A1", to="A2", arrows=2, free=FALSE, values=.5)
dataMZ <- mxData( observed=mzTwinData, type="raw")
dataDZ <- mxData( observed=dzTwinData, type="raw")
paths <- list( latVariances, latMeans, obsMeans, pathAceT1, pathAceT2, covC1C2)
modelMZ <- mxModel(model="MZ", type="RAM", manifestVars=selVars,latentVars=aceVars,
                   paths, covA1A2_MZ, dataMZ)
modelDZ <- mxModel(model="DZ", type="RAM", manifestVars=selVars,latentVars=aceVars, paths,
                   covA1A2_DZ, dataDZ)
twinCEModel <- mxModel(model="CE", modelMZ, modelDZ, minus2ll, obj)
aceMat <- mxMatrix(type="Full",nrow=3,ncol=1,free=T,values=.5,labels=c("a","c","e"),name="ace")
StdVarCompAlg <- mxAlgebra( (ace%^%2) %x% solve(t(ace)%*%ace), name="StdVarComp",
                            dimnames=list(c("a2","c2","e2"),NULL))
#mxCI("StdVarComp") computation of CIs for CE model still problematic
modelACE <- mxModel(model="ACE", modelMZ, modelDZ, minus2ll, obj, aceMat, StdVarCompAlg,
                    mxCI("StdVarComp"))
fitACE <- mxRun(modelACE, intervals = TRUE)

#printACE <- print(fitACE)
sumACE <- summary(fitACE)
#sumACE
# Run CE Model
twinCEFit <- mxRun(twinCEModel, intervals=TRUE)
SumCE <- summary(twinCEFit, verbose=T)
#twinCESum
# Fit CE model
M <- mxEval(mean, twinCEFit)
A <- mxEval(a*a, twinCEFit)
C <- mxEval(c*c, twinCEFit)
E <- mxEval(e*e, twinCEFit)
V <- (A+C+E)
a2 <- A/V
c2 <- C/V
e2 <- E/V
estCE <- rbind(cbind(A, C, E),cbind(a2, c2, e2))
LL_CE <- mxEval(fitfunction, twinCEFit)

#E model#########################################################################
myModel<-mxModel()
mxModelRun<-mxRun(myModel)
latVariances <- mxPath( from=aceVars, arrows=2, free=FALSE, values=1)
latMeans <- mxPath( from="one", to=aceVars, arrows=1,free=FALSE, values=0)
obsMeans <- mxPath( from="one", to=selVars, arrows=1,free=TRUE, values=20, labels="mean" )
#free is nu restricted voor A en C (T=true, F=False)
pathAceT1 <- mxPath( from=c("A1","C1","E1"), to="CHILD1", arrows=1,free=c(F,F,T),
                     values=c(0,0,.6), label=c("a","c","e"))
pathAceT2 <- mxPath( from=c("A2","C2","E2"), to="CHILD2", arrows=1,free=c(F,F,T),
                     values=c(0,0,.6), label=c("a","c","e"))
covC1C2 <- mxPath( from="C1", to="C2", arrows=2,free=FALSE, values=1)
covA1A2_MZ <- mxPath( from="A1", to="A2", arrows=2, free=FALSE, values=1)
covA1A2_DZ <- mxPath( from="A1", to="A2", arrows=2, free=FALSE, values=.5)
dataMZ <- mxData( observed=mzTwinData, type="raw")
dataDZ <- mxData( observed=dzTwinData, type="raw")
paths <- list( latVariances, latMeans, obsMeans, pathAceT1, pathAceT2, covC1C2)
modelMZ <- mxModel(model="MZ", type="RAM", manifestVars=selVars,latentVars=aceVars,
                   paths, covA1A2_MZ, dataMZ)
modelDZ <- mxModel(model="DZ", type="RAM", manifestVars=selVars,latentVars=aceVars, paths,
                   covA1A2_DZ, dataDZ)
twinEModel <- mxModel(model="E", modelMZ, modelDZ, minus2ll, obj)
aceMat <- mxMatrix(type="Full",nrow=3,ncol=1,free=T,values=.5,labels=c("a","c","e"),name="ace")
StdVarCompAlg <- mxAlgebra( (ace%^%2) %x% solve(t(ace)%*%ace), name="StdVarComp",
                            dimnames=list(c("a2","c2","e2"),NULL))
#mxCI("StdVarComp") computation of CIs for CE model still problematic
modelACE <- mxModel(model="ACE", modelMZ, modelDZ, minus2ll, obj, aceMat, StdVarCompAlg,
                    mxCI("StdVarComp"))
fitACE <- mxRun(modelACE, intervals = TRUE)

#printACE <- print(fitACE)
sumACE <- summary(fitACE)
#sumACE
# Run E Model
twinEFit <- mxRun(twinEModel, intervals=TRUE)
SumE <- summary(twinEFit, verbose=T)
#twinESum
# Fit E model
M <- mxEval(mean, twinEFit)
A <- mxEval(a*a, twinEFit)
C <- mxEval(c*c, twinEFit)
E <- mxEval(e*e, twinEFit)
V <- (A+C+E)
a2 <- A/V
c2 <- C/V
e2 <- E/V
estE <- rbind(cbind(A, C, E),cbind(a2, c2, e2))
LL_E <- mxEval(fitfunction, twinEFit)


### COMPARE MODELS ###

## Loglikehood ratio tests
#################################################################################
# ACE vs. AE
LRT_ACE_AE <- LL_AE - LL_ACE
#################################################################################
# ACE vs. CE
LRT_ACE_CE <- LL_CE - LL_ACE
#################################################################################
# AE vs. E
LRT_AE_E <- LL_E - LL_AE
#################################################################################
# CE vs. E
LRT_CE_E <- LL_E - LL_CE
#################################################################################
#Document output:
sumACE
estAE
estCE
estE
LRT_ACE_AE
LRT_ACE_CE
LRT_AE_E
LRT_CE_E
SumAE
SumCE
SumE
