--
-- Addon       _mano_init.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
local addon, mano = ...

--
-- local function userinputsave(handle, params)
--
--    print(string.format("userinputsave: handle=(%s) params=(%s)", handle, params))
-- --    print("params: ", mano.f.dumptable(params))
--
--    local userinput   =  mano.mapnoteinput:GetInput()
--
--    if userinput ~= nil and next(userinput) then
--
--       if userinput.save ~= nil and userinput.save == true then
--
--          -- add note to User's DB
--          local noterecord     =  mano.mapnote.new( {  label       =  userinput.label,
--                                                       text        =  userinput.note,
--                                                       category    =  userinput.category,
--                                                       playerpos   =  nil,
--                                                       idx         =  nil,
--                                                       timestamp   =  nil,
--                                                    }
--                                                 )
--
-- --          local	t        =  {  text        = noterecord.text,
-- --                               category    = noterecord.category,
-- --                               timestamp   = noterecord.timestamp,
-- --                               playerpos   = {   x        =  noterecord.playerpos.x,
-- --                                                 y        =  noterecord.playerpos.y,
-- --                                                 z        =  noterecord.playerpos.z,
-- --                                                 zonename =  noterecord.playerpos.zonename,
-- --                                              },
-- --                               zoneid      =   noterecord.playerpos.zoneid,
-- --                               zonename    =   noterecord.playerpos.zonename,
-- --                               zonetype    =   noterecord.playerpos.zonetype,
-- --          }
--
--          -- Show new Note in Index
--
-- --          local newframe       =  mano.gui.shown.window.addline(t)
-- --          local newframe       =  mano.gui.shown.window.addline(t)
--          mano.gui.shown.window.loadlistbyzoneid(noterecord.playerpos.zoneid)
--       end
--    end
--
--    return
--
-- end

-- local function userinputsave(handle, params)
--
--    print(string.format("userinputsave: handle=(%s) params=(%s)", handle, params))
--    --    print("params: ", mano.f.dumptable(params))
--
--    local userinput   =  mano.mapnoteinput:GetInput()
--
--    if userinput ~= nil and next(userinput) then
--
--       if userinput.save ~= nil and userinput.save == true then
--
--          -- add note to User's DB
--          local noterecord     =  mano.mapnote.new( {  label       =  userinput.label,
--             text        =  userinput.note,
--             category    =  userinput.category,
--             playerpos   =  nil,
--             idx         =  nil,
--             timestamp   =  nil,
--          }
--       )
--
--       --          local	t        =  {  text        = noterecord.text,
--                                        --                               category    = noterecord.category,
--                                        --                               timestamp   = noterecord.timestamp,
--                                        --                               playerpos   = {   x        =  noterecord.playerpos.x,
--                                                                                           --                                                 y        =  noterecord.playerpos.y,
--                                                                                           --                                                 z        =  noterecord.playerpos.z,
--                                                                                           --                                                 zonename =  noterecord.playerpos.zonename,
--                                                                                           --                                              },
--                                        --                               zoneid      =   noterecord.playerpos.zoneid,
--                                        --                               zonename    =   noterecord.playerpos.zonename,
--                                        --                               zonetype    =   noterecord.playerpos.zonetype,
--                                        --          }
--
--       -- Show new Note in Index
--
--       --          local newframe       =  mano.gui.shown.window.addline(t)
--       --          local newframe       =  mano.gui.shown.window.addline(t)
--       mano.gui.shown.window.loadlistbyzoneid(noterecord.playerpos.zoneid)
--    end
-- end
--
-- return
--
-- end

local function userinputsave(handle, params)
   
   print("*** SAVE EVENT *** HANDLE ***\n:", mano.f.dumptable(handle))

--    print(string.format("userinputsave: handle=(%s) params=(%s)", handle, params))
--       print("params: \n", mano.f.dumptable(params))

--    local userinput   =  mano.mapnoteinput:GetInput()
   
   local userinput   =  params

   if userinput ~= nil and next(userinput) then

      if userinput.save ~= nil and userinput.save == true then

         local noterecord           =  {}
         local t  =  {  label       =  userinput.label,
                        text        =  userinput.note,
                        category    =  userinput.category,
                        playerpos   =  nil,
                        idx         =  nil,
                        timestamp   =  nil,
                        shared      =  userinput.shared,
                     }


--          print(string.format("Shared Note: (%s)", userinput.shared))
         
         if userinput.shared == true   then  noterecord     =  mano.sharednote.new(t)  -- add note to Shared Notes Db
                                       else  noterecord     =  mano.mapnote.new(t)     -- add note to User Notes Db
         end   

      mano.gui.shown.window.loadlistbyzoneid(noterecord.playerpos.zoneid)
   end
end

return

end




local function userinputcancel()

   return {}
end

local function parseslashcommands(params)
--    print(string.format("params: -- begin => params(%s)", params))
--    print("params: ", mano.f.dumptable(params))
--    print("params: -- end")


   for i in string.gmatch(params, "%S+") do

      if i  == "add"         then
         print("pre mano.mapnote.new")
         -- ...
         if mano.mapnoteinput.initialized then
            local isonscreen  =  mano.mapnoteinput.o.window:GetVisible()
         else
            local isonscreen  =  false
         end
         
         if not isonscreen then
            mano.mapnoteinput:show('new')
            print("post mano.mapnote.new")
         else
            print("Input Form already on Screen")
         end
      end
   end

   return
end


-- local print nested tables
local function dumptable(o)
   if type(o) == 'table' then
      local s = '{ '
         for k,v in pairs(o) do
            if type(k) ~= 'number' then
               k = '"'..k..'"'
            end
            s =   s ..'['..k..'] = ' ..(dumptable(v) or "nil table").. ',\n'
         end
         return s .. '} '
   else
      return tostring(o)
   end
end

-- only print if debug is on
local function dprint(...) if mano.flags.debug == true then print(...) end end

-- function mano.f.round(num, digits)
function round(num, digits)
   local floor = math.floor
   local mult = 10^(digits or 0)

   return floor(num * mult + .5) / mult
end


local function updateguicoordinates(win, newx, newy)

   if win ~= nil then
      local winName = win:GetName()

      if winName == "mmBtnIconBorder" then
         mano.gui.mmbtn.x  =  round(newx)
         mano.gui.mmbtn.y  =  round(newy)
      end

      if winName == "MaNo" then
         mano.gui.win.x  =  round(newx)
         mano.gui.win.y  =  round(newy)
      end
   end

   return
end

local function setwaypoint(x, z, zonename)

--    mano.f.dprint(string.format("setwaypoint: zone=%s @ (%s, %s)", zonename, x, z))

   if x and z then
      local retval = Command.Map.Waypoint.Set(x, z)
--       mano.f.dprint(string.format("Command.Map.Waypoint.Set(%s, %s) result=%s", x, z, retval))
   end

   local X, Z = Inspect.Map.Waypoint.Get("player")

   mano.f.dprint(string.format("Way Point added in: %s, at %s, %s", zonename, X, Z))

   return X, Z
end


--
--
-- DBs
--
mano.db                    =  {}
mano.db.notes              =  {}
--
-- Initialization flags
--
mano.init                  =  {}
mano.init.startup          =  false
--
mano.flags                 =  {}
mano.flags.trackartifacts  =  false
mano.flags.debug           =  true
--
--
-- GUI
--
mano.gui                   =  {}
--
-- Waypoints Window
--
mano.gui.win               =  {}
mano.gui.win.x             =  0
mano.gui.win.y             =  0
mano.gui.win.width         =  280
--
-- Minimap Button
--
mano.gui.mmbtn	            =  {}
mano.gui.mmbtn.height      =  38
mano.gui.mmbtn.width       =  38
mano.gui.mmbtn.x           =  0
mano.gui.mmbtn.y           =  0
mano.gui.mmbtn.obj         =  nil
--
-- Borders for all windows
--
mano.gui.borders           =  {}
mano.gui.borders.left      =  2
mano.gui.borders.right     =  2
mano.gui.borders.bottom    =  2
mano.gui.borders.top       =  2
--
-- Colors table (Rift format)
--
mano.gui.color             =  {}
mano.gui.color.black       =  {  0,  0,  0, .5}
mano.gui.color.deepblack   =  {  0,  0,  0,  1}
mano.gui.color.red         =  { .2,  0,  0, .5}
mano.gui.color.green       =  {  0,  1,  0, .5}
mano.gui.color.blue        =  {  0,  0,  6, .1}
mano.gui.color.lightblue   =  {  0,  0, .4, .1}
mano.gui.color.darkblue    =  {  0,  0, .2, .1}
mano.gui.color.grey        =  { .5, .5, .5, .5}
mano.gui.color.darkgrey    =  { .2, .2, .2, .5}
mano.gui.color.yellow      =  {  1,  1,  0, .5}
mano.gui.color.white       =  {  9,  9,  9, .5}
--
-- Colors table (HTML format)
--
mano.html                  =  {}
mano.html.yellow           =  '#555500'
mano.html.silver           =  '#c0c0c0'
mano.html.gold             =  '#ffd700'
mano.html.platinum         =  '#e5e4e2'
mano.html.white            =  '#ffffff'
mano.html.red              =  '#ff0000'
mano.html.green            =  '#00ff00'
mano.html.title	         =  "<font color=\'" .. mano.html.green .. "\'>MaNo</font>"
--
-- Fonts
--
mano.gui.font              =  {}
mano.gui.font.size         =  14
mano.gui.font.name         =  nil
--
mano.gui.shown             =  {}
--
--
-- "f" = Function handles
--
mano.f                     =  {}
mano.f.round               =  round
mano.f.updateguicoordinates=  updateguicoordinates
mano.f.dprint              =  dprint
mano.f.setwaypoint         =  setwaypoint
mano.f.dumptable           =  dumptable
mano.f.userinputcancel     =  userinputcancel
mano.f.userinputsave       =  userinputsave
--
-- mano.foo                         =  {}
-- mano.foo["round"]                =  function(args) return(round(args))                 end
-- mano.foo["updateguicoordinates"] =  function(args) return(updateguicoordinates(args))  end
-- mano.foo["dprint"]               =  function(args) return(dprint(args))                end
-- mano.foo["setwaypoint"]          =  function(args) return(setwaypoint(args))           end
-- mano.foo["parseslashcommands"]   =  function(args) return(parseslashcommands(args))    end
--
mano.foo                   =  {
                              round                 =  round,
                              updateguicoordinates  =  updateguicoordinates,
                              dprint                =  dprint,
                              setwaypoint           =  setwaypoint,
                              parseslashcommands    =  parseslashcommands,
                              dumptable             =  dumptable,
                              }

-- print("mano.foo: ", dumptable(mano.foo))
--
-- Events
--
mano.events                =  {}
mano.events.canceltrigger,    mano.events.cancelevent    =  Utility.Event.Create(addon.identifier, "userinput.cancel")
mano.events.savetrigger,      mano.events.saveevent      =  Utility.Event.Create(addon.identifier, "userinput.save")
-- mano.events.catmenutrigger,   mano.events.catmenuchoice  =  Utility.Event.Create(addon.identifier, "catmenu.choice")
--
-- Player's Cached Info
--
mano.player                =  {}
--
-- Default Categories
--
-- mano.categories            =  {  [1]   =  {  name="Default",           icon="macro_icon_clover.dds" },
--                                  [2]   =  {  name="Artifacts",         icon="macro_icon_smile.dds" },
--                                  [3]   =  {  name="Crafting Material", icon="outfitter1.dds" },
--                                  [4]   =  {  name="Villain",           icon="target_portrait_roguepoint.png.dds" },
--                               }
mano.categories            =  {}
mano.lastcategoryidx       =  0
mano.sharedcategories      =  {}
mano.lastsharedcategoryidx =  0
--
-- Bases
--
mano.base                  =  {}
mano.base.usercategories   =  {  [1]   =  {  name="Default",           icon="macro_icon_clover.dds" },
                                 [2]   =  {  name="Artifacts",         icon="macro_icon_smile.dds" },
                                 [3]   =  {  name="Crafting Material", icon="outfitter1.dds" },
                                 [4]   =  {  name="Villain",           icon="target_portrait_roguepoint.png.dds" },
                              }
mano.base.sharedcategories =  mano.base.usercategories
--
-- end declarations
--

-- "macro_icon_crown.dds"
-- "macro_icon_arrow.dds"
-- "macro_icon_no.dds"
-- "macro_icon_radioactive.dds"
-- "macro_icon_sad.dds"
-- "macro_icon_skull.dds"
-- "macro_icon_smile.dds"
-- "macro_icon_squirell.dds"
-- "macro_icon_support.dds"
-- "macro_icon_tank.dds"
