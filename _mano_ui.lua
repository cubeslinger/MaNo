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
--       inputwin =  {},
--       vspacer  =  5,
--       hspacer  =  3,
   }


   local function lockgui(value)

      if value == true or value == false then
         mano.gui.locked   =  value
      else
         mano.gui.locked   =  not cut.gui.locked
      end

      local icon  =  nil

      if mano.gui.locked == true then
         icon  =  "lock_on.png.dds"
         Library.LibDraggable.undraggify(mano.gui.window, updateguicoordinates)
      else
         icon  =  "lock_off.png.dds"
         Library.LibDraggable.draggify(mano.gui.window, updateguicoordinates)
      end

      mano.shown.lockbutton:SetTexture("Rift", icon)

      --    print(string.format("value=(%s) mano.gui.locked=(%s)", value, mano.gui.locked))

      return
   end



   local function showhidewindow(params)
      if mano.gui.visible ==  true then
         mano.gui.visible  =  false
      else
         mano.gui.visible  =  true
      end

      cut.gui.window:SetVisible(mano.gui.visible)

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
--          local tbls  =  { mano.shown.currenttbl, mano.shown.todaytbl, mano.shown.weektbl }
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
--          local tbls  =  { mano.shown.currentnotorietytbl, mano.shown.todaynotorietytbl, mano.shown.weeknotorietytbl }
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
--          mano.shown.windowtitle:SetFontSize(mano.gui.font.size*.75)
--          mano.shown.mano.ersion:SetFontSize(mano.round(mano.gui.font.size/2))
--          mano.shown.windowinfo:SetFontSize(mano.gui.font.size*.75)
--          mano.shown.titleicon:SetHeight(mano.gui.font.size*.75)
--          mano.shown.titleicon:SetWidth(mano.gui.font.size*.75)
--          mano.shown.corner:SetHeight(mano.gui.font.size)
--          mano.shown.corner:SetWidth(mano.gui.font.size)
--          mano.shown.lockbutton:SetHeight(mano.gui.font.size)
--          mano.shown.lockbutton:SetWidth(mano.gui.font.size)
--          mano.shown.iconizebutton:SetHeight(mano.gui.font.size)
--          mano.shown.iconizebutton:SetWidth(mano.gui.font.size)
--          mano.resizewindow(mano.shown.tracker, mano.shown.panel)
      end

      return
   end


   function self.new()

      --Global context (parent frame-thing).
      local window  =  UI.CreateFrame("Frame", "MaNo", UI.CreateContext("mano_context"))
      if cut.gui.x == nil or cut.gui.y == nil then
         -- first run, we position in the screen center
         window:SetPoint("CENTER", UIParent, "CENTER")
      else
         -- we have coordinates
         window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", cut.gui.x or 0, cut.gui.y or 0)
      end
      window:SetLayer(-1)
      window:SetWidth(cut.gui.width)
      window:SetBackgroundColor(unpack(mano.gui.color.black))
      window:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function() changefontsize(1)   end,  "MaNo: window_wheel_forward")
      window:EventAttach(Event.UI.Input.Mouse.Wheel.Back,    function() changefontsize(-1)  end,  "MaNo: window_wheel_backward")
      mano.shown.window =  window

      local titleframe =  UI.CreateFrame("Frame", "Cut_title_frame", mano.shown.window)
      titleframe:SetPoint("TOPLEFT",     window, "TOPLEFT",    0, -(mano.gui.font.size*1.5)+4)  -- move up, outside externalframe
      titleframe:SetPoint("TOPRIGHT",    window, "TOPRIGHT",   0, -(mano.gui.font.size*1.5)+4)  -- move up, outside externalframe
      titleframe:SetHeight(mano.gui.font.size*1.5)
      titleframe:SetBackgroundColor(unpack(mano.color.deepblack))
      titleframe:SetLayer(1)
      mano.shown.titleframe =  titleframe

         -- Title Icon
         titleicon = UI.CreateFrame("Texture", "mano_tile_icon", mano.shown.titleframe)
         titleicon:SetTexture("Rift", "loot_gold_coins.dds")
         titleicon:SetHeight(mano.gui.font.size)
         titleicon:SetWidth(mano.gui.font.size)
         titleicon:SetLayer(3)
         titleicon:SetPoint("CENTERLEFT", titleframe, "CENTERLEFT", mano.gui.borders.left*2, 0)
         mano.shown.titleicon   =  titleicon

         -- Window Title
         local windowtitle =  UI.CreateFrame("Text", "mano_window_title", mano.shown.titleframe)
         windowtitle:SetFontSize(mano.gui.font.size)
         --       windowtitle:SetText(string.format("%s", cut.html.title[1]), true)
         windowtitle:SetText(string.format("%s", mano.html.title), true)
         windowtitle:SetLayer(3)
         windowtitle:SetPoint("CENTERLEFT",   titleicon, "CENTERRIGHT", mano.gui.borders.left*2, 0)
         mano.shown.windowtitle   =  windowtitle

         -- MaNo Version
         local titleversion =  UI.CreateFrame("Text", "mano_title_version", mano.shown.titleframe)
         titleversion:SetFontSize(cut.round(mano.gui.font.size * .75))
         titleversion:SetText(string.format("%s", 'v.'..mano.version), true)
         titleversion:SetLayer(3)
         titleversion:SetPoint("CENTERLEFT", windowtitle, "CENTERRIGHT", mano.gui.borders.left*2, 0)
         mano.shown.manoversion  =  titleversion

         -- Iconize Button
         local iconizebutton = UI.CreateFrame("Texture", "mano_iconize_button", mano.shown.titleframe)
         iconizebutton:SetTexture("Rift", "AlertTray_I54.dds")
         iconizebutton:SetHeight(mano.gui.font.size)
         iconizebutton:SetWidth(mano.gui.font.size)
         iconizebutton:SetLayer(3)
         iconizebutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function() showhidewindow() end, "MaNo: Iconize Button Pressed" )
         iconizebutton:SetPoint("CENTERRIGHT",   titleframe, "CENTERRIGHT", -mano.gui.borders.right, 0)
         mano.shown.iconizebutton =  iconizebutton

         -- Lock Button
         local lockbutton = UI.CreateFrame("Texture", "mano_lock_gui_button", mano.shown.titleframe)
         local icon  =  nil
         if cut.gui.locked then
            icon  =  "lock_on.png.dds"
         else
            icon  =  "lock_off.png.dds"
         end
         lockbutton:SetTexture("Rift", icon)
         lockbutton:SetHeight(mano.gui.font.size)
         lockbutton:SetWidth(mano.gui.font.size)
         lockbutton:SetLayer(3)
         lockbutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function() lockgui() end, "MaNo: Lock GUI Button Pressed" )
         lockbutton:SetPoint("CENTERRIGHT",   iconizebutton, "CENTERRIGHT", -cut.gui.font.size, 0)
         mano.shown.lockbutton =  lockbutton


      -- EXTERNAL CUT CONTAINER FRAME
      local externalframe =  UI.CreateFrame("Frame", "mano_external_frame", window)
      externalframe:SetPoint("TOPLEFT",     mano.shown.titleframe,   "BOTTOMLEFT",  mano.gui.borders.left,    0)
      externalframe:SetPoint("TOPRIGHT",    mano.shown.titleframe,   "BOTTOMRIGHT", - mano.gui.borders.right, 0)
      externalframe:SetPoint("BOTTOMLEFT",  mano.shown.window,       "BOTTOMLEFT",  mano.gui.borders.left,    - mano.gui.borders.bottom)
      externalframe:SetPoint("BOTTOMRIGHT", mano.shown.window,       "BOTTOMRIGHT", - mano.gui.borders.right, - mano.gui.borders.bottom)
      externalframe:SetBackgroundColor(unpack(mano.color.darkgrey))
      externalframe:SetLayer(1)
      mano.shown.externalframe   =  externalframe

      -- MASK FRAME
      local maskframe = UI.CreateFrame("Mask", "mano_mask_frame", mano.shown.externalframe)
      maskframe:SetAllPoints(mano.shown.externalframe)
      mano.shown.maskframe =  maskframe

      -- Current Session Data Container
      -- CUT CONTAINER FRAME
      local cutframe =  UI.CreateFrame("Frame", "mano_frame", mano.shown.maskframe)
      manoframe:SetAllPoints(mano.shown.maskframe)
      manoframe:SetLayer(1)
      mano.frames.container =  manoframe

      -- RESIZER WIDGET
      local corner=  UI.CreateFrame("Texture", "corner", mano.shown.window)
      --    corner:SetTexture("Rift", "chat_resize_(normal).png.dds")
      --    corner:SetTexture("Rift", "chat_resize_(over).png.dds")
      corner:SetTexture("Rift", "AuctionHouse_I91.dds")
      corner:SetHeight(mano.gui.font.size)
      corner:SetWidth(mano.gui.font.size)
      corner:SetLayer(4)
      corner:SetPoint("BOTTOMRIGHT", mano.shown.titleframe, "BOTTOMRIGHT", mano.gui.font.size/2, mano.gui.font.size/2)
      corner:EventAttach(Event.UI.Input.Mouse.Right.Down,      function()  local mouse = Inspect.Mouse()
                                                                           corner.pressed = true
                                                                           corner.basex   =  window:GetLeft()
                                                                           corner.basey   =  window:GetTop()
                                                                           showtitlebar()
                                                                        end,
                                                                        "Event.UI.Input.Mouse.Right.Down")

      corner:EventAttach(Event.UI.Input.Mouse.Cursor.Move,    function()  if  corner.pressed then
                                                                              local mouse = Inspect.Mouse()
                                                                              cut.gui.width  = cut.round(mouse.x - corner.basex)
                                                                              cut.gui.height = cut.round(mouse.y - corner.basey)
                                                                              cut.gui.window:SetWidth(cut.gui.width)
                                                                              cut.gui.window:SetHeight(cut.gui.height)
                                                                              --                                                                            print(string.format("POST Width[%s] Height[%s]", cut.gui.width, cut.gui.height))
                                                                           end
                                                                        end,
                                                                        "Event.UI.Input.Mouse.Cursor.Move")

      corner:EventAttach(Event.UI.Input.Mouse.Right.Upoutside, function()  corner.pressed = false        end, "MaNo: Event.UI.Input.Mouse.Right.Upoutside")
      corner:EventAttach(Event.UI.Input.Mouse.Right.Up,        function()  corner.pressed = false        end, "MaNo: Event.UI.Input.Mouse.Right.Up")
      mano.shown.corner  =  corner

      --    -- Enable Dragging
      --    Library.LibDraggable.draggify(window, updateguicoordinates)

      --    lockgui(cut.gui.locked)

      return window
   end

end
