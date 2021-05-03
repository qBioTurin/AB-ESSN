extensions [rnd] ;;extension for simplify the roulette wheel selection of agents
globals [time gammatot counter] ;; time is for real time calculation; gammatot is total rate; counter for printing purposes
breed [people individual] ; agentset  used in the simulation


;;we will use agent colors for agent state
;; color == red -> infect
;; color == cyan -> exposed
;; color == green -> recovered
;; color == yellow -> susceptible


turtles-own [age pdelta tgamma]  ; ;age for 3 categories; pdelta for death rate according rate; tgamma for local calculation of agent rate
patches-own [S Ex I I1 I2 I3 R gamma update] ; ;0 interaction not done, 1 interaction done

;; this procedures sets up the model
to setup
  clear-all

  if seed != -1 [
    random-seed seed  ;;to have fixed or random seed
  ]
  set time  0 ;; setting real time = 0
  let xmin  (-1 * xmax) ; setting grid dimensions
  let ymin  (-1 * ymax)

  set-patch-size 10 + (100 / (xmax + 2))  ;; scaling for visualization
  resize-world 0 xmax - 1 0 ymax - 1
  set counter  0 ;; for printing purposes


  create-people number-of-infected [  ;; create the initial infected in a fixed patch, ie. patch 0 0
      setxy 0 0
      set color red ;; infected
      set age 2     ;; age class set to 2
      set pdelta delta2 ;; setting death rate
    ]

  ask patches [
    set update 1


    sprout-people number-of-young / (xmax * ymax) [  ;; create the initial young susceptible agents, equally distributed in all the positions
      setxy pxcor pycor
      set color yellow
      set pdelta delta1
      set age 1
    ]
    sprout-people number-of-mid / (xmax * ymax ) [  ;; create the initial mid susceptible agents, equally distributed in all the positions
      setxy pxcor pycor
      set color yellow
      set pdelta delta2
      set age 2
    ]
    sprout-people number-of-old / (xmax * ymax ) [  ;; create the initial old susceptible agents, equally distributed in all the positions
      setxy pxcor pycor
      set color yellow
      set pdelta delta3
      set age 3
    ]

  ]
  reset-ticks

end

;; makes the model run

;; make the model run
to go
  if ticks = 0 [reset-timer open-file ] ;; auxiliary procedures for printing results in a csv file

  if time > endtime [  ;;stop conditon
    show timer
    close-file
    stop
  ]



    set gammatot 0
    ask patches with [update = 1]  [set S count turtles-here  with [color = yellow]] ;; turtles of type S in each patch necessary for calculating infection rates according mass action
    ask turtles-on patches with [update = 1] [
      (
        if-else color = red [set tgamma  S * inf + rho +  pmove + pdelta] ;; infected agents calculate their rate
        color = yellow [set tgamma pmove] ;; susceptible agents calculate their rate
        color = cyan [set tgamma mu + pmove] ;; exposed agents calculate their rate
        [set tgamma phi] ;; recovered agents calculate their rate
      )
    ]
    ask patches with [update = 1] [
      set gamma sum  [tgamma] of turtles-here ;; rate per patch
      set update 0
    ]
    set gammatot sum [gamma] of patches ;; global rate

    let increment ((-1 /(gammatot)) * ln(random-float 1)) ;; time increment calculation
    if ((time + increment) > counter)  [ ;; printing traces at given time intervals i.e., for timer = 1, 2, 3, ...
       report-results-2
       set counter (counter + 1)
    ]

    set time  time + increment

    let choice rnd:weighted-one-of turtles [tgamma] ;;roulette-wheel selection according to agents' rate
    ask choice [
      ask patch-here [set update 1] ;; changing the state of the patch for rate update
     ;; selected an infected agent
      (if-else color = red [  ;; the infected agent calculates the rates for their actions
          let myp1 S * inf / tgamma
          let myp2  rho   / tgamma
          let myp3 pmove  / tgamma

          let pp random-float 1
          (
            if-else pp <= myp1 ;; the infected agent  choses to infect a turtle
            [
              let friend one-of turtles-here with [color = yellow]
              ask friend [
                set color  cyan  ;; becoming exposed
              ]
            ]
            pp <= myp1 + myp2 ;; the infected agent  recovers
            [
              set color  green
            ]
            pp <= myp1 + myp2 + myp3 ;; the infected agent  moves to another random position
            [
            random_move

            ]
            [
              die ;;the infected agent  moves dies
            ]
          )
        ]

        color = yellow
      ;;we have chosen a random susceptible instead
      [

          random_move  ;;as the susceptible is a passive agent for infection rule (carried by infected) it can only move.
      ]
       color = green ;; we chose a recovered
       [
          set color yellow  ;; the recovered can only loose its immunization status and becomes again susceptible
       ]
       ;; color = cyan
      [                 ;; last possibility, we choose an exposed agent
          let myp1 mu / tgamma
          let pp random-float 1
            if-else pp <= myp1
            [
                set color  red  ;; the exposed becomes infected
            ]
            [
                random_move   ;; the exposed moves to another random position (patch)
            ]
      ]
     )

  ]

  tick

end


to random_move  ;; procedure used to move to another random position
  let next one-of other patches
            while [next = patch-here]   [set next one-of other patches]
                ask next [set update 1]
              move-to next
end

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
        file-print (word counter " " count turtles with [color = yellow] " "  count turtles with [color = cyan] " "  count turtles with [color = red] " "  count turtles with [color = green] )
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
755
270
884
400
-1
-1
24.285714285714285
1
10
1
1
1
0
1
1
1
0
4
0
4
1
1
1
ticks
30.0

BUTTON
270
270
336
303
setup
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
365
270
428
303
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
272
9
732
239
Population over Ticks
Time
Population
0.0
10.0
0.0
1100.0
true
true
"" ""
PENS
"susceptible" 1.0 0 -1184463 true "" "plot count people with [color = yellow ]"
"infected" 1.0 0 -8053223 true "" "plot count people with [color = red ]"
"recovered" 1.0 0 -15575016 true "" "plot count people with [color = green ]"
"exposed" 1.0 0 -11221820 true "" "plot count people with [color = cyan ]"

SLIDER
25
400
230
433
xmax
xmax
1
100
5.0
1
1
NIL
HORIZONTAL

SLIDER
25
480
230
513
seed
seed
-1
10000
0.0
1
1
NIL
HORIZONTAL

INPUTBOX
25
60
260
120
number-of-young
200.0
1
0
Number

INPUTBOX
25
255
260
315
number-of-infected
5.0
1
0
Number

PLOT
750
10
1215
240
population over time (time scaled)
NIL
NIL
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"susceptible" 1.0 0 -987046 true "" "plotxy time count turtles with [color = yellow]"
"infected" 1.0 0 -2674135 true "" "plotxy time count turtles with [color = red]"
"recovered" 1.0 0 -10899396 true "" "plotxy time count turtles with [color = green]"
"exposed" 1.0 0 -11221820 true "" "plotxy time count turtles with [color = cyan]"

INPUTBOX
545
265
692
325
endtime
10.0
1
0
Number

SLIDER
25
440
230
473
ymax
ymax
1
100
5.0
1
1
NIL
HORIZONTAL

INPUTBOX
430
375
577
435
mu
0.2
1
0
Number

INPUTBOX
275
550
422
610
phi
0.01
1
0
Number

INPUTBOX
435
550
580
610
rho
0.125
1
0
Number

INPUTBOX
275
465
422
525
delta1
0.001
1
0
Number

INPUTBOX
430
465
577
525
delta2
0.01
1
0
Number

INPUTBOX
585
465
732
525
delta3
0.2
1
0
Number

INPUTBOX
275
375
420
435
inf
0.08
1
0
Number

INPUTBOX
585
375
732
435
pmove
0.2
1
0
Number

INPUTBOX
25
125
260
185
Number-of-mid
400.0
1
0
Number

INPUTBOX
25
190
260
250
number-of-old
400.0
1
0
Number

BUTTON
460
270
523
303
step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

TEXTBOX
30
30
180
56
Initial  conditions on populations\n
11
0.0
1

TEXTBOX
25
380
175
398
Grid size and seed settings
11
0.0
0

TEXTBOX
280
445
430
463
Death rates per age
11
0.0
1

TEXTBOX
275
355
425
373
infection rate
11
0.0
1

TEXTBOX
590
355
740
373
movement rate
11
0.0
1

TEXTBOX
545
245
695
263
Final simulation time\n
11
0.0
1

TEXTBOX
275
530
435
556
Loss of immunization rate
11
0.0
1

TEXTBOX
435
530
585
548
Recovery rate 
11
0.0
1

TEXTBOX
430
355
580
373
Latency rate\n
11
0.0
1

TEXTBOX
270
255
420
273
init the sim
11
0.0
1

TEXTBOX
365
255
515
273
exec the sim
11
0.0
1

TEXTBOX
460
255
610
273
step by step
11
0.0
1

@#$#@#$#@
COPYRIGHT

Beccuti, M., Castagno, P., Franceschinis, G., Pennisi, M., and Pernice, S.

Agent-Based Simulation and Stochastic Simulation of Petri Net epidemiological models:
how to get the best of both worlds

submitted to QEST 2021
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

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

moose
false
0
Polygon -7500403 true true 196 228 198 297 180 297 178 244 166 213 136 213 106 213 79 227 73 259 50 257 49 229 38 197 26 168 26 137 46 120 101 122 147 102 181 111 217 121 256 136 294 151 286 169 256 169 241 198 211 188
Polygon -7500403 true true 74 258 87 299 63 297 49 256
Polygon -7500403 true true 25 135 15 186 10 200 23 217 25 188 35 141
Polygon -7500403 true true 270 150 253 100 231 94 213 100 208 135
Polygon -7500403 true true 225 120 204 66 207 29 185 56 178 27 171 59 150 45 165 90
Polygon -7500403 true true 225 120 249 61 241 31 265 56 272 27 280 59 300 45 285 90

moose-face
false
0
Circle -7566196 true true 101 110 95
Circle -7566196 true true 111 170 77
Polygon -7566196 true true 135 243 140 267 144 253 150 272 156 250 158 258 161 241
Circle -16777216 true false 127 222 9
Circle -16777216 true false 157 222 8
Circle -1 true false 118 143 16
Circle -1 true false 159 143 16
Polygon -7566196 true true 106 135 88 135 71 111 79 95 86 110 111 121
Polygon -7566196 true true 205 134 190 135 185 122 209 115 212 99 218 118
Polygon -7566196 true true 118 118 95 98 69 84 23 76 8 35 27 19 27 40 38 47 48 16 55 23 58 41 71 35 75 15 90 19 86 38 100 49 111 76 117 99
Polygon -7566196 true true 167 112 190 96 221 84 263 74 276 30 258 13 258 35 244 38 240 11 230 11 226 35 212 39 200 15 192 18 195 43 169 64 165 92

newwolf
false
0
Polygon -7500403 true true 20 205 26 181 45 154 54 144 70 135 80 135 98 133 132 132 128 129 161 126 178 123 191 123 212 122 225 111 226 122 224 123 234 120 247 113 243 124 258 131 261 135 281 138 276 152 254 155 246 169 235 174 219 182 198 189 194 213 194 228 196 239 204 246 190 248 187 232 184 217 185 198 183 225 190 248 193 255 182 255 174 226 173 200 135 208 117 204 101 205 80 207 77 177 80 216 67 231 52 238 54 249 61 259 65 263 55 265 45 245 54 265 46 264 38 254 34 235 39 225 46 218 46 201 41 209 35 218 24 220 21 211 21 216
Line -16777216 false 275 153 259 150
Polygon -16777216 true false 253 133 245 131 245 133

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
  <experiment name="5zones_Total_susceptible_2000_1000_sims" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <final>my-timer " 5 zones"</final>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="behavior">
      <value value="&quot;new_version_v2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-mid">
      <value value="800"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pmove">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ymax">
      <value value="1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="0" step="1" last="999"/>
    <enumeratedValueSet variable="phi">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="xmax">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="endtime">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mu">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="delta1">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-old">
      <value value="800"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-infected">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="delta2">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-young">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="delta3">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rho">
      <value value="0.125"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="inf">
      <value value="0.08"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20zones_Total_susceptible_1000_1000_sims" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <final>my-timer " 5 zones"</final>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="behavior">
      <value value="&quot;new_version_v2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-mid">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pmove">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ymax">
      <value value="4"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="0" step="1" last="999"/>
    <enumeratedValueSet variable="phi">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="xmax">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="endtime">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mu">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="delta1">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-old">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-infected">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="delta2">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-young">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="delta3">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rho">
      <value value="0.125"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="inf">
      <value value="0.08"/>
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
1
@#$#@#$#@
