--
-- Addon       _mano_input_form.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
local addon, mano = ...

--[[
    local context = UI.CreateContext("SWT_Context")
    SWT_Window = UI.CreateFrame("SimpleWindow", "SWT_Window", context)
    SWT_Window:SetCloseButtonVisible(true)
    SWT_Window:SetTitle("List Test")
    SWT_Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 100)
    SWT_Window.listScrollView = UI.CreateFrame("SimpleScrollView", "SWT_TestScrollView", SWT_Window:GetContent())
    SWT_Window.listScrollView:SetPoint("TOPLEFT", SWT_Window:GetContent(), "TOPLEFT")
    SWT_Window.listScrollView:SetWidth(150)
    SWT_Window.listScrollView:SetHeight(300)
    SWT_Window.listScrollView:SetBorder(1, 1, 1, 1, 1)
    SWT_Window.list = UI.CreateFrame("SimpleList", "SWT_TestList", SWT_Window.listScrollView)
    SWT_Window.list.Event.ItemSelect = function(view, item) print("ItemSelect("..item..")") end
    local items = {}
    for i=1,100 do
      table.insert(items, "Item "..i)
    end
    SWT_Window.list:SetItems(items)
    SWT_Window.listScrollView:SetContent(SWT_Window.list)
]]--

function noteinputform()
   -- the new instance
   local self =   {
                  -- public fields go in the instance table      
                  inputwin =  {},
                  }

   local function create()
      
      local inputwin =  {}
      
      local context = UI.CreateContext("inputwin_Context")
      inputwin = UI.CreateFrame("SimpleWindow", "inputwin", context)
      inputwin:SetCloseButtonVisible(true)
      inputwin:SetTitle("List Test")
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
      --
      inputwin.textarea = UI.CreateFrame("SimpleTextArea", "inputwin_textarea", inputwin:GetContent())
      inputwin.textarea:SetPoint("TOPLEFT",     inputwin:GetContent(), "TOPLEFT")
      inputwin.textarea:SetPoint("BOTTOMRIGHT", inputwin:GetContent(), "BOTTOMRIGHT")
      inputwin.textarea:SetBorder(1, 1, 1, 1, 1)
            
      
      
      return inputwin
   end
   
   function self.show()      
      
      if not self.inputwin or not next(self.inputwin) then self.inputwin  =  create() end

      self.inputwin:SetVisible(true)
      
      return
   end
   
   function self.hide()
      
      if next(self.inputwin) then  self.inputwin:SetVisible(false) end
      
      return
   end   

   -- return the class instance
   return   self

end
   
