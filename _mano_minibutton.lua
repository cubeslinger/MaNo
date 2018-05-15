--
-- Addon       _mano_minibutton.lua
-- Author      marcob@marcob.org
-- StartDate   15/05/2017
--

local addon, mano = ...

function mano.createminimapbutton()

   -- avoid creating multiple minimap buttons...
   if not mano.gui.mmbtnobj then
      --       print(string.format("mano.createMiniMapButton: mano.gui.mmbtnobj=%s", mano.gui.mmbtnobj))

      --Global context (parent frame-thing).
      mmbtncontext = UI.CreateContext("button_context")

      -- MiniMapButton Border
      mmbuttonborder = UI.CreateFrame("Texture", "mmBtnIconBorder", mmbtncontext)
      mmbuttonborder:SetTexture("Rift", "sml_icon_border_(over)_yellow.png.dds")
      mmbuttonborder:SetHeight(mano.gui.mmbtnheight)
      mmbuttonborder:SetWidth(mano.gui.mmbtnwidth)
      mmbuttonborder:SetLayer(1)
--       mmbuttonborder:EventAttach(Event.UI.Input.Mouse.Left.Click, function() mano.showhidewindow() end, "Show/Hide Pressed" )

      mmbuttonborder:EventAttach(Event.UI.Input.Mouse.Left.Click, function()
                                                                     local playerposition = mano.mapnote.getplayerposition()
                                                                     mano.noteinputform.show(playerposition)
                                                                     mano.mapnote.new(playerposition)
                                                                  end,
                                                                  "Show/Hide Pressed" )

      if mano.gui.mmbtnx == nil or mano.gui.mmbtny == nil then
         -- first run, we position in the screen center
         mmbuttonborder:SetPoint("CENTER", UIParent, "CENTER")
      else
         -- we have coordinates
         mmbuttonborder:SetPoint("TOPLEFT", UIParent, "TOPLEFT", mano.gui.mmbtnx, mano.gui.mmbtny)
      end

      -- MiniMapButton Icon
      mmbutton = UI.CreateFrame("Texture", "mmBtnIcon", mmbuttonborder)
--       mmbutton:SetTexture("Rift", "loot_gold_coins.dds")
      mmbutton:SetTexture("Rift", "AATree_16D.dds")
      mmbutton:SetLayer(1)
      mmbutton:SetPoint("TOPLEFT",     mmbuttonborder, "TOPLEFT",      12, 12)
      mmbutton:SetPoint("BOTTOMRIGHT", mmbuttonborder, "BOTTOMRIGHT", -12, -12)

      -- Enable Dragging
      Library.LibDraggable.draggify(mmbuttonborder, mano.updateguicoordinates)

      mano.gui.mmbtnobj   =  mmbuttonborder
   else
      mmbutton = mano.gui.mmbtnobj
   end

   return mmbutton
end
