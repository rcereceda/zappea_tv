module Provider
  def translate(program)
    case appDelegate.provider
      when 0 then vtr(program)
    end
  end
  
  # VTR
  def vtr(program)
    case program.channel
      when 4271 then 
        program.name = 'Canal 13'
        program.number = '3' # claro:25 movistar:122 directv:152
      when 5057 then
        program.number = '6' # tvn claro:22 movistar:119 directv 149
      when 29368 then 
        program.name = 'La Red'
        program.number = '10' # claro:21 movistar:117
      when 29371 then
        program.number = '8' # mega claro:23 movistar:120 directv:150
      when 4313 then 
        program.name = 'Chilevisión'
        program.number =  '12' # claro:24 movistar:121
      when 29387 then
        program.number = '14' # ucv movistar:118
      when 29367 then 
        program.name = 'TeleCanal'
        program.number = '15' # movistar:116
      when 29375 then 
        program.name = 'CNN Chile'
        program.number = '16' # claro:19 directv:154
      when 32843 then 
        program.name = '24 Horas' 
        program.number = '17' # movistar:423 directv:708
      when 23448 then
        program.name = 'Cartoon Network'
        program.number = '18' # claro:6 movistar:301 diectv:304
      when 5023 then
        program.name = 'Disney XD'
        program.number = '19' # claro:7 movistar:307 directv:316
      when 29379 then
        program.name = 'Disney en Español'
        program.number = '20' # claro:4 movistar:304 directv:312
      when 5018 then
        program.name = 'Discovery Kids'
        program.number = '21' # claro:2 movistar:303 directv:330
      when 2991 then
        program.name = 'The Discovery Channel'
        program.number = '22' # claro:10 movistar:351 directv:732
      when 2377 then
        program.name = 'Animal Planet'
        program.number = '23' # claro:11 movistar:305 directv:734
      when 9412 then
        program.name = 'El Gourmet'
        program.number = '24' # movistar:371 directv:232
      when 9227 then
        program.name = 'Antena 3'
        program.number = '25' # movistar:435 directv:762
      when 29369 then
        program.name = 'Vive Deportes'
        program.number = '26'
      when 29381 then
        program.name = 'CDF Básico'
        program.number = '27' # claro:67 movistar:484 directv:632
      when 3793 then
        program.name = 'Fox Sports'
        program.number = '28' # claro:61 movistar:483 directv:604
      when 29393 then
        program.name = 'ESPN'
        program.number = '29' # claro:62 movistar:480 directv:621
      when 10199 then
        program.name = 'Boomerang'
        program.number = '30' # movistar:306 directv:334
      when 28684 then
        program.name = 'Nickelodeon'
        program.number = '31' # claro:5 movistar:302 directv:308
      when 17908 then
        program.name = 'National Geographic Channel'
        program.number = '32' # claro:12 movistar:352 directv:730
      when 16826 then
        program.name = 'The History Channel'
        program.number = '33' # claro:13 movistar:354 directv:742
      when 10337 then
        program.name = 'Infinito'
        program.number = '34' # movistar:356 directv:748
      when 4319 then
        program.name = 'Film & Arts'
        program.number = '35' # movistar:357 directv:746
      when 33916 then
        program.name = '13 Cable'
        program.number = '215' # claro:72
      when 5020 then
        program.name = 'Eternal Word Television'
        program.number = '36' # movistar:439 directv:350
      when 29399 then
        program.name = 'Televisión Nacional Evangélica'
        program.number = '37'
      when 29394 then
        program.number = '171' # claro:63 directv:625
      when 3343 then
        program.name = 'BBC World News'
        program.number = '38' # movistar:402 directv:768
      when 5056 then
        program.name = 'TVE'
        program.number = '39' # movistar:434 directv:760
      when 19643 then
        program.name = 'Glitz'
        program.number = '41' # movistar:376 directv:224
      when 5036 then
        program.name = 'MTV'
        program.number = '42' # claro:51 movistar:387 directv:264
      when 5194 then
        program.name = 'HTV Música'
        program.number = '315' # movistar:389 directv:272
      when 6161 then
        program.number = '43' # claro:54 movistar:124
      when 29372 then
        program.name = 'Zona Latina'
        program.number = '44' # claro:52 movistar:123
      when 16674 then
        program.number = '45' # movistar:386
      when 10948 then
        program.name = 'E! Entertainment Television'
        program.number = '46' # claro:50 movistar:374 directv:222
      when 3998 then
        program.name = 'HBO Este'
        program.number = '47' # claro:30 movistar:630 directv:524
      when 32911 then
        program.name = 'Cinecanal'
        program.number = '48' # claro:31 movistar:615 directv:507
      when 3994 then
        program.name = 'Cinemax'
        program.number = '49' # claro:32 movistar:616 directv:509
      when 44027 then
        program.name = 'The Film Zone'
        program.number = '50' # claro:39 movistar:606 directv:505
      when 24368 then
        program.number = '51' # claro:42 movistar:607 directv:217
      when 16755 then
        program.number = '52' # claro:43 movistar:506 directv:207
      when 4191 then
        program.name = 'Investigation Discovery'
        program.number = '53' # claro:70 movistar:372 directv:223
      when 23086 then
        program.name = 'Sony Entertainment Television'
        program.number = '54' # claro:35 movistar:503 directv:210
      when 15290 then
        program.name = 'Warner Channel'
        program.number = '55' # claro:36 movistar:501 directv:206
      when 18972 then
        program.name = 'Studio Universal'
        program.number = '56' # movistar:602 directv:508
      when 16994 then
        program.name = 'FOX Life'
        program.number = '57' # claro:57 movistar:505 directv:219
      when 5107 then
        program.number = '58'# claro:37 movistar:502 directv:202
      when 5021 then
        program.number = '59' # movistar:608 directv:510
      when 44331 then
        program.number = '60' # tnt claro:34 movistar:601
      when 36167 then
        program.name = 'Space'
        program.number = '61' # claro:40
      when 23556 then
        program.number = '62' # i-sat claro:41 movistar:605 directv:520(conosur)
      when 23013 then
        program.name = 'TCM'
        program.number = '63' # claro:44 movistar:603 directv:504
      when 23109 then
        program.number = '77' # axn claro:38 movistar:504 directv:214
      when 24199 then
        program.name = 'CNN en Español'
        program.number = '78' # claro:20 movistar:401 directv:704
      when 10878 then
        program.name = 'Canal del Senado'
        program.number = '79' # movistar:425
      when 29373 then
        program.name = 'Falabella TV'
        program.number = '100'
      when 32996 then
        program.number = '110' # tbs movistar:739
      when 12351 then
        program.name = 'Cosmopolitan TV'
        program.number = '111' # movistar:722
      when 8461 then
        program.name = 'Casa Club'
        program.number = '112' # movistar:723 directv:230
      when 32262 then
        program.name = 'Utilísima'
        program.number = '117 '# claro:55 movistar:370 directv:234
      when 9294 then
        program.number = '118' # tlc claro:71 movistar:373 directv:740
      when 9293 then
        program.name = 'Discovery Home & Health'
        program.number = '119' # claro:57 movistar:355 directv:229
      when 16646 then
        program.name = 'Fox Sports 3' 
        program.number = '151' # movistar:479 directv:609
      when 29366 then
        program.name = 'Teletrak'
        program.number = '152' # movistar:477
      when 27138 then
        program.name = 'TYC'
        program.number = '164' # claro:65 movistar:750
      when 29382 then
        program.name = 'CDF Premium'
        program.number = '165' # claro:60 movistar:486 directv:631
      when 32896 then
        program.name = 'Fox Sports Premium'
        program.number = '166' # claro:68 movistar:485 directv:607
      when 16122 then
        program.name = 'Discovery Science'
        program.number = '208' # movistar:711 directv:736
      when 16121 then
        program.name = 'Discovery Civilization'
        program.number = '209' # movistar:712
      when 16118 then
        program.name = 'Discovery Turbo'
        program.number = '210' # movistar:713
      when 19092 then
        program.name = 'The Biography Channel'
        program.number = '220' # movistar:353 directv:744
      when 29667 then
        program.number = '225' # artv
      when 23265 then
        program.name = 'Baby TV'
        program.number = '251'
      when 29365 then
        program.name = 'ETC TV'
        program.number = '235' # movistar:310
      when 23312 then
        program.name = 'Tooncast'
        program.number = '254' # movistar:702
      when 29380 then
        program.name = 'Disney Junior'
        program.number = '255' # claro:3 movistar:308 directv:315
      when 10561 then
        program.name = 'MTV Hits'
        program.number = '312'
      when 2181 then
        program.name = 'CNN International'
        program.number = '351' # movistar:403 directv:706
      when 5053 then
        program.name = 'TV5MONDE'
        program.number = '353'
      when 5044 then
        program.name = 'RAI Italia'
        program.number = '354' # movistar:437 directv:766
      when 34292 then
        program.name = 'Deutsche Welle TV'
        program.number = '352' # movistar:438 directv:770
      when 5002 then
        program.name = 'América TV'
        program.number = '356'
      when 5019 then
        program.name = 'Canal de las Estrellas'
        program.number = '358' # claro:74 movistar:375 directv:226
      when 4893 then
        program.name = 'Bloomberg TV'
        program.number = '370' # vtr:370 movistar:741 directv:710
      when 4317 then
        program.name = 'Voice of America Television'
        program.number = '371'
      when 450 then
        program.name = 'Fox News Channel'
        program.number = '372' # movistar:734
      when 4307 then
        program.name = 'Europa Europa'
        program.number = '401' # movistar:617
      when 5030 then
        program.name = 'Sony Spin'
        program.number = '403' # movistar:521 directv:212
      when 28660 then
        program.name = 'Universal Channel'
        program.number = '406' # claro:33 movistar:510 directv:218
      when 3748 then
        program.name = 'Golden Edge'
        program.number = '407' # vtr:407 directv:517
      when 34623 then
        program.name = 'Comedy Central'
        program.number = '408' # movistar:786 directv:215
      when 13049 then
        program.name = 'HBO Family Este'
        program.number = '467' # claro:209 Este movistar:631 directv:534
      when 35475 then
        program.name = 'HBO Plus Oeste'
        program.number = '468' # movistar:637 directv:532
      when 23311 then
        program.name = 'truTV'
        program.number = '211' # movistar:511 directv:220
      when 34803 then
        program.number = '469' # hbo 2 claro:211 Este movistar:634 directv:525
      when 13048 then
        program.name = 'HBO Signature'
        program.number = '470' # movistar:635 directv:528
      when 3996 then
        program.name = 'HBO Plus Este'
        program.number = '471' # claro:210 movistar:633 directv:526
      when 19579 then
        program.name = 'Gol TV'
        program.number = '163' # claro:64
      when 27178 then
        program.name = 'MAX Este'
        program.number = '472' # max directv:540
      when 21041 then
        program.number = '402' # syfy movistar:548 directv:221
      when 13050 then
        program.name = 'MAX Prime Oeste'
        program.number = '473' # claro:212 movistar:632 directv:538
      when 41324 then
        program.name = 'MAX Prime Este'
        program.number = '474' # movistar:636 directv:542
      when 5110 then
        program.name = 'Moviecity Premieres Este'
        program.number = '475' # movistar:647 directv:552
      # 5034 Moviecity Premieres Oeste claro:221 movistar:654 directv:554
      when 14707 then
        program.name = 'Moviecity Classics'
        program.number = '476' # movistar:652 directv:560
      when 29522 then
        program.name = 'Moviecity Mundo'
        program.number = '477' # movistar:649 directv:562
      when 20299 then
        program.name = 'Moviecity Hollywood'
        program.number = '478' # claro:220 movistar:651 directv:559
      when 20300 then
        program.name = 'Moviecity Action'
        program.number = '479' # claro:222 Este movistar:648 directv:561
      when 24157 then
        program.name = 'Moviecity Family Este'
        program.number = '480' # movistar:653 directv:556
      # 24158 Moviecity Family Oeste movistar:650
      when 20405 then
        program.name = 'CCTV en Español'
        program.number = '552'
      when 12931 then
        program.name = 'Caracol TV'
        program.number = '558' # directv:772
      when 3721 then
        program.name = 'TV Globo Internacional'
        program.number = '565' # directv:776
      when 5301 then
        program.name = 'Zee TV'
        program.number = '570' # vtr:570 directv:780
      when 21039 then
        program.name = 'Moviecity Premieres HD'
        program.number = '801' # claro:531 movistar:883 directv:1552
      when 22185 then
        program.name = 'HBO HD'
        program.number = '802' # claro:530 movistar:881 directv:1524
      when 28440 then
        program.name = 'Cinecanal HD'
        program.number = '803' # claro:532 movistar:850 directv:1507
      when 28452 then
        program.name = 'TNT HD'
        program.number = '804' # claro:534 movistar:848 directv:1502
      when 33473 then
        program.name = 'MGM HD'
        program.number = '805' # movistar:851
      when 33314 then
        program.name = 'Vive Deportes HD'
        program.number = '810'
      when 32541 then
        program.name = 'Canal 13 HD'
        program.number = '813' # movistar:813
      when 35817 then
        program.name = 'FX HD'
        program.number = '814' # movistar:835 directv:1217
      when 28439 then
        program.name = 'Universal Channel HD'
        program.number = '815' # claro:533 movistar:854 directv:1218
      when 28536 then
        program.name = 'Sony Entertainment Television HD'
        program.number = '816' # movistar:842 directv:1210
      when 30578 then
        program.name = 'Warner Channel HD'
        program.number = '817' # claro:536 movistar:843 directv:1206
      when 30579 then
        program.name = 'AXN HD'
        program.number = '818' # claro:538 movistar:844 directv:1214
      when 28535 then
        program.number = '819' # a&e hd claro:539 movistar:838
      when 22860 then
        program.name = 'FOX + Nat Geo HD'
        program.number = '820' # claro:511 movistar:841 directv:1204
      when 23559 then
        program.name = 'HD Theater'
        program.number = '821' # claro:510 movistar:830 directv:1732
      when 27421 then
        program.name = 'National Geographic Wild HD'
        program.number = '822' # claro:512 movistar:832
      when 28437 then
        program.name = 'truTV HD'
        program.number = '823' # movistar:856
      when 28410 then
        program.name = 'The History Channel HD'
        program.number = '824' # claro:513 movistar:833 directv:1742
      when 24270 then
        program.name = 'ESPN HD'
        program.number = '830' # claro:551 movistar:860 directv:1620
      when 34956 then
        program.name = 'ESPN 3 HD'
        program.number = '831' # movistar:866
      when 29383 then
        program.name = 'CDF HD'
        program.number = '838' # claro:550 movistar:865
      when 32900 then
        program.name = 'Fox Sports HD'
        program.number = '839' # claro:553 movistar:861/33944 directv:1604
      when 29083 then
        program.name = 'MTV Live HD'
        program.number = '840' # movistar:855
      when 32542 then
        program.name = 'VIA-X HD'
        program.number = '845'
    end
  end
  
end