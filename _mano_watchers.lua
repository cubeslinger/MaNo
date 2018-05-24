--
-- Addon       _watchers.lua
-- Author      marcob@marcob.org
-- StartDate   04/04/2018
-- Version     0.6
--
local addon, mano = ...
--
local function countarray(array)
   local k, v  =  nil, nil
   local count =  0
   local t     =  array

   if array then
      for k, v in pairs(array) do count = count +1 end
   end

   return count
end

-- local function displayresults(t)
-- local function displayresultsandaddnote(t)
--
--    local k, v = nil, nil
--    local a, b = nil, nil
--
--    for k, v in pairs (t) do
--
-- --       print(string.format("_init_watchers: displayresults (t): msgid [%s]", k))
-- --       for a, b in pairs(v) do
-- --          print(string.format("    : %s=%s", a, b))
-- --       end
--
--
--       if mano.base  then
--          --
--          -- is it a REAL event or we did just got a
--          -- refresh from server, like when we use a
--          -- porticulum?
--          --
--          if (v.stack ~= (mano.delta[v.name] or 0)) then
--             Command.Console.Display(   "general",
--                                        true,
--                                        string.format("BagWatcher: %s %s (base/delta/stack=%s/%s/%s)", v.name,
--                                                             (v.stack - (mano.delta[v.name] or 0)),
--                                                             (mano.base[v.name] or nil),
--                                                             (mano.delta[v.name] or nil),
--                                                             v.stack
--                                                    ),
--                                        true)
--          end
--
--          mano.delta[v.name] =  v.stack
--          if not mano.base[v.name] then mano.base[v.name] = v.stack end
--
--          -- add map note
--          mano.mapnote.new(playerposition, v)
--          mano.ui.addline(t.icon, t.text. t.x. t.z, playerposition.locationName)
--
--       end
--    end
--
--    return
--
-- end

local function  doinventoryscan()

   mano.bagscanner.scanlist( { "inventory", "quest" })
   mano.delta =  mano.bagscanner.base
   mano.base  =  mano.bagscanner.base

--    print(string.format("BagWatcher is ready: %s items indexed.", countarray(mano.base)))

   Command.Console.Display( "general", true, string.format("BagWatcher is ready: %s items indexed.", countarray(mano.base)), true)

   return

end

function mano._init_watchers(h, t, callback)

   mano.player   =  Inspect.Unit.Detail("player")
   mano.base     =  {}
   mano.delta    =  {}

   local availableid, availablename, weareready =  nil,  nil, false

   for availableid, availablename in pairs(t) do if mano.player.id == availableid then  weareready = true break end end

   if weareready then

      Command.Event.Detach(Event.Unit.Availability.Full, _init_watchers, "Stats: get base stats")

--       mano.bagwatcher  =  bagwatcher(displayresults)
--       mano.bagwatcher  =  bagwatcher(displayresultsandaddnote)
      mano.bagwatcher  =  bagwatcher(callback)
      mano.bagscanner  =  bagscanner()

      mano.timer       =  __timer()
      mano.timer.add(doinventoryscan, 5)

      local q  =  {  -- fish     =  mano.bagwatcher.addwatcher({ category =  "fish",                 bag="si" }),   -- everything in a category with "fish" in it's name (in inventory)
                     -- burlap   =  mano.bagwatcher.addwatcher({ name     =  "burlap cloth",         bag="si" }),   -- look for "burlap cloth" by name (case INsensitive)(in inventory)
                     artifact =  mano.bagwatcher.addwatcher({ category =  "artifact",             bag="si" }),   -- look for "burlap cloth" by name (case INsensitive)(in inventory)
                     -- sparkles =  mano.bagwatcher.addwatcher({ name     =  "exceptional sparkles", bag="qst"})    -- look for "Exceptional Sparkles" by name (in Quest Log Bag Slots)
                  }

--       -- display active Watchers list
--       local watcherslist   =  mano.bagwatcher.list()
--       -- debug -- begin
--       if next(watcherslist)  then
--
--          for queryid, table in pairs(watcherslist) do
--
--             print(string.format("Watchers List, QuerID: [%s]", queryid))
--
--             local k, v  =  nil, nil
--             for k, v in pairs(table) do
--                --                print(string.format("             : k[%s]=v(%s)", k, v))
--
--                local a, b  =  nil, nil
--                for a, b in pairs(v) do
--                   print(string.format("             : [%s]=(%s)", a, b))
--                end
--             end
--          end
--       end
--       -- debug -- end

   end

   return

end

-- Command.Event.Attach(Event.Unit.Availability.Full, mano._init_watchers,    "Stats: get base stats")
