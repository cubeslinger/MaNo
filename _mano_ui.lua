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
                  initialized =  false
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


   local function buildforstock(parent,t)

      print(string.format("buildforstock: parent=[%s]", parent))
      for var, val in pairs(t) do
         print(string.format("buildforstock: var[%s]=[%s]", var,val))
      end


      local lineframe, icon, text   =  nil, nil, nil

      for var, val in pairs(t) do
         print(string.format("buildforstock: var[%s]=[%s]", var, val))
      end

      -- (...)

      self.lineid =  self.lineid + 1

      -- Line Frame container
      lineframe =  UI.CreateFrame("Frame", "line_item_Frame" .. self.lineid, parent)
      lineframe:SetBackgroundColor(.2, .2, .2, .6)
      lineframe:SetPoint("TOPLEFT",  parent, "BOTTOMLEFT", 0, 1)
      lineframe:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT",0, 1)
      lineframe:SetLayer(3)


      -- Icon
      local icon = UI.CreateFrame("Texture", "line_icon_" .. self.lineid, lineframe)
      icon:SetTexture("Rift", t.icon or "Fish_icon.png.dds")
      icon:SetWidth(mano.gui.font.size)
      icon:SetHeight(mano.gui.font.size)
      icon:SetPoint("TOPLEFT",   lineframe, "TOPRIGHT", mano.gui.borders.left, 0)
      icon:SetLayer(3)

      -- Item's Name
      local text     =  UI.CreateFrame("Text", "line_name_" .. self.lineid, lineframe)
      if mano.gui.font.name then
         text:SetFont(mano.addon, mano.gui.font.name)
      end
      text:SetFontSize(mano.gui.font.size)
      text:SetText(t.name or t.location)
      text:SetLayer(3)
--       text:SetFontColor(objColor.r, objColor.g, objColor.b)
      text:SetFontColor(unpack(mano.gui.color.lightblue))
      text:SetPoint("TOPLEFT",   icon,    "TOPRIGHT", mano.gui.borders.left, -4)
      -- text:EventAttach(Event.UI.Input.Mouse.Left.Click, function() self.setwaypoint(t.x, t.y) end, "Way Point Selected" )

      -- (...)

      local T  =  {
                  inuse =  true,
                  frame =  lineframe,
                  icon  =  icon,
                  text  =  text
                  }

      print(string.format("T=[%s] count=%s", T, countarray(T)))
      table.insert(self.linestock, T)
      print(string.format("self.linestock=[%s] count=%s", self.linestock, countarray(self.linestock)))

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
         tbl.text:EventDetach(Event.UI.Input.Mouse.Left.Click, function() self.setwaypoint(t.x, t.y, t.zonename) end, "Way Point Selected" )
      end

      return
   end

   local function fetchlinefromstock(parent,t)

      local idx, tbl =  nil, {}
      local retval   =  nil

      for idx, tbl in pairs(self.linestock) do
         if not tbl.inuse then
            retval = tbl
            -- set the frame as INUSE
            self.linestock[idx].inuse     =  true
            break
         end
      end

      if not retval then
         retval = buildforstock(parent, t)
         print(string.format("fetchlinefromstock: BUILD NEW LINE FRAME=>[%s] count(%s)", retval, countarray(retval)))
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
         Library.LibDraggable.undraggify(mano.gui.window, updateguicoordinates)
      else
         icon  =  "lock_off.png.dds"
         Library.LibDraggable.draggify(mano.gui.window, updateguicoordinates)
      end

      mano.gui.shown.lockbutton:SetTexture("Rift", icon)

      --    print(string.format("value=(%s) mano.gui.locked=(%s)", value, mano.gui.locked))

      return
   end



   local function showhidewindow(params)
      if mano.gui.visible ==  true then
         mano.gui.visible  =  false
      else
         mano.gui.visible  =  true
      end

      mano.gui.window:SetVisible(mano.gui.visible)

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

      local inuse, frame, icon, text, parent =  nil, nil, nil, nil, nil

      if not self.initialized then
         print("MY WAY ON THE HIGHWAY!")
         self = self.new() end

      if mano.gui.shown.counter   == 0  then
         parent   =  mano.gui.frames.container
      else
         parent   =  mano.gui.frames.last
      end


      print(string.format("ui.addline: parent=[%s]", parent))
      local stockframe  = fetchlinefromstock(parent,t)

      if next(stockframe) ~= nil then
         for var, val in pairs(stockframe) do
            print(string.format("stockframe: var[%s]=[%s]", var, val))
         end
      else
         print(string.format("stockframe: ERROR, stockframe=[%s] n=%s", stockframe, countarray(stockframe)))
      end

--       frame =  stockframe.frame
--       icon  =  stockframe.icon
--       text  =  stockframe.text

      if t.icon then stockframe.icon:SetTexture("Rift", t.icon)
      else           stockframe.icon:SetTexture("Rift", "Fish_icon.png.dds")
      end
      stockframe.icon:SetVisible(true)

      stockframe.text:SetText(t.text or "lorem ipsum")
      stockframe.text:EventAttach(Event.UI.Input.Mouse.Left.Click, function() self.setwaypoint(t.x, t.z, t.zone) end, "Way Point Added" )

      mano.gui.frames.last  =  stockframe

      return

   end


   function self.new()

      --Global context (parent frame-thing).
      local window  =  UI.CreateFrame("Frame", "MaNo", UI.CreateContext("mano_context"))
      if mano.gui.x == nil or mano.gui.y == nil then
         -- first run, we position in the screen center
         window:SetPoint("CENTER", UIParent, "CENTER")
      else
         -- we have coordinates
         window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", mano.gui.x or 0, mano.gui.y or 0)
      end
      window:SetLayer(-1)
      window:SetWidth(mano.gui.width)
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
      externalframe:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
      externalframe:SetLayer(1)
      mano.gui.shown.externalframe   =  externalframe

      -- MASK FRAME
      local maskframe = UI.CreateFrame("Mask", "mano_mask_frame", mano.gui.shown.externalframe)
      maskframe:SetAllPoints(mano.gui.shown.externalframe)
      mano.gui.shown.maskframe =  maskframe

      -- Current Session Data Container
      -- CUT CONTAINER FRAME
      local manoframe =  UI.CreateFrame("Frame", "mano_frame", mano.gui.shown.maskframe)
      manoframe:SetAllPoints(mano.gui.shown.maskframe)
      manoframe:SetLayer(1)
      mano.gui.frames.container =  manoframe
      print(string.format("ui.new: mano.gui.frames.container=[%s]", mano.gui.frames.container))

      -- RESIZER WIDGET
      local corner=  UI.CreateFrame("Texture", "corner", mano.gui.shown.window)
      --    corner:SetTexture("Rift", "chat_resize_(normal).png.dds")
      --    corner:SetTexture("Rift", "chat_resize_(over).png.dds")
      corner:SetTexture("Rift", "AuctionHouse_I91.dds")
      corner:SetHeight(mano.gui.font.size)
      corner:SetWidth(mano.gui.font.size)
      corner:SetLayer(4)
      corner:SetPoint("BOTTOMRIGHT", mano.gui.shown.titleframe, "BOTTOMRIGHT", mano.gui.font.size/2, mano.gui.font.size/2)
      corner:EventAttach(Event.UI.Input.Mouse.Right.Down,      function()  local mouse = Inspect.Mouse()
                                                                           corner.pressed = true
                                                                           corner.basex   =  window:GetLeft()
                                                                           corner.basey   =  window:GetTop()
                                                                           showtitlebar()
                                                                        end,
                                                                        "Event.UI.Input.Mouse.Right.Down")

      corner:EventAttach(Event.UI.Input.Mouse.Cursor.Move,    function()  if  corner.pressed then
                                                                              local mouse = Inspect.Mouse()
                                                                              mano.gui.width  = mano.round(mouse.x - corner.basex)
                                                                              mano.gui.height = mano.round(mouse.y - corner.basey)
                                                                              mano.gui.window:SetWidth(mano.gui.width)
                                                                              mano.gui.window:SetHeight(mano.gui.height)
                                                                              --                                                                            print(string.format("POST Width[%s] Height[%s]", mano.gui.width, mano.gui.height))
                                                                           end
                                                                        end,
                                                                        "Event.UI.Input.Mouse.Cursor.Move")

      corner:EventAttach(Event.UI.Input.Mouse.Right.Upoutside, function()  corner.pressed = false        end, "MaNo: Event.UI.Input.Mouse.Right.Upoutside")
      corner:EventAttach(Event.UI.Input.Mouse.Right.Up,        function()  corner.pressed = false        end, "MaNo: Event.UI.Input.Mouse.Right.Up")
      mano.gui.shown.corner  =  corner

      --    -- Enable Dragging
      --    Library.LibDraggable.draggify(window, updateguicoordinates)

      --    lockgui(mano.gui.locked)

      return window
   end

   if self  then  self.initialized =   true  end

   return self

end
