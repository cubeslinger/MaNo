--
-- Addon       _mano_ui_2.lua
-- Author      marcob@marcob.org
-- StartDate   29/05/2017
--

local addon, mano = ...

function manoui()
   -- the new instance
   local self =   {
                  -- public fields go in the instance table
                  linestock         =  {},
                  lineid            =  0,
                  initialized       =  false,
                  o                    =  {},
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


   local function buildforstock(t)

      local parent      =  nil
      local T           =  {}

      self.lineid    =  self.lineid + 1

      if self.o.lastlinecontainer ~= nil and next(self.o.lastlinecontainer) ~= nil then
         parent = self.o.lastlinecontainer
      else
         parent = self.o.manoframe
--             parent = self.o.maskframe
      end

      -- Line Frame container
      T.frame =  UI.CreateFrame("Frame", "line_item_frame_" .. self.lineid, parent)
      T.frame:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
      T.frame:SetHeight(mano.gui.font.size+2)
      T.frame:SetLayer(3)
      T.frame:SetVisible(true)
      if self.o.lastlinecontainer ~= nil and next(self.o.lastlinecontainer) ~= nil then
         mano.f.dprint("attaching to lastlinecontainer")
         T.frame:SetPoint("TOPLEFT",  parent, "BOTTOMLEFT", 0, 1)
         T.frame:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT",0, 1)
      else
         mano.f.dprint("attaching to maskframe")
         T.frame:SetPoint("TOPLEFT",  parent, "TOPLEFT", 0, 1)
         T.frame:SetPoint("TOPRIGHT", parent, "TOPRIGHT",0, 1)
      end

--       -- Icon
--       local T.icon = UI.CreateFrame("Texture", "line_T.icon_" .. self.lineid, T.frame)
--       T.icon:SetTexture("Rift", t.T.icon or "Fish_T.icon.png.dds")
--       T.icon:SetWidth(mano.gui.font.size)
--       T.icon:SetHeight(mano.gui.font.size)
--       T.icon:SetLayer(3)
--       T.icon:SetVisible(true)
--       T.icon:SetPoint("TOPLEFT",   T.frame, "TOPRIGHT", mano.gui.borders.left, 0)

      -- Item's Name
      T.text     =  UI.CreateFrame("Text", "line_name_" .. self.lineid, T.frame)
      if mano.gui.font.name then
         T.text:SetFont(mano.addon.name, mano.gui.font.name)
      end
      T.text:SetFontSize(mano.gui.font.size)
      T.text:SetText(t.name or t.location .. " (" .. self.lineid .. ")")
      T.text:SetLayer(3)
      T.text:EventAttach( Event.UI.Input.Mouse.Left.Click, function() mano.f.setwaypoint(t.x, t.z, t.location) end, "Way Point Selected" )
      T.text:SetVisible(true)
      T.text:SetPoint("TOPLEFT",    T.frame, "TOPLEFT",  mano.gui.borders.left,     0)
      T.text:SetPoint("TOPRIGHT",   T.frame, "TOPRIGHT", -mano.gui.borders.right,   0)

      -- (...)

--       local T  =  {
--                   inuse =  true,
--                   frame =  T.frame,
--                   T.icon  =  T.icon,
--                   T.text  =  T.text
--                   }

      table.insert(self.linestock, T)

      return(T)
   end

   local function clearlist()
      --
      -- Set all linestock to "invisible"
      -- and set all linestockk[*].used = false
      --
      local idx, tbl = nil, {}
      for idx, tbl in pairs(self.linestock) do
         tbl.inuse = false
         tbl.frame:SetVisible(false)
         tbl.text:EventDetach(   Event.UI.Input.Mouse.Left.Click,
                                 function()
                                    mano.f.setwaypoint(t.x, t.y, t.zonename)
                                 end,
                                 "Way Point Selected" )
      end

      self.o.lastlinecontainer =  nil

      return
   end

   local function fetchlinefromstock(t)

      local idx, tbl, cnt  =  nil, {}, 0
      local newline        =  nil

      for idx, tbl in pairs(self.linestock) do
         cnt = cnt + 1
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
         -- frame
         newline.frame:SetVisible(true)

--          -- icon
--          newline.icon:SetVisible(true)

--          mano.f.dprint(strinf.format("Text is [%s]", t.text))
         newline.text:SetText(t.text or "lorem ipsum")
         newline.text:EventAttach(   Event.UI.Input.Mouse.Left.Click,
                                    function()
                                       mano.f.setwaypoint(t.x, t.z, t.location)
                                    end,
                                    "Way Point Added" )
         newline.text:SetVisible(true)
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

      for var, val in pairs(t) do
         print(string.format("addline: %s=%s", var, val))
      end


      local inuse, frame, icon, text   =  nil, nil, nil, nil

      if not self.initialized then
         mano.f.dprint("MY WAY ON THE HIGHWAY!")
         self = self.new()
      end

      local stockframe  =  fetchlinefromstock(t)
      self.o.lastlinecontainer   =  stockframe.frame


      -- auto adjust window Y size
      self.adjustheight()

      return stockframe
   end


   function self.adjustheight()

      if self.o.lastlinecontainer ~= nil then
         local maxY  =  self.o.lastlinecontainer:GetBottom()
         local minY  =  self.o.manoframe:GetTop()

         self.o.manoframe:SetHeight(mano.f.round(maxY - maxY))
         self.o.window:SetHeight(self.o.titleframe:GetHeight() +  mano.f.round(maxY - minY))
         print(string.format("new Height: (%s)", self.o.window:GetHeight()))
      end

      return
   end

   function self.new()

      -- Create/Initialize Menus
      self.o.menu                            =  {}
      self.o.submenu                         =  {}
      self.o.submenu.db                      =  {}
      self.o.submenu.db.puzzles              =  {}
      self.o.submenu.db.puzzles.mathosia     =  {}
      self.o.submenu.db.puzzles.stormlegion  =  {}
      self.o.submenu.db.cairns               =  {}
      self.o.submenu.db.cairns.mathosia      =  {}
      self.o.submenu.db.cairns.stormlegion   =  {}
      self.menucfg               =  {}
      self.menucfg.dbs           =  {  parent   =  self.o.menubutton,
                                       voices   =  {  { name   ="Puzzles",       callback =  self.o.submenu.db.puzzles.mathosia:show() },
                                                      { name   ="Puzzles",       callback =  self.o.submenu.db.puzzles.stormlegion:show() },
                                                      { name   ="Cairns",        callback =  self.o.submenu.db.cairns.mathosia:show() },
                                                      { name   ="Cairns",        callback =  self.o.submenu.db.cairns.stormlegion:show() },
                                                   },
                                    }
      self.menucfg.main          =  {  parent   =  self.o.menubutton,
                                       voices   =  {  { name="Load DB",          callback =  self.o.menu.dbs:show() },
                                                      { name="Add Note Here!",   callback =  mano.mapnote.new() },
                                                   },
                                    }

      -- Main Menu
      self.o.menu.main           =  menu()
      self.o.menu.main.instance  =  self.o.menu.main.new(self.menucfg.main)
      self.o.menu.main:hide()

      -- submenu: DBs
      self.o.menu.dbs            =  menu()
      self.o.menu.dbs.instance   =  self.o.menu.dbs.new(self.menucfg.dbs)
      self.o.menu.dbs:hide()

      --Global context (parent frame-thing).
      local context  = UI.CreateContext("mano_context")

      -- Main Window
      self.o.window  =  UI.CreateFrame("Frame", "MaNo", context)

      mano.f.dprint(string.format("mano.gui.win.x=%s mano.gui.win.y=%s", mano.gui.win.x, mano.gui.win.y))

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
      self.o.window:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function() changefontsize(1)   end,  "MaNo: window_wheel_forward")
      self.o.window:EventAttach(Event.UI.Input.Mouse.Wheel.Back,    function() changefontsize(-1)  end,  "MaNo: window_wheel_backward")

      self.o.titleframe =  UI.CreateFrame("Frame", "Cut_title_frame", self.o.window)
      self.o.titleframe:SetPoint("TOPLEFT",  self.o.window, "TOPLEFT",    0, -(mano.gui.font.size*1.5)+4)  -- move up, outside externalframe
      self.o.titleframe:SetPoint("TOPRIGHT", self.o.window, "TOPRIGHT",   0, -(mano.gui.font.size*1.5)+4)  -- move up, outside externalframe
      self.o.titleframe:SetHeight(mano.gui.font.size*1.5)
      self.o.titleframe:SetBackgroundColor(unpack(mano.gui.color.deepblack))
      self.o.titleframe:SetLayer(1)

         -- Title Icon
         self.o.titleicon = UI.CreateFrame("Texture", "mano_tile_icon", self.o.titleframe)
         self.o.titleicon:SetTexture("Rift", "loot_gold_coins.dds")
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

         -- MaNo Version
         self.o.titleversion =  UI.CreateFrame("Text", "mano_title_version", self.o.titleframe)
         self.o.titleversion:SetFontSize(mano.round(mano.gui.font.size * .75))
         self.o.titleversion:SetText(string.format("%s", 'v.' .. mano.addon.version), true)
         self.o.titleversion:SetLayer(3)
         self.o.titleversion:SetPoint("CENTERLEFT", self.o.windowtitle, "CENTERRIGHT", mano.gui.borders.left*2, 0)

         -- Iconize Button
         self.o.iconizebutton = UI.CreateFrame("Texture", "mano_iconize_button", self.o.titleframe)
         self.o.iconizebutton:SetTexture("Rift", "AlertTray_I54.dds")
         self.o.iconizebutton:SetHeight(mano.gui.font.size)
         self.o.iconizebutton:SetWidth(mano.gui.font.size)
         self.o.iconizebutton:SetLayer(3)
         self.o.iconizebutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function() showhidewindow() end, "MaNo: Iconize Button Pressed" )
         self.o.iconizebutton:SetPoint("CENTERRIGHT",   self.o.titleframe, "CENTERRIGHT", -mano.gui.borders.right, 0)

--          -- Lock Button
--          self.o.lockbutton = UI.CreateFrame("Texture", "mano_lock_gui_button", self.o.titleframe)
--          local icon  =  nil
--          if mano.gui.locked then
--             icon  =  "lock_on.png.dds"
--          else
--             icon  =  "lock_off.png.dds"
--          end
--          self.o.lockbutton:SetTexture("Rift", icon)
--          self.o.lockbutton:SetHeight(mano.gui.font.size)
--          self.o.lockbutton:SetWidth(mano.gui.font.size)
--          self.o.lockbutton:SetLayer(3)
--          self.o.lockbutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function() lockgui() end, "MaNo: Lock GUI Button Pressed" )
--          self.o.lockbutton:SetPoint("CENTERRIGHT",   self.o.iconizebutton, "CENTERRIGHT", -mano.gui.font.size, 0)


         -- Menu Button
         self.o.menubutton = UI.CreateFrame("Texture", "mano_menu_gui_button", self.o.titleframe)
         local icon  =  "btn_arrow_R_(normal).png.dds"   -- normal
--          local icon  =  "btn_arrow_R_(over).png.dds"   -- mouseover

         self.o.menubutton:SetTexture("Rift", icon)
         self.o.menubutton:SetHeight(mano.gui.font.size)
         self.o.menubutton:SetWidth(mano.gui.font.size)
         self.o.menubutton:SetLayer(3)
         self.o.menubutton:EventAttach( Event.UI.Input.Mouse.Left.Click,   function()
                                                                              self.o.menu.menu.main:show()
                                                                           end,
                                                                           "MaNo: Main Menu GUI Button Pressed" )
         self.o.menubutton:SetPoint("CENTERRIGHT",   self.o.iconizebutton, "CENTERRIGHT", -mano.gui.font.size, 0)



      -- EXTERNAL CUT CONTAINER FRAME
      self.o.externalframe =  UI.CreateFrame("Frame", "mano_external_frame", self.o.window)
      self.o.externalframe:SetPoint("TOPLEFT",     self.o.titleframe,   "BOTTOMLEFT",  mano.gui.borders.left,    0)
      self.o.externalframe:SetPoint("TOPRIGHT",    self.o.titleframe,   "BOTTOMRIGHT", - mano.gui.borders.right, 0)
      self.o.externalframe:SetPoint("BOTTOMLEFT",  self.o.window,       "BOTTOMLEFT",  mano.gui.borders.left,    - mano.gui.borders.bottom)
      self.o.externalframe:SetPoint("BOTTOMRIGHT", self.o.window,       "BOTTOMRIGHT", - mano.gui.borders.right, - mano.gui.borders.bottom)
      self.o.externalframe:SetBackgroundColor(unpack(mano.gui.color.black))
      self.o.externalframe:SetLayer(1)

      -- MASK FRAME
      self.o.maskframe = UI.CreateFrame("Mask", "mano_mask_frame", self.o.externalframe)
      self.o.maskframe:SetAllPoints(self.o.externalframe)

      -- CONTAINER FRAME
      self.o.manoframe =  UI.CreateFrame("Frame", "mano_notes_frame", self.o.maskframe)
      self.o.manoframe:SetAllPoints(self.o.maskframe)
      self.o.manoframe:SetLayer(1)

      -- RESIZER WIDGET
      self.o.corner  =  UI.CreateFrame("Texture", "mano_corner", self.o.window)
      self.o.corner:SetTexture("Rift", "chat_resize_(over).png.dds")
      self.o.corner:SetHeight(mano.gui.font.size)
      self.o.corner:SetWidth(mano.gui.font.size)
      self.o.corner:SetLayer(4)
      self.o.corner:SetPoint("BOTTOMRIGHT", self.o.manoframe, "BOTTOMRIGHT")
      self.o.corner:EventAttach(Event.UI.Input.Mouse.Right.Down,  function()
                                                                     local mouse = Inspect.Mouse()
                                                                     self.o.corner.pressed = true
                                                                     self.o.corner.basex   =  self.o.window:GetLeft()
                                                                     self.o.corner.basey   =  self.o.window:GetTop()
                                                                  end,
                                                                  "Event.UI.Input.Mouse.Right.Down")

      self.o.corner:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function()
                                                                     if  self.o.corner.pressed then
                                                                        local mouse = Inspect.Mouse()
                                                                        mano.gui.win.width  = mano.round(mouse.x - self.o.corner.basex)
                                                                        mano.gui.win.height = mano.round(mouse.y - self.o.corner.basey)
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


--       -- MENUBUTTON WIDGET
--       self.o.menubutton  =  UI.CreateFrame("Texture", "mano.menubutton", self.o.window)
--       self.o.menubutton:SetTexture("Rift", "reward_gold.png.dds")
--       self.o.menubutton:SetHeight(mano.gui.font.size)
--       self.o.menubutton:SetWidth(mano.gui.font.size)
--       self.o.menubutton:SetLayer(4)
--       self.o.menubutton:SetPoint("BOTTOMLEFT", self.o.manoframe, "BOTTOMLEFT")
--       self.o.menubutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function() mano.gui.shown.menuclass.show() end, "MaNo: Lock GUI Button Pressed" )


      return self.o.window
   end

   if self  then
      self.initialized =   true
   end

   return self

end

--[[

   mano.uiclass            =  manoui()
   mano.gui.shown.window   =  mano.uiclass.new()
   local tt =  {  parent   =  mano.uiclass.o.menubutton,
                  title    =  "Configuration",
                  voices   =  {  { name="First Voice" },
                                 { name="Second Voice"},
                                 { name="Cippa Lippa", callback=mano.mapnote.new() },
                              }
                }
   mano.gui.shown.menuclass   =  menu()
   mano.gui.shown.menu        =  mano.gui.shown.menuclass.new(tt)
   mano.gui.shown.menuclass.hide()
]]
