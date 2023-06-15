# AB-ESSN
In  this  github page we show how the **GreatMod** framework can be efficiently exploited to define model by exploiting the both the extended stochastic symmetric net (ESSN) and agent based model (ABM)  formalisms. The potentiality of the approach is showed through two case studies: 

1. using the AB-ESSN translation for the realization of  computational epidemiology model;
2. exploiting a compositional approach for the definition of a computational immunology model.

We exploit the framework, called GreatMod, developed by [q-Bio group](https://qbio.di.unito.it/) for  the  analysis  of  biological  and  epidemiological  systems. All the details regarding the framework, and the R package *epimod*, can be found at the following link: [GreatMod](https://qbioturin.github.io/epimod/). 
In particular, the installation of the workflow and the opening of the Petri Net models requires to download the last version of the [GreatSPN](https://github.com/greatspn/SOURCES/blob/master/docs/INSTALL.md) editor.

## Annex 1
Supplementary file for manuscript:
From compositional Petri Net modeling to macro and micro simulation by means of Stochatic Simulation and Agent-Based models
by
ELVIO AMPARORE, MARCO BECCUTI, PAOLO CASTAGNO, and SIMONE PERNICE, GIULIANA FRANCESCHINIS and MARZIO PENNISI
submitted to
ACM Transactions on Modeling and Performance Evaluation of Computing Systems

The file contains additional details about the translation algortihm from ESSN to NetLogo format and some considerations about the correctness of the translation. 

## SEIR model 

### SSA folder

In this folder all the files necessary to reproduce the simulation of the SEIRS model are reported:
  
  1. the *main.R* file reports all the steps to run the SSA algorithm to simulate the model, 
  2. the *Plot&Test.R* reports the commands to generate the images and to run the statistical tests.

### ABM folder

In this folder all the files necessary to reproduce the simulation of the SEIRS
obtained using the ABM are reported.

## Melanoma model

<img src="./Melanoma/SSA/Plots/MelanomaModel.png" alt="Fig.1) Composed model of Immune system and Melanoma cells behavior."  />
<p class="caption">
Fig.1) AB-ESSN composed model of Immune system and Melanoma cells behavior.
</p>

This case study is inspired by the ordinary differential equations (ODEs) model presented in this [work](https://pubmed.ncbi.nlm.nih.gov/22701144/).
Such model reproduced the immune response stimulated by OT1 activated cytotoxic T cells with Anti-CD 137 immunostimulatory monoclonal antibodies against melanoma,  one of the most aggressive malignant tumors.

The composed, decolored models and the subnets necessary for the composition are all stored in the PNPRO file in *Melanoma/SSA/Net* folder.

### SSA folder

In this folder all the files necessary to reproduce the simulation of the Melanoma model. In particular
  
  1. *Main.R* reports all the steps to run the SSA algorithm starting from the decolored model 
  2. *Rfunction/PlotsGeneration.R* reports the functions to generate the images.
  
### ABM folder
In this folder all the files necessary to compose the final model, as well as, obtain the netlogo code for  the simulation of the Melanoma model are reported.
