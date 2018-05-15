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
mano.mapnote         =  mapnotes()
mano.noteinputform   =  noteinputform()
--

local function parseslashcommands(params)

   print(string.format( "got mano [%s]", params))

   for i in string.gmatch(params, "%S+") do

      print(string.format( "i [%s]", i))

      if i  == "add"         then

         local playerposition = mano.mapnote.getplayerposition()
         mano.noteinputform.show(playerposition)
         mano.mapnote.new(playerposition)

      end
   end

   return
end

local function savevariables()
   return
end

local function loadvariables()
   return
end

local function startmeup()

   if not mano.init.startup then

      -- Create/Display/Hide Mini Map Button Window
      if mano.gui.mmbtnobj == nil then
         mano.gui.mmbtnobj =  mano.createminimapbutton()
         mano.gui.mmbtnobj:SetVisible(true)
         mano.init.startup =  true
         -- remove tracking for this event
         Command.Event.Detach(Event.Unit.Availability.Full, startmeup, "MaNo: Show MiniMpa Button")
      end

   end

   return
end


-- Event tracking initialization -- begin
Command.Event.Attach(Event.Unit.Availability.Full,          startmeup,     "MaNo: Show MiniMpa Button")
Command.Event.Attach(Event.Addon.SavedVariables.Load.End,   loadvariables,	"MaNo: Load Variables")
Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, savevariables, "MaNo: Save Variables")
--
table.insert(Command.Slash.Register("mano"), {function (...) parseslashcommands(...) end, mano.addon.name, "MaNo: add note here"})
-- Event tracking initialization -- end
