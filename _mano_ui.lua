--
-- Addon       _mano_ui.lua
-- Author      marcob@marcob.org
-- StartDate   23/05/2017
--

local addon, mano = ...


function manoui()
   -- the new instance
   local self =   {
                  -- public fields go in the instance table
                  linestock   =  {},
                  lineid      =  0,
                  initialized =  false,
                  o           =  {}
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

      local lineframe   =  nil
      local icon        =  nil
      local text        =  nil
      local parent      =  nil

      self.lineid    =  self.lineid + 1

      if mano.gui.frames.lastlinecontainer ~= nil and next(mano.gui.frames.lastlinecontainer) ~= nil then
         parent = mano.gui.frames.lastlinecontainer
      else
         parent = mano.gui.shown.manoframe
--             parent = mano.gui.shown.maskframe
      end

      -- Line Frame container
      lineframe =  UI.CreateFrame("Frame", "line_item_frame_" .. self.lineid, parent)
      lineframe:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
      lineframe:SetHeight(mano.gui.font.size+2)
      lineframe:SetLayer(3)
      lineframe:SetVisible(true)
      if mano.gui.frames.lastlinecontainer ~= nil and next(mano.gui.frames.lastlinecontainer) ~= nil then
         mano.f.dprint("attaching to lastlinecontainer")
         lineframe:SetPoint("TOPLEFT",  parent, "BOTTOMLEFT", 0, 1)
         lineframe:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT",0, 1)
      else
         mano.f.dprint("attaching to maskframe")
         lineframe:SetPoint("TOPLEFT",  parent, "TOPLEFT", 0, 1)
         lineframe:SetPoint("TOPRIGHT", parent, "TOPRIGHT",0, 1)
      end

      -- Icon
      local icon = UI.CreateFrame("Texture", "line_icon_" .. self.lineid, lineframe)
      icon:SetTexture("Rift", t.icon or "Fish_icon.png.dds")
      icon:SetWidth(mano.gui.font.size)
      icon:SetHeight(mano.gui.font.size)
      icon:SetLayer(3)
      icon:SetVisible(true)
      icon:SetPoint("TOPLEFT",   lineframe, "TOPRIGHT", mano.gui.borders.left, 0)

      -- Item's Name
      local text     =  UI.CreateFrame("Text", "line_name_" .. self.lineid, lineframe)
      if mano.gui.font.name then
         text:SetFont(mano.addon.name, mano.gui.font.name)
      end
      text:SetFontSize(mano.gui.font.size)
      text:SetText(t.name or t.location .. " (" .. self.lineid .. ")")
      text:SetLayer(3)
      text:EventAttach( Event.UI.Input.Mouse.Left.Click,
                        function()
                           self.setwaypoint(t.x, t.y)
                        end,
                        "Way Point Selected" )
      text:SetVisible(true)
      text:SetPoint("TOPLEFT", icon, "TOPRIGHT", mano.gui.borders.left, 0)

      -- (...)

      local T  =  {
                  inuse =  true,
                  frame =  lineframe,
                  icon  =  icon,
                  text  =  text
                  }

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
                                    self.setwaypoint(t.x, t.y, t.zonename)
                                 end,
                                 "Way Point Selected" )
      end

      mano.gui.frames.lastlinecontainer =  nil

      return
   end

   local function fetchlinefromstock(t)

      local idx, tbl, cnt =  nil, {}, 0
      local retval   =  nil

      for idx, tbl in pairs(self.linestock) do
         cnt = cnt + 1
         if not tbl.inuse then
            retval = tbl
            -- set the frame as INUSE
            self.linestock[idx].inuse     =  true
            break
         end
      end

      if not retval then
         retval = buildforstock(t)
         print(string.format("fetchlinefromstock: BUILD NEW LINE FRAME=>[%s] count(%s)", retval, countarray(retval)))
         mano.gui.frames.lastlinecontainer =  retval.frame
      else
         retval.frame:SetVisible(true)
         retval.icon:SetVisible(true)
         mano.f.dprint(strinf.format("Text is [%s]", t.text))
         retval.text:SetText(t.text or "lorem ipsum")
         retval.text:EventAttach(   Event.UI.Input.Mouse.Left.Click,
                                    function()
                                       self.setwaypoint(t.x, t.z, t.zone)
                                    end,
                                    "Way Point Added" )
         retval.text:SetVisible(true)
         mano.gui.frames.lastlinecontainer =  retval.frame
      end

      return retval
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
         Library.LibDraggable.undraggify(mano.gui.shown.window, mano.f.updateguicoordinates)
      else
         icon  =  "lock_off.png.dds"
         Library.LibDraggable.draggify(mano.gui.shown.window, mano.f.updateguicoordinates)
      end

      mano.gui.shown.lockbutton:SetTexture("Rift", icon)

      return
   end

   local function showhidewindow(params)
      if mano.gui.visible ==  true then
         mano.gui.visible  =  false
      else
         mano.gui.visible  =  true
      end

      mano.gui.shown.window:SetVisible(mano.gui.visible)

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
--          local tbls  =  { mano.gui.shown.currenttbl, mano.gui.shown.todaytbl, mano.gui.shown.weektbl }
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
--          local tbls  =  { mano.gui.shown.currentnotorietytbl, mano.gui.shown.todaynotorietytbl, mano.gui.shown.weeknotorietytbl }
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
--          mano.gui.shown.windowtitle:SetFontSize(mano.gui.font.size*.75)
--          mano.gui.shown.mano.ersion:SetFontSize(mano.round(mano.gui.font.size/2))
--          mano.gui.shown.windowinfo:SetFontSize(mano.gui.font.size*.75)
--          mano.gui.shown.titleicon:SetHeight(mano.gui.font.size*.75)
--          mano.gui.shown.titleicon:SetWidth(mano.gui.font.size*.75)
--          mano.gui.shown.corner:SetHeight(mano.gui.font.size)
--          mano.gui.shown.corner:SetWidth(mano.gui.font.size)
--          mano.gui.shown.lockbutton:SetHeight(mano.gui.font.size)
--          mano.gui.shown.lockbutton:SetWidth(mano.gui.font.size)
--          mano.gui.shown.iconizebutton:SetHeight(mano.gui.font.size)
--          mano.gui.shown.iconizebutton:SetWidth(mano.gui.font.size)
--          mano.resizewindow(mano.gui.shown.tracker, mano.gui.shown.panel)
      end

      return
   end


   function self.addline(t)

      local inuse, frame, icon, text   =  nil, nil, nil, nil

      if not self.initialized then
         mano.f.dprint("MY WAY ON THE HIGHWAY!")
         self = self.new()
      end

      local stockframe  =  fetchlinefromstock(t)
      mano.gui.frames.lastlinecontainer   =  stockframe.frame


      -- auto adjust window Y size
      self.adjustheight()

      return stockframe
   end


   function self.adjustheight()

      if mano.gui.frames.lastlinecontainer ~= nil then
         local maxY  =  mano.gui.frames.lastlinecontainer:GetBottom()
         local minY  =  mano.gui.shown.manoframe:GetTop()

         mano.gui.shown.manoframe:SetHeight(mano.f.round(maxY - maxY))
         mano.gui.shown.window:SetHeight(mano.gui.shown.titleframe:GetHeight() +  mano.f.round(maxY - minY))
         print(string.format("new Height: (%s)", mano.gui.shown.window:GetHeight()))
      end

      return
   end

   function self.new()

      --Global context (parent frame-thing).
      local context  = UI.CreateContext("mano_context")

      -- Main Window
      local window  =  UI.CreateFrame("Frame", "MaNo", context)

      mano.f.dprint(string.format("mano.gui.win.x=%s mano.gui.win.y=%s", mano.gui.win.x, mano.gui.win.y))

      if mano.gui.win.x == nil or mano.gui.win.y == nil then
         -- first run, we position in the screen center
         window:SetPoint("CENTER", UIParent, "CENTER")
      else
         -- we have coordinates
         window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", mano.gui.win.x or 0, mano.gui.win.y or 0)
      end
      window:SetLayer(-1)
      window:SetWidth(mano.gui.win.width)
      window:SetBackgroundColor(unpack(mano.gui.color.black))
      window:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function() changefontsize(1)   end,  "MaNo: window_wheel_forward")
      window:EventAttach(Event.UI.Input.Mouse.Wheel.Back,    function() changefontsize(-1)  end,  "MaNo: window_wheel_backward")
      mano.gui.shown.window =  window

      local titleframe =  UI.CreateFrame("Frame", "Cut_title_frame", mano.gui.shown.window)
      titleframe:SetPoint("TOPLEFT",     window, "TOPLEFT",    0, -(mano.gui.font.size*1.5)+4)  -- move up, outside externalframe
      titleframe:SetPoint("TOPRIGHT",    window, "TOPRIGHT",   0, -(mano.gui.font.size*1.5)+4)  -- move up, outside externalframe
      titleframe:SetHeight(mano.gui.font.size*1.5)
      titleframe:SetBackgroundColor(unpack(mano.gui.color.deepblack))
      titleframe:SetLayer(1)
      mano.gui.shown.titleframe =  titleframe

         -- Title Icon
         titleicon = UI.CreateFrame("Texture", "mano_tile_icon", mano.gui.shown.titleframe)
         titleicon:SetTexture("Rift", "loot_gold_coins.dds")
         titleicon:SetHeight(mano.gui.font.size)
         titleicon:SetWidth(mano.gui.font.size)
         titleicon:SetLayer(3)
         titleicon:SetPoint("CENTERLEFT", titleframe, "CENTERLEFT", mano.gui.borders.left*2, 0)
         mano.gui.shown.titleicon   =  titleicon

         -- Window Title
         local windowtitle =  UI.CreateFrame("Text", "mano_window_title", mano.gui.shown.titleframe)
         windowtitle:SetFontSize(mano.gui.font.size)
         --       windowtitle:SetText(string.format("%s", mano.html.title[1]), true)
         windowtitle:SetText(string.format("%s", mano.html.title), true)
         windowtitle:SetLayer(3)
         windowtitle:SetPoint("CENTERLEFT",   titleicon, "CENTERRIGHT", mano.gui.borders.left*2, 0)
         mano.gui.shown.windowtitle   =  windowtitle

         -- MaNo Version
         local titleversion =  UI.CreateFrame("Text", "mano_title_version", mano.gui.shown.titleframe)
         titleversion:SetFontSize(mano.round(mano.gui.font.size * .75))
         titleversion:SetText(string.format("%s", 'v.' .. mano.addon.version), true)
         titleversion:SetLayer(3)
         titleversion:SetPoint("CENTERLEFT", windowtitle, "CENTERRIGHT", mano.gui.borders.left*2, 0)
         mano.gui.shown.manoversion  =  titleversion

         -- Iconize Button
         local iconizebutton = UI.CreateFrame("Texture", "mano_iconize_button", mano.gui.shown.titleframe)
         iconizebutton:SetTexture("Rift", "AlertTray_I54.dds")
         iconizebutton:SetHeight(mano.gui.font.size)
         iconizebutton:SetWidth(mano.gui.font.size)
         iconizebutton:SetLayer(3)
         iconizebutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function() showhidewindow() end, "MaNo: Iconize Button Pressed" )
         iconizebutton:SetPoint("CENTERRIGHT",   titleframe, "CENTERRIGHT", -mano.gui.borders.right, 0)
         mano.gui.shown.iconizebutton =  iconizebutton

         -- Lock Button
         local lockbutton = UI.CreateFrame("Texture", "mano_lock_gui_button", mano.gui.shown.titleframe)
         local icon  =  nil
         if mano.gui.locked then
            icon  =  "lock_on.png.dds"
         else
            icon  =  "lock_off.png.dds"
         end
         lockbutton:SetTexture("Rift", icon)
         lockbutton:SetHeight(mano.gui.font.size)
         lockbutton:SetWidth(mano.gui.font.size)
         lockbutton:SetLayer(3)
         lockbutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function() lockgui() end, "MaNo: Lock GUI Button Pressed" )
         lockbutton:SetPoint("CENTERRIGHT",   iconizebutton, "CENTERRIGHT", -mano.gui.font.size, 0)
         mano.gui.shown.lockbutton =  lockbutton


      -- EXTERNAL CUT CONTAINER FRAME
      local externalframe =  UI.CreateFrame("Frame", "mano_external_frame", window)
      externalframe:SetPoint("TOPLEFT",     mano.gui.shown.titleframe,   "BOTTOMLEFT",  mano.gui.borders.left,    0)
      externalframe:SetPoint("TOPRIGHT",    mano.gui.shown.titleframe,   "BOTTOMRIGHT", - mano.gui.borders.right, 0)
      externalframe:SetPoint("BOTTOMLEFT",  mano.gui.shown.window,       "BOTTOMLEFT",  mano.gui.borders.left,    - mano.gui.borders.bottom)
      externalframe:SetPoint("BOTTOMRIGHT", mano.gui.shown.window,       "BOTTOMRIGHT", - mano.gui.borders.right, - mano.gui.borders.bottom)
      externalframe:SetBackgroundColor(unpack(mano.gui.color.black))
      externalframe:SetLayer(1)
      mano.gui.shown.externalframe   =  externalframe

      -- MASK FRAME
      local maskframe = UI.CreateFrame("Mask", "mano_mask_frame", mano.gui.shown.externalframe)
      maskframe:SetAllPoints(mano.gui.shown.externalframe)
      mano.gui.shown.maskframe =  maskframe

      -- CONTAINER FRAME
      local manoframe =  UI.CreateFrame("Frame", "mano_notes_frame", mano.gui.shown.maskframe)
      manoframe:SetAllPoints(mano.gui.shown.maskframe)
      manoframe:SetLayer(1)
      mano.gui.shown.manoframe   =  manoframe

      -- RESIZER WIDGET
      local corner=  UI.CreateFrame("Texture", "mano_corner", mano.gui.shown.window)
      corner:SetTexture("Rift", "chat_resize_(over).png.dds")
      corner:SetHeight(mano.gui.font.size)
      corner:SetWidth(mano.gui.font.size)
      corner:SetLayer(4)
      corner:SetPoint("BOTTOMRIGHT", mano.gui.shown.manoframe, "BOTTOMRIGHT")
      corner:EventAttach(Event.UI.Input.Mouse.Right.Down,      function()
                                                                  local mouse = Inspect.Mouse()
                                                                  corner.pressed = true
                                                                  corner.basex   =  window:GetLeft()
                                                                  corner.basey   =  window:GetTop()
                                                               end,
                                                               "Event.UI.Input.Mouse.Right.Down")

      corner:EventAttach(Event.UI.Input.Mouse.Cursor.Move,     function()
                                                                  if  corner.pressed then
                                                                     local mouse = Inspect.Mouse()
                                                                     mano.gui.win.width  = mano.round(mouse.x - corner.basex)
                                                                     mano.gui.win.height = mano.round(mouse.y - corner.basey)
                                                                     mano.gui.shown.window:SetWidth(mano.gui.win.width)
                                                                     mano.gui.shown.window:SetHeight(mano.gui.win.height)
                                                                  end
                                                               end,
                                                               "Event.UI.Input.Mouse.Cursor.Move")

      corner:EventAttach(Event.UI.Input.Mouse.Right.Upoutside, function()
                                                                  corner.pressed = false
                                                                  self.adjustheight()
                                                               end,
                                                               "MaNo: Event.UI.Input.Mouse.Right.Upoutside")
      corner:EventAttach(Event.UI.Input.Mouse.Right.Up,        function()
                                                                  corner.pressed = false
                                                                  self.adjustheight()
                                                               end,
                                                               "MaNo: Event.UI.Input.Mouse.Right.Up")
      mano.gui.shown.corner  =  corner

      return window
   end

   if self  then
      self.initialized =   true
   end

   return self

end
