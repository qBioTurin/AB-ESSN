# AB-ESSN
In  this  github page we show how the **GreatMod** framework can be efficiently exploited to define model by exploiting the both the extended stochastic symmetric net (ESSN) and agent based model (ABM)  formalisms. The potentiality of the approach is showed through two case studies: 

1. using the AB-ESSN translation for the realization of  computational epidemiology model;
2. exploiting a compositional approach for the definition of a computational immunology model.

We exploit the framework, called GreatMod, developed by [q-Bio group](https://www.cs.unito.it/do/gruppi.pl/Show?_id=lxu3) for  the  analysis  of  biological  and  epidemiological  systems. All the details regarding the framework, and the R package *epimod*, can be found at the following link: [GreatMod](https://qbioturin.github.io/epimod/).

## SEIR model 

### SSA folder

In this folder all the files necessary to reproduce the simulation of the SEIRS model are reported. 
In the *main.R* file all the steps to run the SSA algorithm to simulate the model are reported, while in *Plot&Test.R* the commands to generate the images and to run the statistical tests are reported.

### ABM folder

In this folder all the files necessary to reproduce the simulation of the SEIRS
obtained using the ABM are reported.

## Melanoma model

<img src="./Melanoma/Plots/MelanomaModel.png" alt="Fig.1) Composed model of Immune system and Melanoma cells behavior."  />
<p class="caption">
Fig.1) AB-ESSN composed model of Immune system and Melanoma cells behavior.
</p>

This case study is inspired by the ordinary differential equations (ODEs) model presented in this [work](https://pubmed.ncbi.nlm.nih.gov/22701144/).
Such model reproduced the immune response stimulated by OT1 activated cytotoxic T cells with Anti-CD 137 immunostimulatory monoclonal antibodies against melanoma,  one of the most aggressive malignant tumors.

The composed, decolored models and the subnets necessary for the composition are all stored in the PNPRO file in *Melanoma/SSA/Net* folder.

### SSA folder

In the *Main.R* file all the steps to run the SSA algorithm starting from the decolored model are reported, while in *Rfunction/PlotsGeneration.R* it is possible to find the functions to generate the images.

### ABM folder
