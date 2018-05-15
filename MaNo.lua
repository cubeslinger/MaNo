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

local function savevariables(_, addonname)
   --    mano.gui             =  {}
   --    mano.gui.mmbtnheight =  38
   --    mano.gui.mmbtnwidth  =  38
   --    mano.gui.mmbtnx      =  0
   --    mano.gui.mmbtny      =  0
   --    mano.gui.mmbtnobj    =  nil
   --    --
   --    -- Initialization flags
   --    --
   --    mano.init            =  {}
   --    mano.init.startup    =  false
   --

   if addon.name == addonname then

      print(string.format("addon.name [%s] -> addonname [%s]", addon.name, addonname))
      print(string.format("  for US [%s]", addonname))

      local a        =  mano.gui
      a.mmbtnheight  =  nil
      a.mmbtnwidth   =  nil
      a.mmbtnobj     =  nil

      manoguidata        =  a
   end

   return
end

local function loadvariables(_, addonname)

   if addon.name == addonname then

      print(string.format("addon.name [%s] -> addonname [%s]", addon.name, addonname))
      print(string.format("  for US [%s]", addonname))

      if manoguidata then

         local a  =  manoguidata
         local key, val = nil, nil
         for key, val in pairs(a) do   mano.gui[key]   =  val   print(string.format("Importing %s: %s", key, val)) end

      end


      Command.Event.Detach(Event.Addon.SavedVariables.Load.End,   loadvariables,	"MaNo: Load Variables")
   end

   return
end

local function startmeup()

   if not mano.init.startup then

      -- Create/Display/Hide Mini Map Button Window
      if mano.gui.mmbtnobj == nil then
         mano.mmbutton     =  mano.createminimapbutton()
         mano.gui.mmbtnobj =  mano.mmbutton.button
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
