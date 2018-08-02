--
-- Addon       MaNo_1.lua
-- Author      marcob@marcob.org
-- StartDate   05/05/2018
--
local addon, mano = ...
--
mano.addon           =  {}
mano.addon.name      =  Inspect.Addon.Detail(Inspect.Addon.Current())["name"]
mano.addon.version   =  Inspect.Addon.Detail(Inspect.Addon.Current())["toc"]["Version"]

local function zonechangeevent(h, t)

--       print(string.format("zonechangeevent: h=%s t=%s", h, t ))

--       local unitid   =  nil
--       local cnt      =  1

-- 		print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
--       for unit, zone in pairs(t) do
--
-- 			local u = Inspect.Unit.Detail(unit)
-- 			local z = Inspect.Zone.Detail(zone)
--
-- 			if u and z then
-- 				print(string.format("%s) %s: %s", cnt, u, z))
-- 				print(string.format("%s) %s: %s", cnt, u.name, z.name))
-- 			else
-- 				print(string.format("ERROR: u=(%s) z=(%s)", u, z))
-- 			end
--
--          cnt = cnt + 1
--          if unitid   == nil   then
--             unitid   =  unit
--             zoneid   =  zone
--          end
--       end
--
-- -- 		mano.f.dumptable(t)
-- 		print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")

		local zonetext, regiontext, zoneid, playerid	=	mano.f.getzoneinfos()

      if playerid   == mano.player.unitid   then
--          print("zonechangeevent: Zone change event IS for US!")
         mano.gui.shown.window.loadlistbyzoneid(zoneid)
      else
--          print(string.format("zonechangeevent: Zone change event NOT for US.: \n[%s]\n[%s]", unitid, mano.player.unitid))
      end



--       if unitid   == mano.player.unitid   then
-- --          print("zonechangeevent: Zone change event IS for US!")
--          mano.gui.shown.window.loadlistbyzoneid(zoneid)
--       else
-- --          print(string.format("zonechangeevent: Zone change event NOT for US.: \n[%s]\n[%s]", unitid, mano.player.unitid))
--       end


   return
end


local function savevariables(_, addonname)

   if addon.name == addonname then

      -- Save Character GUI data
      local a        =  {}
      a.mmbtn        =  mano.gui.mmbtn
      a.win          =  mano.gui.win
      manoguidata    =  a

      -- Save Character Notes Db
      if next(mano.mapnote.notes)      ~= nil then manonotesdb    =  mano.mapnote.notes      end

      -- Save Character Shared Notes Db
      if next(mano.sharednote.notes)   ~= nil then manoextnotesdb =  mano.sharednote.notes   end

      -- Save Character Categories
      if next(mano.categories)         ~= nil then manousercats   =  mano.categories         end

      -- Shared Categories
      if next(mano.sharedcategories)   ~= nil then manosharedcats =  mano.sharedcategories   end

   end

   return
end

local function loadvariables(_, addonname)

   if addon.name == addonname then

      -- Character GUI data
      if manoguidata then
         local a        =  manoguidata
         local key, val =  nil, nil
         for key, val in pairs(a) do   mano.gui[key]  =  val   end
      end

      -- Character Notes Db
      local notesdb  =  {}
      if manonotesdb ~= nil and next(manonotesdb) ~= nil then
         notesdb  =  manonotesdb
      end
      mano.mapnote   =  __map_notes(notesdb)

      -- Shared Notes Db
      local shareddb =  {}
      if manoextnotesdb ~= nil and next(manoextnotesdb) ~= nil then
         shareddb =  manoextnotesdb
      end
      mano.sharednote   =  __map_notes(shareddb)

      -- Character Categories
      if manousercats ~= nil and next(manousercats) ~= nil then
         mano.categories   =  manousercats
      else
         if next(mano.categories) == nil then
            mano.categories = mano.base.usercategories
         end
      end
      local k, v  =  nil, nil
      for k, v in pairs(mano.categories) do mano.lastcategoryidx  =  math.max(mano.lastcategoryidx, k)  end

      -- Shared Categories
      if manosharedcats ~= nil and next(manosharedcats) ~= nil then
         mano.sharedcategories   =  manosharedcats
      else
         if next(mano.sharedcategories) == nil then
            mano.sharedcategories = mano.base.sharedcategories
         end
      end
      for k, v in pairs(mano.sharedcategories) do mano.lastsharedcategoryidx  =  math.max(mano.lastsharedcategoryidx, k)  end

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


      mano.gui.shown.window   =  __mano_ui()

--       print("mano.gui.shown.window: ", mano.f.dumptable(mano.gui.shown.window))


      Library.LibDraggable.draggify(mano.gui.shown.window.o.window, mano.f.updateguicoordinates)
--       Library.LibDraggable.draggify(mano.gui.shown.window.o.titleframe, mano.f.updateguicoordinates)

      mano.gui.shown.window.o.window:SetVisible(true)

      -- remove tracking for this event
      Command.Event.Detach(Event.Unit.Availability.Full, startmeup, "MaNo: startup event")


      -- Save Player's UnitID
      mano.player.unitid   =  Inspect.Unit.Lookup("player")

      -- Let's see if we have notes for the starting zone to load
      local bool0, t = pcall(Inspect.Unit.Detail, "player")
      if bool0  then
         local bool1, zonedata = pcall(Inspect.Zone.Detail, t.zone)
         if bool1 then
            mano.gui.shown.window.loadlistbyzoneid(zonedata.id)
         end
      end
      mano.player.unitname =  t.name

      -- Start monitoring Player's Zone Changes
      Command.Event.Attach(Event.Unit.Detail.Zone, function(...) zonechangeevent(...) end,   "MaNo: Zone Change Event")

      -- Load External DBs if it's first run
--       if mano.db == nil or next(mano.db) ==  nil then
--          mano.extdbhandle  =  __externaldbs()
--          local retval      =  mano.extdbhandle.filldbs()
--          print("...initializing EXTERNAL DBs...")
--       end

      mano.init.startup =  true
   end

   return
end

-- Event tracking initialization -- begin
Command.Event.Attach(Event.Unit.Availability.Full,          startmeup,                                "MaNo: startup event")
Command.Event.Attach(Event.Addon.SavedVariables.Load.End,   loadvariables,	                           "MaNo: Load Variables")
Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, savevariables,                            "MaNo: Save Variables")
-- -- Custom Events
-- Command.Event.Attach(Event.MaNo.userinput.cancel,           function(...) mano.f.userinputcancel(...) end,  "MaNo: input: Cancel")
-- Command.Event.Attach(Event.MaNo.userinput.save,             function(...) mano.f.userinputsave(...)   end,  "MaNo: input: Save")
--
-- Event tracking initialization -- end
--
--
table.insert(Command.Slash.Register("mano"), {function (...) mano.f.parseslashcommands(...) end, mano.addon.name, "MaNo: add note here"})
--
-- if not mano.mapnote        then  mano.mapnote      =  __map_notes({}) end
-- if not mano.mapnoteinput   then  mano.mapnoteinput =  __mano_ui_input() mano.mapnoteinput.o.window:SetVisible(false)  end
-- if not mano.mapnoteinput   then  mano.mapnoteinput =  __mano_ui_input('new') end
if not mano.mapnoteinput   then  mano.mapnoteinput =  __mano_ui_input() end
--
