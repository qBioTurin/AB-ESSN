;; preamble
extensions [rnd]
globals [counter k1 k2 k3 M C0 p q alpha11 unosuTau alpha8 alpha10 alpha3 alpha1 alpha2 h alpha6 alpha4 unosuTinj alpha5 alpha9 alpha7 time gammatot Einj Ab Etravel Abtravel Es As C N Ag environment]

;; declare main agent classes
breed [Ecells a_Ecells]
breed [ABB a_ABB]
breed [Ccells a_Ccells]
breed [Ncells a_Ncells]
breed [AGG a_AGG]
breed [ENV a_ENV]
;; declare support classes (for attributes)

;; Agent attributes
ABB-own [place myrate totrate]
AGG-own [place myrate totrate]
Ccells-own [place myrate totrate]
ENV-own [place myrate totrate]
Ecells-own [place myrate totrate]
Ncells-own [place myrate totrate]
;; Support agent attributes

;; model setup procedure
to setup
  ca ;; clear all
  if seed != -1 [ random-seed SEED ]
  reset-ticks
  set alpha11 1.0
  set unosuTau 1.0
  set alpha8 0.04621
  set alpha10 0.03301
  set alpha3 0.0033
  set alpha1 0.2165
  set alpha2 0.01269
  set h 0.01
  set alpha6 0.1
  set alpha4 0.21
  set unosuTinj 0.5
  set alpha5 0.07701
  set alpha7 0.095
  set alpha9 0.000001
  set k1 1
  set k2 0.1
  set k3 5
  set M  20
  set C0 100
  set p  76
  set q  100
  ;; place identifiers
  set Einj 1000
  set Ab 1001
  set Etravel 1002
  set Abtravel 1003
  set Es 1004
  set As 1005
  set C 1006
  set N 1007
  set Ag 1008
  set environment 1009

  ;; setup initial marking
  create-Ccells C0 [
    set place C
    set color [173 216 230]
  ]
  create-Ecells p [
    set place Einj
  ]
  create-ABB q [
    set place Ab
  ]
  create-Ncells M [
    set place N
  ]
  create-ENV 1 [
    set place environment
    set color [0 255 255]
  ]

  ;; setup static color subclasses of attribute color classes

  ;; setup support agents
  let attrCounter 0

  set time 0.0
end

to go
;;if STOPTIME > 0 AND time > STOPTIME [ STOP ]

  if ticks = 0 [reset-timer open-file ]
 ;; if not any? turtles with [color = red] [  ;; now check for any turtles, that is
                                            ;;print ticks
  ;;  show timer                                       ;;print time
  ;;  close-file
  ;;  stop
 ;; ]
  if time > STOPTIME  AND STOPTIME > 0[  ;;
                                          ;;print ticks
    show timer
    ;;print time
    close-file
    stop
  ]


let _A1 0
;; ask agents to initialize myrate
ask ABB [set myrate (list  0 0 0 0 0 ) set totrate 0.0 ]
ask AGG [set myrate (list  0 ) set totrate 0.0 ]
ask Ccells [set myrate (list  0 0 ) set totrate 0.0 ]
ask ENV [set myrate (list  0 ) set totrate 0.0 ]
ask Ecells [set myrate (list  0 0 0 0 0 0 0 ) set totrate 0.0 ]
ask Ncells [set myrate (list  0 0 ) set totrate 0.0 ]

;; transition Emigration
set _A1 Ecells with [place = Einj AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 6 myrate (countInstances * (alpha11))
  ]
]
;; transition Delay
set _A1 Ecells with [place = Etravel AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 0 myrate (countInstances * (unosuTau))
  ]
]
;; transition Amigration
set _A1 ABB with [place = Ab AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 4 myrate (countInstances * (alpha11))
  ]
]
;; transition Delay2
set _A1 ABB with [place = Abtravel AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 3 myrate (countInstances * (unosuTau))
  ]
]
;; transition Edeath
set _A1 Ecells with [place = Einj AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 3 myrate (countInstances * (alpha8))
  ]
]
;; transition Abdeath
set _A1 ABB with [place = Ab AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 2 myrate (countInstances * (alpha10))
  ]
]
;; transition Esdeath
set _A1 Ecells with [place = Es AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 1 myrate (countInstances * (alpha8))
  ]
]
;; transition Asdeath
set _A1 ABB with [place = As AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 0 myrate (countInstances * (alpha10))
  ]
]
;; transition NewC
set _A1 Ccells with [place = C AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 0 myrate (countInstances * (alpha1))
  ]
]
;; transition Ckill
set _A1 Ecells with [place = Es AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 0
    let xe [who] of self
    let _A2 Ccells with [place = C AND (TRUE)]
    if any? _A2 [
      ask _A2 [
        let xc [who] of self
        set countInstances  countInstances + 1
      ]
    ]
    ;; summing up all rates
    ;;set myrate replace-item 2 myrate (countInstances * (alpha3))
    let ASS count ABB with [place = As AND (TRUE)]
    set myrate replace-item 2 myrate (countInstances * (alpha3) *  ((ASS + k2)/(ASS + k3)) * (1 - alpha4) )
  ]
]
;; transition Cdeath
set _A1 Ccells with [place = C AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    ;;set myrate replace-item 1 myrate (countInstances * (alpha2))
    set myrate replace-item 1 myrate (countInstances * (alpha2) * ln (count _A1) )
  ]
]
;; transition NewN
set _A1 ENV with [place = environment AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 0 myrate (countInstances * (h) * M)
  ]
]
;; transition growEs
set _A1 Ncells with [place = N AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 0
    let xn [who] of self
    let _A2 AGG with [place = Ag AND (TRUE)]
    if any? _A2 [
      ask _A2 [
        let xag [who] of self
        set countInstances  countInstances + 1
      ]
    ]
    ;; summing up all rates
    set myrate replace-item 0 myrate (countInstances * (alpha6))
  ]
]
;; transition Ckill2
set _A1 Ecells with [place = Es AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 0
    let xe [who] of self
    let _A2 Ccells with [place = C AND (TRUE)]
    if any? _A2 [
      ask _A2 [
        let xc [who] of self
        set countInstances  countInstances + 1
      ]
    ]
    ;; summing up all rates
    ;;set myrate replace-item 5 myrate (countInstances * (alpha4))

      let ASS count ABB with [place = As AND (TRUE)]
      set myrate replace-item 5 myrate (countInstances * (alpha3) *  ((ASS + k2)/(ASS + k3))  * ( alpha4) )

  ]
]
;; transition Agkill
set _A1 AGG with [place = Ag AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 0 myrate (countInstances * (alpha5))
  ]
]
;; transition Nkill
set _A1 Ncells with [place = N AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 1
    ;; summing up all rates
    set myrate replace-item 1 myrate (countInstances * (h))
  ]
]
;; transition EskillsAs
set _A1 Ecells with [place = Es AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 0
    let xe [who] of self
    let _A2 ABB with [place = As AND (TRUE)]
    if any? _A2 [
      ask _A2 [
        let xab [who] of self
        set countInstances  countInstances + 1
      ]
    ]
    ;; summing up all rates
    set myrate replace-item 4 myrate (countInstances * (alpha9))
  ]
]
;; transition Esdup

set _A1 ABB with [place = As AND (TRUE)]
if any? _A1 [
  ask _A1 [
    let countInstances 0
    let xab [who] of self
    let _A2 Ecells with [place = Es AND (TRUE)]
    if any? _A2 [
      ask _A2 [
        let xe [who] of self
        set countInstances  countInstances + 1

      ]
    ]
    ;; summing up all rates
    let ASS count ABB with [place = As AND (TRUE)]
    set myrate replace-item 1 myrate (countInstances * (alpha7  * (1 /(1 + (k1 / ASS ))) / ASS )   )
    ;;set myrate replace-item 1 myrate (countInstances * (alpha7))


  ]
]

;; ask agents to update their myrate values, and then update gammatot
let allAgents (turtle-set ABB AGG Ccells ENV Ecells Ncells )

ask allAgents [set totrate sum myrate]
set gammatot sum [totrate] of allAgents
if gammatot = 0 [stop]
let increment ((-1 / gammatot) * ln(random-float 1))
set time  time + increment

  if ((time + increment) > counter)  [
       report-results-2
       ;;set counter (counter + 0.1)
      set counter  precision (counter + 0.1) 3
    ]

;; select the next agent that will perform an action
let chosenAgent rnd:weighted-one-of allAgents [totrate]

;; switch over the class of the chosen agent
ask chosenAgent [
  let bindingSelected false
  (if-else
  is-a_ABB? self [
    ;; select the next action performed by the chosen ABB
    let indices  n-values (length myrate) [ i -> i ]
    let pairs (map list indices myrate)
    let nextaction  first rnd:weighted-one-of-list pairs [ [var_P] -> last var_P ]
    (
      if-else
      nextaction = 0 [
        ;; chosenAgent is leader of Asdeath
        let targetRate random-float (item 0 myrate)
        let xab [who] of self
        set targetRate targetRate - (alpha10)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xab is killed
          ask turtle xab [die]

        ]
      ]
      nextaction = 1 [
        ;; chosenAgent is leader of Esdup
        let targetRate random-float (item 1 myrate)
        let xab [who] of self
        let _AA2 Ecells with [place = Es AND (TRUE)]
        if any? _AA2 [
          ask _AA2 [
            if NOT bindingSelected [
              let xe [who] of self
              let ASS count ABB with [place = As AND (TRUE)]
              set targetRate targetRate -  (alpha7  * (1 /(1 + (k1 / ASS ))) / ASS )
              if-else targetRate > 0 [ ]
              [
                ;; fire this binding
                set bindingSelected true

                ;; agent xab is modified
                ask turtle xab [
                  set place As
                ]

                ;; agent xe is modified
                ask turtle xe [
                  set place Es
                ]

                ;; agent xe1 is new
                hatch-Ecells 1 [
                  set place Es
                  set color [100 149 237]
                  set myrate 0
                  set totrate 0
                ]

              ]
            ]
          ]
        ]
      ]
      nextaction = 2 [
        ;; chosenAgent is leader of Abdeath
        let targetRate random-float (item 2 myrate)
        let xab [who] of self
        set targetRate targetRate - (alpha10)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xab is killed
          ask turtle xab [die]

        ]
      ]
      nextaction = 3 [
        ;; chosenAgent is leader of Delay2
        let targetRate random-float (item 3 myrate)
        let xab [who] of self
        set targetRate targetRate - (unosuTau)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xab is modified
          ask turtle xab [
            set place As
          ]

        ]
      ]
      nextaction = 4 [
        ;; chosenAgent is leader of Amigration
        let targetRate random-float (item 4 myrate)
        let xab [who] of self
        set targetRate targetRate - (alpha11)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xab is modified
          ask turtle xab [
            set place Abtravel
          ]

        ]
      ]
    )
  ]
  is-a_AGG? self [
    ;; select the next action performed by the chosen AGG
    let indices  n-values (length myrate) [ i -> i ]
    let pairs (map list indices myrate)
    let nextaction  first rnd:weighted-one-of-list pairs [ [var_P] -> last var_P ]
    (
      if-else
      nextaction = 0 [
        ;; chosenAgent is leader of Agkill
        let targetRate random-float (item 0 myrate)
        let xag [who] of self
        set targetRate targetRate - (alpha5)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xag is killed
          ask turtle xag [die]

        ]
      ]
    )
  ]
  is-a_Ccells? self [
    ;; select the next action performed by the chosen Ccells
    let indices  n-values (length myrate) [ i -> i ]
    let pairs (map list indices myrate)
    let nextaction  first rnd:weighted-one-of-list pairs [ [var_P] -> last var_P ]
    (
      if-else
      nextaction = 0 [
        ;; chosenAgent is leader of NewC
        let targetRate random-float (item 0 myrate)
        let xc [who] of self
        set targetRate targetRate - (alpha1)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xc is modified
          ask turtle xc [
            set place C
          ]

          ;; agent xc2 is new
          hatch-Ccells 1 [
            set place C
            set color [173 216 230]
            set myrate 0
            set totrate 0
          ]

        ]
      ]
      nextaction = 1 [
        ;; chosenAgent is leader of Cdeath
        let targetRate random-float (item 1 myrate)
        let xc [who] of self
        let CCC Ccells with [place = C AND (TRUE)]
        set targetRate targetRate - (alpha2) * ln (count CCC)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xc is killed
          ask turtle xc [die]

        ]
      ]
    )
  ]
  is-a_ENV? self [
    ;; select the next action performed by the chosen ENV
    let indices  n-values (length myrate) [ i -> i ]
    let pairs (map list indices myrate)
    let nextaction  first rnd:weighted-one-of-list pairs [ [var_P] -> last var_P ]
    (
      if-else
      nextaction = 0 [
        ;; chosenAgent is leader of NewN
        let targetRate random-float (item 0 myrate)
        let xenv [who] of self
        set targetRate targetRate - (h) * M
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xn is new
          hatch-Ncells 1 [
            set place N
            set color [30 144 255]
            set myrate 0
            set totrate 0
          ]

          ;; agent xenv is modified
          ask turtle xenv [
            set place environment
          ]

        ]
      ]
    )
  ]
  is-a_Ecells? self [
    ;; select the next action performed by the chosen Ecells
    let indices  n-values (length myrate) [ i -> i ]
    let pairs (map list indices myrate)
    let nextaction  first rnd:weighted-one-of-list pairs [ [var_P] -> last var_P ]
    (
      if-else
      nextaction = 0 [
        ;; chosenAgent is leader of Delay
        let targetRate random-float (item 0 myrate)
        let xe [who] of self
        set targetRate targetRate - (unosuTau)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xe is modified
          ask turtle xe [
            set place Es
          ]

        ]
      ]
      nextaction = 1 [
        ;; chosenAgent is leader of Esdeath
        let targetRate random-float (item 1 myrate)
        let xe [who] of self
        set targetRate targetRate - (alpha8)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xe is killed
          ask turtle xe [die]

        ]
      ]
      nextaction = 2 [
        ;; chosenAgent is leader of Ckill
        let targetRate random-float (item 2 myrate)
        let xe [who] of self
        let _AA2 Ccells with [place = C AND (TRUE)]
        if any? _AA2 [
          ask _AA2 [
            if NOT bindingSelected [
              let xc [who] of self
              let ASS count ABB with [place = As AND (TRUE)]
              set targetRate targetRate - (alpha3) *  ((ASS + k2)/(ASS + k3)) * (1 - alpha4)
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
      nextaction = 3 [
        ;; chosenAgent is leader of Edeath
        let targetRate random-float (item 3 myrate)
        let xe [who] of self
        set targetRate targetRate - (alpha8)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xe is killed
          ask turtle xe [die]

        ]
      ]
      nextaction = 4 [
        ;; chosenAgent is leader of EskillsAs
        let targetRate random-float (item 4 myrate)
        let xe [who] of self
        let _AA2 ABB with [place = As AND (TRUE)]
        if any? _AA2 [
          ask _AA2 [
            if NOT bindingSelected [
              let xab [who] of self
              set targetRate targetRate - (alpha9)
              if-else targetRate > 0 [ ]
              [
                ;; fire this binding
                set bindingSelected true

                ;; agent xe is modified
                ask turtle xe [
                  set place Es
                ]

                ;; agent xab is killed
                ask turtle xab [die]

              ]
            ]
          ]
        ]
      ]
      nextaction = 5 [
        ;; chosenAgent is leader of Ckill2
        let targetRate random-float (item 5 myrate)
        let xe [who] of self
        let _AA2 Ccells with [place = C AND (TRUE)]
        if any? _AA2 [
          ask _AA2 [
            if NOT bindingSelected [
              let xc [who] of self
              let ASS count ABB with [place = As AND (TRUE)]
              set targetRate targetRate - (alpha4) *  ((ASS + k2)/(ASS + k3))  * ( alpha4)
              if-else targetRate > 0 [ ]
              [
                ;; fire this binding
                set bindingSelected true

                ;; agent xe is modified
                ask turtle xe [
                  set place Es
                ]

                ;; agent xag is new
                hatch-AGG 1 [
                  set place Ag
                  set color [25 25 112]
                  set myrate 0
                  set totrate 0
                ]

                ;; agent xc is killed
                ask turtle xc [die]

              ]
            ]
          ]
        ]
      ]
      nextaction = 6 [
        ;; chosenAgent is leader of Emigration
        let targetRate random-float (item 6 myrate)
        let xe [who] of self
        set targetRate targetRate - (alpha11)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xe is modified
          ask turtle xe [
            set place Etravel
          ]

        ]
      ]
    )
  ]
  is-a_Ncells? self [
    ;; select the next action performed by the chosen Ncells
    let indices  n-values (length myrate) [ i -> i ]
    let pairs (map list indices myrate)
    let nextaction  first rnd:weighted-one-of-list pairs [ [var_P] -> last var_P ]
    (
      if-else
      nextaction = 0 [
        ;; chosenAgent is leader of growEs
        let targetRate random-float (item 0 myrate)
        let xn [who] of self
        let _AA2 AGG with [place = Ag AND (TRUE)]
        if any? _AA2 [
          ask _AA2 [
            if NOT bindingSelected [
              let xag [who] of self
              set targetRate targetRate - (alpha6)
              if-else targetRate > 0 [ ]
              [
                ;; fire this binding
                set bindingSelected true

                ;; agent xe is new
                hatch-Ecells 1 [
                  set place Es
                  set color [100 149 237]
                  set myrate 0
                  set totrate 0
                ]

                ;; agent xn is killed
                ask turtle xn [die]

                ;; agent xag is killed
                ask turtle xag [die]

              ]
            ]
          ]
        ]
      ]
      nextaction = 1 [
        ;; chosenAgent is leader of Nkill
        let targetRate random-float (item 1 myrate)
        let xn [who] of self
        set targetRate targetRate - (h)
        if-else targetRate > 0 [ ]
        [
          ;; fire this binding
          set bindingSelected true

          ;; agent xn is killed
          ask turtle xn [die]

        ]
      ]
    )
  ]
)]
tick

end


To open-file
  let namefile (word  seed ".csv")
  file-open   namefile
end

to close-file
file-close
end

to report-results
       ; let namefile (sentence seed ".csv")

        file-print (word time " " count turtles with [color = yellow] " "  count turtles with [color = cyan] " "  count turtles with [color = red] " "  count turtles with [color = green] )
       ; file-close
end

to report-results-2
       ; let namefile (sentence seed ".csv")

  file-print (word counter " " count ccells " " count ecells with [place = ES] " " count ABB with [place = AS] " " count  AGG " " count Ncells )
       ; file-close
end


to my-timer [ ExperimentName ]
        let thetime timer
        file-open "timers.csv"
        file-print (sentence ExperimentName "," thetime "," date-and-time )
        file-close
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
17
10
83
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
93
10
156
43
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
684
33
1162
324
plot 1
NIL
NIL
0.0
5.0
0.0
10.0
true
true
"" ""
PENS
"Ecells" 1.0 0 -10185235 true "" "plotxy time (count Ecells)"
"Ecells_Einj" 1.0 0 -8388608 true "" "plotxy time (count Ecells with [Place = Einj])"
"Ecells_Etravel" 1.0 0 -29696 true "" "plotxy time (count Ecells with [Place = Etravel])"
"Ecells_Es" 1.0 0 -65536 true "" "plotxy time (count Ecells with [Place = Es])"
"ABB" 1.0 0 -16728065 true "" "plotxy time (count ABB)"
"ABB_Ab" 1.0 0 -8388608 true "" "plotxy time (count ABB with [Place = Ab])"
"ABB_Abtravel" 1.0 0 -29696 true "" "plotxy time (count ABB with [Place = Abtravel])"
"ABB_As" 1.0 0 -65536 true "" "plotxy time (count ABB with [Place = As])"
"Ccells" 1.0 0 -5383962 true "" "plotxy time (count Ccells)"
"Ncells" 1.0 0 -14774017 true "" "plotxy time (count Ncells)"
"AGG" 1.0 0 -15132304 true "" "plotxy time (count AGG)"
"ENV" 1.0 0 -16711681 true "" "plotxy time (count ENV)"

INPUTBOX
17
63
166
123
SEED
1291.0
1
0
Number

INPUTBOX
16
138
165
198
STOPTIME
20.0
1
0
Number

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <steppedValueSet variable="SEED" first="0" step="1" last="99"/>
    <enumeratedValueSet variable="STOPTIME">
      <value value="20"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
