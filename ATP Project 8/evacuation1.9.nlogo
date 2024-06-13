globals [
  inside-colors
  exit-colors
  casualties
  cafeteria-deaths
  cafeteria-pop
  lobby-deaths
  lobby-pop
  long-hall-deaths
  long-hall-pop
  study-landscape-deaths
  study-landscape-pop
  office-deaths
  office-pop
  staged?
]

patches-own [
  original-color
]

turtles-own [
  in-office? ;; whether they are inside a room/office. Makes them focus on getting out of the room first before finding the exit.
  outside? ;; whether the agent is outside
  exit ;; patches representing exit door
  forward-speed ;; is changed when in a crowded area
  available-exits ;; list of available exits
  spawn-location ;; contains the color code representing the spawn-location
  obstacle?
  stuck?
  priority?
]
to build
  clear-all
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WORLD BUILDING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;import-pcolors "layout.jpg"

  ask patches [set pcolor white]

  ;; zone coloring
  ;; cafeteria
  ask patches with [pxcor >= -119 and pxcor <= 115 and pycor >= 202 and pycor <= 297] [set pcolor 139]
  ;; entrance lobby
  ask patches with [pxcor >= -101 and pxcor <= 116 and pycor >= 63 and pycor <= 201 ] [set pcolor 69]
  ;; long hallway
  ask patches with [pxcor >= 54 and pxcor <= 115 and pycor >= -292 and pycor <= 181 ] [set pcolor 49]
  ;; BBL
  ask patches with [pxcor >= -119 and pxcor <= 52 and pycor >= -292 and pycor <= -28] [set pcolor 99]
  ;; rooms / offcies
  ;; offices with less spawns
  ask patches with [pxcor >= -96 and pxcor <= -35 and pycor >= -249 and pycor <= -216] [set pcolor black]
  ask patches with [pxcor >= -96 and pxcor <= -35 and pycor >= -281 and pycor <= -251] [set pcolor black]
  ask patches with [pxcor >= -33 and pxcor <= 38 and pycor >= -281 and pycor <= -251] [set pcolor black]
  ask patches with [pxcor >= -33 and pxcor <= 38 and pycor >= -249 and pycor <= -216] [set pcolor black]
  ask patches with [pxcor >= 69 and pxcor <= 115 and pycor >= -111 and pycor <= -13] [set pcolor black]
  ask patches with [pxcor >= 69 and pxcor <= 115 and pycor >= -199 and pycor <= -113] [set pcolor black]
  ask patches with [pxcor >= -39 and pxcor <= 52 and pycor >= -26 and pycor <= 62] [set pcolor 9] ;; cover room
  ask patches with [pxcor >= -119 and pxcor <= -41 and pycor >= -26 and pycor <= 62] [set pcolor black]

  ;; outside patches
  ask patches with [pxcor >= -300 and pxcor <= 300 and pycor >= 297 and pycor <= 300] [set pcolor white]
  ask patches with [pxcor >= -300 and pxcor <= 300 and pycor >= -300 and pycor <= -293] [set pcolor white]
  ask patches with [pxcor >= -300 and pxcor <= -120 and pycor >= -300 and pycor <= 300] [set pcolor white]
  ask patches with [pxcor >= 116 and pxcor <= 300 and pycor >= -300 and pycor <= 300] [set pcolor white]
  ask patches with [pxcor >= -120 and pxcor <= -102 and pycor >= 63 and pycor <= 201] [set pcolor white]

  ;; black blocks (cafeteria kitchen, bathroom, elevator, stairs)
  ;ask patches with [pxcor >= -85 and pxcor <= 54 and pycor >= 202 and pycor <= 250] [set pcolor black]
  ask patches with [pxcor >= 92 and pxcor <= 116 and pycor >= 202 and pycor <= 250] [set pcolor  black]
  ask patches with [pxcor >= 67 and pxcor <= 84 and pycor >= 202 and pycor <= 250] [set pcolor  black]
  ask patches with [pxcor >= -58 and pxcor <= 53 and pycor >= 63 and pycor <= 181 ] [set pcolor black]
  ask patches with [pxcor >= -101 and pxcor <= 53 and pycor >= 63 and pycor <= 76] [set pcolor black]
  ask patches with [pxcor >= -96 and pxcor <= -84 and pycor >= -78 and pycor <= -55] [set pcolor black] ;; stairs
  ask patches with [pxcor >= -96 and pxcor <= -84 and pycor >= -179 and pycor <= -156] [set pcolor black] ;; stairs
  ask patches with [pxcor >= -29 and pxcor <= -6 and pycor >= 284 and pycor <= 296] [set pcolor black] ;; stairs

  ;ask patches with [pxcor >= 67 and pxcor <= 116 and pycor >= 60 and pycor <= 181] [set pcolor black] ;; mystery office
  ask patches with [pxcor >= 67 and pxcor <= 116 and pycor >= 10 and pycor <= 181] [set pcolor black] ;; mystery office
  ask patches with [pxcor >= 69 and pxcor <= 115 and pycor >= -292 and pycor <= -244] [set pcolor black] ;; weird block next to north exit

  ;; kitchen cafeteria
  ask patches with [pxcor >= -42 and pxcor <= 4 and pycor >= 239 and pycor <= 250] [set pcolor black]
  ask patches with [pxcor >= -85 and pxcor <= -61 and pycor >= 202 and pycor <= 250] [set pcolor black]
  ask patches with [pxcor >= 31 and pxcor <= 53 and pycor >= 202 and pycor <= 250] [set pcolor black]
  ask patches with [pxcor >= -41 and pxcor <= 4 and pycor >= 218 and pycor <= 226] [set pcolor black]
  ask patches with [pxcor >= -41 and pxcor <= 4 and pycor >= 203 and pycor <= 206] [set pcolor black]


  ;; touch up on edges
  ;; horizontal walls
  ask patches with [pxcor >= -120 and pxcor <= 116 and pycor = 297] [set pcolor black]
  ask patches with [pxcor >= -120 and pxcor <= -102 and pycor = 201] [set pcolor black]
  ask patches with [pxcor >= -120 and pxcor <= -102 and pycor = 63] [set pcolor  black]
  ask patches with [pxcor >= -120 and pxcor <= 116 and pycor =  -293] [set pcolor black]

  ask patches with [pxcor >= 68 and pxcor <= 116 and pycor = -243] [set pcolor black]
  ask patches with [pxcor >= 68 and pxcor <= 116 and pycor = -200] [set pcolor  black]
  ask patches with [pxcor >= 68 and pxcor <= 116 and pycor = -12] [set pcolor  black]
  ask patches with [pxcor >= 68 and pxcor <= 116 and pycor = 9] [set pcolor  black]
  ask patches with [pxcor >= 68 and pxcor <= 116 and pycor =  60] [set pcolor black]
  ask patches with [pxcor >= 68 and pxcor <= 116 and pycor = 181] [set pcolor black]

  ask patches with [pxcor >= -120 and pxcor <= 53 and pycor = -27] [set pcolor black]
  ask patches with [pxcor >= 68 and pxcor <= 116 and pycor = -112] [set pcolor black]
  ask patches with [pxcor >= -97 and pxcor <= 38 and pycor = -215 ] [set pcolor black]
  ask patches with [pxcor >= -97 and pxcor <= 38 and pycor = -250 ] [set pcolor black]
  ask patches with [pxcor >= -97 and pxcor <= 38 and pycor = -282 ] [set pcolor black]

  ask patches with [pxcor >= -85 and pxcor <= 53 and pycor = 202 ] [set pcolor  black]
  ask patches with [pxcor >= -85 and pxcor <=  53 and pycor = 250 ] [set pcolor black]

  ;; vertical walls
  ask patches with [pxcor = -120 and pycor >= 201 and pycor <= 297] [set pcolor black]
  ask patches with [pxcor = -102 and pycor >= 63 and pycor <= 201] [set pcolor black]
  ask patches with [pxcor = -120 and pycor >= -293 and pycor <= 63] [set pcolor black]
  ask patches with [pxcor = 53 and pycor >= -293 and pycor <= 63] [set pcolor black]

  ask patches with [pxcor = 68 and pycor >= -200 and pycor <= -12] [set pcolor black]
  ask patches with [pxcor = 68 and pycor >= -293 and pycor <= -243] [set pcolor black]

  ask patches with [pxcor = 116 and pycor >= -293 and pycor <= 297] [set pcolor black]
  ask patches with [pxcor = 67 and pycor >= 9 and pycor <= 181] [set pcolor black]
  ask patches with [pxcor = 92 and pycor >= 202 and pycor <= 250] [set pcolor black]
  ask patches with [pxcor = 84 and pycor >= 202 and pycor <= 250] [set pcolor black]
  ask patches with [pxcor = 68 and pycor >= 202 and pycor <= 250] [set pcolor black]
  ask patches with [pxcor = -97 and pycor >= -282 and pycor <= -215] [set pcolor black]
  ask patches with [pxcor = 39 and pycor >= -282 and pycor <= -215] [set pcolor black]
  ask patches with [pxcor = -34 and pycor >= -282 and pycor <= -215] [set pcolor black]
  ask patches with [pxcor = -40 and pycor >= -27 and pycor <= 65] [set pcolor black]


  ;; normal doors
  ask patches with [pxcor = 53 and pycor >= -198 and pycor <= -181] [set pcolor 99] ;; bb door
  ask patches with [pxcor = 53 and pycor >= -1 and pycor <= 9] [set pcolor 8]
  ;ask patches with [pxcor = 68 and pycor >= -139 and pycor <= -130] [set pcolor 8]
  ;ask patches with [pxcor = 68 and pycor >= -95 and pycor <= -86] [set pcolor 8]
  ;ask patches with [pxcor >= 2 and pxcor <= 11 and pycor = -215] [set pcolor 8]
  ;ask patches with [pxcor >= -78 and pxcor <= -69 and pycor = -215] [set pcolor 8]
  ;ask patches with [pxcor >= 2 and pxcor <= 11 and pycor = -282] [set pcolor 8]
  ;ask patches with [pxcor >= -78 and pxcor <= -69 and pycor = -282] [set pcolor 8]
  ;ask patches with [pxcor = 67 and pycor <= 8 and pycor = 16] [set pcolor 8]
  ;ask patches with [pxcor = 67 and pycor <= 80 and pycor = 89] [set pcolor white] mystery offices
  ;ask patches with [pxcor >= -58 and pxcor <= -49 and pycor = -27] [set pcolor 8]
  ask patches with [pxcor >= -60 and pxcor <= -42 and pycor = 202] [set pcolor 139]
  ask patches with [pxcor >= 5 and pxcor <= 30 and pycor = 202] [set pcolor 139]
  ask patches with [pxcor >= -60 and pxcor <= -43 and pycor = 250] [set pcolor 139]
  ask patches with [pxcor >= 5 and pxcor <= 30 and pycor = 250] [set pcolor 139]

  ;;;;;;;;;;;; tables
  ;; cafeteria
  ask patches with [pxcor >= -76 and pxcor <= -7 and pycor >= 272 and pycor <= 276][set pcolor black]
  ask patches with [pxcor >= -117 and pxcor <= -103 and pycor >= 210 and pycor <= 290][set pcolor black]
  ask patches with [pxcor >= 33 and pxcor <= 51 and pycor >= 253 and pycor <= 260][set pcolor black]
  ask patches with [pxcor >= 67 and pxcor <= 84 and pycor >= 253 and pycor <= 260][set pcolor black]
  ask patches with [pxcor >= 36 and pxcor <= 51 and pycor >= 288 and pycor <= 292][set pcolor black]
  ask patches with [pxcor >= 36 and pxcor <= 51 and pycor >= 272 and pycor <= 276][set pcolor black]
  ask patches with [pxcor >= 96 and pxcor <= 111 and pycor >= 288 and pycor <= 292][set pcolor black]
  ask patches with [pxcor >= 96 and pxcor <= 111 and pycor >= 272 and pycor <= 276][set pcolor black]
  ask patches with [pxcor >= 96 and pxcor <= 111 and pycor >= 255 and pycor <= 259][set pcolor black]
  ask patches with [pxcor >= 67  and pxcor <= 84 and pycor >= 253 and pycor <= 260][set pcolor black]
  ask patches with [pxcor >= -81 and pxcor <= -77 and pycor >= 253 and pycor <= 262][set pcolor black]
  ask patches with [pxcor >= -69 and pxcor <= -65 and pycor >= 253 and pycor <= 262][set pcolor black]
  ask patches with [pxcor >= -44 and pxcor <= -40 and pycor >= 253 and pycor <= 262][set pcolor black]
  ask patches with [pxcor >= -32 and pxcor <= -28 and pycor >= 253 and pycor <= 262][set pcolor black]
  ask patches with [pxcor >= -21  and pxcor <= -17 and pycor >= 253 and pycor <= 262][set pcolor black]
  ask patches with [pxcor >= -9 and pxcor <= -6 and pycor >= 253 and pycor <= 262][set pcolor black]
  ask patches with [pxcor >= 2 and pxcor <= 6 and pycor >= 253 and pycor <= 262][set pcolor black]
  ask patches with [pxcor >= -85 and pxcor <= -81 and pycor >= 285 and pycor <= 295][set pcolor black]
  ask patches with [pxcor >= -74 and pxcor <= -70 and pycor >= 285 and pycor <= 295][set pcolor black]
  ask patches with [pxcor >= -62 and pxcor <= -58 and pycor >= 285 and pycor <= 295][set pcolor black]
  ask patches with [pxcor >= -51 and pxcor <= -47 and pycor >= 285 and pycor <= 295][set pcolor black]
  ask patches with [pxcor >= -39 and pxcor <= -35 and pycor >= 285 and pycor <= 295][set pcolor black]

  ;; BBL
  ask patches with [pxcor >= -117 and pxcor <= -105 and pycor >= -46 and pycor <= -39][set pcolor black]
  ask patches with [pxcor >= -117 and pxcor <= -105 and pycor >= -61 and pycor <= -54][set pcolor black]
  ask patches with [pxcor >= -117 and pxcor <= -105 and pycor >= -74 and pycor <= -67 ][set pcolor black]
  ask patches with [pxcor >= -117 and pxcor <= -105 and pycor >= -89 and pycor <= -82 ][set pcolor black]
  ask patches with [pxcor >= -117 and pxcor <= -105 and pycor >= -104 and pycor <= -97][set pcolor black]
  ;ask patches with [pxcor >= -117 and pxcor <= -105 and pycor >= -117 and pycor <= -109][set pcolor black]
  ask patches with [pxcor >= -117 and pxcor <= -105 and pycor >= -152 and pycor <= -145 ][set pcolor black]
  ask patches with [pxcor >= -117 and pxcor <= -105 and pycor >= -166 and pycor <= -159][set pcolor black]
  ask patches with [pxcor >= -117 and pxcor <= -105 and pycor >= -180 and pycor <= -173][set pcolor black]

  ask patches with [pxcor >= -77 and pxcor <= -30 and pycor >= -69 and pycor <= -62][set pcolor black]
  ask patches with [pxcor >= -77 and pxcor <= -30 and pycor >= -93 and pycor <= -85][set pcolor black]
  ask patches with [pxcor >= -77 and pxcor <= -30 and pycor >= -118 and pycor <= -110][set pcolor black]
  ask patches with [pxcor >= -77 and pxcor <= -30 and pycor >= -145 and pycor <= -137][set pcolor black]

  ask patches with [pxcor >= -8 and pxcor <= 46 and pycor >= -85 and pycor <= -70] [set pcolor black]
  ask patches with [pxcor >= -80 and pxcor <= -24 and pycor >= -178 and pycor <= -164] [set pcolor black]
  ask patches with [pxcor >= -10 and pxcor <= 45 and pycor >= -57 and pycor <= -43] [set pcolor black]
  ask patches with [pxcor >= 19 and pxcor <= 46 and pycor >= -113 and pycor <= -98] [set pcolor black]
  ask patches with [pxcor >= 19 and pxcor <= 46 and pycor >= -141 and pycor <= -126] [set pcolor black]
  ask patches with [pxcor >= 30 and pxcor <= 46 and pycor >= -176 and pycor <= -150] [set pcolor black]
  ask patches with [pxcor >= -2 and pxcor <= 17 and pycor >= -177 and pycor <= -147] [set pcolor black]
  ask patches with [pxcor >= 3 and pxcor <= 5 and pycor >= -147 and pycor <= -130] [set pcolor black]

  ;; exits, big doors are 15-patches wide, small doors are 9-patches wide
  ask patches with [pxcor >= -103 and pxcor <= -101 and pycor >= 140 and pycor <= 155] [set pcolor 12] ;; main entrance exit door
 ; ask patches with [pxcor = -102 and pycor = 145] [set pcolor 12] ;; main entrance exit door ;; nvm this, testing purposes
  ask patches with [pxcor >= 57 and pxcor <= 65 and pycor >= -294 and pycor <= -291] [set pcolor 18] ;; north exit
  ask patches with [pxcor >= -121 and pxcor <= -119 and pycor >= -125 and pycor <= -110] [set pcolor 19] ;; landscape exit

  ask patches with [pxcor >= 115 and pxcor <= 117 and pycor >= -219 and pycor <= -210] [set pcolor 17] ;; west exit, farthest towards north
  ask patches with [pxcor >= 115 and pxcor <= 117 and pycor >= -5 and pycor <= 4] [set pcolor 16] ;; west exit, front of Cover room
  ;ask patches with [pxcor >= 115 and pxcor <= 117 and pycor >= 20 and pycor <= 29] [set pcolor red] ;; west exit, tiny office room
  ;ask patches with [pxcor >= 115 and pxcor <= 117 and pycor >= 90 and pycor <= 100] [set pcolor red] ;; west exit, bigger office room
  ask patches with [pxcor >= 115 and pxcor <= 117 and pycor >= 185 and pycor <= 200] [set pcolor 15] ;; west exit (big door), next to toilets

  ask patches with [pxcor >= 67 and pxcor <= 82 and pycor >= 296 and pycor <= 298] [set pcolor 13] ;; cafeteria exit west
  ask patches with [pxcor >= -1 and pxcor <= 14 and pycor >= 296 and pycor <= 298] [set pcolor 14] ;; cafeteria exit east (next to stairs)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF WORLD  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ask patches [
    set original-color pcolor
  ]
end

to setup
  set cafeteria-deaths 0
  set lobby-deaths 0
  set long-hall-deaths 0
  set cafeteria-deaths 0
  set study-landscape-deaths 0
  set office-deaths 0
  set staged? false
  clear-turtles
  clear-drawing
  clear-plot
  reset-ticks

  ask patches with [pcolor = orange] [
    set pcolor original-color
  ]

  set inside-colors [139 169 49 166 69 99 9 8]
  set exit-colors [12 13 14 15 16 17 18 19]
  let n ((2 * num-agents) / 100)
  ask n-of (num-agents - n) patches with [member? pcolor inside-colors and pcolor != 9] [ ;; 9 is small room/office patches
     sprout 1 [set color blue]
  ]


  ;; have less agents spawning inside offices to be more realistic
  ask n-of n patches with [pcolor = 9] [
     sprout 1 [set color blue]
  ]
  ask turtles [
    set forward-speed 1
    set in-office? false
    set outside? false
    set stuck? false
    set size 4
    if [pcolor] of patch-here = 9 [set in-office? true]
    set available-exits [12 13 14 15 16 17 18 19]
    set spawn-location [pcolor] of patch-here
  ]

  start-fire
  set casualties 0

  ;; Count the number of turtles in each location
  set cafeteria-pop count turtles with [pcolor = 139]
  set lobby-pop count turtles with [pcolor = 69]
  set long-hall-pop count turtles with [pcolor = 49]
  set study-landscape-pop count turtles with [pcolor = 99]
  set office-pop count turtles with [pcolor = 9]

end

to go
  ;; do until all turtles are outside
  ifelse any? turtles-on patches with [pcolor != white] [
    ask turtles [
      if [pcolor] of patch-here = orange [
        if spawn-location = 139 [set cafeteria-deaths cafeteria-deaths + 1]
        if spawn-location = 69 [set lobby-deaths lobby-deaths + 1]
        if spawn-location = 49 [set long-hall-deaths long-hall-deaths + 1]
        if spawn-location = 139 [set cafeteria-deaths cafeteria-deaths + 1]
        if spawn-location = 99 [set study-landscape-deaths study-landscape-deaths + 1]
        if spawn-location = 9 [set office-deaths office-deaths + 1]

        set casualties casualties + 1
        die
      ]
      ifelse outside? [ ;; if already outside, stop moving and stay in this coordinate (arbitrarily chosen for now just to stop them from cluttering the exit)
        setxy -200 100
      ][
        if pen-yes [pen-down]
        if not pen-yes [pen-up]
        ;; calculate crowd speed factor
        let crowd (count turtles in-radius 5 - 1)* crowd-factor ;; where from?
        let argument list 0.8 crowd
        set forward-speed 1 - min argument
        ifelse staged? = true [
          if any? patches in-radius 100 with [pcolor = orange] [
            move
          ]
        ]
        [
          move
        ]
        if [pcolor] of patch-here = black [set stuck? true]
      ]
    ]
    spread-fire
    tick
  ] [
    stop
  ]
end

to move
  if [pcolor] of patch-here = 8 or [pcolor] of patch-here != 9 [set in-office? false] ;; if agent is on the room door (c = 8) or anywhere outside the room
  ;; face middle patch of chosen exit by default
  face patch mean [pxcor] of exit mean [pycor] of exit

  if in-office? [face patch 53 4] ;; middle of the door of cover room
  ifelse [pcolor] of patch-ahead 1 = black or [pcolor] of patch-ahead 1 = orange or [pcolor] of patch-ahead 2 = orange or [pcolor] of patch-ahead 3 = orange [ ;; if wall/table or fire ahead
    set obstacle? true
    ifelse [pcolor] of patch-ahead 1 = orange or [pcolor] of patch-ahead 2 = orange or [pcolor] of patch-ahead 3 = orange [ ;; if fire ahead
      rt 180
      repeat 10 [if patch-ahead 1 != nobody and [pcolor] of patch-ahead 1 != black and [pcolor] of patch-ahead 1 != orange [fd forward-speed]]
      change-exit
    ]
    [
      ;; if no fire ahead
      ;; check if easy exit is nearby
      if pxcor >= 68 and pycor >= -11 and pycor <= 8 [set exit patches with [pcolor = 16]]
      if pxcor >= 68 and pycor >= -242 and pycor <= -200 [set exit patches with [pcolor = 17]]
      if pxcor >= 92 and pycor >= 250 [set exit patches with [pcolor = 13]]
      avoid
      repeat 10 [if patch-ahead 1 != nobody and [pcolor] of patch-ahead 1 != black and [pcolor] of patch-ahead 1 != orange [fd forward-speed]]
    ]
  ]
  [
    set obstacle? false
    if patch-ahead 1 != nobody and [pcolor] of patch-ahead 1 != black and [pcolor] of patch-ahead 1 != orange [fd forward-speed]
  ]

  ;; if agent on the exit, put it outside
  if [pcolor] of patch-here = [pcolor] of one-of exit or [pcolor] of patch-here = white [
    set outside? true
    pen-up
  ]
end

to avoid
  bk 1
  rt (random 180) - 90
end

to change-exit
  let current-exit [pcolor] of one-of exit
  ifelse member? current-exit available-exits and length available-exits > 2 [ ;; if current exit is a part of available exit
    set available-exits remove current-exit available-exits ;; remove current exit from the list
    let new-exit one-of available-exits
    set exit patches with [pcolor = new-exit]
  ]
  [
    let new-exit one-of available-exits
    set exit patches with [pcolor = new-exit]
  ]
end

to-report survived
  report count turtles-on patches with [pcolor = white]
end

to start-fire
  ask one-of patches with [pcolor = one-of inside-colors] [set pcolor orange]
end

to spread-fire
  ask patches with [pcolor = orange] [
    every 25 [
      ask neighbors [
        if member? pcolor inside-colors and random 100 <= spread-rate [
          set pcolor orange
        ]
      ]
    ]
  ]
end

;; agents choose an exit randomly based on predetermined exits around them that depends on their spawning point.
;; the exits are still predetermined even though it is a random strategy because it is more sensible to choose an exit thats near you, even if it is at random
to random-strategy
  let num 0
  ask turtles [
    set exit patches with [pcolor = 12] ;; ignore

    ;; if in cafeteria
    if [pcolor] of patch-here = 139 or [pcolor] of patch-here = 69 [
      set num random 4
      if num = 0 [set exit patches with [pcolor = 12]]
      if num = 1 [set exit patches with [pcolor = 13]]
      if num = 2 [set exit patches with [pcolor = 14]]
      if num = 3 [set exit patches with [pcolor = 15]]

    ]

    ;; if in the long awkward hallway
    if [pcolor] of patch-here = 49 [
      set num random 3
      if num = 0 [set exit patches with [pcolor = 16]]
      if num = 1 [set exit patches with [pcolor = 17]]
      if num = 2 [set exit patches with [pcolor = 18]]
    ]

    ;; if in cover room
    if [pcolor] of patch-here = 9 [ set exit patches with [pcolor = 16]] ;; head for the east-mid exit

    ;; if in BBL
    if [pcolor] of patch-here = 99 [
      set exit patches with [pcolor = 19]
    ]
  ]
end

;; agents use the exit designed for their location
to directed-strategy
  ask turtles [

    ;; cafeteria east-side
    if [pcolor] of patch-here = 139 and xcor >= 31[
      set exit patches with [pcolor = 13] ;; cafeteria
    ]

    ;; cafeteria west-side
    if [pcolor] of patch-here = 139 and xcor < 31[
      set exit patches with [pcolor = 14] ;; cafeteria
    ]

    ;; entrance lobby west-side
    if [pcolor] of patch-here = 69 and xcor < -58 [
      set exit patches with [pcolor = 12] ;; next to main entrance
    ]
    ;; entrance lobby east-side
    if [pcolor] of patch-here = 69 and xcor >= -58 [
      set exit patches with [pcolor = 15] ;; next to main entrance
    ]

    ;; if in the long awkward hallway
    if [pcolor] of patch-here = 49 and ycor > 61 [
      set exit patches with [pcolor = 15] ;; east-north exit
    ]
    if [pcolor] of patch-here = 49 and ycor <= 61 and ycor >= -103 [
      set exit patches with [pcolor = 16] ;; east-mid exit
    ]
    if [pcolor] of patch-here = 49 and ycor < -103 and xcor >= 68[
      set exit patches with [pcolor = 17] ;; east-south exit
    ]
    if [pcolor] of patch-here = 49 and ycor < -103 and xcor <= 68[
      set exit patches with [pcolor = 18] ;; south exit
    ]

    ;; if in cover room
    if [pcolor] of patch-here = 9 [
      set exit patches with [pcolor = 16]
    ]

    ;; if in BBL
    if [pcolor] of patch-here = 99 [
     set exit patches with [pcolor = 19] ;; BBL exit
    ]
  ]
end

to staged-strategy
  set staged? true
  ask turtles [

    ;; cafeteria east-side
    if [pcolor] of patch-here = 139 and xcor >= 31[
      set exit patches with [pcolor = 13] ;; cafeteria
    ]

    ;; cafeteria west-side
    if [pcolor] of patch-here = 139 and xcor < 31[
      set exit patches with [pcolor = 14] ;; cafeteria
    ]

    ;; entrance lobby west-side
    if [pcolor] of patch-here = 69 and xcor < -58 [
      set exit patches with [pcolor = 12] ;; next to main entrance
    ]
    ;; entrance lobby east-side
    if [pcolor] of patch-here = 69 and xcor >= -58 [
      set exit patches with [pcolor = 15] ;; next to main entrance
    ]

    ;; if in the long awkward hallway
    if [pcolor] of patch-here = 49 and ycor > 61 [
      set exit patches with [pcolor = 15] ;; east-north exit
    ]
    if [pcolor] of patch-here = 49 and ycor <= 61 and ycor >= -103 [
      set exit patches with [pcolor = 16] ;; east-mid exit
    ]
    if [pcolor] of patch-here = 49 and ycor < -103 and xcor >= 68[
      set exit patches with [pcolor = 17] ;; east-south exit
    ]
    if [pcolor] of patch-here = 49 and ycor < -103 and xcor <= 68[
      set exit patches with [pcolor = 18] ;; south exit
    ]

    ;; if in cover room
    if [pcolor] of patch-here = 9 [
      set exit patches with [pcolor = 16]
    ]

    ;; if in BBL
    if [pcolor] of patch-here = 99 [
     set exit patches with [pcolor = 19] ;; BBL exit
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
323
10
1176
864
-1
-1
1.406
1
10
1
1
1
0
0
0
1
-300
300
-300
300
0
0
1
ticks
30.0

BUTTON
11
107
153
140
Directed Evacuation
directed-strategy
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
11
152
146
185
Staged Evacuation
staged-strategy
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
12
13
105
46
Build World
build
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
118
13
182
46
Setup
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
196
14
259
47
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
1

BUTTON
12
60
153
93
Random Evacuation
random-strategy
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
9
377
69
422
Survived
survived
17
1
11

SWITCH
10
196
113
229
pen-yes
pen-yes
1
1
-1000

SLIDER
7
246
179
279
num-agents
num-agents
0
300
150.0
1
1
NIL
HORIZONTAL

SLIDER
7
290
179
323
spread-rate
spread-rate
0
100
5.0
1
1
NIL
HORIZONTAL

MONITOR
79
378
151
423
Casualties
casualties
17
1
11

SLIDER
7
334
179
367
crowd-factor
crowd-factor
0
0.3
0.15
0.01
1
NIL
HORIZONTAL

MONITOR
1197
275
1346
320
NIL
study-landscape-deaths
0
1
11

MONITOR
1197
319
1302
364
NIL
long-hall-deaths
0
1
11

MONITOR
1197
410
1304
455
NIL
cafeteria-deaths
0
1
11

MONITOR
1197
457
1285
502
NIL
office-deaths
17
1
11

MONITOR
1197
364
1284
409
NIL
lobby-deaths
17
1
11

PLOT
1197
10
1595
266
Casualties
Time
Casualties
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Cafeteria" 1.0 0 -2064490 true "" "plot cafeteria-deaths"
"Long-hall" 1.0 0 -1184463 true "" "plot long-hall-deaths"
"Office" 1.0 0 -7500403 true "" "plot office-deaths"
"Lobby" 1.0 0 -13840069 true "" "plot lobby-deaths"
"Study-landscape" 1.0 0 -13791810 true "" "plot study-landscape-deaths"

MONITOR
1378
276
1548
321
study-landscape-death-rate
study-landscape-deaths / study-landscape-pop * 100
2
1
11

MONITOR
1379
321
1505
366
long-hall-death-rate
long-hall-deaths / long-hall-pop * 100
2
1
11

MONITOR
1378
365
1486
410
lobby-death-rate
lobby-deaths / lobby-pop * 100
2
1
11

MONITOR
1379
410
1506
455
cafeteria-death-rate
cafeteria-deaths / cafeteria-pop * 100
2
1
11

MONITOR
1378
455
1487
500
office-death-rate
office-deaths / office-pop * 100
2
1
11

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
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="random_evacuation" repetitions="20" runMetricsEveryStep="false">
    <setup>build
setup
random-strategy</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>casualties</metric>
    <metric>survived</metric>
    <metric>ticks</metric>
    <metric>study-landscape-deaths / study-landscape-pop * 100</metric>
    <metric>long-hall-deaths / long-hall-pop * 100</metric>
    <metric>lobby-deaths / lobby-pop * 100</metric>
    <metric>cafeteria-deaths / cafeteria-pop * 100</metric>
    <metric>office-deaths / office-pop * 100</metric>
    <enumeratedValueSet variable="spread-rate">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="crowd-factor">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-agents">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pen-yes">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="directed_evacuation" repetitions="20" runMetricsEveryStep="false">
    <setup>build
setup
directed-strategy</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>casualties</metric>
    <metric>survived</metric>
    <metric>ticks</metric>
    <metric>study-landscape-deaths / study-landscape-pop * 100</metric>
    <metric>long-hall-deaths / long-hall-pop * 100</metric>
    <metric>lobby-deaths / lobby-pop * 100</metric>
    <metric>cafeteria-deaths / cafeteria-pop * 100</metric>
    <metric>office-deaths / office-pop * 100</metric>
    <enumeratedValueSet variable="spread-rate">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="crowd-factor">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-agents">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pen-yes">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="staged_evacuation" repetitions="40" runMetricsEveryStep="false">
    <setup>build
setup
staged-strategy</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>casualties</metric>
    <metric>survived</metric>
    <metric>ticks</metric>
    <metric>study-landscape-deaths / study-landscape-pop * 100</metric>
    <metric>long-hall-deaths / long-hall-pop * 100</metric>
    <metric>lobby-deaths / lobby-pop * 100</metric>
    <metric>cafeteria-deaths / cafeteria-pop * 100</metric>
    <metric>office-deaths / office-pop * 100</metric>
    <enumeratedValueSet variable="spread-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="crowd-factor">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-agents">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pen-yes">
      <value value="false"/>
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
