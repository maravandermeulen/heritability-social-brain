* Encoding: UTF-8.
**Import CSV file: vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior.csv
*This file is the merged product of demographic information, brain output (Freesurfer), and parent-reported data. 

*Steps in this syntax include:
*### DATA CLEANING ###
*# Renaming variables
*# Checking outliers
*# Checking normality
*# Checking associations with co-variates
*# Saving residuals from regression analyses to account for effects of covariates

*### DATA SELECTION FOR BEHAVIORAL GENETIC ANALYSES ###
*# Transforming file format from long to wide
*# Selecting variables for specific analyses
*# Performing within-twin correlations for first estimate of heritability
*# Computing phenotypic brain-behavior associations
*# Saving files in CSV format, suitable for R-script for behavioral genetic analyses.

*Univariate and bivariate behavioral genetic analyses are performed with a separate R-script.
*Univariate: vanderMeulen_DCN_2020_Script_Univariate_BehavioralGenetics.R
*Bivariate: vanderMeulen_DCN_2020_Script_Bivariate_BehavioralGenetics.R

PRESERVE.
SET DECIMAL DOT.

GET DATA  /TYPE=TXT
  /FILE="...\vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior.csv"
  /ENCODING='UTF8'
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  V1 AUTO
  SU_ID AUTO
  FamilyID.x AUTO
  ChildID.x AUTO
  ChildNr.x AUTO
  Sample.x AUTO
  Zygosity AUTO
  Age AUTO
  Sex AUTO
  IQ AUTO
  Handedness AUTO
  AnomalousFinding AUTO
  PsychDisorders AUTO
  QCscore AUTO
  mPFC_lh_SurfaceArea AUTO
  mPFC_lh_ThicknessMean AUTO
  mPFC_rh_SurfaceArea AUTO
  mPFC_rh_ThicknessMean AUTO
  TPJ_lh_TPJ_lh_SurfaceArea AUTO
  TPJ_lh_TPJ_lh_ThicknessMean AUTO
  TPJ_rh_SurfaceArea AUTO
  TPJ_rh_ThicknessMean AUTO
  pSTS_lh_SurfaceArea AUTO
  pSTS_lh_ThicknessMean AUTO
  pSTS_rh_SurfaceArea AUTO
  pSTS_rh_ThicknessMean AUTO
  lh_precuneus_area AUTO
  rh_precuneus_area AUTO
  lh_precuneus_thickness AUTO
  rh_precuneus_thickness AUTO
  lh_cuneus_area AUTO
  rh_cuneus_area AUTO
  lh_cuneus_thickness AUTO
  rh_cuneus_thickness AUTO
  lh_lingual_area AUTO
  rh_lingual_area AUTO
  lh_lingual_thickness AUTO
  rh_lingual_thickness AUTO
  Parent_Prosocial AUTO
  Parent_Empathy AUTO
  /MAP.
RESTORE.
CACHE.
EXECUTE.
DATASET NAME DataSet3 WINDOW=FRONT.

* Change variable type to Numeric for all variables

* Remove QC score for 31117102.

DELETE VARIABLES
V1.


RENAME VARIABLES
FamilyID.x = FamilyID
ChildID.x = ChildID
ChildNr.x = ChildNr
Sample.x = Sample
mPFC_lh_SurfaceArea = mPFC_lh_SA
mPFC_rh_SurfaceArea = mPFC_rh_SA
mPFC_lh_ThicknessMean = mPFC_lh_CT
mPFC_rh_ThicknessMean = mPFC_rh_CT
TPJ_lh_TPJ_lh_SurfaceArea = TPJ_lh_SA
TPJ_rh_SurfaceArea = TPJ_rh_SA
TPJ_lh_TPJ_lh_ThicknessMean = TPJ_lh_CT
TPJ_rh_ThicknessMean = TPJ_rh_CT
pSTS_lh_SurfaceArea = pSTS_lh_SA
pSTS_rh_SurfaceArea = pSTS_rh_SA
pSTS_lh_ThicknessMean = pSTS_lh_CT
pSTS_rh_ThicknessMean = pSTS_rh_CT
lh_precuneus_area = Precuneus_lh_SA
rh_precuneus_area = Precuneus_rh_SA
lh_precuneus_thickness = Precuneus_lh_CT
rh_precuneus_thickness = Precuneus_rh_CT
lh_cuneus_area = Cuneus_lh_SA
rh_cuneus_area = Cuneus_rh_SA
lh_cuneus_thickness = Cuneus_lh_CT
rh_cuneus_thickness = Cuneus_rh_CT
lh_lingual_area = Lingual_lh_SA
rh_lingual_area = Lingual_rh_SA
lh_lingual_thickness = Lingual_lh_CT
rh_lingual_thickness = Lingual_rh_CT.

*Save the cleaned file.
SAVE OUTFILE='...\vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior.sav'.

*##################### Data check neuroimaging data ########################################################.
GET OUTFILE='...\vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior.sav'.

*First, select relevant cases (without anomalous findings).
USE ALL.
COMPUTE filter_$=(AnomalousFinding = 0  &  QCscore < 4).
VARIABLE LABELS filter_$ 'AnomalousFinding = 0  &  QCscore < 4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

*Step 1: compute correlations. 
CORRELATIONS
  /VARIABLES=mPFC_lh_SA mPFC_lh_CT mPFC_rh_SA mPFC_rh_CT TPJ_lh_SA TPJ_lh_CT TPJ_rh_SA TPJ_rh_CT 
    pSTS_lh_SA pSTS_lh_CT pSTS_rh_SA pSTS_rh_CT Precuneus_lh_SA Precuneus_rh_SA Precuneus_lh_CT 
    Precuneus_rh_CT Cuneus_lh_SA Cuneus_rh_SA Cuneus_lh_CT Cuneus_rh_CT Lingual_lh_SA Lingual_rh_SA 
    Lingual_lh_CT Lingual_rh_CT
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Correlations for pairs of brain measures range from .33-.83 (all p<.001). Correlations for non-pairs (e.g. Precuneus lh SA - mPFC lh SA) range from .33-.59 (all p<.001).


***********************************************Check descriptives and check brain measures for outliers (LEFT hemisphere).
DESCRIPTIVES VARIABLES=mPFC_lh_SA TPJ_lh_SA pSTS_lh_SA Precuneus_lh_SA Cuneus_lh_SA Lingual_lh_SA mPFC_lh_CT TPJ_lh_CT pSTS_lh_CT Precuneus_lh_CT  Cuneus_lh_CT  Lingual_lh_CT
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.

*## Below is an overview of the outliers per variable: variable name --> participant number (Z score) --> winsorized value, name of new variable.
*mPFC_SA --> 31006701 (Z = 3.47) --> adapt value to 717.50. Create new variable mPFC_lh_SA_WINS.
*TPJ_SA --> none
*pSTS_SA  --> 31080601 (Z =3.41) --> adapt value to 2327. Create new variable pSTS_lh_SA_WINS.
*Precuneus_SA  --> none
*Cuneus_SA --> none
* Lingual_SA --> none
*mPFC_CT  --> none
*TPJ_CT --> none
*pSTS_CT --> 31106902 (Z =4.34) --> adapt value to 3.66. Create new variable pSTS_lh_CT_WINS.
*Precuneus_CT --> 31007901 (Z =3.32)  --> adapt value to 3.25. Create new variable Precuneus_lh_CT_WINS.
*Cuneus_CT --> 31013502 (Z =3.55)  --> adapt value to 3.76. Create new variable Cuneus_lh_CT_WINS.
*Lingual_CT --> 31011502 (Z =3.74) and 31083801 (Z =3.40) --> adapted values to 2.77 and 2.74 respectively. Create new variable Lingual_lh_CT_WINS.


********************************************Check descriptives and check brain measures for outliers (RIGHT hemisphere).
DESCRIPTIVES VARIABLES=mPFC_rh_SA TPJ_rh_SA pSTS_rh_SA Precuneus_rh_SA Cuneus_rh_SA Lingual_rh_SA mPFC_rh_CT TPJ_rh_CT pSTS_rh_CT Precuneus_rh_CT  Cuneus_rh_CT  Lingual_rh_CT
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.

*mPFC_SA         --> 31006402 (3.65) --> adapt value to 907.50. Create new variable mPFC_rh_SA_WINS.
*TPJ_SA             --> 31022401 (3.70) --> adapt value to 2559.00. Create new variable TPJ_lh_SA_WINS.
*pSTS_SA          --> 31020002 (3.72) and 31083402 (3.38) --> adapt value to 2030 and 2002, respectively. Create new variable pSTS_rh_SA_WINS.
*Precuneus_SA  --> none
*Cuneus_SA       --> 31070202 (-4.55) --> adapt value to 1074.00. Create new variable Cuneus_rh_SA_WINS.
* Lingual_SA      --> 31070202 (-3.72)  --> adapt value to 2051.33. Create new variable Lingual_rh_SA_WINS
*mPFC_CT         --> none
*TPJ_CT             --> 31080601 (-3.73)  --> adapt value to 2.29 . Create new variable TPJ_rh_CT_WINS.
*pSTS_CT         --> none
*Precuneus_CT  --> 31065901 (-3.36)  --> adapt value to 2.48 . Create new variable Precuneus_rh_CT_WINS.
*Cuneus_CT       --> none
*Lingual_CT        --> none

*Step 2: combine measures across hemispheres (based on raw data).
***************************************Compute new variables for ROIs across hemispheres (left + right --> surface area).
COMPUTE mPFC_SA=(mPFC_lh_SA + mPFC_rh_SA)/2.
COMPUTE TPJ_SA=(TPJ_lh_SA + TPJ_rh_SA)/2.
COMPUTE pSTS_SA=(pSTS_lh_SA + pSTS_rh_SA)/2.
COMPUTE Precuneus_SA=(Precuneus_lh_SA + Precuneus_rh_SA)/2.
COMPUTE Cuneus_SA=(Cuneus_lh_SA + Cuneus_rh_SA)/2.
COMPUTE Lingual_SA=(Lingual_lh_SA + Lingual_rh_SA)/2.
EXECUTE.

*******************************************Compute new variables for ROIs across hemispheres (left + right --> cortical thickness).
COMPUTE mPFC_CT=((mPFC_lh_SA * mPFC_lh_CT) + (mPFC_rh_SA * mPFC_rh_CT)) / (mPFC_lh_SA+mPFC_rh_SA).
COMPUTE TPJ_CT=((TPJ_lh_SA * TPJ_lh_CT) + (TPJ_rh_SA * TPJ_rh_CT)) / (TPJ_lh_SA+TPJ_rh_SA).
COMPUTE pSTS_CT=((pSTS_lh_SA * pSTS_lh_CT) + (pSTS_rh_SA * pSTS_rh_CT)) / (pSTS_lh_SA+pSTS_rh_SA).
COMPUTE Precuneus_CT=((Precuneus_lh_SA * Precuneus_lh_CT) + (Precuneus_rh_SA * Precuneus_rh_CT)) / (Precuneus_lh_SA+Precuneus_rh_SA).
COMPUTE Cuneus_CT=((Cuneus_lh_SA * Cuneus_lh_CT) + (Cuneus_rh_SA * Cuneus_rh_CT)) / (Cuneus_lh_SA+Cuneus_rh_SA).
COMPUTE Lingual_CT=((Lingual_lh_SA * Lingual_lh_CT) + (Lingual_rh_SA * Lingual_lh_CT)) / (Lingual_lh_SA+Lingual_rh_SA).
EXECUTE.

*Check descriptives and check brain measures for outliers..
DESCRIPTIVES VARIABLES=mPFC_SA TPJ_SA pSTS_SA Precuneus_SA Cuneus_SA Lingual_SA mPFC_CT TPJ_CT pSTS_CT Precuneus_CT  Cuneus_CT  Lingual_CT
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.

*mPFC_SA --> 31006701 (3.39) --> adapt value to 754.13. Create new variable mPFC_SA_WINS.
*TPJ_SA --> none
*pSTS_SA  --> none
*Precuneus_SA  --> none
*Cuneus_SA --> none
* Lingual_SA --> none
*mPFC_CT  --> none
*TPJ_CT --> 31080601 (-3.63) --> adapt value to 2.42 (based on non-outliers without anon. findings and QC score < 4). Create new variable TPJ_CT_WINS.
*pSTS_CT --> none
*Precuneus_CT --> none
*Cuneus_CT --> none
*Lingual_CT --> 31011502 (3.74) and 31083801 (3.39) --> adapted values to 2.8 and 2.78 respectively. Create new variable Lingual_CT_WINS.

*Outliers have been winsorized.

*Delete Z-score variables.
DELETE VARIABLES
ZmPFC_lh_SA
ZTPJ_lh_SA
ZpSTS_lh_SA
ZPrecuneus_lh_SA
ZCuneus_lh_SA
ZLingual_lh_SA
ZmPFC_lh_CT
ZTPJ_lh_CT
ZpSTS_lh_CT
ZPrecuneus_lh_CT
ZCuneus_lh_CT
ZLingual_lh_CT
ZmPFC_rh_SA
ZTPJ_rh_SA
ZpSTS_rh_SA
ZPrecuneus_rh_SA
ZCuneus_rh_SA
ZLingual_rh_SA
ZmPFC_rh_CT
ZTPJ_rh_CT
ZpSTS_rh_CT
ZPrecuneus_rh_CT
ZCuneus_rh_CT
ZLingual_rh_CT
ZmPFC_SA
ZTPJ_SA
ZpSTS_SA
ZPrecuneus_SA
ZCuneus_SA
ZLingual_SA
ZmPFC_CT
ZTPJ_CT
ZpSTS_CT
ZPrecuneus_CT
ZCuneus_CT
ZLingual_CT.


*##################### Data check parent-report data ######################################################.
FILTER OFF.
USE ALL.
EXECUTE.
  
  DESCRIPTIVES VARIABLES=Parent_Prosocial Parent_Empathy
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.

* Parent prosocial has been winsorized.

*31006401 -->  (-4.50)  --> adapt value to 2.22.
*31024202 -->  (-3.78) --> adapt value to 2.30.
*31007602 -->  (-3.78) --> adapt value to 2.38.
*31113502 -->  (-3.57) --> adapt value to 2.46.
*31020401 --> (-3.37) --> adapt value to 2.54.
*31074301 --> (-3.37) --> adapt value to 2.61.

*Created new variable Parent_Prosocial_WINS
*Delete Z-score variables.
DELETE VARIABLES
ZParent_Prosocial
ZParent_Empathy.

*##################### Normality check ######################################################.
*First, select relevant cases (without anomalous findings).
USE ALL.
COMPUTE filter_$=(AnomalousFinding = 0  &  QCscore < 4).
VARIABLE LABELS filter_$ 'AnomalousFinding = 0  &  QCscore < 4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


*Examine normality in brain data (BILATERAL).
EXAMINE VARIABLES=mPFC_SA_WINS TPJ_SA pSTS_SA Precuneus_SA Cuneus_SA 
    Lingual_SA mPFC_CT TPJ_CT_WINS pSTS_CT Precuneus_CT Cuneus_CT Lingual_CT_WINS
  /PLOT BOXPLOT STEMLEAF NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

*Examine normality in brain data (LEFT).
EXAMINE VARIABLES=mPFC_lh_SA_WINS TPJ_lh_SA pSTS_lh_SA_WINS Precuneus_lh_SA Cuneus_lh_SA 
    Lingual_lh_SA mPFC_lh_CT TPJ_lh_CT pSTS_lh_CT_WINS Precuneus_lh_CT_WINS Cuneus_lh_CT_WINS Lingual_lh_CT_WINS
  /PLOT BOXPLOT STEMLEAF NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

*Examine normality in brain data (RIGHT).
EXAMINE VARIABLES=mPFC_rh_SA_WINS TPJ_rh_SA_WINS pSTS_rh_SA_WINS Precuneus_rh_SA Cuneus_rh_SA_WINS 
    Lingual_rh_SA_WINS mPFC_rh_CT TPJ_rh_CT_WINS pSTS_rh_CT Precuneus_rh_CT_WINS Cuneus_rh_CT Lingual_rh_CT
  /PLOT BOXPLOT STEMLEAF NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

GRAPH
  /HISTOGRAM(NORMAL)=mPFC_SA.
GRAPH
  /HISTOGRAM(NORMAL)=TPJ_SA.
GRAPH
  /HISTOGRAM(NORMAL)=pSTS_SA.
GRAPH
  /HISTOGRAM(NORMAL)=Precuneus_SA.
GRAPH
  /HISTOGRAM(NORMAL)=mPFC_CT.
GRAPH
  /HISTOGRAM(NORMAL)=TPJ_CT.
GRAPH
  /HISTOGRAM(NORMAL)=pSTS_CT.
GRAPH
  /HISTOGRAM(NORMAL)=Precuneus_CT.

FILTER OFF.
USE ALL.
EXECUTE.

*Examine normality in parent-reported data.
EXAMINE VARIABLES=Parent_Prosocial_WINS Parent_Empathy
  /PLOT BOXPLOT STEMLEAF NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

GRAPH
  /HISTOGRAM(NORMAL)=Parent_Prosocial_WINS.
GRAPH
  /HISTOGRAM(NORMAL)=Parent_Empathy.

*Note: values of skewness and kurtosis for all variables was between -2 and 2, so data was considered normally distributed.

*##################### Check association with covariates ######################################################.
*First, select relevant cases (without anomalous findings).
USE ALL.
COMPUTE filter_$=(AnomalousFinding = 0  &  QCscore < 4).
VARIABLE LABELS filter_$ 'AnomalousFinding = 0  &  QCscore < 4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


*--> Separate sample A en sample B.
SORT CASES  BY Sample.
SPLIT FILE SEPARATE BY Sample.

*Check boy/girl difference on brain measures.
T-TEST GROUPS=Sex(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=mPFC_SA_WINS TPJ_SA pSTS_SA Precuneus_SA Cuneus_SA Lingual_SA mPFC_CT TPJ_CT_WINS 
    pSTS_CT Precuneus_CT Cuneus_CT Lingual_CT_WINS
  /CRITERIA=CI(.95).
*Sample A --> Significant differences for all surface area measures and TPJ CT.
* Sample B --> Significant differences for all surface area measures.

*Check association age/IQ with brain measures.
CORRELATIONS
  /VARIABLES=Age IQ with mPFC_SA_WINS TPJ_SA pSTS_SA Precuneus_SA Cuneus_SA Lingual_SA mPFC_CT TPJ_CT_WINS 
    pSTS_CT Precuneus_CT Cuneus_CT Lingual_CT_WINS
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Sample A --> significant neg correlation age with CT Cuneus and Lingual
*Sample B --> significant neg correlation age with CT precuneus, cuneus and lingual, and pos with surface area measures (mPFC, TPJ, precuneus, cuneus, lingual).


FILTER OFF.
USE ALL.
EXECUTE.

*Check boy/girl difference on parent report.
T-TEST GROUPS=Sex(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=Parent_Prosocial_WINS_LOG Parent_Empathy
  /CRITERIA=CI(.95).
*Sample A --> Significant differences for prosocial and empathy.
* Sample B --> Significant differences for prosocial and empathy.

*Check association age/IQ with parent report.
CORRELATIONS
  /VARIABLES=Age IQ Parent_Prosocial_WINS_LOG Parent_Empathy
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Sample B --> significant neg. correlation IQ-prosocial behavior (-.15), and pos correlation age with empathy (.14).


*Decision: Take effects of age, sex, and IQ into account.
*Create dummy variable of sex.
RECODE Sex (1=0) (2=1) INTO Sex_dummy.
EXECUTE.

*####################################### REGRESSION ANALYSES ON BILATERAL MEASURES ###########################################.
*Perform regression analyses, save residuals.
USE ALL.
COMPUTE filter_$=(AnomalousFinding = 0  &  QCscore < 4).
VARIABLE LABELS filter_$ 'AnomalousFinding = 0  &  QCscore < 4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

SORT CASES  BY Sample.
SPLIT FILE SEPARATE BY Sample.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT mPFC_SA_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT TPJ_SA
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pSTS_SA
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Precuneus_SA
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Cuneus_SA
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Lingual_SA
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT mPFC_CT
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT TPJ_CT_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pSTS_CT
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Precuneus_CT
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Cuneus_CT
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Lingual_CT_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

FILTER OFF.
USE ALL.
EXECUTE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Parent_Prosocial_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Parent_Empathy
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

RENAME VARIABLES
RES_1 = mPFC_SA_WINS_RES 
RES_2 = TPJ_SA_RES
RES_3 = pSTS_SA_RES
RES_4 = Precuneus_SA_RES
RES_5 = Cuneus_SA_RES
RES_6 = Lingual_SA_RES
RES_7 = mPFC_CT_RES
RES_8 = TPJ_CT_WINS_RES
RES_9 = pSTS_CT_RES
RES_10 = Precuneus_CT_RES
RES_11 = Cuneus_CT_RES
RES_12 = Lingual_CT_WINS_RES
RES_13 = Parent_Prosocial_WINS_RES
RES_14 = Parent_Empathy_RES.

EXAMINE VARIABLES=mPFC_SA_WINS_RES TPJ_SA_RES pSTS_SA_RES Precuneus_SA_RES Cuneus_SA_RES Lingual_SA_RES 
  mPFC_CT_RES TPJ_CT_WINS_RES pSTS_CT_RES Precuneus_CT_RES Cuneus_CT_RES Lingual_CT_WINS_RES Parent_Prosocial_WINS_RES Parent_Empathy_RES
  /PLOT BOXPLOT STEMLEAF NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

EXAMINE VARIABLES=Parent_Prosocial_WINS_RES Parent_Empathy_RES
  /PLOT BOXPLOT STEMLEAF NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

*####################################### REGRESSION ANALYSES ON LEFT BRAIN MEASURES ###########################################.
USE ALL.
COMPUTE filter_$=(AnomalousFinding = 0  &  QCscore < 4).
VARIABLE LABELS filter_$ 'AnomalousFinding = 0  &  QCscore < 4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT mPFC_lh_SA_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT TPJ_lh_SA
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pSTS_lh_SA_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Precuneus_lh_SA
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Cuneus_lh_SA
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Lingual_lh_SA
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT mPFC_lh_CT
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT TPJ_lh_CT
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pSTS_lh_CT_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Precuneus_lh_CT_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Cuneus_lh_CT_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Lingual_lh_CT_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

RENAME VARIABLES
RES_1 = mPFC_lh_SA_WINS_RES 
RES_2 = TPJ_lh_SA_RES
RES_3 = pSTS_lh_SA_WINS_RES
RES_4 = Precuneus_lh_SA_RES
RES_5 = Cuneus_lh_SA_RES
RES_6 = Lingual_lh_SA_RES
RES_7 = mPFC_lh_CT_RES
RES_8 = TPJ_lh_CT_RES
RES_9 = pSTS_lh_CT_WINS_RES
RES_10 = Precuneus_lh_CT_WINS_RES
RES_11 = Cuneus_lh_CT_WINS_RES
RES_12 = Lingual_lh_CT_WINS_RES.

EXAMINE VARIABLES=mPFC_lh_SA_WINS_RES TPJ_lh_SA_RES pSTS_lh_SA_WINS_RES Precuneus_lh_SA_RES Cuneus_lh_SA_RES Lingual_lh_SA_RES
  mPFC_lh_CT_RES  TPJ_lh_CT_RES pSTS_lh_CT_WINS_RES Precuneus_lh_CT_WINS_RES Cuneus_lh_CT_WINS_RES Lingual_lh_CT_WINS_RES
  /PLOT BOXPLOT STEMLEAF NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.


*####################################### REGRESSION ANALYSES ON RIGHT BRAIN MEASURES ###########################################.
USE ALL.
COMPUTE filter_$=(AnomalousFinding = 0  &  QCscore < 4).
VARIABLE LABELS filter_$ 'AnomalousFinding = 0  &  QCscore < 4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT mPFC_rh_SA_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT TPJ_rh_SA_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pSTS_rh_SA_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Precuneus_rh_SA
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Cuneus_rh_SA_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Lingual_rh_SA_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT mPFC_rh_CT
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT TPJ_rh_CT_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pSTS_rh_CT
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Precuneus_rh_CT_WINS
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Cuneus_rh_CT
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Lingual_rh_CT
  /METHOD=ENTER Age IQ Sex_dummy
  /SAVE RESID.

RENAME VARIABLES
RES_1 = mPFC_rh_SA_WINS_RES 
RES_2 = TPJ_rh_SA_WINS_RES
RES_3 = pSTS_rh_SA_WINS_RES
RES_4 = Precuneus_rh_SA_RES
RES_5 = Cuneus_rh_SA_WINS_RES
RES_6 = Lingual_rh_SA_WINS_RES
RES_7 = mPFC_rh_CT_RES
RES_8 = TPJ_rh_CT_WINS_RES
RES_9 = pSTS_rh_CT_RES
RES_10 = Precuneus_rh_CT_WINS_RES
RES_11 = Cuneus_rh_CT_RES
RES_12 = Lingual_rh_CT_RES.

EXAMINE VARIABLES=mPFC_rh_SA_WINS_RES TPJ_rh_SA_WINS_RES pSTS_rh_SA_WINS_RES  Precuneus_rh_SA_RES Cuneus_rh_SA_WINS_RES Lingual_rh_SA_WINS_RES 
    mPFC_rh_CT_RES TPJ_rh_CT_WINS_RES  pSTS_rh_CT_RES Precuneus_rh_CT_WINS_RES Cuneus_rh_CT_RES Lingual_rh_CT_RES  
  /PLOT BOXPLOT STEMLEAF NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.


*Now that all variables have been checked and prepared for further analyses, delete unneeded variables. Retain only variables that will be used in behavioral genetic modelling.
DELETE VARIABLES
Handedness 
        mPFC_lh_SA mPFC_lh_SA_WINS mPFC_lh_CT mPFC_rh_SA mPFC_rh_SA_WINS mPFC_rh_CT 
    TPJ_lh_SA TPJ_lh_CT TPJ_rh_SA TPJ_rh_SA_WINS TPJ_rh_CT TPJ_rh_CT_WINS pSTS_lh_SA pSTS_lh_SA_WINS 
    pSTS_lh_CT pSTS_lh_CT_WINS pSTS_rh_SA pSTS_rh_SA_WINS pSTS_rh_CT Precuneus_lh_SA Precuneus_rh_SA 
    Precuneus_lh_CT Precuneus_lh_CT_WINS Precuneus_rh_CT Precuneus_rh_CT_WINS Cuneus_lh_SA Cuneus_rh_SA 
    Cuneus_rh_SA_WINS Cuneus_lh_CT Cuneus_lh_CT_WINS Cuneus_rh_CT Lingual_lh_SA Lingual_rh_SA 
    Lingual_rh_SA_WINS Lingual_lh_CT Lingual_lh_CT_WINS Lingual_rh_CT Parent_Prosocial 
    Parent_Prosocial_WINS Parent_Empathy filter_$ mPFC_SA mPFC_SA_WINS TPJ_SA pSTS_SA Precuneus_SA 
    Cuneus_SA Lingual_SA mPFC_CT TPJ_CT TPJ_CT_WINS pSTS_CT Precuneus_CT Cuneus_CT Lingual_CT 
    Lingual_CT_WINS Sex_dummy. 


SAVE OUTFILE='...\vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior_PROCESSED.sav'.

*##################### Change file from long to wide ######################################################.

GET FILE='...\vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior_PROCESSED.sav'.

*Change file format from long to wide.
casestovars
 /id=FamilyID
 /index = ChildNr
 /separator = "_C"
 /fixed Zygosity Age Sex.
list.

*Some variables need to be manuall checked and adjusted. Correct values are below.
*Family 117 -> sex = 1
*Family 429 -> sex = 1
*Family 624 -> sex = 1
*Family 39 -> age is 7.87.

DELETE VARIABLES
Sex_C2.
RENAME VARIABLES
Sex_C1 = Sex.
DELETE VARIABLES
Age_C2.
RENAME VARIABLES
Age_C1 = Age.

*256 cases should remain.

SAVE OUTFILE='...\vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior_PROCESSED_wideformat.sav'.


*##################### Select participants for univariate behavioral genetics analyses on measures of brain structure ######################################################.
*Include only families with twin children who both have NO anomalous finding AND a QC score higher than 4.
FILTER OFF.
USE ALL.
SELECT IF (AnomalousFinding_C1 = 0  &  AnomalousFinding_C2 = 0  & QCscore_C1 < 4 & QCscore_C2 < 4).
EXECUTE.

DELETE VARIABLES
Parent_Prosocial_WINS_RES_C1 Parent_Prosocial_WINS_RES_C2 Parent_Empathy_RES_C1 Parent_Empathy_RES_C2.


SAVE OUTFILE='...\vanderMeulen_DCN_2020_Data_BehGen_Univariate_Brain'.

*Inspect within-twin correlations.
SORT CASES  BY Zygosity.
SPLIT FILE SEPARATE BY Zygosity.

*##########################BILATERAL WITHIN TWIN-CORRELATIONS###############################.
CORRELATIONS
  /VARIABLES=mPFC_SA_WINS_RES_C1 mPFC_SA_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=TPJ_SA_RES_C1 TPJ_SA_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=pSTS_SA_RES_C1 pSTS_SA_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Precuneus_SA_RES_C1 Precuneus_SA_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Cuneus_SA_RES_C1 Cuneus_SA_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Lingual_SA_RES_C1 Lingual_SA_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.


CORRELATIONS
  /VARIABLES=mPFC_CT_RES_C1 mPFC_CT_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=TPJ_CT_WINS_RES_C1 TPJ_CT_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=pSTS_CT_RES_C1 pSTS_CT_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Precuneus_CT_RES_C1 Precuneus_CT_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Cuneus_CT_RES_C1 Cuneus_CT_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Lingual_CT_WINS_RES_C1 Lingual_CT_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.


*##########################LEFT HEMISPHERE TWIN-CORRELATIONS###############################.
*reported in supplementary files.
CORRELATIONS
  /VARIABLES=mPFC_lh_SA_WINS_RES_C1 mPFC_lh_SA_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=TPJ_lh_SA_RES_C1 TPJ_lh_SA_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=pSTS_lh_SA_WINS_RES_C1 pSTS_lh_SA_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Precuneus_lh_SA_RES_C1 Precuneus_lh_SA_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Cuneus_lh_SA_RES_C1 Cuneus_lh_SA_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Lingual_lh_SA_RES_C1 Lingual_lh_SA_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.


CORRELATIONS
  /VARIABLES=mPFC_lh_CT_RES_C1 mPFC_lh_CT_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=TPJ_lh_CT_RES_C1 TPJ_lh_CT_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=pSTS_lh_CT_WINS_RES_C1 pSTS_lh_CT_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Precuneus_lh_CT_WINS_RES_C1 Precuneus_lh_CT_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Cuneus_lh_CT_WINS_RES_C1 Cuneus_lh_CT_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Lingual_lh_CT_WINS_RES_C1 Lingual_lh_CT_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*##########################RIGHT HEMISPHERE TWIN-CORRELATIONS###############################.
*reported in supplementary files.
CORRELATIONS
  /VARIABLES=mPFC_rh_SA_WINS_RES_C1 mPFC_rh_SA_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=TPJ_rh_SA_WINS_RES_C1 TPJ_rh_SA_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=pSTS_rh_SA_WINS_RES_C1 pSTS_rh_SA_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Precuneus_rh_SA_RES_C1 Precuneus_rh_SA_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Cuneus_rh_SA_WINS_RES_C1 Cuneus_rh_SA_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Lingual_rh_SA_WINS_RES_C1 Lingual_rh_SA_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.


CORRELATIONS
  /VARIABLES=mPFC_rh_CT_RES_C1 mPFC_rh_CT_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=TPJ_rh_CT_WINS_RES_C1 TPJ_rh_CT_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=pSTS_rh_CT_RES_C1 pSTS_rh_CT_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Precuneus_rh_CT_WINS_RES_C1 Precuneus_rh_CT_WINS_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Cuneus_rh_CT_RES_C1 Cuneus_rh_CT_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Lingual_rh_CT_RES_C1 Lingual_rh_CT_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*Save file for analyses in R in csv format.
SAVE TRANSLATE OUTFILE='...\vanderMeulen_DCN_2020_Data_BehGen_Univariate_Brain.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.


*##################### Select participants for univariate and bivariate behavioral genetics analyses on parent-reported prosocial behavior and empathy ######################################################.
GET FILE='...\vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior_PROCESSED_wideformat.sav'.

*Select only participants with complete data on parent-report measures.
FILTER OFF.
USE ALL.
SELECT IF NOT(SYSMIS (Parent_Prosocial_WINS_RES_C2)).
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF NOT(SYSMIS (Parent_Prosocial_WINS_RES_C1)).
EXECUTE.
*243 families (486 participants) should remain.

DELETE VARIABLES
AnomalousFinding_C1 AnomalousFinding_C2 QCscore_C1 QCscore_C2 
mPFC_SA_WINS_RES_C1 mPFC_SA_WINS_RES_C2 TPJ_SA_RES_C1 TPJ_SA_RES_C2 
    pSTS_SA_RES_C1 pSTS_SA_RES_C2 Precuneus_SA_RES_C1 Precuneus_SA_RES_C2 Cuneus_SA_RES_C1 
    Cuneus_SA_RES_C2 Lingual_SA_RES_C1 Lingual_SA_RES_C2 mPFC_CT_RES_C1 mPFC_CT_RES_C2 
    TPJ_CT_WINS_RES_C1 TPJ_CT_WINS_RES_C2 pSTS_CT_RES_C1 pSTS_CT_RES_C2 Precuneus_CT_RES_C1 
    Precuneus_CT_RES_C2 Cuneus_CT_RES_C1 Cuneus_CT_RES_C2 Lingual_CT_WINS_RES_C1 Lingual_CT_WINS_RES_C2 
    mPFC_lh_SA_WINS_RES_C1 mPFC_lh_SA_WINS_RES_C2 TPJ_lh_SA_RES_C1 TPJ_lh_SA_RES_C2 
    pSTS_lh_SA_WINS_RES_C1 pSTS_lh_SA_WINS_RES_C2 Precuneus_lh_SA_RES_C1 Precuneus_lh_SA_RES_C2 
    Cuneus_lh_SA_RES_C1 Cuneus_lh_SA_RES_C2 Lingual_lh_SA_RES_C1 Lingual_lh_SA_RES_C2 mPFC_lh_CT_RES_C1 
    mPFC_lh_CT_RES_C2 TPJ_lh_CT_RES_C1 TPJ_lh_CT_RES_C2 pSTS_lh_CT_WINS_RES_C1 pSTS_lh_CT_WINS_RES_C2 
    Precuneus_lh_CT_WINS_RES_C1 Precuneus_lh_CT_WINS_RES_C2 Cuneus_lh_CT_WINS_RES_C1 
    Cuneus_lh_CT_WINS_RES_C2 Lingual_lh_CT_WINS_RES_C1 Lingual_lh_CT_WINS_RES_C2 mPFC_rh_SA_WINS_RES_C1 
    mPFC_rh_SA_WINS_RES_C2 TPJ_rh_SA_WINS_RES_C1 TPJ_rh_SA_WINS_RES_C2 pSTS_rh_SA_WINS_RES_C1 
    pSTS_rh_SA_WINS_RES_C2 Precuneus_rh_SA_RES_C1 Precuneus_rh_SA_RES_C2 Cuneus_rh_SA_WINS_RES_C1 
    Cuneus_rh_SA_WINS_RES_C2 Lingual_rh_SA_WINS_RES_C1 Lingual_rh_SA_WINS_RES_C2 mPFC_rh_CT_RES_C1 
    mPFC_rh_CT_RES_C2 TPJ_rh_CT_WINS_RES_C1 TPJ_rh_CT_WINS_RES_C2 pSTS_rh_CT_RES_C1 pSTS_rh_CT_RES_C2 
    Precuneus_rh_CT_WINS_RES_C1 Precuneus_rh_CT_WINS_RES_C2 Cuneus_rh_CT_RES_C1 Cuneus_rh_CT_RES_C2 
    Lingual_rh_CT_RES_C1 Lingual_rh_CT_RES_C2.

SAVE OUTFILE='...\vanderMeulen_DCN_2020_Data_BehGen_Behavior.sav'.


GET FILE='...\vanderMeulen_DCN_2020_Data_Univariate_BehGen_Behavior.sav'.

SORT CASES  BY Zygosity.
SPLIT FILE SEPARATE BY Zygosity.

NONPAR CORR
  /VARIABLES=Parent_Prosocial_WINS_RES_C1 Parent_Prosocial_WINS_RES_C2
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=Parent_Empathy_RES_C1 Parent_Empathy_RES_C2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.


*Save file for analyses in R.
SAVE TRANSLATE OUTFILE='...\vanderMeulen_DCN_2020_Data_BehGen_Behavior.csv'.
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.


*##################### Select participants for bivariate behavior analyses ######################################################.
GET FILE='...\vanderMeulen_DCN_2020_Data_Demograhpics_sMRI_Behavior_PROCESSED_wideformat.sav'.

*For bivariate behavioral genetic analyses on brain & behavior, select participants with suitable parent-reported and neuroimaging data.
FILTER OFF.
USE ALL.
SELECT IF NOT(SYSMIS (Parent_Prosocial_WINS_RES_C2)).
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF NOT(SYSMIS (Parent_Prosocial_WINS_RES_C1)).
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (AnomalousFinding_C1 = 0  &  AnomalousFinding_C2 = 0  & QCscore_C1 < 4 & QCscore_C2 < 4).
EXECUTE.
*171 families (342 participants) should remain.

*Compute phenotypic brain-behavior associations.
* RUN syntax "hcreg.SPS" --> open second syntax file, run syntax and keep file open.

USE ALL.
COMPUTE filter_$=(AnomalousFinding = 0  &  QCscore < 4).
VARIABLE LABELS filter_$ 'AnomalousFinding = 0  &  QCscore < 4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

*Prosocial * surface area.
HCREG dv = Parent_Prosocial_WINS_RES
/iv = mPFC_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =  TPJ_SA_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   pSTS_SA_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Precuneus_SA_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   Cuneus_SA_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Lingual_SA_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

*Prosocial * cortical thickness.
HCREG dv = Parent_Prosocial_WINS_RES
/iv = mPFC_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =  TPJ_CT_WINS_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   pSTS_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Precuneus_CT_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   Cuneus_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Lingual_CT_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3


*Empathy * surface area.
HCREG dv = Parent_Empathy_RES
/iv = mPFC_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =  TPJ_SA_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   pSTS_SA_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Precuneus_SA_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   Cuneus_SA_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Lingual_SA_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

*Empathy * cortical thickness.
HCREG dv = Parent_Empathy_RES
/iv = mPFC_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =  TPJ_CT_WINS_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   pSTS_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Precuneus_CT_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   Cuneus_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Lingual_CT_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

*Empathy*Prosocial.
HCREG dv = Parent_Empathy_RES
/iv = Parent_Prosocial_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3



*############################ LEFT BRAIN ###############################################

*Prosocial * surface area.
HCREG dv = Parent_Prosocial_WINS_RES
/iv = mPFC_lh_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =  TPJ_lh_SA_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   pSTS_lh_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Precuneus_lh_SA_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   Cuneus_lh_SA_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Lingual_lh_SA_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

*Prosocial * cortical thickness.
HCREG dv = Parent_Prosocial_WINS_RES
/iv = mPFC_lh_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =  TPJ_lh_CT_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   pSTS_lh_CT_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Precuneus_lh_CT_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   Cuneus_lh_CT_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Lingual_lh_CT_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3


*Empathy * surface area.
HCREG dv = Parent_Empathy_RES
/iv = mPFC_lh_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =  TPJ_lh_SA_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   pSTS_lh_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Precuneus_lh_SA_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   Cuneus_lh_SA_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Lingual_lh_SA_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

*Empathy * cortical thickness.
HCREG dv = Parent_Empathy_RES
/iv = mPFC_lh_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =  TPJ_lh_CT_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   pSTS_lh_CT_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Precuneus_lh_CT_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   Cuneus_lh_CT_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Lingual_lh_CT_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3


*############################ RIGHT BRAIN ###############################################

*Prosocial * surface area.
HCREG dv = Parent_Prosocial_WINS_RES
/iv = mPFC_rh_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =  TPJ_rh_SA_WINS_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   pSTS_rh_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Precuneus_rh_SA_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   Cuneus_rh_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Lingual_rh_SA_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

*Prosocial * cortical thickness.
HCREG dv = Parent_Prosocial_WINS_RES
/iv = mPFC_rh_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =  TPJ_rh_CT_WINS_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   pSTS_rh_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Precuneus_rh_CT_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv =   Cuneus_rh_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Prosocial_WINS_RES
/iv = Lingual_rh_CT_RES
/const = 1
/method =3
/covmat = 1      
/test = 3


*Empathy * surface area.
HCREG dv = Parent_Empathy_RES
/iv = mPFC_rh_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =  TPJ_rh_SA_WINS_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   pSTS_rh_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Precuneus_rh_SA_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   Cuneus_rh_SA_WINS_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Lingual_rh_SA_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

*Empathy * cortical thickness.
HCREG dv = Parent_Empathy_RES
/iv = mPFC_rh_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =  TPJ_rh_CT_WINS_RES  
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   pSTS_rh_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Precuneus_rh_CT_WINS_RES
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv =   Cuneus_rh_CT_RES 
/const = 1
/method =3
/covmat = 1      
/test = 3

HCREG dv = Parent_Empathy_RES
/iv = Lingual_rh_CT_RES
/const = 1
/method =3
/covmat = 1      
/test = 3


*Now create a datafile for bivariate behavioral genetic analyses of brain & behavior.
DELETE VARIABLES
AnomalousFinding_C1 AnomalousFinding_C2 QCscore_C1 QCscore_C2 
    mPFC_lh_SA_WINS_RES_C1 mPFC_lh_SA_WINS_RES_C2 TPJ_lh_SA_RES_C1 TPJ_lh_SA_RES_C2 
    pSTS_lh_SA_WINS_RES_C1 pSTS_lh_SA_WINS_RES_C2 Precuneus_lh_SA_RES_C1 Precuneus_lh_SA_RES_C2 
    Cuneus_lh_SA_RES_C1 Cuneus_lh_SA_RES_C2 Lingual_lh_SA_RES_C1 Lingual_lh_SA_RES_C2 mPFC_lh_CT_RES_C1 
    mPFC_lh_CT_RES_C2 TPJ_lh_CT_RES_C1 TPJ_lh_CT_RES_C2 pSTS_lh_CT_WINS_RES_C1 pSTS_lh_CT_WINS_RES_C2 
    Precuneus_lh_CT_WINS_RES_C1 Precuneus_lh_CT_WINS_RES_C2 Cuneus_lh_CT_WINS_RES_C1 
    Cuneus_lh_CT_WINS_RES_C2 Lingual_lh_CT_WINS_RES_C1 Lingual_lh_CT_WINS_RES_C2 mPFC_rh_SA_WINS_RES_C1 
    mPFC_rh_SA_WINS_RES_C2 TPJ_rh_SA_WINS_RES_C1 TPJ_rh_SA_WINS_RES_C2 pSTS_rh_SA_WINS_RES_C1 
    pSTS_rh_SA_WINS_RES_C2 Precuneus_rh_SA_RES_C1 Precuneus_rh_SA_RES_C2 Cuneus_rh_SA_WINS_RES_C1 
    Cuneus_rh_SA_WINS_RES_C2 Lingual_rh_SA_WINS_RES_C1 Lingual_rh_SA_WINS_RES_C2 mPFC_rh_CT_RES_C1 
    mPFC_rh_CT_RES_C2 TPJ_rh_CT_WINS_RES_C1 TPJ_rh_CT_WINS_RES_C2 pSTS_rh_CT_RES_C1 pSTS_rh_CT_RES_C2 
    Precuneus_rh_CT_WINS_RES_C1 Precuneus_rh_CT_WINS_RES_C2 Cuneus_rh_CT_RES_C1 Cuneus_rh_CT_RES_C2 
    Lingual_rh_CT_RES_C1 Lingual_rh_CT_RES_C2.


SAVE OUTFILE='...\vanderMeulen_DCN_2020_Data_BehGen_Bivariate_Brain_Behavior.sav'.



*Save file for analyses in R.
SAVE TRANSLATE OUTFILE='...\vanderMeulen_DCN_2020_Data_BehGen_Bivariate_Brain_Behavior.csv'.
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
