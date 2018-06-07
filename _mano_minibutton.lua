--
-- Addon       _mano_minibutton.lua
-- Author      marcob@marcob.org
-- StartDate   15/05/2017
--

local addon, mano = ...

function mano.createminimapbutton()

   local btn = {}

   --Global context (parent frame-thing).
   btn.context = UI.CreateContext("button_context")

   -- MiniMapButton Border
   btn.border = UI.CreateFrame("Texture", "mmBtnIconBorder", btn.context)
   btn.border:SetTexture("Rift", "sml_icon_border_(over)_yellow.png.dds")
   btn.border:SetHeight(mano.gui.mmbtn.height)
   btn.border:SetWidth(mano.gui.mmbtn.width)
   btn.border:SetLayer(1)
   btn.border:EventAttach(Event.UI.Input.Mouse.Left.Click,     function()
--                                                                   local playerposition = mano.mapnote.getplayerposition()
--                                                                   mano.noteinputform.show(playerposition)
--                                                                   mano.mapnote.new(playerposition)
                                                                     mano.gui.shown.window:flip()
                                                                  return
                                                               end,
                                                               "Show/Hide Left Click" )

   btn.border:EventAttach(Event.UI.Input.Mouse.Middle.Click,   function()
                                                                  mano.flags.trackartifacts = not mano.flags.trackartifacts
                                                                  print("Middle Click")
                                                                  return
                                                               end,
                                                               "Show/Hide Middle Click" )

   if mano.gui.mmbtn.x == nil or mano.gui.mmbtn.y == nil then
      -- first run, we position in the screen center
      btn.border:SetPoint("CENTER", UIParent, "CENTER")
   else
      -- we have coordinates
      btn.border:SetPoint("TOPLEFT", UIParent, "TOPLEFT", mano.gui.mmbtn.x, mano.gui.mmbtn.y)
   end

   -- MiniMapButton Icon
   btn.button = UI.CreateFrame("Texture", "mmBtnIcon", btn.border)
   btn.button:SetTexture("Rift", "AATree_16D.dds")
   btn.button:SetLayer(1)
   btn.button:SetPoint("TOPLEFT",     btn.border, "TOPLEFT",      12, 12)
   btn.button:SetPoint("BOTTOMRIGHT", btn.border, "BOTTOMRIGHT", -12, -12)

   -- Enable Dragging
   Library.LibDraggable.draggify(btn.border, mano.f.updateguicoordinates)

   return btn
end
