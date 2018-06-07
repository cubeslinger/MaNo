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
if not mano.mapnote then mano.mapnote =  __map_notes()   end
-- mano.noteinputform   =  noteinputform()
--

-- local function parseslashcommands(params)
--
--    print(string.format("params: -- begin => params(%s)", params))
--    print("params: ", mano.f.dumptable(params))
--    print("params: -- end")
--
--
--    for i in string.gmatch(params, "%S+") do
--
--       if i  == "add"         then
--
--          local playerposition =  mano.mapnote.getplayerposition()
--
--          if next(playerposition) then
-- --             local notetext       =  mano.noteinputform.show(playerposition)
--             local notetext =  "Lorem Ipsum"
--             mano.mapnote.new(playerposition, notetext)
--             local t     = {}
--             t.icon      =  nil
--             t.text      =  notetext or "Lorem Ipsum"
--             t.x         =  playerposition.coordX
--             t.z         =  playerposition.coordZ
--             t.zoneid    =  playerposition.zoneid
--             t.location  =  playerposition.locationName
--
--             if mano.flags.debug  then
--                for var, val in pairs(t) do
--                   print(string.format("t => var[%s]=val[%s]", var, val))
--                end
--             end
--
-- --             mano.uiclass.addline(t)
--
--             if mano.gui.shown.window ~= nil and next(mano.gui.shown.window) then
--                print("XXXX -- begin")
--                print("XXXX: ", mano.f.dumptable(mano.gui.shown.window.o.window))
--                print("XXXX -- end")
--                mano.gui.shown.window.o.window.addline(t)
--             else
--                print("ERROR: mano.gui.shown.window is nil")
--             end
--
--          else
--             print(string.format("ERROR: parseslashcommands: playerposition is empty!"))
--          end
--
--       end
--    end
--
--    return
-- end

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
         if not mano.mapnote then mano.mapnote =  __map_notes()   end

         mano.mapnote.loaddb(manonotesdb)

      end

      Command.Event.Detach(Event.Addon.SavedVariables.Load.End,   loadvariables,	"MaNo: Load Variables")
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
      end


      -- remove tracking for this event


      mano.gui.shown.window   =  __mano_ui()

--       print("mano.gui.shown.window: ", mano.f.dumptable(mano.gui.shown.window))


      Library.LibDraggable.draggify(mano.gui.shown.window.o.window, mano.f.updateguicoordinates)

      mano.gui.shown.window.o.window:SetVisible(true)

      print("++ STARMEUP ++")
      Command.Event.Detach(Event.Unit.Availability.Full, startmeup, "MaNo: startup event")
      mano.init.startup =  true
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
