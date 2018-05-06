--
-- Addon       MaNo.lua
-- Author      marcob@marcob.org
-- StartDate   05/05/2018
--
local addon, mano = ...

mano.mapnote  =  mapnotes()

--
-- function mano.gotevent(handle, params)
--    if params then
--       for var, val in pairs(params) do
-- 
--          if mano.base[var] ~= val then
--             --  Command.Console.Display("general", true, string.format("***[%20s]=[%s]=>[%s] delta[%s]", var, mano.base[var], val, val - mano.base[var]), true)
--             Command.Console.Display("general", true, string.format("MaNo: k[%s] [%s]", var, val - mano.base[var]), true)
--             
--             mano.base[var] =   val
--          end
--       end
--    end
--    return
-- end

local function parseslashcommands(params)
   
   print(string.format( "got mano [%s]", params))
   
   for i in string.gmatch(params, "%S+") do
      
      print(string.format( "i [%s]", i))
      
      if i  == "add"         then mano.mapnote.new()  end
   end
   
   return   
end




table.insert(Command.Slash.Register("mano"), {function (...) parseslashcommands(...) end, mano.addon, "MaNo: add note here"})
