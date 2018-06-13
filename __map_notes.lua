--
-- Addon       __map_notes.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
function __map_notes(basedb)

   local self =   {
                  notes    =  {},
                  lastidx  =  0,
                  }

   local function loaddb(db)

      if db ~= nil then
         self.notes     =  db
      else
         self.notes     =  {}
      end

      -- Seek lastidx used (highest)
      local tbl, idx = {}, nil
      for _, tbl in pairs(self.notes) do
         for _, b in pairs(tbl) do
            print(string.format("__map_notes.loaddb: a=%s, b=%s", a, b))
--             if a == 'idx' then
               print(string.format("__map_notes.loaddb: lastidx=%s, tbl.idx=%s", self.lastidx, b.idx))
--                self.lastidx   =  math.max(self.lastidx, tbl.idx)
               self.lastidx   =  math.max(self.lastidx, b.idx)
--             end
         end
      end

      return
   end


   local function getplayerposition()

      local t  =  {}
      local bool, playerdata = pcall(Inspect.Unit.Detail, "player")


      if bool  then
         t.coordX         = playerdata.coordX
         t.coordY         = playerdata.coordY
         t.coordZ         = playerdata.coordZ
         t.zone           = playerdata.zone
         t.locationName   = playerdata.locationName
         t.radius         = playerdata.radius
         t.name           = playerdata.name

         local bool, zonedata = pcall(Inspect.Zone.Detail, t.zone)

         t.zonename  =  (zonedata.name or nil)
         t.zoneid    =  (zonedata.id   or nil)
         t.zonetype  =  (zonedata.type or nil)
      end

      return t
   end

   function self.new(notetext, notecategory)

      if self.notes  == nil or not next(self.notes) then
         loaddb()
      end


      local playerposition =  getplayerposition()

      if next(playerposition) then


         self.lastidx   =  self.lastidx   +  1

         if notetext ~= nil then

            if not self.notes[playerposition.zoneid]  then
               self.notes[playerposition.zoneid]   =  {}
            end

            table.insert(self.notes[playerposition.zoneid], {  idx         =  self.lastidx,
                                                               text        =  notetext or "",
                                                               category    =  notecategory,
                                                               playerpos   =  playerposition,
                                                               timestamp   =  os.time(),
                                                            }
                        )

         end

      else
         print("__map_notes ERROR: can't determinate Player position, skipping note.")
      end

      return self.lastidx
   end

   loaddb(basedb or nil)

   -- return the class instance
   return self

end

