import Xmobar hiding (date)

battery :: Monitors
battery =
  Battery
    [ "-t", "<leftbar> <acstatus><left>"
    , "-f", "\xf244\xf243\xf243\xf242\xf242\xf241\xf241\xf240" -- ""
    , "-W", "0"
    , "-p", "3"
    , "--"
    , "-O", "\xf0e7" -- " "
    , "-i", "\xf141" -- " "
    , "-o", ""
    , "-P"
    ]
    50

cpu :: Monitors
cpu = Cpu ["-t", "\xe266 <total>%", "-p", "3"] 10

multicoretemp :: Monitors
multicoretemp =
  MultiCoreTemp
    [ "-t", "<avgbar> <avg>°C"
    , "-f", "\xf2cb\xf2ca\xf2ca\xf2c9\xf2c9\xf2c8\xf2c8\xf2c7" -- ""
    , "--"
    , "--mintemp", "35"
    , "--maxtemp", "80"
    ]
    10

memory :: Monitors
memory = Memory [ "-t", "<fn=1>\xf538</fn> <usedratio>%", "-p", "3" ] 10

date :: Date
date = Date "\xf073 %a %d %b %Y" "date" 864000

time :: Date
time = Date "\xf017 %H:%M:%S" "time" 10

volume :: Monitors
volume =
  Alsa
    "default"
    "Master"
    [ "-t", "<status>"
    , "-f", "\xfa80\xfa7e\xfa7e\xfa7f\xfa7f\xfa7d" -- "婢奄奄奔奔墳"
    , "-W", "0"
    , "--"
    , "-O", "<volumebar> "
    , "-o", "\xfc5d " -- "ﱝ"
    ]

wifi :: Monitors
wifi =
  Wireless
    ""
    [ "-t", "<fn=1><qualitybar></fn>"
    , "-f", "\xf6aa\xf6ab\xf6ab\xf1eb"
    , "-W", "0"
    ]
    10

weather :: Monitors
weather =
  WeatherX
    "BIRK"
    [ ("clear", "\xe30d") -- 
    , ("sunny", "\xe30d") -- 
    , ("mostly clear", "\xe30c") -- 
    , ("mostly sunny", "\xe30c") -- 
    , ("partly cloudy", "\xe302") -- 
    , ("partly sunny", "\xe302") -- 
    , ("mostly cloudy", "\xe312") -- 
    , ("considerable cloudiness", "\xe312") -- 
    , ("cloudy", "\xe312") -- 
    , ("fair", "\x32b") -- 
    ]
    [ "-t", "<skyConditionS> <tempC>°" ]
    18000

cmds :: [Runnable]
cmds =
  [ Run battery
  , Run cpu
  , Run multicoretemp
  , Run memory
  , Run date
  , Run time
  , Run volume
  , Run wifi
  , Run weather
  ]

config :: Config
config = defaultConfig
    { font = "xft:JetBrains Mono Nerd Font"
    , additionalFonts = ["xft:FontAwesome"]
    , position = TopP 10 10
    , border = TopBM 10
    , borderWidth = 0
    , overrideRedirect = False
    , commands = cmds
    , template = "L } M { %cpu% %multicoretemp% %memory% | %wifi% %volume% %battery% | %date% %time%"
    }