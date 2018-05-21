--
-- Addon       _mano_minibutton.lua
-- Author      marcob@marcob.org
-- StartDate   15/05/2017
--

local addon, mano = ...

function mano.round(num, digits)
   local floor = math.floor
   local mult = 10^(digits or 0)

   return floor(num * mult + .5) / mult
end


function mano.updateguicoordinates(win, newx, newy)

   if win ~= nil then
      local winName = win:GetName()

      if winName == "mmBtnIconBorder" then
         mano.gui.mmbtnx =  mano.round(newx)
         mano.gui.mmbtny =  mano.round(newy)
      end
   end

   return
end

function mano.createminimapbutton()

   local btn = {}
   
   --Global context (parent frame-thing).
   btn.context = UI.CreateContext("button_context")

   -- MiniMapButton Border
   btn.border = UI.CreateFrame("Texture", "mmBtnIconBorder", btn.context)
   btn.border:SetTexture("Rift", "sml_icon_border_(over)_yellow.png.dds")
   btn.border:SetHeight(mano.gui.mmbtnheight)
   btn.border:SetWidth(mano.gui.mmbtnwidth)
   btn.border:SetLayer(1)
   btn.border:EventAttach(Event.UI.Input.Mouse.Left.Click,     function()
                                                                  local playerposition = mano.mapnote.getplayerposition()
                                                                  mano.noteinputform.show(playerposition)
                                                                  mano.mapnote.new(playerposition)
                                                                  return
                                                               end,
                                                               "Show/Hide Left Click" )
                                                               
   btn.border:EventAttach(Event.UI.Input.Mouse.Middle.Click,   function()                                                                   
                                                                  mano.flags.trackartifacts = not mano.flags.trackartifacts
                                                                  print("Middle Click")
                                                                  return 
                                                               end,
                                                               "Show/Hide Middle Click" )
                                                               
   if mano.gui.mmbtnx == nil or mano.gui.mmbtny == nil then
      -- first run, we position in the screen center
      btn.border:SetPoint("CENTER", UIParent, "CENTER")
   else
      -- we have coordinates
      btn.border:SetPoint("TOPLEFT", UIParent, "TOPLEFT", mano.gui.mmbtnx, mano.gui.mmbtny)
   end

   -- MiniMapButton Icon
   btn.button = UI.CreateFrame("Texture", "mmBtnIcon", btn.border)
   btn.button:SetTexture("Rift", "AATree_16D.dds")
   btn.button:SetLayer(1)
   btn.button:SetPoint("TOPLEFT",     btn.border, "TOPLEFT",      12, 12)
   btn.button:SetPoint("BOTTOMRIGHT", btn.border, "BOTTOMRIGHT", -12, -12)

   -- Enable Dragging
   Library.LibDraggable.draggify(btn.border, mano.updateguicoordinates)

   return btn
end
