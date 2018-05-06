--
-- Addon       _mano_init.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
local addon, mano = ...

mano.addon               =  Inspect.Addon.Detail(Inspect.Addon.Current())["name"]
mano.version             =  Inspect.Addon.Detail(Inspect.Addon.Current())["toc"]["Version"]
--
mano.base  =  {}
--
function mano.getbase()

   mano.base  =  {}
   results    =  Inspect.Unit.Detail("player")

   if results then
      Command.Console.Display("general", true, "========================================", true)
      for var, val in pairs(results) do
         Command.Console.Display("general", true, string.format("[%20s]=[%s]", var, val), true)
      end
      Command.Console.Display("general", true, "========================================", true)

--       mano.base  =  results
--       Command.Event.Attach(Event.Stat, function(handle, params) mano.gotevent(handle, params) end,    "MaNo: event detected.")
   end
   return
end

-- Command.Event.Attach(Event.Unit.Availability.Full, mano.getbase,    "MaNo: get base mano")


-- local player   =  Inspect.Unit.Detail("player")

-- coordX, coordY, coordZ, zone, locationName, radius, name
-- 
