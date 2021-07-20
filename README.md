# AM-ESSN
In  this  github page  we  propose  an  extended  version  of  the  Susceptible-Exposed-Infected-Recovered-Susceptible (SEIRS) model considering the population space and age distribution. The model is defined by exploiting the both the extended stochastic symmetric net (ESSN) and agent based model (ABM)  formalisms.

## ABM folder

In this folder all the files necessary to reproduce the simulation of the SEIRS
obtained using the ABM are reported.

## ESSN folder

In this folder all the files necessary to reproduce the simulation of the SEIRS model are reported. We exploit the framework, called GreatMod, developed by [q-Bio group](https://www.cs.unito.it/do/gruppi.pl/Show?_id=lxu3) for  the  analysis  of  biological  and  epidemiological  systems. All the details regarding the framework, and the R package *epimod*, can be found at the following link: [GreatMod](https://qbioturin.github.io/epimod/).

In the *main.R* file all the steps to run the SSA algorithm to simulate the model are reported, while in *Plot&Test.R* the commands to generate the images and to run the statistical tests are reported.
