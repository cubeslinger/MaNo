--
-- Addon       _mano_ui_input.lua
-- Author      marcob@marcob.org
-- StartDate   15/06/2017
--

local addon, mano = ...

function __mano_ui_input(action, modifytbl)
   -- the new instance
   local self =   {
                  -- public fields go in the instance table
                  linestock         =  {},
                  lineid            =  0,
                  initialized       =  false,
                  o                 =  {},
                  lastfocus         =  nil,
                  }

   local function detacheventwatchers()
      -- Save & Cancel Events
      Command.Event.Detach(Event.MaNo.userinput.cancel,  function(...) mano.f.userinputcancel(...) end,  "MaNo: input: Cancel")
      Command.Event.Detach(Event.MaNo.userinput.save,    function(...) mano.f.userinputsave(...)   end,  "MaNo: input: Save")
      Command.Event.Detach(Event.MaNo.userinput.delete,  function(...) mano.f.userinputdelete(...) end,  "MaNo: input: Delete")

      return
   end

   local function attacheventwatchers()
      -- Save & Cancel Events
      Command.Event.Attach(Event.MaNo.userinput.cancel,  function(...) mano.f.userinputcancel(...) end,  "MaNo: input: Cancel")
      Command.Event.Attach(Event.MaNo.userinput.save,    function(...) mano.f.userinputsave(...)   end,  "MaNo: input: Save")
      Command.Event.Attach(Event.MaNo.userinput.delete,  function(...) mano.f.userinputdelete(...) end,  "MaNo: input: Delete")

      return
   end

   local function flippppanel()

      self.o.externaldxframe:SetVisible(not self.o.externaldxframe:GetVisible())
      self.o.dxframe:SetVisible(not self.o.dxframe:GetVisible())

      return
   end

   local function catmenuchoice(idx)

      if idx and mano.categories[idx] ~= nil then
         self.o.cattext:SetText(mano.categories[idx].name)
         local oldicon  =  self.o.caticon:GetTexture()
         self.o.caticon:SetTexture("Rift", mano.categories[idx].icon or oldicon)
         self.o.catmenu:flip()
         self.o.categorylastidx = idx
      else
         print(string.format("categorychooser: ERROR: idx is out of range = (%s)", idx))
      end


      return
   end


   local function countarray(array)

      local k, v  =  nil, nil
      local count =  0
      local t     =  array

      if array then
         for k, v in pairs(array) do count = count +1 end
      end

      return count
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

   function self.GetInput()

      local icontbl           =  self.o.caticon:GetTexture()
--       local texturetype, icon =  unpack(string.split(icontbl, ","))
      local texturetype, icon =  unpack(mano.f.splitstring(icontbl, ","))

      local t  =  {  label    =  self.o.labeltext:GetText(),
--                      note     =  self.o.notetext:GetText(),
                     text     =  self.o.notetext:GetText(),
                     category =  self.o.cattext:GetText(),
                     icon     =  icon,
                     save     =  self.o.save,
                     shared   =  self.o.sharedbutton:GetChecked()
                  }

      local p  =  {}
      if self.o.ppxtext:GetText()         ~= "" then p.x          =  mano.f.rounddecimal(tonumber(self.o.ppxtext:GetText()), 2)        end
      if self.o.ppztext:GetText()         ~= "" then p.z          =  mano.f.rounddecimal(tonumber(self.o.ppztext:GetText()), 2)        end
      if self.o.ppytext:GetText()         ~= "" then p.y          =  mano.f.rounddecimal(tonumber(self.o.ppytext:GetText()), 2)        end
      if self.o.ppzonenametext:GetText()  ~= "" then p.zonename   =  self.o.ppzonenametext:GetText()  end
      if self.o.ppzoneidtext:GetText()    ~= "" then p.zoneid     =  self.o.ppzoneidtext:GetText()    end
      if self.o.ppownertext:GetText()     ~= "" then p.name       =  self.o.ppownertext:GetText()     end

      if p  ~= {} and next(p) ~= nil then t.playerpos =  p  end


      return t

   end


   local function refresh_category_menu()

      -- Dynamic Category Menu
      local idx,  tbl,  category =  nil, {}, nil
      local T  =  {}

      for idx, tbl in pairs(mano.categories) do
         local t  =  {  name     =  tbl.name,
                        icon     =  tbl.icon,
                        callback =  { catmenuchoice, idx, 'close' },
                     }
         table.insert(T, t)
         t  =  {}
      end

      return T
   end

--    local function __init(action)
   function self.show(dummy, action, modifytbl)

--       print(string.format("action=(%s)\n", mano.f.dumptable(action)))
      print(string.format("dummy=%s, action=%s. modifytbl=%s\n", dummy, action, modifytbl))
      print("modifytbl\n", mano.f.dumptable(modifytbl))

      self.o.save =  false

      self.catmenu         =  {}
      self.catmenu.voices  =  {}
      self.catmenu.voices  =  refresh_category_menu()

      if not self.initialized then

         print("FIRST New Note")

         -- Window Context
         local context  = UI.CreateContext("mano_input_context")

         -- Main Window
         self.o.window  =  UI.CreateFrame("Frame", "input_window", context)

            self.o.window:SetPoint("CENTER", UIParent, "CENTER")
         self.o.window:SetLayer(-1)
         self.o.window:SetWidth(mano.gui.win.width)
         self.o.window:SetBackgroundColor(unpack(mano.gui.color.black))
         self.o.window:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function() changefontsize(1)   end,  "MaNo: inputwindow: window_wheel_forward")
         self.o.window:EventAttach(Event.UI.Input.Mouse.Wheel.Back,    function() changefontsize(-1)  end,  "MaNo: inputwindow: window_wheel_backward")

         self.o.titleframe =  UI.CreateFrame("Frame", "input_title_frame", self.o.window)
         self.o.titleframe:SetPoint("TOPLEFT",  self.o.window, "TOPLEFT",    0, -(mano.gui.font.size*1.5)+4)  -- move up, outside externalframe
         self.o.titleframe:SetPoint("TOPRIGHT", self.o.window, "TOPRIGHT",   0, -(mano.gui.font.size*1.5)+4)  -- move up, outside externalframe
         self.o.titleframe:SetHeight(mano.gui.font.size * 1.5)
         self.o.titleframe:SetBackgroundColor(unpack(mano.gui.color.deepblack))
         self.o.titleframe:SetLayer(1)

            -- Title Icon
            self.o.titleicon = UI.CreateFrame("Texture", "mano_input_tile_icon", self.o.titleframe)
            self.o.titleicon:SetTexture("Rift", "macro_icon_heal.dds")
            self.o.titleicon:SetHeight(mano.gui.font.size)
            self.o.titleicon:SetWidth(mano.gui.font.size)
            self.o.titleicon:SetLayer(3)
            self.o.titleicon:SetPoint("CENTERLEFT", self.o.titleframe, "CENTERLEFT", mano.gui.borders.left*2, 0)

            -- Window Title
            self.o.windowtitle =  UI.CreateFrame("Text", "mano_input_window_title", self.o.titleframe)
            self.o.windowtitle:SetFontSize(mano.gui.font.size)
            self.o.windowtitle:SetText("New Note:")
            self.o.windowtitle:SetLayer(3)
            self.o.windowtitle:SetPoint("CENTERLEFT",   self.o.titleicon, "CENTERRIGHT", mano.gui.borders.left*2, 0)

            -- btn_arrow_R_(normal).png
            -- Title Icon
            self.o.ppbutton   = UI.CreateFrame("Texture", "mano_input_pp_button", self.o.titleframe)
            self.o.ppbutton:SetTexture("Rift", "btn_arrow_R_(normal).png.dds")
--             self.o.ppbutton:SetTexture("Rift", "macro_icon_heal.dds")
            self.o.ppbutton:SetHeight(mano.gui.font.size)
            self.o.ppbutton:SetWidth(mano.gui.font.size)
            self.o.ppbutton:SetLayer(3)
            self.o.ppbutton:SetPoint("CENTERRIGHT", self.o.titleframe, "CENTERRIGHT", -mano.gui.borders.right*2, 0)
            self.o.ppbutton:EventAttach(  Event.UI.Input.Mouse.Left.Click,
                                          function()
                                             flippppanel()
                                          end,
                                          "MaNo input: Show/Hide PlayerPos Panel Button Pressed"
                                       )


         -- EXTERNAL CONTAINER FRAME
         self.o.externalframe =  UI.CreateFrame("Frame", "mano_input_external_frame", self.o.window)
         self.o.externalframe:SetPoint("TOPLEFT",     self.o.titleframe,   "BOTTOMLEFT",  mano.gui.borders.left,    0)
         self.o.externalframe:SetPoint("TOPRIGHT",    self.o.titleframe,   "BOTTOMRIGHT", - mano.gui.borders.right, 0)
         self.o.externalframe:SetPoint("BOTTOMLEFT",  self.o.window,       "BOTTOMLEFT",  mano.gui.borders.left,    - mano.gui.borders.bottom)
         self.o.externalframe:SetPoint("BOTTOMRIGHT", self.o.window,       "BOTTOMRIGHT", - mano.gui.borders.right, - mano.gui.borders.bottom)
         self.o.externalframe:SetBackgroundColor(unpack(mano.gui.color.black))
         self.o.externalframe:SetLayer(1)

         -- MASK FRAME
         self.o.maskframe = UI.CreateFrame("Mask", "mano_input_mask_frame", self.o.externalframe)
         self.o.maskframe:SetAllPoints(self.o.externalframe)

            -- CONTAINER FRAME
            self.o.frame =  UI.CreateFrame("Frame", "mano_input_notes_frame", self.o.maskframe)
            self.o.frame:SetAllPoints(self.o.maskframe)
            self.o.frame:SetLayer(1)


            -- Label's Label
            self.o.labellabel =  UI.CreateFrame("Text", "mano_input_label_label", self.o.frame)
            if mano.gui.font.name then
               self.o.labellabel:SetFont(mano.addon.name, mano.gui.font.name)
            end
            self.o.labellabel:SetFontSize(mano.gui.font.size)
            self.o.labellabel:SetText("Title")
            self.o.labellabel:SetLayer(3)
            self.o.labellabel:SetVisible(true)
            self.o.labellabel:SetPoint("TOPLEFT",    self.o.frame, "TOPLEFT",  mano.gui.borders.left,     mano.gui.borders.top)
            self.o.labellabel:SetPoint("TOPRIGHT",   self.o.frame, "TOPRIGHT", -mano.gui.borders.right,   mano.gui.borders.top)

            -- Label's input field
--             self.o.labeltext     =  UI.CreateFrame("RiftTextfield", "input_line_name_", self.o.frame)
            self.o.labeltext     =  UI.CreateFrame("SimpleTextArea", "input_line_name_", self.o.frame)
            if mano.gui.font.name then
               self.o.labeltext:SetFont(mano.addon.name, mano.gui.font.name)
            end
            self.o.labeltext:SetText("")
            self.o.labeltext:SetLayer(3)
            self.o.labeltext:SetVisible(true)
            self.o.labeltext:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
            self.o.labeltext:SetPoint("TOPLEFT",    self.o.labellabel, "BOTTOMLEFT",  mano.gui.borders.left,      0)
            self.o.labeltext:SetPoint("TOPRIGHT",   self.o.labellabel, "BOTTOMRIGHT", -mano.gui.borders.right,    0)

            -- Note's Label
            self.o.notelabel =  UI.CreateFrame("Text", "mano_input_label_label", self.o.frame)
            if mano.gui.font.name then
               self.o.notelabel:SetFont(mano.addon.name, mano.gui.font.name)
            end
            self.o.notelabel:SetFontSize(mano.gui.font.size)
            self.o.notelabel:SetText("Note")
            self.o.notelabel:SetLayer(3)
            self.o.notelabel:SetVisible(true)
            self.o.notelabel:SetPoint("TOPLEFT",    self.o.labeltext, "BOTTOMLEFT",    0, mano.gui.borders.top)
            self.o.notelabel:SetPoint("TOPRIGHT",   self.o.labeltext, "BOTTOMRIGHT",   0,   mano.gui.borders.top)

            -- Note's input field
--             self.o.notetext     =  UI.CreateFrame("RiftTextfield", "input_line_name_", self.o.frame)
            self.o.notetext     =  UI.CreateFrame("SimpleTextArea", "input_line_name_", self.o.frame)
--             self.o.notetext     =  UI.CreateFrame("Text", "input_line_name_", self.o.frame)
            if mano.gui.font.name then
               self.o.noteltext:SetFont(mano.addon.name, mano.gui.font.name)
            end
--             self.o.notetext:SetFontSize(mano.gui.font.size)
            self.o.notetext:SetText("")
--             self.o.notetext:SetWordwrap(true)
            self.o.notetext:SetLayer(3)
            self.o.notetext:SetHeight(mano.gui.font.size * 4)
            self.o.notetext:SetVisible(true)
            self.o.notetext:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
            self.o.notetext:SetPoint("TOPLEFT",    self.o.notelabel, "BOTTOMLEFT")
            self.o.notetext:SetPoint("TOPRIGHT",   self.o.notelabel, "BOTTOMRIGHT")


            -- CATICON & CATNAME
            local caticon, cattext  =  nil, nil
            if next(mano.categories) and mano.categories[mano.lastcategoryidx] ~= nil then
               cattext  = mano.categories[mano.lastcategoryidx].name
               caticon  = mano.categories[mano.lastcategoryidx].icon
            else
               cattext  = "Default"
               caticon  = mano.f.getcategoryicon(cattext)
            end

            -- Category Icon
            self.o.caticon = UI.CreateFrame("Texture", "input_cat_icon_", self.o.frame)
            self.o.caticon:SetTexture("Rift", caticon)
            self.o.caticon:SetHeight(mano.gui.font.size * 1.5)
            self.o.caticon:SetWidth(mano.gui.font.size  * 1.5)
            self.o.caticon:SetLayer(3)
            self.o.caticon:SetPoint("TOPLEFT",  self.o.notetext, "BOTTOMLEFT",   0, mano.gui.borders.top)

            -- Category field
            self.o.cattext     =  UI.CreateFrame("Text", "input_category_label", self.o.frame)
            if mano.gui.font.name then
               self.o.cattext:SetFont(mano.addon.name, mano.gui.font.name)
            end
            self.o.cattext:SetHeight(mano.gui.font.size * 1.5)
            self.o.cattext:SetText(cattext)
            self.o.cattext:SetLayer(3)
            self.o.cattext:SetVisible(true)
            self.o.cattext:SetPoint("TOPLEFT",  self.o.caticon, "TOPRIGHT",   mano.gui.borders.left, mano.gui.borders.top)

            -- Category Menu Button
            self.o.categorybutton = UI.CreateFrame("Texture", "mano_input_category_menu_button", self.o.frame)
            self.o.categorybutton:SetTexture("Rift", "splitbtn_arrow_D_(normal).png.dds")
            self.o.categorybutton:SetHeight(mano.gui.font.size)
            self.o.categorybutton:SetWidth(mano.gui.font.size)
            self.o.categorybutton:SetLayer(3)
            self.o.categorybutton:SetPoint("TOPLEFT",   self.o.cattext, "TOPRIGHT", mano.gui.borders.left,	0)
            self.o.categorybutton:EventAttach( Event.UI.Input.Mouse.Left.Click,   function() self.o.catmenu:flip() end, "MaNo: Category Button Pressed" )

            -- Category Create Menu
            self.o.catmenu     = {}
--             self.o.catmenu     = menu(self.o.categorybutton, self.catmenu)
            self.o.catmenu     = menu(self.o.cattext, self.catmenu)
            self.o.catmenu:hide()

            -- Category AddButton
            self.o.categoryaddbutton   =  UI.CreateFrame("Texture", "mano_input_category_add_button", self.o.frame)
            self.o.categoryaddbutton:SetTexture("Rift", "AbilityBinder_I15.dds")
            self.o.categoryaddbutton:SetHeight(mano.gui.font.size)
            self.o.categoryaddbutton:SetWidth(mano.gui.font.size)
            self.o.categoryaddbutton:SetLayer(3)
            self.o.categoryaddbutton:SetPoint("TOPLEFT",   self.o.categorybutton, "TOPRIGHT", mano.gui.borders.left,	0)
            self.o.categoryaddbutton:EventAttach( Event.UI.Input.Mouse.Left.Click,   function() print("Category ADD click!") end, "MaNo: Category Button Pressed" )

            -- Shared Button
            self.o.sharedbutton  =  UI.CreateFrame("RiftCheckbox", "mano_input_shared_button", self.o.frame)
            self.o.sharedbutton:SetHeight(mano.gui.font.size * 1.5)
            self.o.sharedbutton:SetWidth(mano.gui.font.size  * 1.5)
            self.o.sharedbutton:SetLayer(3)
      --       self.o.sharedbutton:SetPoint("TOPLEFT",   self.o.frame, "TOPRIGHT", 0,	-mano.gui.borders.bottom)
            self.o.sharedbutton:SetPoint("TOPRIGHT", self.o.notetext, "BOTTOMRIGHT", 0, mano.gui.borders.top)

            -- Shared Label
            self.o.sharedlabel   =  UI.CreateFrame("Text", "mano_input_label_label", self.o.frame)
            if mano.gui.font.name then self.o.sharedlabel:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.sharedlabel:SetFontSize(mano.gui.font.size)
            self.o.sharedlabel:SetText("Shared")
            self.o.sharedlabel:SetLayer(3)
            self.o.sharedlabel:SetVisible(true)
            self.o.sharedlabel:SetPoint("TOPRIGHT",   self.o.sharedbutton, "TOPLEFT",  -mano.gui.borders.right, 0)



         -- ----------------------------------------------------------------------
               --          playerpos   =  playerpos,
               --                         y              =  tbl.y or nil,
               --                         x              =  tbl.x,
               --                         z              =  tbl.z,
               --                         locationName   =  tbl.location or nil,
               --                         name           =  "forums",
               --                         radius         =  self.default.radius,
               --                         zoneid         =  tbl.zoneid or  self.extdbhandler.zonename2id[zonename],
               --                         zonename       =  zonename,
               --                         },
         -- ----------------------------------------------------------------------

            -- Cancel Button
            self.o.cancelbutton = UI.CreateFrame("Texture", "mano_input_cancel_button", self.o.frame)
            self.o.cancelbutton:SetTexture("Rift", "AlertTray_I54.dds")
            self.o.cancelbutton:SetHeight(mano.gui.font.size*2)
            self.o.cancelbutton:SetWidth(mano.gui.font.size*2)
            self.o.cancelbutton:SetLayer(3)
            self.o.cancelbutton:SetPoint("BOTTOMLEFT",   self.o.frame, "BOTTOMLEFT", mano.gui.borders.left,	-mano.gui.borders.bottom)
            self.o.cancelbutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function()
                                                                                 self.o.save =  false
                                                                                 self.o.window:SetVisible(false)
                                                                                 mano.events.canceltrigger( { save =  false } )
--                                                                                  detacheventwatchers()
                                                                              end, "MaNo input: Cancel Button Pressed"
                                             )

            -- btn_DeleteMail_(click).png
            -- Delete Button
            self.o.deletebutton = UI.CreateFrame("Texture", "mano_input_delete_button", self.o.frame)
--             self.o.deletebutton:SetTexture("Rift", "btn_DeleteMail_(click).png")
            self.o.deletebutton:SetTexture("Rift", "target_portrait_roguepoint.png.dds")
            self.o.deletebutton:SetHeight(mano.gui.font.size*2)
            self.o.deletebutton:SetWidth(mano.gui.font.size*2)
            self.o.deletebutton:SetLayer(3)
            self.o.deletebutton:SetPoint("BOTTOMCENTER",   self.o.frame, "BOTTOMCENTER", 0,	-mano.gui.borders.bottom)
            self.o.deletebutton:EventAttach( Event.UI.Input.Mouse.Left.Click, function()
                                                                                 self.o.save =  false
                                                                                 self.o.window:SetVisible(false)
                                                                                 mano.events.deletetrigger('delete', modifytbl)
--                                                                                  detacheventwatchers()
                                                                              end, "MaNo input: Delete Button Pressed"
                                             )




            -- Save Button
            self.o.savebutton = UI.CreateFrame("Texture", "mano_input_save_button", self.o.frame)
            self.o.savebutton:SetTexture("Rift", "AddonManager_I19.dds")
            self.o.savebutton:SetHeight(mano.gui.font.size*2)
            self.o.savebutton:SetWidth(mano.gui.font.size*2)
            self.o.savebutton:SetLayer(3)
            self.o.savebutton:SetPoint("BOTTOMRIGHT",   self.o.frame, "BOTTOMRIGHT", -mano.gui.borders.right,	-mano.gui.borders.bottom)
            self.o.savebutton:EventAttach(   Event.UI.Input.Mouse.Left.Click,
                                             function()
                                                self.o.save =  true
                                                self.o.window:SetVisible(false)

                                                if action   == 'modify' then

--                                                 local t  =  {  label    =  self.o.labeltext:GetText(),
--                                                                note     =  self.o.notetext:GetText(),
--                                                                category =  self.o.cattext:GetText(),
--                                                                icon     =  icon,
--                                                                save     =  self.o.save,
--                                                                shared   =  self.o.sharedbutton:GetChecked()
--                                                             }

                                                   local t     =  modifytbl
                                                   t.text      =  self.o.notetext:GetText()
                                                   t.label     =  self.o.labeltext:GetText()
                                                   t.category  =  self.o.cattext:GetText()
                                                   t.icon      =  self.o.caticon:GetTexture()
                                                   t.save      =  self.o.save

                                                   if modifytbl.customtbl ~= nil then
                                                      t.customtbl =  modifytbl.customtbl
                                                   else
                                                      t.customtbl =	{}
                                                   end
                                                   t.customtbl.shared   =  self.o.sharedbutton:GetChecked()

                                                   mano.events.savetrigger(action, t)
                                                else
                                                   mano.events.savetrigger(action, self:GetInput())
                                                end

                                             end,
                                             "MaNo input: Save Button Pressed"
                                          )


         --	DX FRAME -- BEGIN

         -- DX EXTERNAL CONTAINER FRAME
         self.o.externaldxframe =  UI.CreateFrame("Frame", "mano_input_external_frame", self.o.window)
         self.o.externaldxframe:SetWidth(self.o.externalframe:GetWidth())
         self.o.externaldxframe:SetBackgroundColor(unpack(mano.gui.color.black))
         self.o.externaldxframe:SetLayer(1)
         self.o.externaldxframe:SetPoint("TOPLEFT",     self.o.titleframe,   "BOTTOMRIGHT",  mano.gui.borders.left,    0)
--          self.o.externaldxframe:SetPoint("BOTTOMLEFT",  self.o.window,       "BOTTOMRIGHT",  mano.gui.borders.left,    - mano.gui.borders.bottom)
         self.o.externaldxframe:SetPoint("BOTTOMLEFT",  self.o.savebutton,    "TOPRIGHT",  mano.gui.borders.left,    0)

         -- DX MASK FRAME
         self.o.maskdxframe = UI.CreateFrame("Mask", "mano_input_dx_mask_frame", self.o.externaldxframe)
         self.o.maskdxframe:SetAllPoints(self.o.externaldxframe)
         self.o.maskdxframe:SetBackgroundColor(unpack(mano.gui.color.black))

            -- DX CONTAINER FRAME
            self.o.dxframe =  UI.CreateFrame("Frame", "mano_input_dx_notes_frame", self.o.maskdxframe)
            self.o.dxframe:SetBackgroundColor(unpack(mano.gui.color.black))
            self.o.dxframe:SetAllPoints(self.o.maskdxframe)
            self.o.dxframe:SetLayer(1)

--          playerpos   =  {,
--                         y              =  tbl.y or nil,
--                         x              =  tbl.x,
--                         z              =  tbl.z,
--                         locationName   =  tbl.location or nil,
--                         name           =  "forums",
--                         radius         =  self.default.radius,
--                         zoneid         =  tbl.zoneid or  self.extdbhandler.zonename2id[zonename],
--                         zonename       =  zonename,


            -- LABELS
            self.o.ppxlabel =  UI.CreateFrame("Text", "input_x_label", self.o.dxframe)
            if mano.gui.font.name then self.o.ppxlabel:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppxlabel:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppxlabel:SetText("X coordinate:")
            self.o.ppxlabel:SetLayer(3)
            self.o.ppxlabel:SetVisible(true)
            self.o.ppxlabel:SetWidth(mano.gui.font.size * 6)
            self.o.ppxlabel:SetPoint("TOPLEFT",  self.o.dxframe, "TOPLEFT",  mano.gui.borders.left*2, mano.gui.borders.top*5)

            self.o.ppzlabel =  UI.CreateFrame("Text", "input_z_label", self.o.dxframe)
            if mano.gui.font.name then self.o.ppzlabel:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppzlabel:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppzlabel:SetText("Z coordinate:")
            self.o.ppzlabel:SetLayer(3)
            self.o.ppzlabel:SetVisible(true)
            self.o.ppzlabel:SetWidth(mano.gui.font.size * 6)
            self.o.ppzlabel:SetPoint("TOPLEFT",  self.o.ppxlabel, "BOTTOMLEFT",  0, mano.gui.borders.top)

            self.o.ppylabel =  UI.CreateFrame("Text", "input_y_label", self.o.dxframe)
            if mano.gui.font.name then self.o.ppylabel:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppylabel:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppylabel:SetText("Y coordinate:")
            self.o.ppylabel:SetLayer(3)
            self.o.ppylabel:SetVisible(true)
            self.o.ppylabel:SetWidth(mano.gui.font.size * 6)
            self.o.ppylabel:SetPoint("TOPLEFT",  self.o.ppzlabel, "BOTTOMLEFT",  0,   mano.gui.borders.top)

            self.o.ppzonenamelabel =  UI.CreateFrame("Text", "input_zone_name_label", self.o.dxframe)
            if mano.gui.font.name then self.o.ppzonenamelabel:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppzonenamelabel:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppzonenamelabel:SetText("Zone Name:")
            self.o.ppzonenamelabel:SetLayer(3)
            self.o.ppzonenamelabel:SetVisible(true)
            self.o.ppzonenamelabel:SetWidth(mano.gui.font.size * 6)
            self.o.ppzonenamelabel:SetPoint("TOPLEFT",  self.o.ppylabel, "BOTTOMLEFT",  0,   mano.gui.borders.top)

            self.o.ppzoneidlabel =  UI.CreateFrame("Text", "input_zone_id_label", self.o.dxframe)
            if mano.gui.font.name then self.o.ppzoneidlabel:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppzoneidlabel:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppzoneidlabel:SetText("Zone Id:")
            self.o.ppzoneidlabel:SetLayer(3)
            self.o.ppzoneidlabel:SetVisible(true)
            self.o.ppzoneidlabel:SetWidth(mano.gui.font.size * 6)
            self.o.ppzoneidlabel:SetPoint("TOPLEFT",  self.o.ppzonenamelabel, "BOTTOMLEFT",  0,   mano.gui.borders.top)

            self.o.ppownerlabel =  UI.CreateFrame("Text", "input_owner_label", self.o.dxframe)
            if mano.gui.font.name then self.o.ppownerlabel:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppownerlabel:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppownerlabel:SetText("Note Owner:")
            self.o.ppownerlabel:SetLayer(3)
            self.o.ppownerlabel:SetVisible(true)
            self.o.ppownerlabel:SetWidth(mano.gui.font.size * 6)
            self.o.ppownerlabel:SetPoint("TOPLEFT",  self.o.ppzoneidlabel, "BOTTOMLEFT",  0,   mano.gui.borders.top)

            -- FIELDS
            self.o.ppxtext =  UI.CreateFrame("RiftTextfield", "input_x_text", self.o.dxframe)
            if mano.gui.font.name then self.o.ppxtext:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppxtext:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppxtext:SetText("")
            self.o.ppxtext:SetLayer(3)
            self.o.ppxtext:SetVisible(true)
--             self.o.ppxtext:SetWidth(mano.gui.font.size * 5)
            self.o.ppxtext:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
            self.o.ppxtext:SetPoint("TOPLEFT",  self.o.ppxlabel, "TOPRIGHT",  mano.gui.borders.left,  0)


            self.o.ppztext =  UI.CreateFrame("RiftTextfield", "input_z_text", self.o.dxframe)
            if mano.gui.font.name then self.o.ppztext:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppztext:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppztext:SetText("")
            self.o.ppztext:SetLayer(3)
            self.o.ppztext:SetVisible(true)
            self.o.ppztext:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
            self.o.ppztext:SetPoint("TOPLEFT",  self.o.ppzlabel, "TOPRIGHT",  mano.gui.borders.left,  0)


            self.o.ppytext =  UI.CreateFrame("RiftTextfield", "input_y_text", self.o.dxframe)
            if mano.gui.font.name then self.o.ppytext:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppytext:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppytext:SetText("")
            self.o.ppytext:SetLayer(3)
            self.o.ppytext:SetVisible(true)
            self.o.ppytext:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
            self.o.ppytext:SetPoint("TOPLEFT",  self.o.ppylabel, "TOPRIGHT",  mano.gui.borders.left,   0)


            self.o.ppzonenametext =  UI.CreateFrame("RiftTextfield", "input_zone_name_text", self.o.dxframe)
            if mano.gui.font.name then self.o.ppzonenametext:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppzonenametext:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppzonenametext:SetText("")
            self.o.ppzonenametext:SetLayer(3)
            self.o.ppzonenametext:SetVisible(true)
            self.o.ppzonenametext:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
            self.o.ppzonenametext:SetPoint("TOPLEFT",  self.o.ppzonenamelabel, "TOPRIGHT",  mano.gui.borders.left,   0)

            self.o.ppzoneidtext =  UI.CreateFrame("Text", "input_zone_id_text", self.o.dxframe)
            if mano.gui.font.name then self.o.ppzoneidtext:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppzoneidtext:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppzoneidtext:SetText("")
            self.o.ppzoneidtext:SetLayer(3)
            self.o.ppzoneidtext:SetVisible(true)
            self.o.ppzoneidtext:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
            self.o.ppzoneidtext:SetPoint("TOPLEFT",  self.o.ppzoneidlabel, "TOPRIGHT",  mano.gui.borders.left,   0)


            self.o.ppownertext =  UI.CreateFrame("RiftTextfield", "input_owner_text", self.o.dxframe)
            if mano.gui.font.name then self.o.ppownertext:SetFont(mano.addon.name, mano.gui.font.name)   end
            self.o.ppownertext:SetHeight(mano.gui.font.size * 1.5)
            self.o.ppownertext:SetText("")
            self.o.ppownertext:SetLayer(3)
            self.o.ppownertext:SetVisible(true)
            self.o.ppownertext:SetBackgroundColor(unpack(mano.gui.color.darkgrey))
            self.o.ppownertext:SetPoint("TOPLEFT",  self.o.ppownerlabel, "TOPRIGHT",  mano.gui.borders.left,   0)

            --	DX FRAME -- END


         self.initialized =   true
         Library.LibDraggable.draggify(self.o.window)

         self.o.lastlinecontainer   =  self.o.cattext
         local maxY  =  self.o.lastlinecontainer:GetBottom()
         maxY  =  maxY  +  self.o.cancelbutton:GetHeight() + mano.gui.borders.bottom
         local minY  =  self.o.frame:GetTop()

         self.o.frame:SetHeight(mano.f.round(maxY - maxY))
         self.o.dxframe:SetHeight(mano.f.round(maxY - maxY))
         self.o.window:SetHeight(self.o.titleframe:GetHeight() +  mano.f.round(maxY - minY))

         attacheventwatchers()

--          self.o.labeltext:SetKeyFocus(true)
         self.o.dxframe:SetVisible(false)
         self.o.externaldxframe:SetVisible(false)

      end

      if action   == 'new' then
         -- New Note but not first
         print("New Note but not first")

         self.o.labeltext:SetText("")
         self.o.notetext:SetText("")
         self.o.window:SetVisible(true)
         self.o.sharedbutton:SetChecked(false)

--          attacheventwatchers()
--          self.o.labeltext:SetKeyFocus(true)
         self.o.deletebutton:SetVisible(false)

         if modifytbl ~= nil and  next(modifytbl) and modifytbl.playerpos ~= nil and next(modifytbl.playerpos) ~= nil then
            self.o.ppxtext:SetText(tostring(modifytbl.playerpos.x))
            self.o.ppztext:SetText(tostring(modifytbl.playerpos.z))
            self.o.ppytext:SetText(tostring(modifytbl.playerpos.y))
            self.o.ppzonenametext:SetText(modifytbl.playerpos.zonename)
            self.o.ppzoneidtext:SetText(modifytbl.playerpos.zoneid)
            self.o.ppownertext:SetText(modifytbl.playerpos.name)
         end
      else
         print("MODIFY Note")
         -- modify
         local t  =  {  label =  "",   text  =  "", shared  =  false, category   =  "",   caticon  =  "" }

         if modifytbl.label      ~= nil   then  t.label  =  modifytbl.label   end
         if modifytbl.text       ~= nil   then  t.text   =  modifytbl.text    end
         if modifytbl.customtbl  ~= nil   and
            modifytbl.customtbl.shared ~= nil then  t.shared   =  modifytbl.customtbl.shared
         end
         if modifytbl.category	~= nil   then  t.category	=  modifytbl.category   end
         if modifytbl.icon			~= nil   then  t.icon		=  modifytbl.icon	      end

         self.o.labeltext:SetText(t.label)
         self.o.notetext:SetText(t.text)
         self.o.window:SetVisible(true)
         if t.category  ~= nil   then  self.o.cattext:SetText(t.category)		end
--          if t.caticon   ~= nil   then  self.o.caticon:SetTexture("Rift", mano.f.getcategoryicon(t.category))   end
         if t.caticon   ~= nil   then  self.o.caticon:SetTexture("Rift", t.caticon)   end
         self.o.sharedbutton:SetChecked(t.shared)

         if modifytbl.playerpos ~= nil and next(modifytbl.playerpos) ~= nil then
            self.o.ppxtext:SetText(tostring(modifytbl.playerpos.x))
            self.o.ppztext:SetText(tostring(modifytbl.playerpos.z))
            self.o.ppytext:SetText(tostring(modifytbl.playerpos.y))
            self.o.ppzonenametext:SetText(modifytbl.playerpos.zonename)
            self.o.ppzoneidtext:SetText(modifytbl.playerpos.zoneid)
            self.o.ppownertext:SetText(modifytbl.playerpos.name)
         end

--          attacheventwatchers()
--          self.o.labeltext:SetKeyFocus(true)
         self.o.deletebutton:SetVisible(true)
      end

--       end

   end

   return self

end
