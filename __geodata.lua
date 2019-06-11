--
-- Addon       __geodata.lua
-- Author      marcob@marcob.org
-- StartDate   17/07/2018
-- Version     0.3
-- Source:     https://rift.magelo.com/en/zones.jspa
--

function __geodata()
   -- the new instance
   local self =   {
                     db          =  {},
                     initialized =  false,
                  }
   -- public fields go in the instance table

   self.db.chronicles   =  {
                              { zonename="Chronicle: A Hero Rises", zonetype="Chronicle", expansion="Storm Legion", zoneid="" },
                              { zonename="Chronicle: Greenscale's Blight", zonetype="Chronicle", expansion="Rift", zoneid="" },
                              { zonename="Chronicle: Hammerknell Fortress", zonetype="Chronicle", expansion="Rift", zoneid="" },
                              { zonename="Chronicle: River of Souls", zonetype="Chronicle", expansion="Rift", zoneid="" },
                              { zonename="Duo-Queen Gambit", zonetype="Chronicle", expansion="Storm Legion", zoneid="" },
                              { zonename="Infernal Dawn", zonetype="Chronicle", expansion="Storm Legion", zoneid="" },
                              { zonename="Intrepid Chronicle: Greenscale's Blight", zonetype="Chronicle", expansion="Rift", zoneid="" },
                              { zonename="Intrepid Chronicle: Hammerknell Fortress", zonetype="Chronicle", expansion="Rift", zoneid="" },
                              { zonename="Intrepid Chronicle: River of Souls", zonetype="Chronicle", expansion="Rift", zoneid="" },
                              { zonename="Meridian", zonetype="Chronicle", expansion="Rift", zoneid="z6BA3E574E9564149" },
                              { zonename="Planebreaker Bastion", zonetype="Chronicle", expansion="Storm Legion", zoneid="" },
                              { zonename="Sanctum", zonetype="Chronicle", expansion="Rift", zoneid="" },
   }
   self.db.dimensions  =  {
                              { zonename="Dimension: Alittu", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Anywhere", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Atia", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Auditorium Carnos Plaza", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Azcu'azg Oasis", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Bahralt's Ascent", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Breach Chamber", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Bronze Tomb", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Center of Oblivion", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Central Necropolis", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Comet of Ahnket", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Daazez Wastes", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Dream Hive", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Edge of Infinity", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Edgestone Ridge", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Empyrean Mill", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Endless Eclipse", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Everywhere", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Faen's Retreat", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Faering Woods", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Fetid Plains", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Fortress of the Apocalypse", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Gloamwood Glen", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Golem Foundry", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Hammerknell", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Harvest Meadow", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Haunted Terminal", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Heart of Darkness", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Izbithu's Demise", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Karthan Ponds", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Kestrel's Cry Ravine", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Khort", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Kilcual", zonetype="Dimension", expansion="Rift", zoneid="" },
                              { zonename="Dimension: Landquarium", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Malluma Track", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Mathosian Cascades", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Moonriven Breach", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Moonshade Highlands", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Octus Monastery", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Ovog Shrine", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Plaza Aurentine", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Polyp Promenade", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Pus Swamp", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Saint Taranis", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Scarlet Gorge Cliff", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Shadow Scion", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Snarebrush Grot", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Stillmoor Vale", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Stone Flask Tavern", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Stone Grove", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Strozza Estate Villa", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Subzero", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Tempest Island", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Tower Meadow", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Tulan", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Vengeful Sky", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Volcanic Playground", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
                              { zonename="Dimension: Wyrd Hut", zonetype="Dimension", expansion="Storm Legion", zoneid="" },
   }
   self.db.dungeons  =  {
                           { zonename="Abyssal Precipice", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Archive of Flesh", zonetype="Dungeon", expansion="Storm Legion", zoneid="" },
                           { zonename="Caduceus Rise", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Charmer's Caldera", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Citadel of Insanity", zonetype="Dungeon", expansion="Nightmare Tide", zoneid="" },
                           { zonename="Darkening Deeps", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Deepstrike Mines", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Empyrean Core", zonetype="Dungeon", expansion="Storm Legion", zoneid="" },
                           { zonename="Exodus of the Storm Queen", zonetype="Dungeon", expansion="Storm Legion", zoneid="" },
                           { zonename="Foul Cascade", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Glacial Maw", zonetype="Dungeon", expansion="Nightmare Tide", zoneid="" },
                           { zonename="Golem Foundry", zonetype="Dungeon", expansion="Storm Legion", zoneid="" },
                           { zonename="Gyel Fortress", zonetype="Dungeon", expansion="Nightmare Tide", zoneid="" },
                           { zonename="Intrepid Darkening Deeps", zonetype="Dungeon", expansion="Starfall Prophecy", zoneid="" },
                           { zonename="Iron Tomb", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="King's Breach", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Nightmare Coast", zonetype="Dungeon", expansion="Nightmare Tide", zoneid="" },
                           { zonename="Realm of the Fae", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Realm of Twisted Dreams", zonetype="Dungeon", expansion="Storm Legion", zoneid="" },
                           { zonename="Return to Deepstrike", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Return to Empyrean Core", zonetype="Dungeon", expansion="Nightmare Tide", zoneid="" },
                           { zonename="Return to Iron Tomb", zonetype="Dungeon", expansion="Nightmare Tide", zoneid="" },
                           { zonename="Rhaza'de Canyons", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Runic Descent", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Storm Breaker Protocol", zonetype="Dungeon", expansion="Storm Legion", zoneid="" },
                           { zonename="Temple of Ananke", zonetype="Dungeon", expansion="Starfall Prophecy", zoneid="" },
                           { zonename="The Fall of Lantern Hook", zonetype="Dungeon", expansion="Rift", zoneid="" },
                           { zonename="Tower of the Shattered", zonetype="Dungeon", expansion="Storm Legion", zoneid="" },
                           { zonename="Tuath'de Coven", zonetype="Dungeon", expansion="Starfall Prophecy", zoneid="" },
                           { zonename="Unhallowed Boneforge", zonetype="Dungeon", expansion="Storm Legion", zoneid="" },
   }
   self.db.raids  =  {
                        { zonename="Binding of Blood: Maelforge", zonetype="Raid 20", expansion="Storm Legion", zoneid="" },
                        { zonename="Bindings of Blood: Akylios", zonetype="Raid 20", expansion="Storm Legion", zoneid="" },
                        { zonename="Bindings of Blood: Greenscale", zonetype="Raid 20", expansion="Storm Legion", zoneid="" },
                        { zonename="Bindings of Blood: Laethys", zonetype="Raid 20", expansion="Storm Legion", zoneid="" },
                        { zonename="Drowned Halls", zonetype="Raid 10", expansion="Rift", zoneid="" },
                        { zonename="Endless Eclipse", zonetype="Raid 20", expansion="Storm Legion", zoneid="" },
                        { zonename="Frozen Tempest", zonetype="Raid 20", expansion="Storm Legion", zoneid="" },
                        { zonename="Gilded Prophecy", zonetype="Raid 10", expansion="Rift", zoneid="" },
                        { zonename="Greenscale's Blight", zonetype="Raid 20", expansion="Rift", zoneid="" },
                        { zonename="Grim Awakening", zonetype="Raid 10", expansion="Storm Legion", zoneid="" },
                        { zonename="Hammerknell Fortress", zonetype="Raid 20", expansion="Rift", zoneid="" },
                        { zonename="Infernal Dawn", zonetype="Raid 20", expansion="Rift", zoneid="" },
                        { zonename="Intrepid: Drowned Halls", zonetype="Raid 10", expansion="Rift", zoneid="" },
                        { zonename="Intrepid: Rise of the Phoenix", zonetype="Raid 10", expansion="Rift", zoneid="" },
                        { zonename="Mount Sharax", zonetype="Raid 20", expansion="Nightmare Tide", zoneid="" },
                        { zonename="Planebreaker Bastion", zonetype="Raid 20", expansion="Storm Legion", zoneid="" },
                        { zonename="Primeval Feast", zonetype="Raid 10", expansion="Rift", zoneid="" },
                        { zonename="Rise of the Phoenix", zonetype="Raid 10", expansion="Rift", zoneid="" },
                        { zonename="River of Souls", zonetype="Raid 20", expansion="Rift", zoneid="" },
                        { zonename="The Infinity Gate", zonetype="Raid 20", expansion="Storm Legion", zoneid="" },
                        { zonename="The Mind of Madness", zonetype="Raid 20", expansion="Rift", zoneid="" },
                        { zonename="The Rhen of Fate", zonetype="Raid 10", expansion="Nightmare Tide", zoneid="" },
                        { zonename="Triumph of the Dragon Queen", zonetype="Raid 10", expansion="Storm Legion", zoneid="" },
                        { zonename="Tyrant's Forge", zonetype="Raid 20", expansion="Nightmare Tide", zoneid="" },
   }
   self.db.warfronts =  {
                           { zonename="Assault on Bronze Tomb", zonetype="Warfront", expansion="Rift", zoneid="" },
                           { zonename="Blighted Antechamber", zonetype="Warfront", expansion="Rift", zoneid="" },
                           { zonename="Ghar Station Eyn", zonetype="Warfront", expansion="Rift", zoneid="" },
                           { zonename="Karthan Ridge", zonetype="Warfront", expansion="Storm Legion", zoneid="" },
                           { zonename="Library of the Runemasters", zonetype="Warfront", expansion="Rift", zoneid="" },
                           { zonename="The Battle for Port Scion", zonetype="Warfront", expansion="Rift", zoneid="" },
                           { zonename="The Black Garden", zonetype="Warfront", expansion="Rift", zoneid="" },
                           { zonename="The Codex", zonetype="Warfront", expansion="Rift", zoneid="" },
                           { zonename="The Tenebrean Prison", zonetype="Warfront", expansion="Rift", zoneid="" },
                           { zonename="Whitefall Steppes", zonetype="Warfront", expansion="Rift", zoneid="" },
   }
   self.db.zones  =  {
                        { zonename="Alittu", zonetype="Normal", expansion="Starfall Prophecy", zoneid="" },
                        { zonename="Ardent Domain", zonetype="Normal", expansion="Storm Legion", zoneid="z563CB77E4A32233F" },
                        { zonename="Ashenfell", zonetype="Normal", expansion="Starfall Prophecy", zoneid="" },
                        { zonename="Ashora", zonetype="Normal", expansion="Storm Legion", zoneid="z2F1E4708BEC6A608" },
                        { zonename="Cape Jule", zonetype="Normal", expansion="Storm Legion", zoneid="z698CB7B72B3D69E9" },
                        { zonename="City Core", zonetype="Normal", expansion="Storm Legion", zoneid="z754553DD46F46371" },
                        { zonename="Conquest", zonetype="Normal", expansion="Rift", zoneid="" },
                        { zonename="Draumheim", zonetype="Normal", expansion="Nightmare Tide", zoneid="z0000012E087E78E1" },
                        { zonename="Droughtlands", zonetype="Normal", expansion="Rift", zoneid="z1416248E485F6684" },
                        { zonename="Eastern Holdings", zonetype="Normal", expansion="Storm Legion", zoneid="z48530386ED2EA5AD" },
                        { zonename="Ember Isle", zonetype="Normal", expansion="Rift", zoneid="z76C88A5A51A38D90" },
                        { zonename="Freemarch", zonetype="Normal", expansion="Rift", zoneid="z00000013CAF21BE3" },
                        { zonename="Gedlo Badlands", zonetype="Normal", expansion="Starfall Prophecy", zoneid="" },
                        { zonename="Gloamwood", zonetype="Normal", expansion="Rift", zoneid="z0000001B2BB9E10E" },
                        { zonename="Goboro Reef", zonetype="Normal", expansion="Nightmare Tide", zoneid="z0000012D6EEBB377" },
                        { zonename="Greenscale's Blight", zonetype="Normal", expansion="Rift", zoneid="" },
                        { zonename="Iron Pine Peak", zonetype="Normal", expansion="Rift", zoneid="z00000016EB9ECBA5" },
                        { zonename="Kingdom of Pelladane", zonetype="Normal", expansion="Storm Legion", zoneid="z1C938C07F41C83CC" },
                        { zonename="Kingsward", zonetype="Normal", expansion="Storm Legion", zoneid="z4D8820D7EF52685C" },
                        { zonename="Mathosia", zonetype="Normal", expansion="Rift", zoneid="" },
                        { zonename="Meridian", zonetype="Normal", expansion="Rift", zoneid="z6BA3E574E9564149" },
                        { zonename="Moonshade Highlands", zonetype="Normal", expansion="Rift", zoneid="z0000001804F56C61" },
                        { zonename="Morban", zonetype="Normal", expansion="Storm Legion", zoneid="z39095BA75AD7DC03" },
                        { zonename="Planetouched Wilds", zonetype="Normal", expansion="Rift", zoneid="z0000001CE3FE8B2C" },
                        { zonename="Sanctum", zonetype="Normal", expansion="Rift", zoneid="" },
                        { zonename="Scarlet Gorge", zonetype="Normal", expansion="Rift", zoneid="z019595DB11E70F58" },
                        { zonename="Scarwood Reach", zonetype="Normal", expansion="Rift", zoneid="z000000142C649218" },
                        { zonename="Scatherran Forest", zonetype="Normal", expansion="Starfall Prophecy", zoneid="z7B2B0BB6E3EA1BEC" },
                        { zonename="Seratos", zonetype="Normal", expansion="Storm Legion", zoneid="z59124F7DD7F15825" },
                        { zonename="Shimmersand", zonetype="Normal", expansion="Rift", zoneid="z000000069C1F0227" },
                        { zonename="Silverwood", zonetype="Normal", expansion="Rift", zoneid="z0000000CB7B53FD7" },
                        { zonename="Steppes of Infinity", zonetype="Normal", expansion="Storm Legion", zoneid="z2F9C9E1FF91F9293" },
                        { zonename="Stillmoor", zonetype="Normal", expansion="Rift", zoneid="z0000001A4AF8CD7A" },
                        { zonename="Stonefield", zonetype="Normal", expansion="Rift", zoneid="z585230E5F68EA919" },
                        { zonename="Tarken Glacier", zonetype="Normal", expansion="Nightmare Tide", zoneid="z0000012F14279B5A" },
                        { zonename="Tempest Bay", zonetype="Normal", expansion="Storm Legion", zoneid="" },
                        { zonename="Tenebrean Schism", zonetype="Normal", expansion="Starfall Prophecy", zoneid="" },
                        { zonename="Tenebrean Trouble", zonetype="Normal", expansion="Rift", zoneid="" },
                        { zonename="Terminus", zonetype="Normal", expansion="Rift", zoneid="" },
                        { zonename="The Dendrome", zonetype="Normal", expansion="Storm Legion", zoneid="z10D7E74AB6D7B293" },
                        { zonename="Tyrant's Throne", zonetype="Normal", expansion="Nightmare Tide", zoneid="z196650F5AA524928" },
                        { zonename="Vostigar Peaks", zonetype="Normal", expansion="Starfall Prophecy", zoneid="z1E81B494CFA05AD0" },
                        { zonename="Xarth Mire", zonetype="Normal", expansion="Starfall Prophecy", zoneid="" },
   }

   function self.getzonedatabyzonename(zname)

      local retval   =  {}
      for _, tbl in ipairs(self.db.zones) do

         if zname == tbl.zonename then
--             print(string.format("got zone id; %s", tbl.zoneid))
            retval   =  tbl
            break
         end

      end

      return retval
   end



   return self
end
