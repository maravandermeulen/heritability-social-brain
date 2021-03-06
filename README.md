<!-- Find and replace the following: -->

<!-- study-short-name: the short name displayed as the heading -->
<!-- corresponding-author-name: your first and last name -->
<!-- data-url: a link to the raw data if hosted openly, preferrably a DOI link -->
<!-- preprint-url: a link to the preprint if available, preferrably a DOI link -->
<!-- prereg-url: a link to the preregistration if available, preferrably a DOI link -->
<!-- manuscript-url: a link to the published manuscript, preferrably a DOI link -->
<!-- binder-url: a link to the binder repository to reproduce the results online, if available -->
<!-- dashboard-url: a link to the dashboard to explore the results online, if available -->
<!-- manuscript-title: the full manuscript title, as published -->
<!-- group-institution: the name of the lab, department, institution, etc, where the study was conducted -->
<!-- study-summary: description of the study and its goals -->
<!-- data-summary: overview of data used for the study -->
<!-- data-access-statement:: if the dataset is openly available, describe how and where to access it, with link to dataset; if not, add short statment about why it's not accessible -->
<!-- materials-summary: summary of materials contained in this repo -->
<!-- methods-summary: overview of main methods applied to data -->
<!-- reproducibility-summary: description of how to reproduce the results. this can include referencing main derivative data from which the results figures are generated, as well as the main script that is used to do that; additionally, this might also reference a binder environment where the results can be reproduced online -->
<!-- license-type: the type of open license selected for this repo -->
<!-- publication-package-citation: full text citation based on the Zenodo DOI -->
<!-- manuscript-citation: full text citation of the published article -->

<!-- NOTE: the descriptions in this main readme file are intended to be summarising information. For more detailed information/instructions, add this to the respective README files in the appropriate individual folders -->

<!-- EDIT ALL INFO BELOW AS NECESSARY -->
# Genetic and environmental influences on structure of the social brain in childhood

*By: Mara van der Meulen*


<!-- Link for raw data; remove this section if not applicable -->
[![Download the dataset](https://img.shields.io/badge/download-Raw%20data-9cf.svg)](`data-url`)

<!-- Link for published manuscript; remove this section if not applicable -->
[![Read this work](https://img.shields.io/badge/read-Published%20manuscript-red.svg)](https://doi.org/10.1016/j.dcn.2020.100782)

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/maravandermeulen/heritability-social-brain/HEAD?urlpath=notebooks/code/vanderMeulen_DCN_2020_Script_Visualization_WithinTwinCorrelations.Rmd)



## Overview
This is the online publication package for the project

[**Genetic and environmental influences on structure of the social brain in childhood**](`https://doi.org/10.1016/j.dcn.2020.100782`)

which was conducted at Leiden Consortium on Individual Development, Leiden University, the Netherlands.

The publication package contains descriptions, code and data that aid reproducibility and transparency of the results.

Below we provide summary information regarding:
- [The study](#study)
- [The dataset](#data)
- [The materials](#materials)
- [The methods](#methods)
- [Reproducing the results](#reproduce)
- [Citing this work](#cite)
- [Contributing](#contribute)

Where applicable, further details are supplied in individual `README.md` files in the `code`, `data`, `materials`, and `results` folders respectively.


<div id="study"></div>

## Study summary

Prosocial behavior and empathy are important aspects of developing social relations in childhood. Prior studies
showed protracted structural development of social brain regions associated with prosocial behavior. However, it
remains unknown how structure of the social brain is influenced by genetic or environmental factors, and
whether overlapping heritability factors explain covariance in structure of the social brain and behavior. The
current study examined this hypothesis in a twin sample (aged 7???9-year; N = 512). Bilateral measures of surface
area and cortical thickness of the medial prefrontal cortex (mPFC), temporo-parietal junction (TPJ), posterior
superior temporal sulcus (pSTS), and precuneus were analyzed. Results showed genetic contributions to surface
area and cortical thickness for all brain regions. We found additional shared environmental influences for TPJ,
suggesting that this region might be relatively more sensitive to social experiences. Genetic factors also influenced
parent-reported prosocial behavior (A = 45%) and empathy (A = 59%). We provided initial evidence that
the precuneus shares genetically determined variance with empathy, suggesting a possible small genetic overlap
(9%) in brain structure and empathy. These findings show that structure of the social brain and empathy are
driven by a combination of genetic and environmental factors, with some factors overlapping for brain structure
and behavior.


<div id="data"></div>

## Data summary

For this paper we used a sample of 512 participants. Since some participants missed data on either behavioral or neuroimaging measures, only subsets of participants were included in the final analyses. For a more thorough description see the methods section of the publication.
A flowchart of participant inclusion is visualized below.

Figure 1. Flowchart of inclusion of samples (including demographic information) at various stages of the study.
<!-- data summary figure, if available -->
<img src="assets/Flowchart_participants.png" alt="data-figure" style="width: 60%; text-align: center"/>
Note. MZ ?? monozygotic twin pairs; 1 Diagnosed Axis-I disorders: ADHD and/or ADD (eight participants), PDD-NOS (one participant), generalized anxiety disorder
(GAD; one participant); 2 Diagnosed Axis-I disorders: ADHD and/or ADD (six participants), PDD-NOS (one participant), GAD (one participant); 3 Diagnosed Axis-I
disorders: ADHD and/or ADD (five participants), PDD-NOS (one participant), GAD (one participant).


### Data access

Data that was used to generate the results and figures in the publication can be found in the DATA directory of this repository. 
Raw data can be accessed at [insert link Dataverse publication package].

Note that the European General Data Protection Regulation (GDPR) prevents us from sharing raw MRI data as this could compromise the privacy of research participants. 
For additional information please contact Mara van der Meulen at m.van.der.meulen@fsw.leidenuniv.nl


<div id="materials"></div>

## Materials summary

See publication in __Developmental Cognitive Neuroscience_._

<div id="methods"></div>

## Methods summary

See publication in __Developmental Cognitive Neuroscience_._


<div id="reproduce"></div>

## Reproducing the results

The visualisation of the within-twin correlations of brain structure (as reported in the Supplementary files, Figure S1) can be reproduced by clicking the button
Launch Binder at the top of the page. This will generate a RMarkdown file, which can be executed to show the scatterplots.

To reproduce the results of the behavioral genetic modelling, follow the manual in the folder _Results._


<div id="cite"></div>

## Citing this work

Content in this publication package is shared under the CC BY license. When referring to this work, or when creating derivatives from it, please cite it as:

> `publication-package-citation`

When referring to the manuscript, please cite it as:

> van der Meulen, M., Wierenga, L.M., Achterberg, M., Drenth, N., van IJzendoorn, M.H., & Crone, E.A. (2020). Genetic and environmental influences on structure of the social brain in childhood. Developmental Cognitive Neuroscience, 44, 100782.


<div id="contribute"></div>

## Contributions / feedback

Feedback and contributions are very welcome. If you have any comments, questions or suggestions about this work, please [create an issue](`issue-url`) in this repository.

