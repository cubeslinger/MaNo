--
-- Addon       _mano_db_puzzles_cairns.lua
-- Author      marcob@marcob.org
-- StartDate   29/05/2018
--
-- Expansion:  Mathosia
-- Source:     http://www.kfguides.com/rift/puzzlesguide.php
-- Credits:    Krinadon and Faiona, or KFGuides (Support@KFGuides.com)
--
-- Expansion:  Storm Legion - Cairns
-- Source:     http://archive.riftscene.com/guides/achievements/cairn-do-too-storm-legion-cairns/
-- Credits:     Cupcakes
--
-- Data:       Storm Legion - Puzzles
-- Source:     http://tmrguides.blogspot.com/
--
-- Format:     {
--                name="puzzle/cairn name",
--                location="zone Name",
--                subzone=["es.: Lake of Solace"],
--                x=nn,
--                z=nn,
--                y=[nn],
--                notes=["...mi favourite fishing spot..."]
--             }
--
--             ONLY fields between [] may be missing.
--
local addon, mano = ...

if not mano.db.puzzles  then  mano.db.puzzles   =  {} end
mano.db.puzzles.mathosia=  {
                              { name="Puzzled at the Top of the World", location="Silverwood",                       x=6515, z=3080 },
                              { name="Shield Wall",                     location="Gloamwood",                        x=4540, z=2382 },
                              { name="A Barrel of Laughs",              location="Scarlet Gorge",                    x=3619, z=2775 },
                              { name="Lake Solace",                     location="Freemarch",                        x=5998, z=6141 },
                              { name="Spinning Plates",                 location="Stonefield",                       x=4577, z=4974 },
                              { name="Scarwood by Torchlight",          location="Scarwood Reach",                   x=3123, z=4426 },
                              { name="Don’t be Cagey",                  location="Drought Islands",                  x=8335, z=6200 },
                              { name="Tracks in the Snow",              location="Iron Pine Peaks",                  x=3760, z=2266 },
                              { name="The Peg Solitaire",               location="Shimmersand",                      x=6414, z=7714 },
                              { name="Stillmoor",                       location="Thalin Thor",                      x=1705, z=2310 }
                              }
mano.db.puzzles.stormlegion=  {
                                 { name="Circuit Diagrams",    location="Brevane",  subzone="Ardent Domain",         x=5988,  z=10744,
                                 notes="Artifact Set Required: Circuit Diagrams (12)" },
                                 { name="A Knight's Tour",     location="Brevane",  subzone="City Core",             x=6984,  z=10036,
                                 notes="Artifact Set Required: A Knight's Tour (6)" },
                                 { name="M'doidoi Dolls",      location="Brevane",  subzone="Eastern Holdings",      x=8800,  z=8750,
                                 notes="Artifact Set Required: M'doidoi Dolls (9) (bottom of the pond has a portal)" },
                                 { name="Seeing Dots",         location="Dusken",   subzone="Seratos",               x=11400, z=6280,
                                 notes="Artifact Set Required: Seeing Dots, 3 Blob of Ectoplasm (found in NW Ardent Domain)" },
                                 { name="Queen's Gambit",      location="Dusken",   subzone="Kingsward",             x=4813,  z=8675,
                                 notes="Artifact Set Required: Queen's Gambit (12)" },
                                 { name="Black Box",           location="Dusken",   subzone="Morban",                x=12700, z=7450,
                                 notes="Artifact Set Required: Black Box" },
                                 { name="Snake Eyes",          location="Dusken",   subzone="The Dendrome",          x=4410,  z=4240,
                                 notes="Artifact Set Required: Snake Eyes, 10 Glowing Rootballs (attained from watching puppet shows in Hailol)" }
                              }

if not mano.db.cairns   then  mano.db.cairns    =  {} end
mano.db.cairns.mathosia =  {
                              { name="Discarded Strongbox",          location="Freemarch", subzone="Lake of Solace", x=5626, z=5685 },
                              { name="Forgotten Casket",             location="Freemarch", subzone="Lake of Solace", x=5449, z=6009 },
                              { name="Plundered Safe",               location="Freemarch", subzone="Lake of Solace", x=5560, z=6233 },
                              { name="Lost Soul",                    location="Freemarch", subzone="Lake of Solace", x=5872, z=6223 },
                              { name="Weed Covered Vase",            location="Freemarch", subzone="Lake of Solace", x=6029, z=6509,
                              notes="DO THIS ONE LAST!" },
                              { name="Heavy Metal Barrel",           location="Freemarch", subzone="Lake of Solace", x=6311, z=6228 },
                              { name="Sunken Cargo",                 location="Freemarch", subzone="Lake of Solace", x=6708, z=5987 },
                              { name="Old Chest",                    location="Freemarch", subzone="Lake of Solace", x=6430, z=6430 },
                              { name="Cairn of Bahar Farwind</a>",   location="Stonefied",                           x=5898, z=5033,
                              notes="This is considered a Freemarch Cairn. It caps at Level 30" },
                              { name="Cairn of Nasreen Tahleed",     location="Stonefied",                           x=5327, z=5364 },
                              { name="Cairn of Valta Cliftswind",    location="Stonefied",                           x=4664, z=5006 },
                              { name="Cairn of Nylaan Starhearth",   location="Glomwood",                            x=5576, z=3210 },
                              { name="Cairn of Faraz Massi",         location="Scarlet Gorge",                       x=4654, z=3097 },
                              { name="Cairn of Engel Malik",         location="Scarwood Reach",                      x=4075, z=4443 },
                              { name="Cairn of Roma Gammult",        location="Moonshade Highlands",                 x=5348, z=2239 },
                              { name="Cairn of Mongo Vachir",        location="Droughtlands",                        x=9161, z=6927 },
                              { name="Cairn of Harwin Kalmar",       location="Iron Pine Peaks",                     x=4980, z=1865 },
                              { name="Cairn of Qara Chuluun",        location="Shimmersand",                         x=7535, z=7170 },
                              { name="Cairn of Thera Valnir",        location="Stillmoor",                           x=1585, z=1862 }
                           }
mano.db.cairns.stormlegion =  {
                                 { name="Ina'eme Sarus",       location="Brevane", subzone="Cape Jule",              x=7438, z=12194 },
                                 { name="Queny Sulgar",        location="Brevane", subzone="Cape Jule",              x=7765, z=11041 },
                                 { name="Asha Tonavar",        location="Brevane", subzone="Cape Jule",              x=6436, z=11015 },
                                 { name="Nunmemph Batshinshi", location="Brevane", subzone="City Core",              x=7266, z=9340 },
                                 { name="Warsul Icero",        location="Brevane", subzone="City Core",              x=7096, z=8585 },
                                 { name="Irque Guemech",       location="Brevane", subzone="City Core",              x=7168, z=8303 },
                                 { name="Oryp Namap",          location="Brevane", subzone="Eastern Holdings",       x=7534, z=8879 },
                                 { name="Tathon I'rilgar",     location="Brevane", subzone="Eastern Holdings",       x=8090, z=9626 },
                                 { name="Banald Warver",       location="Brevane", subzone="Eastern Holdings",	      x=9096, z=8384 },
                                 { name="Yer'shyi Att",        location="Brevane", subzone="Ardent Domain",          x=5844, z=9834 },
                                 { name="Riduf Enthurn",	      location="Brevane", subzone="Ardent Domain",          x=4830, z=10189 },
                                 { name="Niey Tiran",          location="Brevane", subzone="Kingsward",              x=6231, z=7240 },
                                 { name="Isbur Oughverund",	   location="Brevane", subzone="Kingsward",              x=5601, z=8070 },
                                 { name="Skeltorard Perdyn",   location="Brevane", subzone="Kingsward",              x=4066, z=9072 },
                                 { name="Okalu Prev",          location="Brevane", subzone="Ashora",                 x=4063, z=7123 },
                                 { name="Omoosi Itnal",        location="Brevane", subzone="Ashora",                 x=2678, z=7117 },
                                 { name="Orn Tonall",          location="Brevane", subzone="Ashora",                 x=2083, z=6035 },
                                 { name="Morbur Atl Itther",   location="Brevane", subzone="The Dendrome",           x=2960, z=4555 },
                                 { name="Uomu Tonig",          location="Brevane", subzone="The Dendrome",           x=3988, z=5925 },
                                 { name="Ildbur Reled",        location="Brevane", subzone="The Dendrome",           x=4539, z=4273 },
                                 { name="Omight Tonig",        location="Dusken",  subzone="Kingdom of Pelladane",   x=8484, z=5896 },
                                 { name="Tirror Awaya",        location="Dusken",  subzone="Kingdom of Pelladane",   x=7455, z=4077 },
                                 { name="Vesdar Doc",          location="Dusken",  subzone="Seratos",                x=10593, z=4800 },
                                 { name="Sayiss Vernys",       location="Dusken",  subzone="Seratos",                x=11257, z=3610 },
                                 { name="Osm",                 location="Dusken",  subzone="Morban",                 x=12333, z=4715 },
                                 { name="Urari Urari",         location="Dusken",  subzone="Morban",                 x=12641, z=7346 },
                                 { name="Lunibe",              location="Dusken",  subzone="Morban",                 x=15702, z=6066 },
                                 { name="Fevok Beleen",        location="Dusken",  subzone="Steppes of Infinity",    x=15592, z=7395 },

                              }
