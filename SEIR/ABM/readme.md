NetLogo SEIRS model (continuous-time approach)

To try the model you need NetLogo 6: https://ccl.northwestern.edu/netlogo/

To produce the model from the ESSN net you need greatSPN3: https://github.com/greatspn/SOURCES

/*************************************************/

The starting point is represented by the SEIRS_nlogo.PNPRO file. In  this file the initial SEIRS ESSN net is represented. Then, the composition tab shows the composition of the transition infection, and presents as result the composed SEIRS net, that has been duplicated for editing in the tab SEIRS_composed. In such net we also  added an example initial marking with 90 susceptible equally divided into 3 ageclasses and position Z1, and  10 susceptible with age A2 (e.g. old) in position Z2.
To obtain the netlogo model select this last network and then do: "File->Export->Export in NetLogo format..."

/*************************************************/

The generated model (SEIRS_composed.nlogo) can be thus directly loaded within NetLogo. The model already include plots. However reporting functions for storing data into csv files is not implemented yet. For such reason we also manually included  the required modifications to store presented results into .csv files. Such functions  have manually been added at the end of the netlogo code:
    
;;****

;; auxiliary procedures for results reporting

;;****

    to open-file
    let namefile (word  seed ".csv")
    file-open   namefile
    end

    to close-file
    file-close
    end

    to report-results-2
            file-print (word counter " " count turtles with [color = yellow] " "  count turtles with [color = cyan] " "  count turtles with [color = red] " "  count turtles with [color =   green] )
          ; file-close
    end

    to my-timer [ ExperimentName ]
         let thetime timer
         file-open "timers.csv"
         file-print (sentence ExperimentName "," thetime "," date-and-time )
         file-close
    end
    
Furthermore, the variable counter has been added among the global variables.

Finally, to enable printing, the following code lines must been uncommented (remove the ";").

    ;if ticks = 0 [reset-timer open-file ]
    if STOPTIME > 0 AND time > STOPTIME [ 
        ;close-file  
    STOP ]  

    ;if ((time + increment) > counter)  [ 
    ;  report-results-2
    ;   set counter (precision (counter + 0.1) 3)
    ;]
  
/*************************************************/
   
The manual modifications for file saving allow to produce a <seed>.csv file (with the results  obtained at time 0.1, 0.2, ... up to endtime or stop by user).
Once the model is loaded, you can run the simulation with the "go" button.

If you with to change this to have more granularity, 
inside the "to go" procedure you have to change 
the counter increment, from

    set counter (counter + 0.1) 3
  
to 

    set counter  precision (counter + <delta>) 3

Where "<delta>" is you time-step size (i.e., 0.01)


/*************************************************/

Tho plots are already represented into the interface. They  show  the total population (PEOPLE) and the sub_populations (i.e., susceptible, exposed, infected, recovered) vs time 

/*************************************************/


/*************************************************/

 Note: The file seirs_v1.0.netlogo refers to previous work used for Epew2021 workshop and
 presents a version of the SEIRS model obtained by manually  traslating the algorithm into  code  
    
/*************************************************/

If you want to execute multiple simulations at a time you 
can try the "behaviorspace" functionality from the "tools"
menu, where you wil find one pre-defined experiment that carries 100 simulation with initial random seeds from 0 to 99.

Please refer to the NetLogo manual for further assistance.


