--
-- Addon       __zones.lua
-- Author      marcob@marcob.org
-- StartDate   23/07/2018
--
-- Source:     https://rift.magelo.com/en/zones.jspa

function __zones()
   -- the new instance
   local self =   {
                  db =  {},
                  }
      -- public fields go in the instance table

   local zones =  {
   }
   
   return self
end

--[[

db["Abyssal Precipice"],	Dungeon"],	Rift
db["Alittu"],	Normal"],	Starfall Prophecy
db["Archive of Flesh"],	Dungeon"],	Storm Legion
db["Ardent Domain"],	Normal"],	Storm Legion
db["Art_Test_Four"],	Normal"],	Rift
db["Ashenfell"],	Normal"],	Starfall Prophecy
db["Ashora"],	Normal"],	Storm Legion
db["Assault on Bronze Tomb"],	Warfront"],	Rift
db["Binding of Blood: Maelforge"],	Raid 20"],	Storm Legion
db["Bindings of Blood: Akylios"],	Raid 20"],	Storm Legion
db["Bindings of Blood: Greenscale"],	Raid 20"],	Storm Legion
db["Bindings of Blood: Laethys"],	Raid 20"],	Storm Legion
db["Blighted Antechamber"],	Warfront"],	Rift
db["Caduceus Rise"],	Dungeon"],	Rift
db["Cape Jule"],	Normal"],	Storm Legion
db["Charmer's Caldera"],	Dungeon"],	Rift
db["Chronicle: A Hero Rises"],	Chronicle"],	Storm Legion
db["Chronicle: Greenscale's Blight"],	Chronicle"],	Rift
db["Chronicle: Hammerknell Fortress"],	Chronicle"],	Rift
db["Chronicle: River of Souls"],	Chronicle"],	Rift
db["Citadel of Insanity"],	Dungeon"],	Nightmare Tide
db["City Core"],	Normal"],	Storm Legion
db["Conquest"],	Normal"],	Rift
db["Darkening Deeps"],	Dungeon"],	Rift
db["Deepstrike Mines"],	Dungeon"],	Rift
db["Dimension: Alittu"],	Dimension"],	Storm Legion
db["Dimension: Anywhere"],	Dimension"],	Storm Legion
db["Dimension: Atia"],	Dimension"],	Storm Legion
db["Dimension: Auditorium Carnos Plaza"],	Dimension"],	Storm Legion
db["Dimension: Azcu'azg Oasis"],	Dimension"],	Storm Legion
db[""],	"],	
db[""],	"],	
db["Dimension: Bahralt's Ascent"],	Dimension"],	Storm Legion
db["Dimension: Breach Chamber"],	Dimension"],	Storm Legion
db["Dimension: Bronze Tomb"],	Dimension"],	Storm Legion
db["Dimension: Center of Oblivion"],	Dimension"],	Storm Legion
db["Dimension: Central Necropolis"],	Dimension"],	Storm Legion
db["Dimension: Comet of Ahnket"],	Dimension"],	Storm Legion
db["Dimension: Daazez Wastes"],	Dimension"],	Storm Legion
db["Dimension: Dream Hive"],	Dimension"],	Storm Legion
db["Dimension: Edge of Infinity"],	Dimension"],	Storm Legion
db["Dimension: Edgestone Ridge"],	Dimension"],	Storm Legion
db["Dimension: Empyrean Mill"],	Dimension"],	Storm Legion
db["Dimension: Endless Eclipse"],	Dimension"],	Storm Legion
db["Dimension: Everywhere"],	Dimension"],	Storm Legion
db["Dimension: Faen's Retreat"],	Dimension"],	Storm Legion
db["Dimension: Faering Woods"],	Dimension"],	Storm Legion
db["Dimension: Fetid Plains"],	Dimension"],	Storm Legion
db["Dimension: Fortress of the Apocalypse"],	Dimension"],	Storm Legion
db["Dimension: Gloamwood Glen"],	Dimension"],	Storm Legion
db["Dimension: Golem Foundry"],	Dimension"],	Storm Legion
db["Dimension: Hammerknell"],	Dimension"],	Storm Legion
db["Dimension: Harvest Meadow"],	Dimension"],	Storm Legion
db["Dimension: Haunted Terminal"],	Dimension"],	Storm Legion
db["Dimension: Heart of Darkness"],	Dimension"],	Storm Legion
db["Dimension: Izbithu's Demise"],	Dimension"],	Storm Legion
db["Dimension: Karthan Ponds"],	Dimension"],	Storm Legion
db["Dimension: Kestrel's Cry Ravine"],	Dimension"],	Storm Legion
db["Dimension: Khort"],	Dimension"],	Storm Legion
db["Dimension: Kilcual"],	Normal"],	Rift
db["Dimension: Landquarium"],	Dimension"],	Storm Legion
db["Dimension: Malluma Track"],	Dimension"],	Storm Legion
db[""],	"],	
db["Dimension: Mathosian Cascades"],	Dimension"],	Storm Legion
db["Dimension: Moonriven Breach"],	Dimension"],	Storm Legion
db["Dimension: Moonshade Highlands"],	Dimension"],	Storm Legion
db["Dimension: Octus Monastery"],	Dimension"],	Storm Legion
db["Dimension: Ovog Shrine"],	Dimension"],	Storm Legion
db["Dimension: Plaza Aurentine"],	Dimension"],	Storm Legion
db["Dimension: Polyp Promenade"],	Dimension"],	Storm Legion
db["Dimension: Pus Swamp"],	Dimension"],	Storm Legion
db["Dimension: Saint Taranis"],	Dimension"],	Storm Legion
db["Dimension: Scarlet Gorge Cliff"],	Dimension"],	Storm Legion
db["Dimension: Shadow Scion"],	Dimension"],	Storm Legion
db["Dimension: Snarebrush Grot"],	Dimension"],	Storm Legion
db["Dimension: Stillmoor Vale"],	Dimension"],	Storm Legion
db["Dimension: Stone Flask Tavern"],	Dimension"],	Storm Legion
db["Dimension: Stone Grove"],	Dimension"],	Storm Legion
db["Dimension: Strozza Estate Villa"],	Dimension"],	Storm Legion
db["Dimension: Subzero"],	Dimension"],	Storm Legion
db["Dimension: Tempest Island"],	Dimension"],	Storm Legion
db["Dimension: Tower Meadow"],	Dimension"],	Storm Legion
db["Dimension: Tulan"],	Dimension"],	Storm Legion
db["Dimension: Vengeful Sky"],	Dimension"],	Storm Legion
db["Dimension: Volcanic Playground"],	Dimension"],	Storm Legion
db["Dimension: Wyrd Hut"],	Dimension"],	Storm Legion
db["Draumheim"],	Normal"],	Nightmare Tide
db["Droughtlands"],	Normal"],	Rift
db["Drowned Halls"],	Raid 10"],	Rift
db["Duo -Queen Gambit"],	Chronicle"],	Storm Legion
db["Eastern Holdings"],	Normal"],	Storm Legion
db["Ember Isle"],	Normal"],	Rift
db["Empyrean Core"],	Dungeon"],	Storm Legion
db[""],	"],	
db["Endless Eclipse"],	Raid 20"],	Storm Legion
db["Exodus of the Storm Queen"],	Dungeon"],	Storm Legion
db["Foul Cascade"],	Dungeon"],	Rift
db["Freemarch"],	Normal"],	Rift
db["Frozen Tempest"],	Raid 20"],	Storm Legion
db["Gedlo Badlands"],	Normal"],	Starfall Prophecy
db["Ghar Station Eyn"],	Warfront"],	Rift
db["Gilded Prophecy"],	Raid 10"],	Rift
db["Glacial Maw"],	Dungeon"],	Nightmare Tide
db["Gloamwood"],	Normal"],	Rift
db["Goboro Reef"],	Normal"],	Nightmare Tide
db["Golem Foundry"],	Dungeon"],	Storm Legion
db["Greenscale's Blight"],	Normal"],	Rift
db["Greenscale's Blight"],	Normal"],	Rift
db["Greenscale's Blight"],	Normal"],	Rift
db["Greenscale's Blight"],	Raid 20"],	Rift
db["Grim Awakening"],	Raid 10"],	Storm Legion
db["Gyel Fortress"],	Dungeon"],	Nightmare Tide
db["Hammerknell Fortress"],	Raid 20"],	Rift
db["Infernal Dawn"],	Chronicle"],	Storm Legion
db["Infernal Dawn"],	Raid 20"],	Rift
db["Intrepid: Drowned Halls"],	Raid 10"],	Rift
db["Intrepid: Rise of the Phoenix"],	Raid 10"],	Rift
db["Intrepid Chronicle: Greenscale's Blight"],	Chronicle"],	Rift
db["Intrepid Chronicle: Hammerknell Fortress"],	Chronicle"],	Rift
db["Intrepid Chronicle: River of Souls"],	Chronicle"],	Rift
db["Intrepid Darkening Deeps"],	Dungeon"],	Starfall Prophecy
db["Iron Pine Peak"],	Normal"],	Rift
db["Iron Tomb"],	Dungeon"],	Rift
db["Karthan Ridge"],	Warfront"],	Storm Legion
db[""],	"],	
db["King's Breach"],	Dungeon"],	Rift
db["Kingdom of Pelladane"],	Normal"],	Storm Legion
db["Kingsward"],	Normal"],	Storm Legion
db["Library of the Runemasters"],	Warfront"],	Rift
db["Mathosia"],	Normal"],	Rift
db["Meridian"],	Chronicle"],	Rift
db["Meridian"],	Normal"],	Rift
db["Moonshade Highlands"],	Normal"],	Rift
db["Morban"],	Normal"],	Storm Legion
db["Mount Sharax"],	Raid 20"],	Nightmare Tide
db["Nightmare Coast"],	Dungeon"],	Nightmare Tide
db["Planebreaker Bastion"],	Raid 20"],	Storm Legion
db["Planebreaker Bastion"],	Chronicle"],	Storm Legion
db["Planetouched Wilds"],	Normal"],	Rift
db["Primeval Feast"],	Raid 10"],	Rift
db["Realm of the Fae"],	Dungeon"],	Rift
db["Realm of Twisted Dreams"],	Dungeon"],	Storm Legion
db["Return to Deepstrike"],	Dungeon"],	Rift
db["Return to Empyrean Core"],	Dungeon"],	Nightmare Tide
db["Return to Iron Tomb"],	Dungeon"],	Nightmare Tide
db["Rhaza'de Canyons"],	Dungeon"],	Rift
db["Rise of the Phoenix"],	Raid 10"],	Rift
db["River of Souls"],	Raid 20"],	Rift
db["Runic Descent"],	Dungeon"],	Rift
db["Sanctum"],	Chronicle"],	Rift
db["Sanctum"],	Normal"],	Rift
db["Scarlet Gorge"],	Normal"],	Rift
db["Scarwood Reach"],	Normal"],	Rift
db["Scatherran Forest"],	Normal"],	Starfall Prophecy
db["Seratos"],	Normal"],	Storm Legion
db[""],	"],	
db["Shimmersand"],	Normal"],	Rift
db["Silverwood"],	Normal"],	Rift
db["Steppes of Infinity"],	Normal"],	Storm Legion
db["Stillmoor"],	Normal"],	Rift
db["Stonefield"],	Normal"],	Rift
db["Storm Breaker Protocol"],	Dungeon"],	Storm Legion
db["Tarken Glacier"],	Normal"],	Nightmare Tide
db["Tempest Bay"],	Normal"],	Storm Legion
db["Temple of Ananke"],	Dungeon"],	Starfall Prophecy
db["Tenebrean Schism"],	Normal"],	Starfall Prophecy
db["Tenebrean Trouble"],	Normal"],	Rift
db["Terminus"],	Normal"],	Rift
db["The Battle for Port Scion"],	Warfront"],	Rift
db["The Black Garden"],	Warfront"],	Rift
db["The Codex"],	Warfront"],	Rift
db["The Dendrome"],	Normal"],	Storm Legion
db["The Fall of Lantern Hook"],	Dungeon"],	Rift
db["The Infinity Gate"],	Raid 20"],	Storm Legion
db["The Mind of Madness"],	Raid 20"],	Rift
db["The Rhen of Fate"],	Raid 10"],	Nightmare Tide
db["The Tenebrean Prison"],	Warfront"],	Rift
db["Tower of the Shattered"],	Dungeon"],	Storm Legion
db["Triumph of the Dragon Queen"],	Raid 10"],	Storm Legion
db["Tuath'de Coven"],	Dungeon"],	Starfall Prophecy
db["Tyrant's Forge"],	Raid 20"],	Nightmare Tide
db["Tyrant's Throne"],	Normal"],	Nightmare Tide
db["Unhallowed Boneforge"],	Dungeon"],	Storm Legion
db["Vostigar Peaks"],	Normal"],	Starfall Prophecy
db["Whitefall Steppes"],	Warfront"],	Rift
db["Xarth Mire"],	Normal"],	Starfall Prophecy
]]--   
   
