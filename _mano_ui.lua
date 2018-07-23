--
-- Addon       _mano_ui_4.lua
-- Author      marcob@marcob.org
-- StartDate   29/05/2017
--

local addon, mano = ...

function __mano_ui()
   -- the new instance
   local self =   {
                  -- public fields go in the instance table
                  linestock         =  {},
                  lineid            =  0,
                  initialized       =  false,
                  o                 =  {},
                  lastzone          =  nil
                  }

   local function countarray(array)

      local k, v  =  nil, nil
      local count =  0
      local t     =  array

      if array then
         for k, v in pairs(array) do count = count +1 end
      end

      return count
   end


   local function modifynote(tbl, customtbl, shared)

--       local tbl   =  t[1]

--       print("\n-------------------------------------------BEGIN")
--       print("modifynote(tbl)\n", mano.f.dumptable(tbl))
--       print("modifynote(customtbl)\n", mano.f.dumptable(customtbl))
--       print("modifynote(t.playerpos)\n", mano.f.dumptable(tbl.playerpos))

      local note  =  {}

--       print(string.format("tbl.playerpos.zonename=%s, tbl.idx=%s", tbl.playerpos.zonename, tbl.idx))

      if	shared then
--          print(string.format("SHARED mano.sharednote.getnotebyzoneandidx(%s, %s)", tbl.playerpos.zonename, tbl.idx))
         note  =  mano.sharednote.getnotebyzoneandidx(tbl.playerpos.zonename, tbl.idx)
      else
--          print(string.format("LOCAL mano.mapnote.getnotebyzoneandidx(%s, %s)", tbl.playerpos.zonename, tbl.idx))
         note  =  mano.mapnote.getnotebyzoneandidx(tbl.playerpos.zonename, tbl.idx)
      end

      if note  ~= nil and next(note) ~= nil then
         mano.mapnoteinput:show('modify', note)
      else
         print("modifynote: Note NOT Found!")
      end

--       print("\n-------------------------------------------END")

      return
   end

   local function setstatusbarbyzoneid(zoneid, count)

      local bool, zonedata = pcall(Inspect.Zone.Detail, zoneid)

      if bool then
         if zonedata.name ~= self.lastzone  then
            self.o.statuszone:SetText(string.format("%s (%s)", zonedata.name, count or 0))
            self.lastzone  =	zonedata.name
         end
      end

      return
   end


   local function buildforstock(t)

      local parent      =  nil
      local T           =  {}
      T.inuse           =  true
      self.lineid       =  self.lineid + 1

      if self.o.lastlinecontainer ~= nil and next(self.o.lastlinecontainer) ~= nil then
         parent = self.o.lastlinecontainer
      else
         parent = self.o.manoframe
      end

      -- Line Frame container
      T.frame =  UI.CreateFrame("Frame", "line_item_frame_" .. self.lineid, parent)
      T.frame:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
      T.frame:SetHeight(mano.gui.font.size + 6)
      T.frame:SetLayer(3)
      T.frame:SetVisible(true)
      if self.o.lastlinecontainer ~= nil and next(self.o.lastlinecontainer) ~= nil then
         T.frame:SetPoint("TOPLEFT",  parent, "BOTTOMLEFT")
         T.frame:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT")
      else
         T.frame:SetPoint("TOPLEFT",  parent, "TOPLEFT",    mano.gui.borders.left,     mano.gui.borders.top)
         T.frame:SetPoint("TOPRIGHT", parent, "TOPRIGHT",   -mano.gui.borders.right,   mano.gui.borders.top)
      end

      -- Note's Category Icon ||<--
      T.icon = UI.CreateFrame("Texture", "line_icon_" .. self.lineid, T.frame)
      local icon  =  mano.f.getcategoryicon(t.category)
      if icon  == nil then icon   =  "target_portrait_roguepoint.png.dds"   end
      T.icon:SetTexture("Rift", icon)
      T.icon:SetHeight(mano.gui.font.size * 1.5)
      T.icon:SetWidth(mano.gui.font.size  * 1.5)
      T.icon:SetLayer(3)
      T.icon:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
      T.icon:SetPoint("TOPLEFT",    T.frame, "TOPLEFT",  mano.gui.borders.left*2,     1)

      -- Way Point Icon -->||
      T.wpicon = UI.CreateFrame("Texture", "line_icon_wp" .. self.lineid, T.frame)
      T.wpicon:SetTexture("Rift", "ze_deliver_(yellow).png.dds")
      T.wpicon:SetHeight(mano.gui.font.size * 1.5)
      T.wpicon:SetWidth(mano.gui.font.size  * 1.5)
      T.wpicon:SetLayer(3)
      T.wpicon:EventAttach( Event.UI.Input.Mouse.Left.Click, function() mano.f.setwaypoint(t.playerpos.x, t.playerpos.z, t.playerpos.zonename) end, "Way Point Selected_" .. self.lineid )
      T.wpicon:SetPoint("TOPRIGHT",    T.frame, "TOPRIGHT",  -mano.gui.borders.right*2,	1)

      -- Edit Point Icon -->|-->||
      T.editicon = UI.CreateFrame("Texture", "line_icon_edit" .. self.lineid, T.frame)
      T.editicon:SetTexture("Rift", "Macros_I79.dds")
      T.editicon:SetHeight(mano.gui.font.size * .75)
      T.editicon:SetWidth(mano.gui.font.size  * .75)
      T.editicon:SetLayer(3)
      T.editicon:EventAttach( Event.UI.Input.Mouse.Left.Click, function()
                                                                  local shared   =  false
                                                                  if t.customtbl and t.customtbl.shared ~= nil and t.customtbl.shared == true then
                                                                     shared   =  true
                                                                  end
                                                                  modifynote(t, t.customtbl, shared)
                                                               end,
                              "edit_note_" .. self.lineid )
      T.editicon:SetPoint("TOPRIGHT",   T.wpicon,   "TOPLEFT",  -mano.gui.borders.right*2,   4)

      -- Note's Text -->|<--
      T.text     =  UI.CreateFrame("Text", "line_name_" .. self.lineid, T.frame)
      if mano.gui.font.name then
         T.text:SetFont(mano.addon.name, mano.gui.font.name)
      end
--       print("ui4 t:\n", mano.f.dumptable(t))
      T.text:SetFontSize(mano.gui.font.size)
      local text  =  ""
      if t.label  ~= nil then text  =  t.label  end
      if text == ""  and t.text ~= nil then text  =  t.text end
      if t.customtbl and t.customtbl.shared ~= nil and t.customtbl.shared == true then
         T.text:SetFontColor(unpack(mano.gui.color.lightgreen))
      else
         T.text:SetFontColor(unpack(mano.gui.color.white))
      end
      T.text:SetText(text, true)
      T.text:SetLayer(3)
      T.text:SetVisible(true)
      T.text:SetPoint("TOPLEFT",    T.icon,     "TOPRIGHT",  mano.gui.borders.left,     -1)
      T.text:SetPoint("TOPRIGHT",   T.editicon,   "TOPRIGHT",  -mano.gui.borders.right,   -1)
      table.insert(self.linestock, T)

      return(T)
   end

   local function clearlist()
      --
      -- Set all linestock to "invisible"
      -- and set all linestock[*].used = false
      --
      local idx, tbl = nil, {}
      for idx, tbl in pairs(self.linestock) do

         tbl.inuse = false

         tbl.frame:SetVisible(false)

         tbl.wpicon:EventDetach( Event.UI.Input.Mouse.Left.Click, function() mano.f.setwaypoint(t.playerpos.x, t.playerpos.z, t.playerpos.zonename) end, "Way Point Selected_" .. self.lineid )

      end

      self.o.lastlinecontainer =  nil

      return
   end

   local function fetchlinefromstock(t)

      local idx, tbl =  nil, {}
      local newline  =  nil

      for idx, tbl in pairs(self.linestock) do
         if not tbl.inuse then
            newline = tbl
            -- set the frame as INUSE
            self.linestock[idx].inuse     =  true
            break
         end
      end

      if not newline then
         newline = buildforstock(t)
         self.o.lastlinecontainer =  newline.frame
      else
         -- frame --
         newline.frame:SetVisible(true)

         -- icon  --
         newline.icon:SetVisible(true)
--          newline.icon:SetTexture("Rift", t.icon or "Fish_icon.png.dds")
         local icon  =  mano.f.getcategoryicon(t.category)
         if icon  == nil then icon   =  "target_portrait_roguepoint.png.dds"   end
         newline.icon:SetTexture("Rift", icon)


         -- label or text  --
--          newline.text:SetText(t.label or t.text)
         local text  =  ""
         if t.label  ~= nil then text  =  t.label  end
         if text == ""  and t.text ~= nil then text  =  t.text end

         if t.customtbl and t.customtbl.shared ~= nil and t.customtbl.shared == true then
--             text  =  '<i>' .. text .. '</i>'
            newline.text:SetFontColor(unpack(mano.gui.color.lightgreen))
         else
            newline.text:SetFontColor(unpack(mano.gui.color.white))
         end
         newline.text:SetText(text, true)
         newline.text:SetVisible(true)

         -- Edit Button
         newline.editicon:EventAttach( Event.UI.Input.Mouse.Left.Click,
                                       function()
                                          local shared   =  false
                                          if t.customtbl and t.customtbl.shared ~= nil and t.customtbl.shared == true then
                                             shared   =  true
                                          end
                                          modifynote(t, t.customtbl, shared)
                                       end,
                                       "edit_note_" .. self.lineid )


         -- WayPoint Button --
         newline.wpicon:EventAttach( Event.UI.Input.Mouse.Left.Click, function() mano.f.setwaypoint(t.playerpos.x, t.playerpos.z, t.playerpos.zonename) end, "Way Point Selected_" .. self.lineid )

         -- lastlinecontainer --
         self.o.lastlinecontainer =  newline.frame
      end

      return newline
   end

   local function lockgui(value)

      if value == true or value == false then
         mano.gui.locked   =  value
      else
         mano.gui.locked   =  not mano.gui.locked
      end

      local icon  =  nil

      if mano.gui.locked == true then
         icon  =  "lock_on.png.dds"
         Library.LibDraggable.undraggify(self.o.window, mano.f.updateguicoordinates)
      else
         icon  =  "lock_off.png.dds"
         Library.LibDraggable.draggify(self.o.window, mano.f.updateguicoordinates)
      end

      self.o.lockbutton:SetTexture("Rift", icon)

      return
   end

   local function showhidewindow(params)
      if mano.gui.visible ==  true then
         mano.gui.visible  =  false
      else
         mano.gui.visible  =  true
      end

      self.o.window:SetVisible(mano.gui.visible)

      return
   end


   local function changefontsize(newfontsize)

      local nfs   =  mano.gui.font.size + newfontsize
      if (nfs > 24)  then  nfs   =  24 end
      if (nfs < 6)   then  nfs   =  6  end

      if nfs ~=   mano.gui.font.size then
         --       print(string.format("Font was %s, now is %s.", mano.gui.font.size, nfs))

         mano.gui.font.size =  nfs

--          -- currencies
--          local tbls  =  { self.o.currenttbl, self.o.todaytbl, self.o.weektbl }
--          local TBL   =  {}
--          local currency, tbl = nil, {}
--          for _, TBL in pairs(tbls) do
--             for currency, tbl in pairs(TBL) do
--                tbl.frame:SetHeight(mano.gui.font.size)
--                tbl.label:SetFontSize(mano.gui.font.size)
--                tbl.icon:SetHeight(mano.gui.font.size)
--                tbl.icon:SetWidth(mano.gui.font.size)
--                tbl.value:SetFontSize(mano.gui.font.size)
--             end
--          end
--
--          -- notorieties
--          local tbls  =  { self.o.currentnotorietytbl, self.o.todaynotorietytbl, self.o.weeknotorietytbl }
--          local TBL   = {}
--          local notoriety, tbl = nil, {}
--          for _, TBL in pairs(tbls) do
--             for notoriety, tbl in pairs(TBL) do
--                tbl.frame:SetHeight(mano.gui.font.size)
--                tbl.label:SetFontSize(mano.gui.font.size)
--                tbl.value:SetFontSize(mano.gui.font.size)
--                tbl.standing:SetFontSize(mano.gui.font.size)
--                tbl.percent:SetFontSize(mano.gui.font.size * .75)
--             end
--          end
--
--          -- window title
--          self.o.windowtitle:SetFontSize(mano.gui.font.size*.75)
--          self.o.mano.ersion:SetFontSize(mano.round(mano.gui.font.size/2))
--          self.o.windowinfo:SetFontSize(mano.gui.font.size*.75)
--          self.o.titleicon:SetHeight(mano.gui.font.size*.75)
--          self.o.titleicon:SetWidth(mano.gui.font.size*.75)
--          self.o.corner:SetHeight(mano.gui.font.size)
--          self.o.corner:SetWidth(mano.gui.font.size)
--          self.o.lockbutton:SetHeight(mano.gui.font.size)
--          self.o.lockbutton:SetWidth(mano.gui.font.size)
--          self.o.iconizebutton:SetHeight(mano.gui.font.size)
--          self.o.iconizebutton:SetWidth(mano.gui.font.size)
--          mano.resizewindow(self.o.tracker, self.o.panel)
      end

      return
   end


   function self.addline(t)

      local stockframe  =  fetchlinefromstock(t)
      self.o.lastlinecontainer   =  stockframe.frame

      -- auto adjust window Y size
      self.adjustheight()

      return stockframe
   end

   function self.loadlistbyzoneid(zoneid)
--       print(string.format("loadlistbyzoneid(%s)", zoneid))

      clearlist()

      local zonedata =  mano.mapnote.getzonedatabyid(zoneid)
      local counter  =  0

      -- Search in both User's notes db and sharenotesdb
      for _, db in ipairs({  mano.mapnote.getzonedatabyid(zoneid), mano.sharednote.getzonedatabyid(zoneid) }) do
         for _, tbl in ipairs(db) do
            local newframe =  mano.gui.shown.window.addline(tbl)
            counter        =  counter + 1
         end
      end

      self.adjustheight()

--       setzonetitlebyid(zoneid, counter)
      setstatusbarbyzoneid(zoneid, counter)

      return
   end

   local function mainmenuchoice(zonename)

      mano.events.mainmenutrigger(mano.db.geo.zones[zonename])
      self.o.menu.main.flip()

      return
   end



   function self.adjustheight()

      local minY  =  0
      local maxY  =  0

      if self.o.lastlinecontainer ~= nil then
         maxY  =  self.o.lastlinecontainer:GetBottom()
         minY  =  self.o.manoframe:GetTop()

         self.o.manoframe:SetHeight(mano.f.round(maxY - maxY))
         self.o.window:SetHeight(self.o.titleframe:GetHeight() +  mano.f.round(maxY - minY))
--          print(string.format("new Height: (%s)", self.o.window:GetHeight()))
      else
         minY  =  self.o.manoframe:GetTop()
--          maxY  =  self.o.titleframe:GetBottom() + mano.gui.borders.bottom
         maxY  =  self.o.titleframe:GetBottom()

         self.o.manoframe:SetHeight(mano.f.round(maxY - maxY))
         self.o.window:SetHeight(self.o.titleframe:GetHeight() +  mano.f.round(maxY - minY))
      end

      return
   end

   if not self.initialized then
      -- main  --
      -- Create/Initialize Menus
      self.menucfg         =  {}
      self.menucfg.zones   =  {}
      local tbl            =  {}
      for _, tbl in ipairs(mano.db.geo.zones) do
--          table.insert(self.menucfg.zones, {  "name=\'" .. tbl.zonename .. "\'",
         table.insert(self.menucfg.zones, {  "name=\'".. tbl.zonename .. ", callback = { mainmenuchoice," .. tbl.zonename .. ", \'close\' }" } )

--          table.insert(self.menucfg.zones,   {   "name    =  \'" .. tbl.zonename .. "\'",
--                                                 "callback=  { " .. mainmenuchoice .. ", " .. tbl.zonename .. ", \'close\' }",
--                                              }
--                      )
      end

      self.menucfg.main =  {
                              voices   =  {  {  name     =  "Show Zone",
                                                callback =  "_submenu_",
                                                submenu  =  { voices   =  self.menucfg.zones },
--                                                 submenu  =  self.menucfg.zones,
                                             },
                                             {  name     =  "Add Note Here!",
                                                callback =  { mano.foo["parseslashcommands"], "add", 'close' },
                                             },
                                          },
                           }

--       print("self.menucfg.main:\n", mano.f.dumptable(self.menucfg.main ))

      --Global context (parent frame-thing).
      local context  = UI.CreateContext("mano_context")

      -- Main Window
      self.o.window  =  UI.CreateFrame("Frame", "MaNo", context)

--       mano.f.dprint(string.format("mano.gui.win.x=%s mano.gui.win.y=%s", mano.gui.win.x, mano.gui.win.y))

      if mano.gui.win.x == nil or mano.gui.win.y == nil then
         -- first run, we position in the screen center
         self.o.window:SetPoint("CENTER", UIParent, "CENTER")
      else
         -- we have coordinates
         self.o.window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", mano.gui.win.x or 0, mano.gui.win.y or 0)
      end
      self.o.window:SetLayer(-1)
      self.o.window:SetWidth(mano.gui.win.width)
      self.o.window:SetBackgroundColor(unpack(mano.gui.color.black))
--       self.o.window:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function() changefontsize(1)   end,  "MaNo: window_wheel_forward")
--       self.o.window:EventAttach(Event.UI.Input.Mouse.Wheel.Back,    function() changefontsize(-1)  end,  "MaNo: window_wheel_backward")


      self.o.tooltip = UI.CreateFrame("SimpleTooltip", "mano_ui_tt", self.o.window)
--       tooltip:InjectEvents(mybutton, function() return "My Button Tooltip" end)
--       tooltip:InjectEvents(mytextfield , function() return "My Textfield Tooltip" end)




      self.o.titleframe =  UI.CreateFrame("Frame", "mano_title_frame", self.o.window)
--       self.o.titleframe:SetPoint("TOPLEFT",  self.o.window, "TOPLEFT",    0, -(mano.gui.font.size*1.5)+4)  -- move up, outside externalframe
--       self.o.titleframe:SetPoint("TOPRIGHT", self.o.window, "TOPRIGHT",   0, -(mano.gui.font.size*1.5)+4)  -- move up, outside externalframe
      self.o.titleframe:SetPoint("TOPLEFT",  self.o.window, "TOPLEFT")     -- move up, outside externalframe
      self.o.titleframe:SetPoint("TOPRIGHT", self.o.window, "TOPRIGHT")    -- move up, outside externalframe

      self.o.titleframe:SetHeight(mano.gui.font.size*1.5)
      self.o.titleframe:SetBackgroundColor(unpack(mano.gui.color.deepblack))
      self.o.titleframe:SetLayer(1)

         -- Title Icon
         self.o.titleicon = UI.CreateFrame("Texture", "mano_tile_icon", self.o.titleframe)
--          self.o.titleicon:SetTexture("Rift", "loot_gold_coins.dds")
         self.o.titleicon:SetTexture("Rift", "Macros_I79.dds")
         self.o.titleicon:SetHeight(mano.gui.font.size)
         self.o.titleicon:SetWidth(mano.gui.font.size)
         self.o.titleicon:SetLayer(3)
         self.o.titleicon:SetPoint("CENTERLEFT", self.o.titleframe, "CENTERLEFT", mano.gui.borders.left*2, 0)

         -- Window Title
         self.o.windowtitle =  UI.CreateFrame("Text", "mano_window_title", self.o.titleframe)
         self.o.windowtitle:SetFontSize(mano.gui.font.size)
         --       windowtitle:SetText(string.format("%s", mano.html.title[1]), true)
         self.o.windowtitle:SetText(string.format("%s", mano.html.title), true)
         self.o.windowtitle:SetLayer(3)
         self.o.windowtitle:SetPoint("CENTERLEFT",   self.o.titleicon, "CENTERRIGHT", mano.gui.borders.left*2, 0)

--          -- Current Zone
--          self.o.titlezone =  UI.CreateFrame("Text", "mano_zone_name", self.o.titleframe)
--          self.o.titlezone:SetFontSize(mano.f.round(mano.gui.font.size * .75))
--          self.o.titlezone:SetFontSize(mano.gui.font.size)
--          self.o.titlezone:SetText(self.lastzone or "???", true)
--          self.o.titlezone:SetLayer(3)
--          self.o.titlezone:SetPoint("CENTERLEFT", self.o.windowtitle, "CENTERRIGHT", mano.gui.borders.left*2, 0)

         -- Iconize Button
--          self.o.iconizebutton = UI.CreateFrame("Texture", "mano_iconize_button", self.o.titleframe)
--          self.o.iconizebutton:SetTexture("Rift", "AlertTray_I54.dds")
--          self.o.iconizebutton:SetHeight(mano.gui.font.size * 1.5)
--          self.o.iconizebutton:SetWidth(mano.gui.font.size  * 1.5)
--          self.o.iconizebutton:SetLayer(3)
--          self.o.iconizebutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function() showhidewindow() end, "MaNo: Iconize Button Pressed" )
--          self.o.iconizebutton:SetPoint("CENTERRIGHT",   self.o.titleframe, "CENTERRIGHT", -mano.gui.borders.right*2, 0)
--          self.o.tooltip:InjectEvents(self.o.iconizebutton, function() return "Iconize" end)

         -- Menu Button
         self.o.menubutton = UI.CreateFrame("Text", "mano_menu_gui_button", self.o.titleframe)
         self.o.menubutton:SetText("Menu")
         self.o.menubutton:SetFontSize(mano.gui.font.size)
         self.o.menubutton:SetFontColor(unpack(mano.gui.color.white))
         self.o.menubutton:SetLayer(3)
         self.o.menubutton:EventAttach( Event.UI.Input.Mouse.Left.Click,   function() self.o.menu.main:flip() end,
                                                                           "MaNo: Main Menu GUI Button Pressed" )
--          self.o.menubutton:SetPoint("CENTERRIGHT",   self.o.iconizebutton, "CENTERLEFT", -mano.gui.font.size, 0)
         self.o.menubutton:SetPoint("CENTERRIGHT",   self.o.titleframe, "CENTERRIGHT", -mano.gui.borders.right*2, 0)
         self.o.tooltip:InjectEvents(self.o.menubutton, function() return "Config Options" end)

         -- Add Waypoint Button
         self.o.addwpbutton = UI.CreateFrame("Texture", "mano_menu_wp_button", self.o.titleframe)
--          local icon  =  "AbilityBinder_I15.dds"   -- normal
   --                local icon  =  "btn_arrow_R_(over).png.dds"   -- mouseover
         local icon  =  "macro_icon_heal.dds"   -- normal
         self.o.addwpbutton:SetTexture("Rift", icon)
         self.o.addwpbutton:SetHeight(mano.gui.font.size)
         self.o.addwpbutton:SetWidth(mano.gui.font.size)
         self.o.addwpbutton:SetLayer(3)
         self.o.addwpbutton:EventAttach( Event.UI.Input.Mouse.Left.Click,  function()
                                                                              mano.foo.parseslashcommands("add")
                                                                           end,
                                                                           "MaNo: Main Menu Add WP Button Pressed" )
         self.o.addwpbutton:SetPoint("CENTERRIGHT",   self.o.menubutton, "CENTERLEFT", -mano.gui.font.size, 0)
         self.o.tooltip:InjectEvents(self.o.addwpbutton, function() return "Add Waypoint Here!" end)


         -- Create Menu
         self.o.menu          =  {}
         self.o.menu.main     =  menu(self.o.menubutton, self.menucfg.main)
         self.o.menu.main:hide()
         --

      -- EXTERNAL CONTAINER FRAME
      self.o.externalframe =  UI.CreateFrame("Frame", "mano_external_frame", self.o.window)
      self.o.externalframe:SetPoint("TOPLEFT",     self.o.titleframe,   "BOTTOMLEFT",  mano.gui.borders.left,    0)
      self.o.externalframe:SetPoint("TOPRIGHT",    self.o.titleframe,   "BOTTOMRIGHT", - mano.gui.borders.right, 0)
--       self.o.externalframe:SetPoint("BOTTOMLEFT",  self.o.window,       "BOTTOMLEFT",  mano.gui.borders.left,    - mano.gui.borders.bottom)
--       self.o.externalframe:SetPoint("BOTTOMRIGHT", self.o.window,       "BOTTOMRIGHT", - mano.gui.borders.right, - mano.gui.borders.bottom)
      self.o.externalframe:SetPoint("BOTTOMLEFT",  self.o.window,       "BOTTOMLEFT",  mano.gui.borders.left,    0)
      self.o.externalframe:SetPoint("BOTTOMRIGHT", self.o.window,       "BOTTOMRIGHT", - mano.gui.borders.right, 0)

      self.o.externalframe:SetBackgroundColor(unpack(mano.gui.color.black))
      self.o.externalframe:SetLayer(1)

      -- MASK FRAME
      self.o.maskframe = UI.CreateFrame("Mask", "mano_mask_frame", self.o.externalframe)
      self.o.maskframe:SetAllPoints(self.o.externalframe)

      -- CONTAINER FRAME
      self.o.manoframe =  UI.CreateFrame("Frame", "mano_notes_frame", self.o.maskframe)
      self.o.manoframe:SetAllPoints(self.o.maskframe)
      self.o.manoframe:SetLayer(1)

--       -- RESIZER WIDGET
--       self.o.corner  =  UI.CreateFrame("Texture", "mano_corner", self.o.window)
--       self.o.corner:SetTexture("Rift", "chat_resize_(over).png.dds")
--       self.o.corner:SetHeight(mano.gui.font.size)
--       self.o.corner:SetWidth(mano.gui.font.size)
--       self.o.corner:SetLayer(4)
--       self.o.corner:SetPoint("BOTTOMRIGHT", self.o.manoframe, "BOTTOMRIGHT")
--       self.o.corner:EventAttach(Event.UI.Input.Mouse.Right.Down,  function()
--                                                                      local mouse = Inspect.Mouse()
--                                                                      self.o.corner.pressed = true
--                                                                      self.o.corner.basex   =  self.o.window:GetLeft()
--                                                                      self.o.corner.basey   =  self.o.window:GetTop()
--                                                                   end,
--                                                                   "Event.UI.Input.Mouse.Right.Down")
--[[
      self.o.corner:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function()
                                                                     if  self.o.corner.pressed then
                                                                        local mouse = Inspect.Mouse()
                                                                        mano.gui.win.width  = mano.f.round(mouse.x - self.o.corner.basex)
                                                                        mano.gui.win.height = mano.f.round(mouse.y - self.o.corner.basey)
                                                                        self.o.window:SetWidth(mano.gui.win.width)
                                                                        self.o.window:SetHeight(mano.gui.win.height)
                                                                     end
                                                                  end,
                                                                  "Event.UI.Input.Mouse.Cursor.Move")

      self.o.corner:EventAttach(Event.UI.Input.Mouse.Right.Upoutside,   function()
                                                                           self.o.corner.pressed = false
                                                                           self.adjustheight()
                                                                        end,
                                                                        "MaNo: Event.UI.Input.Mouse.Right.Upoutside")

      self.o.corner:EventAttach(Event.UI.Input.Mouse.Right.Up, function()
                                                                  self.o.corner.pressed = false
                                                                  self.adjustheight()
                                                               end,
                                                               "MaNo: Event.UI.Input.Mouse.Right.Up")
                                                               ]]

      -- Status Bar
      self.o.statusframe =  UI.CreateFrame("Frame", "mano_status_frame", self.o.window)
      self.o.statusframe:SetPoint("TOPLEFT",  self.o.window, "BOTTOMLEFT")  -- move up, outside externalframe
      self.o.statusframe:SetPoint("TOPRIGHT", self.o.window, "BOTTOMRIGHT")  -- move up, outside externalframe
      self.o.statusframe:SetHeight(mano.gui.font.size)
      self.o.statusframe:SetBackgroundColor(unpack(mano.gui.color.deepblack))
      self.o.statusframe:SetLayer(1)

      -- Current Zone
      self.o.statuszone =  UI.CreateFrame("Text", "mano_zone_name", self.o.statusframe)
--       self.o.statuszone:SetFontSize(mano.f.round(mano.gui.font.size * .75))
      self.o.statuszone:SetFontSize(mano.gui.font.size*.75)
      self.o.statuszone:SetText(self.lastzone or "???", true)
      self.o.statuszone:SetLayer(3)
      self.o.statuszone:SetPoint("TOPLEFT", self.o.statusframe, "TOPLEFT", mano.gui.borders.left*2, 0)
      self.o.tooltip:InjectEvents(self.o.addwpbutton, function() return "Current Zone (notes number)" end)


      -- RESIZER WIDGET
--       self.o.corner  =  UI.CreateFrame("Texture", "mano_corner", self.o.window)
      self.o.corner  =  UI.CreateFrame("Texture", "mano_corner", self.o.statusframe)
      self.o.corner:SetTexture("Rift", "chat_resize_(over).png.dds")
      self.o.corner:SetHeight(mano.gui.font.size)
      self.o.corner:SetWidth(mano.gui.font.size)
      self.o.corner:SetLayer(4)
--       self.o.corner:SetPoint("BOTTOMRIGHT", self.o.manoframe, "BOTTOMRIGHT")
      self.o.corner:SetPoint("BOTTOMRIGHT", self.o.statusframe, "BOTTOMRIGHT")
      self.o.corner:EventAttach(Event.UI.Input.Mouse.Right.Down,  function()
                                                                     local mouse = Inspect.Mouse()
                                                                     self.o.corner.pressed = true
                                                                     self.o.corner.basex   =  self.o.window:GetLeft()
                                                                     self.o.corner.basey   =  self.o.window:GetTop()
                                                                  end,
                                                                  "Event.UI.Input.Mouse.Right.Down")
      self.o.tooltip:InjectEvents(self.o.corner, function() return "Resize Window" end)

      self.o.corner:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function()
                                                                     if  self.o.corner.pressed then
                                                                        local mouse = Inspect.Mouse()
                                                                        mano.gui.win.width  = mano.f.round(mouse.x - self.o.corner.basex)
                                                                        mano.gui.win.height = mano.f.round(mouse.y - self.o.corner.basey)
                                                                        self.o.window:SetWidth(mano.gui.win.width)
                                                                        self.o.window:SetHeight(mano.gui.win.height)
                                                                     end
                                                                  end,
                                                                  "Event.UI.Input.Mouse.Cursor.Move")

      self.o.corner:EventAttach(Event.UI.Input.Mouse.Right.Upoutside,   function()
                                                                           self.o.corner.pressed = false
                                                                           self.adjustheight()
                                                                        end,
                                                                        "MaNo: Event.UI.Input.Mouse.Right.Upoutside")

      self.o.corner:EventAttach(Event.UI.Input.Mouse.Right.Up, function()
                                                                  self.o.corner.pressed = false
                                                                  self.adjustheight()
                                                               end,
                                                               "MaNo: Event.UI.Input.Mouse.Right.Up")

--       -- Side Menu Bar
--       self.o.sidemenuframe =  UI.CreateFrame("Frame", "mano_sidemenu_frame", self.o.window)
--       self.o.sidemenuframe:SetPoint("TOPLEFT",  self.o.externalframe, "TOPRIGHT")
--       self.o.sidemenuframe:SetHeight(mano.gui.font.size*1.5)
--       self.o.sidemenuframe:SetBackgroundColor(unpack(mano.gui.color.deepblack))
--       self.o.sidemenuframe:SetLayer(1)
--       self.o.sidemenuframe:SetVisible(true)
--
--          -- Modify Note Button
--          self.o.deletemenubutton = UI.CreateFrame("Texture", "mano_delete_button", self.o.sidemenuframe)
--          self.o.deletemenubutton:SetTexture("Rift", "AlertTray_I54.dds")
--          self.o.deletemenubutton:SetHeight(mano.gui.font.size * 1.5)
--          self.o.deletemenubutton:SetWidth(mano.gui.font.size  * 1.5)
--          self.o.deletemenubutton:SetLayer(3)
--          self.o.deletemenubutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function() print("WRITE MODIFY NOTE FUNCTION!") end, "MaNo: Modify Note Button Pressed" )
--          self.o.deletemenubutton:SetPoint("TOPLEFT",   self.o.sidemenuframe, "TOPLEFT")
--
--          -- Delete Note Button
--          self.o.deletemenubutton = UI.CreateFrame("Texture", "mano_delete_button", self.o.sidemenuframe)
--          self.o.deletemenubutton:SetTexture("Rift", "AlertTray_I54.dds")
--          self.o.deletemenubutton:SetHeight(mano.gui.font.size * 1.5)
--          self.o.deletemenubutton:SetWidth(mano.gui.font.size  * 1.5)
--          self.o.deletemenubutton:SetLayer(3)
--          self.o.deletemenubutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function() print("WRITE DELETE NOTE FUNCTION!") end, "MaNo: Delete Note Button Pressed" )
--          self.o.deletemenubutton:SetPoint("TOPLEFT",   self.o.sidemenuframe, "BOTTOMLEFT")

   end

   if self ~= nil and next(self) ~= nil   then
      self.initialized =   true
   end

   return self

end
