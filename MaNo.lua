--
-- Addon       MaNo.lua
-- Author      marcob@marcob.org
-- StartDate   05/05/2018
--
local addon, mano = ...
--
mano.addon           =  {}
mano.addon.name      =  Inspect.Addon.Detail(Inspect.Addon.Current())["name"]
mano.addon.version   =  Inspect.Addon.Detail(Inspect.Addon.Current())["toc"]["Version"]
--
if not mano.mapnote then mano.mapnote =  mapnotes()   end
mano.noteinputform   =  noteinputform()
--

local function parseslashcommands(params)

   mano.f.dprint(string.format( "got mano [%s]", params))

   for i in string.gmatch(params, "%S+") do

      mano.f.dprint(string.format( "i [%s]", i))

      if i  == "add"         then

         local playerposition =  mano.mapnote.getplayerposition()

--          for var, val in pairs(playerposition) do
--             print(string.format("parseslashcommands: playerposition -> [%s]=val[%s]", var, val))
--          end


         if next(playerposition) then
            local notetext       =  mano.noteinputform.show(playerposition)
            mano.mapnote.new(playerposition, notetext)
            local t     = {}
            t.icon      =  nil
            t.text      =  notetext
            t.x         =  playerposition.coordX
            t.z         =  playerposition.coordZ
            t.zoneid    =  playerposition.zoneid
            t.location  =  playerposition.locationName

--             for var, val in pairs(t) do
--                print(string.format("parseslashcommands: var[%s]=val[%s]", var, val))
--             end

            mano.uiclass.addline(t)
--             mano.uiclass.adjustheight()
         else
            print(string.format("ERROR: parseslashcommands: playerposition is empty!"))
         end

      end
   end

   return
end

local function savevariables(_, addonname)

   if addon.name == addonname then

      local a        =  {}
      a.mmbtn        =  mano.gui.mmbtn
      a.win          =  mano.gui.win    
      manoguidata    =  a

      if next(mano.mapnote.notes) then
         manonotesdb    =  mano.mapnote.notes
      end
   end

   return
end

local function loadvariables(_, addonname)

   if addon.name == addonname then

      if manoguidata then

         local a  =  manoguidata
         local key, val = nil, nil
         for key, val in pairs(a) do   
            mano.gui[key]  =  val   
            mano.f.dprint(string.format("Importing %s: %s", key, val))
            if mano.flags.debug then
               local vvar, vval = nil, nil
               for vvar, vval in pairs(val) do
                  print(string.format("  [%s]=[%s]", vvar, vval))
               end
            end
         end

      end

      if manonotesdb  then
         if not mano.mapnote then mano.mapnote =  mapnotes()   end

         mano.mapnote.loaddb(manonotesdb)

      end

      Command.Event.Detach(Event.Addon.SavedVariables.Load.End,   loadvariables,	"MaNo: Load Variables")
   end

   return
end

-- local function displayresultsandaddnote(t)
-- 
--    local k, v = nil, nil
--    local a, b = nil, nil
-- 
--    for k, v in pairs (t) do
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
--                                        string.format("BagWatcher: %s %s (base/delta/stack=%s/%s/%s)", 
--                                           v.name,
--                                           (v.stack - (mano.delta[v.name] or 0)),
--                                           (mano.base[v.name] or nil),
--                                           (mano.delta[v.name] or nil),
--                                           v.stack
--                                           ),
--                                        true)
--          end
-- 
--          mano.delta[v.name] =  v.stack
--          if not mano.base[v.name] then mano.base[v.name] = v.stack end
-- 
--          -- add map note
--          mano.mapnote.new(playerposition, v)
--       end
--    end
-- 
--    return
-- end


local function displayresultsandaddnote(t)

   local k, v = nil, nil
   local a, b = nil, nil

   for k, v in pairs (t) do

      if mano.base  then
         --
         -- is it a REAL event or we did just got a
         -- refresh from server, like when we use a
         -- porticulum?
         --
         if (v.stack ~= (mano.delta[v.name] or 0)) then
            Command.Console.Display(   "general",
                                       true,
                                       string.format("BagWatcher: %s %s (base/delta/stack=%s/%s/%s)", v.name,
                                       (v.stack - (mano.delta[v.name] or 0)),
                                       (mano.base[v.name] or nil),
                                       (mano.delta[v.name] or nil),
                                       v.stack
                                    ),
                                    true)
         end

         mano.delta[v.name] =  v.stack
         if not mano.base[v.name] then
            mano.base[v.name] = v.stack
         end

         -- add map note
         mano.mapnote.new(playerposition, v)
--          mano.ui.addline(t.icon, t.text. t.x. t.z, playerposition.locationName)

      end
   end

   return
end



local function startmeup(h, t)

   if not mano.init.startup then

      -- Create/Display/Hide Mini Map Button Window
      if mano.gui.mmbtnobj == nil then
         mano.mmbutton     =  mano.createminimapbutton()
         mano.gui.mmbtnobj =  mano.mmbutton.button
         mano.gui.mmbtnobj:SetVisible(true)
         mano.init.startup =  true
      end

      -- inizitialize __bag_watcher() and __bag_scanner()
      mano._init_watchers(h, t, displayresultsandaddnote)

      -- remove tracking for this event
      Command.Event.Detach(Event.Unit.Availability.Full, startmeup, "MaNo: startup event")

      mano.uiclass      =  manoui()
      mano.gui.shown.window =  mano.uiclass.new()

      Library.LibDraggable.draggify(mano.gui.shown.window, mano.f.updateguicoordinates)

      mano.gui.shown.window:SetVisible(true)

   end

   return
end


-- Event tracking initialization -- begin
Command.Event.Attach(Event.Unit.Availability.Full,          startmeup,     "MaNo: startup event")
Command.Event.Attach(Event.Addon.SavedVariables.Load.End,   loadvariables,	"MaNo: Load Variables")
Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, savevariables, "MaNo: Save Variables")
-- Event tracking initialization -- end
--
table.insert(Command.Slash.Register("mano"), {function (...) parseslashcommands(...) end, mano.addon.name, "MaNo: add note here"})

