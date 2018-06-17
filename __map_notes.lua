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

      if db ~= nil and next(db) ~= nil then
         self.notes     =  db
      else
         self.notes     =  {}
      end

      -- Seek lastidx used (highest)
      local tbl, idx = {}, nil
      for _, tbl in pairs(self.notes) do
         for _, b in pairs(tbl) do
            if b.idx ~= nil then
               print(string.format("__map_notes.loaddb: b=%s", b))
               print(string.format("__map_notes.loaddb: lastidx=%s, tbl.idx=%s", self.lastidx, b.idx))

--                print("__map_notes.loaddb: dump(b):", mano.f.dumptable(b))

               self.lastidx   =  math.max(self.lastidx, b.idx)
            end
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
   
   function self.getzonedata(zonename)
      print(string.format("self.getzonedata(%s)", zonename))
      local t  =  {}
      
      if zonename ~= nil then
         if self.notes[zonename] ~= nil then
            t  =  self.notes[zonename]
         end
      end
         
      return t
   end   
   
   function self.getzonedatabyid(zoneid)
      print(string.format("self.getzonedatabyid(%s)", zoneid))
      local t   =  {}
      
      if zoneid ~= nil then
         local zone  =  Inspect.Zone.Detail(zoneid)
         local t  =  self.getzonedata(zone.name)
      end
      
      return   t
   end   

   function self.new(notetext, notecategory)

      if self.notes  == nil or not next(self.notes) then
         loaddb()
      end

      local t              =  {}
      local playerposition =  getplayerposition()

      if next(playerposition) then


         self.lastidx   =  self.lastidx   +  1

         if notetext ~= nil then

            if not self.notes[playerposition.zonename]  then
               self.notes[playerposition.zonename]   =  {}
            end

            t  =  {  idx         =  self.lastidx,
                     text        =  notetext or "Lorem Ipsum",
                     category    =  notecategory,
                     playerpos   =  playerposition,
                     timestamp   =  os.time(),
                  }

            table.insert(self.notes[playerposition.zonename], t)

         end

      else
         print("__map_notes ERROR: can't determinate Player position, skipping note.")
      end

--       return self.lastidx
      return t
   end

   loaddb(basedb or nil)

   -- return the class instance
   return self

end

