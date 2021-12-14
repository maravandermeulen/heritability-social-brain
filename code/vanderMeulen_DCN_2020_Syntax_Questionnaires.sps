* Encoding: UTF-8.
*### Syntax for "Genetic and environmental influences on structure of the social brain in childhood" ###.
*### Paper published in DCN, 2020 ###
*### Syntax written and edited by Mara van der Meulen ###.

*This syntax includes:
* checks of reliability of original parent-reported prosocial behavior scales
* principal component analyses
* creation of new subscales for parent-reported prosocial behavior & empathy
* correlation analyses between original subscales of SDQ and MC questionnaires and newly created subscales for parent-reported prosocial behavior & empathy

* Please note:
 *# Translation of items and answering options is available in separate document (under "Measures")
 *# PO = primary parent
 *# AO = other parent

*Reliability scales
* For child 1 and 2 separately.
SORT CASES  BY Sample.
SPLIT FILE LAYERED BY Sample.

*Reliability SDQ - PO.
RELIABILITY
  /VARIABLES=C3.1_PO_SDQ.1_1 C3.1_PO_SDQ.1_4 C3.1_PO_SDQ.2_1 C3.1_PO_SDQ.3_1 C3.1_PO_SDQ.3_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.

COMPUTE SDQ_PO_Prosocial = MEAN(C3.1_PO_SDQ.1_1, C3.1_PO_SDQ.1_4, C3.1_PO_SDQ.2_1, C3.1_PO_SDQ.3_1, C3.1_PO_SDQ.3_4).
EXECUTE.

*Reliability SDQ - AO.
RELIABILITY
  /VARIABLES=C3.1_AO_SDQ.1_1 C3.1_AO_SDQ.1_4 C3.1_AO_SDQ.2_1 C3.1_AO_SDQ.3_1 C3.1_AO_SDQ.3_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.

COMPUTE SDQ_AO_Prosocial = MEAN(C3.1_AO_SDQ.1_1, C3.1_AO_SDQ.1_4, C3.1_AO_SDQ.2_1, C3.1_AO_SDQ.3_1, C3.1_AO_SDQ.3_4).
EXECUTE.

*Reliability MC - PO.
RELIABILITY
  /VARIABLES=C3.1_PO_MC.1_1 C3.1_PO_MC.1_2 C3.1_PO_REC_MC.1_3 C3.1_PO_MC.1_4 C3.1_PO_MC.1_5 
    C3.1_PO_REC_MC.1_6 C3.1_PO_MC.1_7 C3.1_PO_MC.2_1 C3.1_PO_MC.2_2 C3.1_PO_MC.2_3 C3.1_PO_MC.2_4 
    C3.1_PO_MC.2_5 C3.1_PO_REC_MC.2_6
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.


COMPUTE MC_PO_EmpathyProsocial = MEAN (C3.1_PO_MC.1_1, C3.1_PO_MC.1_2, C3.1_PO_REC_MC.1_3, C3.1_PO_MC.1_4, C3.1_PO_MC.1_5, C3.1_PO_REC_MC.1_6, C3.1_PO_MC.1_7, C3.1_PO_MC.2_1, C3.1_PO_MC.2_2, C3.1_PO_MC.2_3, C3.1_PO_MC.2_4, C3.1_PO_MC.2_5, C3.1_PO_REC_MC.2_6). 
EXECUTE.

*Reliability MC - AO.
RELIABILITY
  /VARIABLES=C3.1_AO_MC.1_1 C3.1_AO_MC.1_2 C3.1_AO_MC.1_4 C3.1_AO_MC.1_5 C3.1_AO_MC.1_7 
    C3.1_AO_MC.2_1 C3.1_AO_MC.2_2 C3.1_AO_MC.2_3 C3.1_AO_MC.2_4 C3.1_AO_MC.2_5 C3.1_AO_MC.1_3_REC 
    C3.1_AO_MC.1_6_REC C3.1_AO_MC.2_6_REC
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.

COMPUTE MC_AO_EmpathyProsocial = MEAN (C3.1_AO_MC.1_1, C3.1_AO_MC.1_2, C3.1_AO_MC.1_3_REC, C3.1_AO_MC.1_4, C3.1_AO_MC.1_5, C3.1_AO_MC.1_6_REC, C3.1_AO_MC.1_7, C3.1_AO_MC.2_1, C3.1_AO_MC.2_2, C3.1_AO_MC.2_3, C3.1_AO_MC.2_4, C3.1_AO_MC.2_5, C3.1_AO_MC.2_6_REC). 
EXECUTE.

*###################################### PCA #################################################################.
*Separate PCA are conducted for PO and AO, for child 1 and child 2 seperately.

* Step 1: split file for child 1 and child 2 (to remove twin-dependence).
SORT CASES  BY Sample.
SPLIT FILE LAYERED BY Sample.

* Step 2a: PCA on items from SDQ and MyChild list, as answered by PO.
FACTOR
  /VARIABLES C3.1_PO_SDQ.1_1 C3.1_PO_SDQ.1_4 C3.1_PO_SDQ.2_1 C3.1_PO_SDQ.3_1 C3.1_PO_SDQ.3_4 
    C3.1_PO_MC.1_1 C3.1_PO_MC.1_2 C3.1_PO_REC_MC.1_3 C3.1_PO_MC.1_4 C3.1_PO_MC.1_5 C3.1_PO_REC_MC.1_6 
    C3.1_PO_MC.1_7 C3.1_PO_MC.2_1 C3.1_PO_MC.2_2 C3.1_PO_MC.2_3 C3.1_PO_MC.2_4 C3.1_PO_MC.2_5 
    C3.1_PO_REC_MC.2_6
  /MISSING LISTWISE 
  /ANALYSIS C3.1_PO_SDQ.1_1 C3.1_PO_SDQ.1_4 C3.1_PO_SDQ.2_1 C3.1_PO_SDQ.3_1 C3.1_PO_SDQ.3_4 
    C3.1_PO_MC.1_1 C3.1_PO_MC.1_2 C3.1_PO_REC_MC.1_3 C3.1_PO_MC.1_4 C3.1_PO_MC.1_5 C3.1_PO_REC_MC.1_6 
    C3.1_PO_MC.1_7 C3.1_PO_MC.2_1 C3.1_PO_MC.2_2 C3.1_PO_MC.2_3 C3.1_PO_MC.2_4 C3.1_PO_MC.2_5 
    C3.1_PO_REC_MC.2_6
  /PRINT INITIAL CORRELATION KMO REPR AIC EXTRACTION ROTATION
  /FORMAT SORT
  /PLOT EIGEN ROTATION
  /CRITERIA FACTORS(2) ITERATE(25)
  /EXTRACTION PC
  /CRITERIA ITERATE(25)
  /ROTATION VARIMAX
  /SAVE REG(ALL)
  /METHOD=CORRELATION.

*Adaptation of variable labels, according to outcomes of PCA. All items loading on scale 1 ("Prosocial") are indicated with 1, all items loading on scale 2 ("Empathy") are indicated with 2.
* Items that did not fit well in either of the two scales are indicated with 9.
VARIABLE LABELS
C3.1_PO_SDQ.1_1 '1 - PO - SDQ - Kind houdt rekening met de gevoelens van anderen'
C3.1_PO_SDQ.1_4 '1 - PO - SDQ - Kind deelt makkelijk met andere kinderen (bijvoorbeeld speelgoed, snoep, potloden, enz.).'
C3.1_PO_SDQ.2_1 '1 - PO - SDQ - Kind is behulpzaam als iemand zich heeft bezeerd, van streek is of zich ziek voelt.'
C3.1_PO_SDQ.3_1 '1 - PO - SDQ - Kind is aardig tegen jongere kinderen.'
C3.1_PO_SDQ.3_4 '1 - PO - SDQ - Kind biedt vaak vrijwillig hulp aan anderen (ouders, leerkrachten, andere kinderen).'
C3.1_PO_MC.1_1 '1 - PO - MC - Kind probeert iemand die van streek is of bang is te troosten/gerust te stellen.'
C3.1_PO_MC.1_2 '1 - PO - MC - Kind geeft snoep of speelgoed aan een huilend vriendje, ook zonder dat één van de ouders dit voorstelt.'
C3.1_PO_REC_MC.1_3 '9 - PO - MC - REC - Kind plaagt soms een (huis)dier als er niet op hem/haar wordt gelet'
C3.1_PO_MC.1_4 '9 - PO - MC - Wanneer in een film op TV de spelers leuke dingen meemaken, wordt  Kind vrolijk.'
C3.1_PO_MC.1_5 '2 - PO - MC - Kind is overstuur wanneer hij/zij een gewond dier ziet.'
C3.1_PO_REC_MC.1_6 '2 - PO - MC - REC - Kind huilt zelden bij het zien van iets verdrietigs op televisie.'
C3.1_PO_MC.1_7  '1 - PO - MC - Kind is uit zichzelf lief en zorgzaam voor dieren.'
C3.1_PO_MC.2_1 '1 - PO - MC - Kind merkt snel op hoe anderen zich voelen.'
C3.1_PO_MC.2_2 '1 - PO - MC - Kind vraagt wat er aan de hand is, wanneer hij/zij  ziet dat iemand verdriet of pijn heeft.'
C3.1_PO_MC.2_3 '2 - PO - MC - Tijdens het kijken naar een televisieprogramma kan Kind boos worden op de “slechterik”, als die een ander pijn doet.'
C3.1_PO_MC.2_4 '2 - PO - MC - Kind raakt van streek bij verhalen waarin iemand gewond raakt of dood gaat.'
C3.1_PO_MC.2_5 '1 - PO - MC - Kind heeft medelijden met andere mensen als deze gewond, ziek of ongelukkig zijn.'
C3.1_PO_REC_MC.2_6 '2 - PO - MC - REC - Als een speelkameraadje huilt, raakt Kind daar zelf niet door van streek.'.

*Scale 1 - Prosocial (12 items).
RELIABILITY
  /VARIABLES=C3.1_PO_SDQ.1_1 C3.1_PO_SDQ.1_4 C3.1_PO_SDQ.2_1 C3.1_PO_SDQ.3_1 C3.1_PO_SDQ.3_4 
    C3.1_PO_MC.1_1 C3.1_PO_MC.1_2 C3.1_PO_MC.1_7 C3.1_PO_MC.2_1 C3.1_PO_MC.2_2 C3.1_PO_MC.2_5 
    C3.1_PO_REC_MC.1_3 C3.1_PO_MC.1_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.
**CHILD 1: alpha = .815. When least fitting item ("Kind plaagt soms een (huis)dier als er niet op hem/haar wordt gelet") deleted, alpha = .839
**CHILD 2: alpha = .798. When least fitting item ("Kind plaagt soms een (huis)dier als er niet op hem/haar wordt gelet") deleted, alpha = .825

*Scale 2 - Empathy (6 items).
RELIABILITY
  /VARIABLES=C3.1_PO_MC.1_4 C3.1_PO_MC.1_5 C3.1_PO_REC_MC.1_6 C3.1_PO_MC.2_3 C3.1_PO_MC.2_4 
    C3.1_PO_REC_MC.2_6 C3.1_PO_REC_MC.1_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.
**CHILD 1: alpha = .713. When least fitting item ("Wanneer in een film op TV de spelers leuke dingen meemaken, wordt  Kind vrolijk.") deleted, alpha = .727
**CHILD 2: alpha = .745. When least fitting item ("Wanneer in een film op TV de spelers leuke dingen meemaken, wordt  Kind vrolijk.") deleted, alpha = .762
 
*#############################################.

* Step 2b: PCA on items from SDQ and MyChild list, as answered by AO.
FACTOR
  /VARIABLES C3.1_AO_SDQ.1_1 C3.1_AO_SDQ.1_4 C3.1_AO_SDQ.2_1 C3.1_AO_SDQ.3_1 C3.1_AO_SDQ.3_4 
    C3.1_AO_MC.1_1 C3.1_AO_MC.1_2 C3.1_AO_MC.1_4 C3.1_AO_MC.1_5 C3.1_AO_MC.1_7 C3.1_AO_MC.2_1 
    C3.1_AO_MC.2_2 C3.1_AO_MC.2_3 C3.1_AO_MC.2_4 C3.1_AO_MC.2_5 C3.1_AO_MC.1_3_REC C3.1_AO_MC.1_6_REC 
    C3.1_AO_MC.2_6_REC
  /MISSING LISTWISE 
  /ANALYSIS C3.1_AO_SDQ.1_1 C3.1_AO_SDQ.1_4 C3.1_AO_SDQ.2_1 C3.1_AO_SDQ.3_1 C3.1_AO_SDQ.3_4 
    C3.1_AO_MC.1_1 C3.1_AO_MC.1_2 C3.1_AO_MC.1_4 C3.1_AO_MC.1_5 C3.1_AO_MC.1_7 C3.1_AO_MC.2_1 
    C3.1_AO_MC.2_2 C3.1_AO_MC.2_3 C3.1_AO_MC.2_4 C3.1_AO_MC.2_5 C3.1_AO_MC.1_3_REC C3.1_AO_MC.1_6_REC 
    C3.1_AO_MC.2_6_REC
  /PRINT INITIAL CORRELATION KMO  EXTRACTION ROTATION
  /FORMAT SORT
  /PLOT EIGEN ROTATION
  /CRITERIA FACTORS(2) ITERATE(25)
  /EXTRACTION PC
  /CRITERIA ITERATE(25)
  /ROTATION VARIMAX
  /SAVE REG(ALL)
  /METHOD=CORRELATION.
*Note: PCA for AO (other parent) gives a slightly different result than PCA for PO (primary parent). That is, one item is added to another scale. To maintain consistency the component structure of PO is maintained.

*Adaptation of variable labels, according to outcomes of PCA. All items loading on scale 1 ("Prosocial") are indicated with 1, all items loading on scale 2 ("Empathy") are indicated with 2.
* Items that did not fit well in either of the two scales are indicated with 9.
VARIABLE LABELS
C3.1_AO_SDQ.1_1 '1 - AO - SDQ - Kind houdt rekening met de gevoelens van anderen'
C3.1_AO_SDQ.1_4 '1 - AO - SDQ - Kind deelt makkelijk met andere kinderen (bijvoorbeeld speelgoed, snoep, potloden, enz.).'
C3.1_AO_SDQ.2_1 '1 - AO - SDQ - Kind is behulpzaam als iemand zich heeft bezeerd, van streek is of zich ziek voelt.'
C3.1_AO_SDQ.3_1 '1 - AO - SDQ - Kind is aardig tegen jongere kinderen.'
C3.1_AO_SDQ.3_4 '1 - AO - SDQ - Kind biedt vaak vrijwillig hulp aan anderen (ouders, leerkrachten, andere kinderen).'
C3.1_AO_MC.1_1 '1 - AO - MC - Kind probeert iemand die van streek is of bang is te troosten/gerust te stellen.'
C3.1_AO_MC.1_2 '1 - AO - MC - Kind geeft snoep of speelgoed aan een huilend vriendje, ook zonder dat één van de ouders dit voorstelt.'
C3.1_AO_MC.1_3_REC '9 - AO - MC - REC - Kind plaagt soms een (huis)dier als er niet op hem/haar wordt gelet'
C3.1_AO_MC.1_4 '9 - AO - MC - Wanneer in een film op TV de spelers leuke dingen meemaken, wordt  Kind vrolijk.'
C3.1_AO_MC.1_5 '2 - AO - MC - Kind is overstuur wanneer hij/zij een gewond dier ziet.'
C3.1_AO_MC.1_6_REC '2 - AO - MC - REC - Kind huilt zelden bij het zien van iets verdrietigs op televisie.'
C3.1_AO_MC.1_7  '1 - AO - MC - Kind is uit zichzelf lief en zorgzaam voor dieren.'
C3.1_AO_MC.2_1 '1 - AO - MC - Kind merkt snel op hoe anderen zich voelen.'
C3.1_AO_MC.2_2 '1 - AO - MC - Kind vraagt wat er aan de hand is, wanneer hij/zij  ziet dat iemand verdriet of pijn heeft.'
C3.1_AO_MC.2_3 '2 - AO - MC - Tijdens het kijken naar een televisieprogramma kan Kind boos worden op de “slechterik”, als die een ander pijn doet.'
C3.1_AO_MC.2_4 '2 - AO - MC - Kind raakt van streek bij verhalen waarin iemand gewond raakt of dood gaat.'
C3.1_AO_MC.2_5 '1 - AO - MC - Kind heeft medelijden met andere mensen als deze gewond, ziek of ongelukkig zijn.'
C3.1_AO_MC.2_6_REC '2 - AO - MC - REC - Als een speelkameraadje huilt, raakt Kind daar zelf niet door van streek.'.

*Scale 1 - Prosocial (12 items).
RELIABILITY
  /VARIABLES=C3.1_AO_SDQ.1_1 C3.1_AO_SDQ.1_4 C3.1_AO_SDQ.2_1 C3.1_AO_SDQ.3_1 C3.1_AO_SDQ.3_4 
    C3.1_AO_MC.1_1 C3.1_AO_MC.1_2 C3.1_AO_MC.1_3_REC C3.1_AO_MC.1_4 C3.1_AO_MC.1_7 C3.1_AO_MC.2_1 C3.1_AO_MC.2_2 
    C3.1_AO_MC.2_5
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.
**CHILD 1: alpha = .75. When least fitting item ("Kind plaagt soms een (huis)dier als er niet op hem/haar wordt gelet") deleted, alpha = .78
**CHILD 2: alpha = .81. When least fitting item ("Kind plaagt soms een (huis)dier als er niet op hem/haar wordt gelet") deleted, alpha = .83

*Scale 2 - Empathy (6 items).
RELIABILITY
  /VARIABLES=C3.1_AO_MC.1_4 C3.1_AO_MC.1_5 C3.1_AO_MC.1_6_REC C3.1_AO_MC.2_3 C3.1_AO_MC.2_4 
    C3.1_AO_MC.2_6_REC C3.1_AO_MC.1_3_REC
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.
**CHILD 1: alpha = .66. When least fitting item ("Wanneer in een film op TV de spelers leuke dingen meemaken, wordt  Kind vrolijk.") deleted, alpha = .69
**CHILD 2: alpha = .62. When least fitting item ("Wanneer in een film op TV de spelers leuke dingen meemaken, wordt  Kind vrolijk.") deleted, alpha = .65


*###################################################################################################################.

**Recode SDQ items (from 1-3 to 1-5) for PO and AO.
RECODE C3.1_PO_SDQ.1_1 C3.1_PO_SDQ.1_4 C3.1_PO_SDQ.2_1 C3.1_PO_SDQ.3_1 C3.1_PO_SDQ.3_4 (1=1) (2=3) 
    (3=5) INTO C3.1_PO_SDQ.1_1_REC C3.1_PO_SDQ.1_4_REC C3.1_PO_SDQ.2_1_REC C3.1_PO_SDQ.3_1_REC 
    C3.1_PO_SDQ.4_1_REC.
EXECUTE.

RECODE C3.1_AO_SDQ.1_1 C3.1_AO_SDQ.1_4 C3.1_AO_SDQ.2_1 C3.1_AO_SDQ.3_1 C3.1_AO_SDQ.3_4 (1=1) (2=3) 
    (3=5) INTO C3.1_AO_SDQ.1_1_REC C3.1_AO_SDQ.1_4_REC C3.1_AO_SDQ.2_1_REC C3.1_AO_SDQ.3_1_REC 
    C3.1_AO_SDQ.4_1_REC.
EXECUTE.

**Computation new subscales for PO and AO seperately.
COMPUTE PO_Prosocial=MEAN(C3.1_PO_SDQ.1_1_REC , C3.1_PO_SDQ.1_4_REC , C3.1_PO_SDQ.2_1_REC , 
    C3.1_PO_SDQ.3_1_REC , C3.1_PO_SDQ.4_1_REC , C3.1_PO_MC.1_1 , C3.1_PO_MC.1_2 , C3.1_PO_MC.1_7 , 
    C3.1_PO_MC.2_1 , C3.1_PO_MC.2_2 , C3.1_PO_MC.2_5).
EXECUTE.

COMPUTE PO_Empathy=MEAN(C3.1_PO_MC.1_5 , C3.1_PO_REC_MC.1_6 , C3.1_PO_MC.2_3 , C3.1_PO_MC.2_4 , 
    C3.1_PO_REC_MC.2_6).
EXECUTE.

COMPUTE AO_Prosocial=MEAN(C3.1_AO_SDQ.1_1_REC , C3.1_AO_SDQ.1_4_REC , C3.1_AO_SDQ.2_1_REC , 
    C3.1_AO_SDQ.3_1_REC , C3.1_AO_SDQ.4_1_REC , C3.1_AO_MC.1_1 , C3.1_AO_MC.1_2 , C3.1_AO_MC.1_7 , 
    C3.1_AO_MC.2_1 , C3.1_AO_MC.2_2 , C3.1_AO_MC.2_5).
EXECUTE.

COMPUTE AO_Empathy=MEAN(C3.1_AO_MC.1_5 , C3.1_AO_MC.1_6_REC , C3.1_AO_MC.2_3 , C3.1_AO_MC.2_4 , 
    C3.1_AO_MC.2_6_REC).
EXECUTE.

*Check descriptives, winsorize outliers.
DESCRIPTIVES VARIABLES=PO_Prosocial PO_Empathy AO_Prosocial AO_Empathy
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.

*Check correlations between two scales for PO and AO (for sample A and B separately).

SORT CASES  BY Sample.
SPLIT FILE LAYERED BY Sample.

CORRELATIONS
  /VARIABLES=PO_Prosocial_WINS AO_Prosocial_WINS
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
* Correlations .48-.53.

CORRELATIONS
  /VARIABLES=PO_Empathy AO_Empathy
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
** Correlations .37-.43.



* Compute new variables for PO and AO combined (prosocial subscale and empathy subscale).
COMPUTE Parent_Prosocial=MEAN(PO_Prosocial_WINS,AO_Prosocial_WINS).
EXECUTE.

COMPUTE Parent_Empathy=MEAN(PO_Empathy,AO_Empathy).
EXECUTE.

DESCRIPTIVES VARIABLES=Parent_Prosocial Parent_Empathy
  /STATISTICS=MEAN STDDEV MIN MAX.
*We have parent-reported prosocial behavior for 486 participants!.

*############################### ANALYSES SUPPLEMENTARY FILE ##############################################.
* "For completeness, we reported correlation coefficients between the mean factor scores of the newly created subscales
and the original subscales of SDQ and MC (separately for sample A and B) in Supplementary Table S2."

*Split file on Sample A and B (split twinpairs randomly).
SORT CASES  BY Sample.
SPLIT FILE LAYERED BY Sample.

CORRELATIONS
  /VARIABLES=SDQ_PO_Prosocial SDQ_AO_Prosocial
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Sample A: .48 (p < .001)
*Sample B: .46 (p < .001)

CORRELATIONS
  /VARIABLES=MC_PO_EmpathyProsocial MC_AO_EmpathyProsocial
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Sample A: .43 (p < .001)
*Sample B: .52 (p < .001)

*Correlations are high enough, so collapse parent report scores for PO and AO.
COMPUTE Parent_SDQ=MEAN(SDQ_PO_Prosocial,SDQ_AO_Prosocial).
EXECUTE.

COMPUTE Parent_MC=MEAN(MC_PO_EmpathyProsocial,MC_AO_EmpathyProsocial).
EXECUTE.

*Correlations between original questionnaires and newly created subscales.
CORRELATIONS
  /VARIABLES=Parent_Prosocial_WINS Parent_Empathy Parent_SDQ Parent_MC
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

