
Melanoma  model (continuous-time approach)

To try the model you need NetLogo 6: https://ccl.northwestern.edu/netlogo/

To produce the model from the ESSN net you need greatSPN3: https://github.com/greatspn/SOURCES

/*************************************************/

The starting point is represented by the Melanoma_nlogo.PNPRO file. In this file various subnets representing the involved agent types are presented (Ccells, ABandAscells, EandEscells, Ncells, Agcells). Then, the composition tab shows how composition has been exploited on tagged transitions using a unary conjucated policy to obtain the composed Melanoma model, that has been duplicated for editing in the tab Melanoma. This net considers as intitial marking only 3 Ccells and the Env meta-agent.
/*************************************************/

The generated model can be thus directly loaded within NetLogo. This model already include plots. However reporting functions for storing data into csv files is not implemented yet. For such reason we also manually included the required modifications. See the SEIRS Example to exactly know which modifications have been done to the file in order to obtain csv output.

Furthermore, as GreatSPN does not automatically manage general functions and read arcs related to general functions, these have been manually added within the NetLogo code and are presented into the file Melanoma_netlogo.netlogo. 

For example, for transition Ckill that both includes general functions according to Michaelis-Menten kinetics as well as read arcs, we have modified the code in two points, for rate calculation and rule execution, as follows:

    ;; transition Ckill - rate calculation
    set _A1 Ecells with [place = Es AND (TRUE)] ;;Ecells are leaders
    if any? _A1 [
      ask _A1 [
        let countInstances 0
        let xe [who] of self
        let _A2 Ccells with [place = C AND (TRUE)] ;; Each Ecell ask to the Ccells it can interact with to count themselves
        if any? _A2 [
          ask _A2 [
            let xc [who] of self
            set countInstances  countInstances + 1
          ]
        ]
        ;; summing up all rates
        ;;set myrate replace-item 2 myrate (countInstances * (alpha3)) ;; original commented code for Mass-Action law kinetics
        let ASS count ABB with [place = As AND (TRUE)] ;; Counting the number of AB as for read Arc
        set myrate replace-item 2 myrate (countInstances * (alpha3) *  ((ASS + k2)/(ASS + k3)) * (1 - alpha4) ) ;; modified code for Michaelis-Menten law kinetics and read arc
      ]
    ]
    ;...

    ;...
         ;; chosenAgent is leader of Ckill - rule execution
              let targetRate random-float (item 2 myrate)
              let xe [who] of self
              let _AA2 Ccells with [place = C AND (TRUE)]
              if any? _AA2 [
                ask _AA2 [
                  if NOT bindingSelected [
                    let xc [who] of self
                    let ASS count ABB with [place = As AND (TRUE)] ;; Counting the number of AB as for read Arc
                    ;; set targetRate targetRate - (alpha3)   ; original code
                    set targetRate targetRate - (alpha3) *  ((ASS + k2)/(ASS + k3)) * (1 - alpha4) ;; modified code to select the right CCell that will be killed according to right rule rate
                    if-else targetRate > 0 [ ]
                    [
                      ;; fire this binding
                      set bindingSelected true

                      ;; agent xe is modified
                      ask turtle xe [
                        set place Es
                      ]

                      ;; agent xc is killed
                      ask turtle xc [die]

                    ]
                  ]
                ]
              ]
            ]

/*************************************************/

This model also includes inital conditions for vaccinations in the "setup" procedure, and rule rates set as presented in the article.

/*************************************************/

Tho plots are already represented into the interface. They show the sub_populations number (one for each place) vs time


/*************************************************/

If you want to execute multiple simulations at a time you can try the "behaviorspace" functionality from the "tools" menu, where you wil find one pre-defined experiment that carries 100 simulation with initial random seeds from 0 to 99 and a stop time set to 20.

Please refer to the NetLogo manual for further assistance.
