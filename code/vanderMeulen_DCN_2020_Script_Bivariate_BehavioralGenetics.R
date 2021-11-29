## Script for bivariate behavioral genetics analyses in 
## "Genetic and environmental influences on structure of the social brain in childhood"
## Published in Developmental Cognitive Neuroscience (2020)

## Original script by Jizzo Bosdriesz 
## adapted by Mara van der Meulen - 2020 

#Load path to files for genetic modelling
setwd("J:/ResearchData/FSW/Brain and Development/Labmembers/Mara/Papers/4_C3.1_Prosocial_sMRI/DATA/Behavioral Genetics/Revision 1 DCN/Bivariate")

# Install required packages
install.packages("psych")
install.packages("foreign")

# Load Libraries & Options
library(OpenMx)
library(psych)
library(foreign)
source("miFunctions2.R")
#make sure the source file is also in your working directory, as this contains several necessary helper functions.

#1# Load datafile#
Data<- read.csv2("191106_Meulen_Behavior_Brain_BehGen.csv", header=T, sep=",", dec=".")
head(Data)
describe(Data)

# Create a subset of the datafile "Data", by selecting only relevant variables.
# Change variables names into shorter versions with the command colnames.
sData<-Data[c("Zygosity", "Precuneus_CT_RES_C1", "Precuneus_CT_RES_C2",
              "Parent_Empathy_RES_C1", "Parent_Empathy_RES_C2")]
colnames(sData)<- c("Zygosity", "PrecCT1", "PrecCT2", "Emp1", "Emp2")
describe(sData, skew=T)

# Reschale variables if necessary - analyses run best with sd/variance around 1
#sData$PrecCT1 <- sData$PrecCT1*2
#sData$PrecCT2 <- sData$VAR1K2*2
#sData$Emp1 <- sData$Emp1/100
#sData$Emp2 <- sData$Emp2/100
#describe(sData, skew=T)

# Select Variables for Analysis
# Indicate here which two variables should be included in your model
# In line 44, only give variable name without child number
# In line 49, give full variable name as specified in line 31
vars      <- c('PrecCT','Emp') 
nv        <- length(vars)       # number of variables
ntv       <- 2*nv    # number of total variables
selVars   <- paste(vars,c(rep(1,nv),rep(2,nv)),sep="")
selvars      <- c('PrecCT1','PrecCT2','Emp1','Emp2')

head(sData)


# Create separate data files for MZ and DZ twins
mzData    <- subset(sData, Zygosity==1, selVars)
dzData    <- subset(sData, Zygosity==2, selVars)
describe(mzData)
describe(dzData)

# Generate Descriptive Statistics
round(colMeans(mzData,na.rm=TRUE),4)
round(colMeans(dzData,na.rm=TRUE),4)
round(cov(mzData,use="complete"),4)
round(cov(dzData,use="complete"),4)

##Save dataset as Rdata in your working directory
save.image("twindata.RData")

###############################################


#2# ------------------------------------------------------------------------------
#Saturated model

# First test the standard assumptions of the twin model
# What is the likelihood of the data without further modelling?

# Set Starting Values 
# To increase the model fit you can adapt starting values here
# Use the mean of the variables in your model, in the order as specified above (so first mean of precuneus CT, than mean empathy score)
# Run the code until #3#
svMe      <- c(0,-0.04)               # start value for means
svVa      <- 1                     # start value for variances
svVas     <- diag(svVa,ntv,ntv)    # assign start values to diagonal of matrix
lbVa      <- .0001                 # start value for lower bounds
lbVas     <- diag(lbVa,ntv,ntv)    # assign lower bounds values to diagonal of matrix
lbVas[lower.tri(lbVas)] <- -10     # lower bounds for below diagonal elements
lbVas[upper.tri(lbVas)] <- NA      # lower bounds for above diagonal elements

# Create Labels
labMeMZ   <- paste("meanMZ",selVars,sep="_")
labMeDZ   <- paste("meanDZ",selVars,sep="_")
labMeZ    <- paste("meanZ",selVars,sep="_")
labCvMZ   <- labLower("covMZ",ntv)
labCvDZ   <- labLower("covDZ",ntv)
labCvZ    <- labLower("covZ",ntv)
labVaMZ   <- labDiag("covMZ",ntv)
labVaDZ   <- labDiag("covDZ",ntv)
labVaZ    <- labDiag("covZ",ntv)

# PREPARE MODEL
# Saturated Model
# Create Algebra for expected Mean Matrices
meanMZ    <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=labMeMZ, name="meanMZ" )
meanDZ    <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=labMeDZ, name="meanDZ" )

# Create Algebra for expected Variance/Covariance Matrices
cholMZ    <- mxMatrix( type="Lower", nrow=ntv, ncol=ntv, free=TRUE, values=svVas, lbound=lbVas, labels=labCvMZ, name="cholMZ" )
cholDZ    <- mxMatrix( type="Lower", nrow=ntv, ncol=ntv, free=TRUE, values=svVas, lbound=lbVas, labels=labCvDZ, name="cholDZ" )
covMZ     <- mxAlgebra( expression=cholMZ %*% t(cholMZ), name="covMZ" )
covDZ     <- mxAlgebra( expression=cholDZ %*% t(cholDZ), name="covDZ" )

# Create Data Objects for Multiple Groups
dataMZ    <- mxData( observed=mzData, type="raw" )
dataDZ    <- mxData( observed=dzData, type="raw" )

# Create Expectation Objects for Multiple Groups
expMZ     <- mxExpectationNormal( covariance="covMZ", means="meanMZ", dimnames=selVars )
expDZ     <- mxExpectationNormal( covariance="covDZ", means="meanDZ", dimnames=selVars )
funML     <- mxFitFunctionML()

# Create Model Objects for Multiple Groups
modelMZ   <- mxModel( "MZ", meanMZ, cholMZ, covMZ, dataMZ, expMZ, funML )
modelDZ   <- mxModel( "DZ", meanDZ, cholDZ, covDZ, dataDZ, expDZ, funML )
multi     <- mxFitFunctionMultigroup( c("MZ","DZ") )

# Create Confidence Interval Objects
ciCov     <- mxCI( c('MZ.covMZ','DZ.covDZ') )
ciMean    <- mxCI( c('MZ.meanMZ','DZ.meanDZ') )

# Build Saturated Model with Confidence Intervals
model     <- mxModel( "mulSATc", modelMZ, modelDZ, multi, ciCov, ciMean )

# RUN MODEL
mxOption(NULL,"Default optimizer","SLSQP")

# Run Saturated Model
fit       <- mxRun( model, intervals=F )
sum       <- summary( fit )
round(fit$output$estimate,4)
fitGofs(fit)
fitExpc2(fit)


#3# ------------------------------------------------------------------------------
# Specify the ACE model

# Set Starting Values 
# To increase the model fit you can adapt starting values here
# Use the mean of the variables in your model, in the order as specified above (so first mean of precuneus CT, than mean empathy score)
# Run the code until #4#

# NOTE error codes in your output!

### ACE Model ###
# Set Starting Values 
svMe      <- c(0,-0.04)                # start value for means
svPa      <- .4                        # start value for path coefficient for a
svPaD     <- vech(diag(svPa,nv,nv))    # start values for diagonal of covariance matrix
svPe      <- .8                        # start value for path coefficient for e
svPeD     <- vech(diag(svPe,nv,nv))    # start values for diagonal of covariance matrix
lbPa      <- .0001                     # start value for lower bounds
lbPaD     <- diag(lbPa,nv,nv)          # lower bounds for diagonal of covariance matrix
lbPaD[lower.tri(lbPaD)] <- -10         # lower bounds for below diagonal elements
lbPaD[upper.tri(lbPaD)] <- NA          # lower bounds for above diagonal elements

# Create Labels
labMe     <- paste("mean",vars,sep="_")

# PREPARE MODEL

# ACE Model
# Create Algebra for expected Mean Matrices
meanG     <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=labMe, name="meanG" )

# Create Matrices for Path Coefficients
pathA     <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPaD, label=labLower("a",nv), lbound=lbPaD, name="a" ) 
pathC     <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPaD, label=labLower("c",nv), lbound=lbPaD, name="c" )
pathE     <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPeD, label=labLower("e",nv), lbound=lbPaD, name="e" )

# Create Algebra for Variance Components
covA      <- mxAlgebra( expression=a %*% t(a), name="A" )
covC      <- mxAlgebra( expression=c %*% t(c), name="C" ) 
covE      <- mxAlgebra( expression=e %*% t(e), name="E" )

# Create Algebra for expected Variance/Covariance Matrices in MZ & DZ twins
covP      <- mxAlgebra( expression= A+C+E, name="V" )
covMZ     <- mxAlgebra( expression= A+C, name="cMZ" )
covDZ     <- mxAlgebra( expression= 0.5%x%A+ C, name="cDZ" )
expCovMZ  <- mxAlgebra( expression= rbind( cbind(V, cMZ), cbind(t(cMZ), V)), name="expCovMZ" )
expCovDZ  <- mxAlgebra( expression= rbind( cbind(V, cDZ), cbind(t(cDZ), V)), name="expCovDZ" )

# Create Algebra for Standardization
matI      <- mxMatrix( type="Iden", nrow=nv, ncol=nv, name="I")
invSD     <- mxAlgebra( expression=solve(sqrt(I*V)), name="iSD")

# Calculate genetic and environmental correlations
corA      <- mxAlgebra( expression=solve(sqrt(I*A))%&%A, name ="rA" ) #cov2cor()
corC      <- mxAlgebra( expression=solve(sqrt(I*C))%&%C, name ="rC" )
corE      <- mxAlgebra( expression=solve(sqrt(I*E))%&%E, name ="rE" )

# Create Data Objects for Multiple Groups
dataMZ    <- mxData( observed=mzData, type="raw" )
dataDZ    <- mxData( observed=dzData, type="raw" )

# Create Expectation Objects for Multiple Groups
expMZ     <- mxExpectationNormal( covariance="expCovMZ", means="meanG", dimnames=selVars )
expDZ     <- mxExpectationNormal( covariance="expCovDZ", means="meanG", dimnames=selVars )
funML     <- mxFitFunctionML()

# Create Model Objects for Multiple Groups
pars      <- list(meanG, matI, invSD,
                  pathA, pathC, pathE, covA, covC, covE, covP, corA, corC, corE)
modelMZ   <- mxModel( name="MZ", pars, covMZ, expCovMZ, dataMZ, expMZ, funML )
modelDZ   <- mxModel( name="DZ", pars, covDZ, expCovDZ, dataDZ, expDZ, funML )
multi     <- mxFitFunctionMultigroup( c("MZ","DZ") )

# Create Algebra for Variance Components
colVC     <- vars
rowVC     <- rep(c('A','C','E','SA','SC','SE'),each=nv)
estVC     <- mxAlgebra( expression=rbind(A,C,E,A/V,C/V,E/V), name="VC", dimnames=list(rowVC,colVC))

as <- mxAlgebra(iSD %*% a, name="stdPathA")
cs <- mxAlgebra(iSD %*% c, name="stdPathC")
es <- mxAlgebra(iSD %*% e, name="stdPathE")
as2 <- mxAlgebra(stdPathA%^%2, name="stdPathA2")
cs2 <- mxAlgebra(stdPathC%^%2, name="stdPathC2")
es2 <- mxAlgebra(stdPathE%^%2, name="stdPathE2")
mzcor <- mxAlgebra(cov2cor(MZ.expCovMZ), name="expCorMZ")
dzcor <- mxAlgebra(cov2cor(DZ.expCovDZ), name="expCorDZ")

# Create standardized parameters and CI's
ciACE     <- mxCI(c("stdPathA","stdPathC","stdPathE","stdPathA2","stdPathC2","stdPathE2",
                    "expCorMZ[2,1]","expCorMZ[3,1]","expCorMZ[4,1]","expCorMZ[4,2]",
                    "expCorDZ[2,1]","expCorDZ[3,1]","expCorDZ[4,1]","expCorDZ[4,2]"
))

# Build Model
modelACE  <- mxModel( "mulACEc", pars, modelMZ, modelDZ, multi, estVC, ciACE, as, cs, es, as2, cs2, es2, mzcor, dzcor)

# RUN MODEL
mxOption(NULL,"Default optimizer","SLSQP")

# Run ACE Model
fitACE    <- mxRun( modelACE, intervals=T )
sumACE    <- summary( fitACE )
print(sumACE)

# Compare with Saturated Model
mxCompare( fit, fitACE )


#4# ------------------------------------------------------------------------------
# RUN SUBMODELS

# Run AE model
modelAE   <- mxModel( fitACE, name="mulAEc" )
modelAE   <- omxSetParameters( modelAE, labels=labLower("c",nv), free=FALSE, values=0 )
fitAE     <- mxRun( modelAE, intervals=T )
sumAE    <- summary( fitAE )
print(sumAE)

# Run CE model
modelCE   <- mxModel( fitACE, name="mulCEc" )
modelCE   <- omxSetParameters( modelCE, labels=labLower("a",nv), free=FALSE, values=0 )
fitCE     <- mxRun( modelCE, intervals=T )
sumCE    <- summary( fitCE )
print(sumCE)

# Run E model
modelE    <- mxModel( fitAE, name="mulEc" )
modelE    <- omxSetParameters( modelE, labels=labLower("a",nv), free=FALSE, values=0 )
fitE      <- mxRun( modelE, intervals=T )
sumE    <- summary( fitE )
print(sumE)

# Print Comparative Fit Statistics
mxCompare( fitACE, nested <- list(fitAE, fitCE, fitE) )


#5# ---------------------------------------------------------------
# Determine the best fitting model
# Compute path coefficients

# Per model, compute the raw path coefficients, standardized path coefficients, squared standardized path coefficients,
# covariantiematrix and the correlatiematrix.
# Squared standardized coefficients and correlation matrix are usually used for reporting results.

# Generate List of Parameter Estimates and Derived Quantities using formatOutputMatrices
# ACE  Estimated Path Coefficients --> raw
matACEepaths <- c("a","c","e","iSD")
labACEepaths <- c("PathA","PathC","PathE","iSD")
formatOutputMatrices(fitACE, matACEepaths, labACEepaths, vars,4)

# ACE  Standardized Path Coefficients (pre-multiplied by inverse of standard deviations)
matACEpaths <- c("iSD %*% a","iSD %*% c","iSD %*% e")
labACEpaths <- c("stPathA","stPathC","stPathE")
formatOutputMatrices(fitACE, matACEpaths, labACEpaths, vars,4)

# ACE Squared Standardized Path Coefficients 
matACEpath2 <- c("(iSD%*% a)*(iSD%*% a)","(iSD%*% c)*(iSD%*% c)","(iSD%*% e)*(iSD%*% e)")
labACEpath2 <- c("stPathA^2","stPathC^2","stPathE^2")
formatOutputMatrices(fitACE, matACEpath2, labACEpath2, vars,4)

# ACE Covariance Matrices & Proportions of Variance Matrices
matACEcov   <- c("A","C","E","V","A/V","C/V","E/V")
labACEcov   <- c("covA","covC","covE","Var","stCovA","stCovC","stCovE")
formatOutputMatrices(fitACE, matACEcov, labACEcov, vars,4)

# ACE Correlation Matrices 
matACEcor   <- c("solve(sqrt(I*A)) %&% A","solve(sqrt(I*C)) %&% C","solve(sqrt(I*E)) %&% E")
labACEcor   <- c("corA","corC","corE")
formatOutputMatrices(fitACE, matACEcor, labACEcor, vars, 4)

### AE Model
# AE  Standardized Path Coefficients (pre-multiplied by inverse of standard deviations)
matAEpaths <- c("iSD %*% a","iSD %*% e")
labAEpaths <- c("stPathA","stPathE")
formatOutputMatrices(fitAE, matAEpaths, labAEpaths, vars,4)

# AE Squared Standardized Path Coefficients 
matAEpath2 <- c("(iSD%*% a)*(iSD%*% a)","(iSD%*% e)*(iSD%*% e)")
labAEpath2 <- c("stPathA^2","stPathE^2")
formatOutputMatrices(fitAE, matAEpath2, labAEpath2, vars,4)

# AE Correlation Matrices 
matAEcor   <- c("solve(sqrt(I*A)) %&% A","solve(sqrt(I*E)) %&% E")
labAEcor   <- c("corA","corE")
formatOutputMatrices(fitAE, matAEcor, labAEcor, vars, 4)

### CE Model
# CE  Standardized Path Coefficients (pre-multiplied by inverse of standard deviations)
matCEpaths <- c("iSD %*% c","iSD %*% e")
labCEpaths <- c("stPathC","stPathE")
formatOutputMatrices(fitCE, matCEpaths, labCEpaths, vars,4)

# CE Squared Standardized Path Coefficients 
matCEpath2 <- c("(iSD%*% c)*(iSD%*% c)","(iSD%*% e)*(iSD%*% e)")
labCEpath2 <- c("stPathC^2","stPathE^2")
formatOutputMatrices(fitCE, matCEpath2, labCEpath2, vars,4)

# CE Correlation Matrices 
matCEcor   <- c("solve(sqrt(I*C)) %&% C","solve(sqrt(I*E)) %&% E")
labCEcor   <- c("corC","corE")
formatOutputMatrices(fitCE, matCEcor, labCEcor, vars, 4)

### E Model
# E  Standardized Path Coefficients (pre-multiplied by inverse of standard deviations)
matEpaths <- c("iSD %*% c","iSD %*% e")
labEpaths <- c("stPathE","stPathE")
formatOutputMatrices(fitE, matEpaths, labEpaths, vars,4)

# E Squared Standardized Path Coefficients 
matEpath2 <- c("(iSD%*% c)*(iSD%*% c)","(iSD%*% e)*(iSD%*% e)")
labEpath2 <- c("stPathC^2","stPathE^2")
formatOutputMatrices(fitCE, matCEpath2, labCEpath2, vars,4)

# E Correlation Matrices 
matEcor   <- c("solve(sqrt(I*C)) %&% C","solve(sqrt(I*E)) %&% E")
labEcor   <- c("corC","corE")
formatOutputMatrices(fitCE, matCEcor, labCEcor, vars, 4)



# Correlations
# Simple mz and dz within-twin correlations
cov2cor(mxGetExpected(fitACE$MZ, "covariance"))
cov2cor(mxGetExpected(fitACE$DZ, "covariance"))

# 'legend' of the output
#       c1 c1  c2 c2
#       v1 v2  v1 v2
#c1 V1  x  cw wc1 cc
#c1 v2  x  x   x  wc2
#c2 v1  x  x   x  x
#c2 v2  x  x   x  x
# wc = within-trait cross-twin (voor beide variabelen)
# cw = cross-trait within twin
# cc = cross-trait cross-twin
