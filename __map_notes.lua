--
-- Addon       __map_notes.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
function mapnotes()
   -- the new instance
   local self =   {
                  notes =  {},
--                   mailbox     =  {},
                  -- public fields go in the instance table
                  }

   --
   -- private fields are implemented using locals
   -- they are faster than table access, and are truly private, so the code that uses your class can't get them
   --
--    local watchers             =  {}
--    local queryid              =  0
--    local msgid                =  0
--    local lastmsg              =  0

--    --private
--    local function countarray(array)
--       local k, v  =  nil, nil
--       local count =  0
--       local t     =  array
--
--       if array then
--          for k, v in pairs(array) do count = count +1 end
--       end
--
--       return count
--    end


   --
   -- PUBLIC:
   --
   function self.getplayerposition()

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
         t.zoneid    =  (zonedata.id or nil)
         t.zonetype  =  (zonedata.type or nil)
      end

      return t
   end

   function self.new(playerposition, notetext)

      print "mapnotes.new()"

      if not playerposition or not next(playerposition) then playerposition =  self.getplayerposition() end

      if next(playerposition) then
         Command.Console.Display("general", true, "========================================", true)
         for var, val in pairs(playerposition) do
            Command.Console.Display("general", true, string.format("[%20s]=[%s]", var, val), true)
         end
         Command.Console.Display("general", true, "========================================", true)

         --
         -- MaNo specific  -- begin
         --
         -- here we need to normalize coords to check for
         -- an already exiting note in the same "radius area",
         -- including Z axis distance.
         local idx   =  playerposition.coordX .. "," .. playerposition.coordY .. "," .. playerposition.coordZ
--          if not mano.notes[playerposition.zoneid]   then  mano.notes[playerposition.zoneid] =  {} end
--          mano.notes[playerposition.zoneid][idx]  =  notetext

         if notetext ~= nil then
            if not self.notes[playerposition.zoneid]        then  self.notes[playerposition.zoneid]      =  {} end
            if not self.notes[playerposition.zoneid][idx]   then  self.notes[playerposition.zoneid][idx] =  {} end

            table.insert(self.notes[playerposition.zoneid][idx], notetext)
         end


         --
         -- MaNo specific  -- end
         --
      end

      return
   end

   function self.loaddb(db)

      self.notes  =  manonotesdb

      return
   end

   -- return the class instance
   return self

end

