NetLogo SEIRS model (continuous-time approach)

To try the model you need NetLogo 6.2.0

NetLogo is downlodable from here: https://ccl.northwestern.edu/netlogo/

/*************************************************/

Once loaded, you can run the simulation with the "go" 
button or "step" button (to move one tick at a time).
You need to hit the "setup" button in advance in order 
to establish the initial conditions (i.e. grid size,
populations, rates etc.)

/*************************************************/
Tho plots are represented into the interface.
The first plots population vs tick (or event). 
The second one shows the population vs real (calculated) time 
(see. the paper for more details on how this is calculated)

/*************************************************/
Each simulation saves a <seed>.csv file (with the results 
obtained at time 0, 1, ... up to endtime).
If you with to change this to have more granularity, 
inside the "to go" procedure you have to change 
the counter increment, from

    set counter (counter + 1)
  
to 

    set counter  precision (counter + <delta>) 3

Where <delta> is you time-step size (i.e., 0.1)

/*************************************************/
Each input field has a label to espain its meaning

number-of-young  -> initial population of young 
people (with delta1 death rate). Equally divided 
in each patch

number-of-mid  -> initial population of mid people
(with delta2 death rate). Equally divided 
in each patch

number-of-old  -> initial population of old people
(with delta3 death rate). Equally divided
in each patch

number-of-infected -> initial number of infected people.
In the current implementation will be set all
to mid-age and put on patch 0 0

xmax -> number of columns for the simulation (patches)

ymax -> number of rows for simulation  (patches)

seed -> initial seed for pseudo-random number 
generator (if set to -1 the seed will be
chosen randomly by NetLogo)

inf ->  Rate of infected people to infect
susceptible (interaction rule). The susceptible 
will become exposed

mu -> Latency rate of exposed people to develop 
the disease end become infected (transition rule)

pmove -> movement rate. Rate of susceptible, infected,
and exposed people to randomly move from a patch
to another (transition rule). Actually, recovered don't move.

delta1, delta2, delta3 -> Death rates for young, 
mid, and old people, respectively.

phi -> Loss of immunization rate. Rate for 
recovered people to become again susceptible

Rho -> Recovery rate. Rate for infected people 
to recover from the disease and become recovered.

/*************************************************/
If you want tu execute multiple simulations at a time you 
can try the "behaviorspace" functionality from the "tools"
menu, where you wil find two pre-defined experiments.

Please refer to the NetLogo manual for further assistance.


