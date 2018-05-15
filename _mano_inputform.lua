--
-- Addon       _mano_input_form.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
local addon, mano = ...

function noteinputform()
   -- the new instance
   local self =   {
                  -- public fields go in the instance table
                  inputwin =  {},
                  vspacer  =  5,
                  hspacer  =  3,
                  }

   local function create(playerposition)

--       for k, b in pairs(playerposition) do
--          print(string.format("playerposition: k[%s] v[%s]", k, v))
--       end

      local inputwin =  {}

      local context = UI.CreateContext("inputwin_Context")
      inputwin = UI.CreateFrame("SimpleWindow", "inputwin", context)
      inputwin:SetCloseButtonVisible(true)
      inputwin:SetTitle("Add a Map Note Here")
--       inputwin:SetHeight(350)
      inputwin:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 100)
      --
--       inputwin.listScrollView = UI.CreateFrame("SimpleScrollView", "inputwin_TestScrollView", inputwin:GetContent())
--       inputwin.listScrollView:SetPoint("TOPLEFT", inputwin:GetContent(), "TOPLEFT")
--       inputwin.listScrollView:SetWidth(150)
--       inputwin.listScrollView:SetHeight(300)
--       inputwin.listScrollView:SetBorder(1, 1, 1, 1, 1)
--       inputwin.list = UI.CreateFrame("SimpleList", "inputwin_TestList", inputwin.listScrollView)
--       inputwin.list.Event.ItemSelect = function(view, item) print("ItemSelect("..item..")") end
--       local items = {}
--       for i=1,100 do
--       table.insert(items, "Item "..i)
--       end
--       inputwin.list:SetItems(items)
--       inputwin.listScrollView:SetContent(inputwin.list)
--       --
--          t.coordX         = playerdata.coordX
--          t.coordY         = playerdata.coordY
--          t.coordZ         = playerdata.coordZ
--          t.zone           = playerdata.zone
--          t.locationName   = playerdata.locationName
--          t.radius         = playerdata.radius
--          t.name           = playerdata.name
      --
      inputwin.playernamelabel = UI.CreateFrame("Text", inputwin:GetName() .. "_playername_label", inputwin:GetContent())
      inputwin.playernamelabel:SetText("Player  :")
      inputwin.playernamelabel:SetPoint("TOPLEFT",  inputwin:GetContent(), "TOPLEFT")
      --
      inputwin.playernametext = UI.CreateFrame("Text", inputwin:GetName() .. "_playername_text", inputwin:GetContent())
      print(string.format("playerposition.playername=[%s]", playerposition.playername))
      inputwin.playernametext:SetText(playerposition.name)
      inputwin.playernametext:SetPoint("TOPLEFT",  inputwin.playernamelabel, "TOPRIGHT")

      --
      inputwin.zonelabel = UI.CreateFrame("Text", inputwin:GetName() .. "_zone_label", inputwin:GetContent())
      inputwin.zonelabel:SetText("Zone    :")
      inputwin.zonelabel:SetPoint("TOPLEFT",  inputwin.playernamelabel, "BOTTOMLEFT")
      --
      inputwin.zonetext = UI.CreateFrame("Text", inputwin:GetName() .. "_zone_text", inputwin:GetContent())
      local zn
      if playerposition.zonename then
         zn = playerposition.zonename
         if playerposition.zonetype then
            zn = zn.." ("..playerposition.zonetype..")"
         end
      else
         zn =  playerposition.zone
      end
      inputwin.zonetext:SetText(playerposition.zonename or playerposition.zone)
      inputwin.zonetext:SetPoint("TOPLEFT",  inputwin.zonelabel, "TOPRIGHT")
      --
      --
      inputwin.textarea = UI.CreateFrame("SimpleTextArea", "inputwin_textarea", inputwin:GetContent())
      inputwin.textarea:SetPoint("TOPLEFT",  inputwin.zonelabel,  "BOTTOMLEFT",  self.hspacer, self.vspacer)
      inputwin.textarea:SetPoint("RIGHT",    inputwin:GetContent(),   "RIGHT")
      inputwin.textarea:SetHeight(100)
--       inputwin.textarea:SetPoint("BOTTOMRIGHT", inputwin:GetContent(), "BOTTOMRIGHT")
      inputwin.textarea:SetBorder(1, 1, 1, 1, 1)

      return inputwin
   end

   function self.show(playerposition)

      if playerposition and next(playerposition) then

         if not self.inputwin or not next(self.inputwin) then self.inputwin  =  create(playerposition) end

         self.inputwin:SetVisible(true)
      else
         print("inpuwin.create(): playerposition is nil")
      end

      return
   end

   function self.hide()

      if next(self.inputwin) then  self.inputwin:SetVisible(false) end

      return
   end

   -- return the class instance
   return   self

end

--[[
         -- ZONE NAME CONTAINER Header
         local lbl1  =  UI.CreateFrame("Text", infoWindow:GetName() .. "_zone_label", headerFrame)
         local objColor  =  cD.rarityColor("common")
         lbl1:SetText("Zone    :")
         lbl1:SetFont(cD.addon, cD.text.base_font_name)
         lbl1:SetFontSize(cD.text.base_font_size)
         lbl1:SetLayer(1)
         lbl1:SetPoint("TOPLEFT",  headerFrame, "TOPLEFT")

            -- ZONE NAME Header [idx=1]
            local lineOBJ_2 =  UI.CreateFrame("Text", infoWindow:GetName() .. "_zone", headerFrame)
            local objColor  =  cD.rarityColor("quest")
            lineOBJ_2:SetText(zone)
            lineOBJ_2:SetFont(cD.addon, cD.text.base_font_name)
            lineOBJ_2:SetFontSize(cD.text.base_font_size)
            lineOBJ_2:SetLayer(1)
            lineOBJ_2:SetFontColor(objColor.r, objColor.g, objColor.b)
            lineOBJ_2:SetPoint("TOPLEFT", lbl1, "TOPRIGHT", cD.borders.left, 0)
            table.insert(cD.sLThdrs, lineOBJ_2 )

    ]]
