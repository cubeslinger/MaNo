--
-- Addon       _mano_init.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
local addon, mano = ...

-- only pirnt if debug is on
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

   mano.f.dprint(string.format("setwaypoint: zone=%s @ (%s, %s)", zonename, x, z))

   if x and z then
      local retval = Command.Map.Waypoint.Set(x, z)
      mano.f.dprint(string.format("Command.Map.Waypoint.Set(%s, %s) result=%s", x, z, retval))
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
mano.gui.font.size         =  12
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
--
-- mano.foo                         =  {}
-- mano.foo['round']                =  function(args) return(round(args))                    end
-- mano.foo['updateguicoordinates'] =  function(args) return(updateguicoordinates(args))     end
-- mano.foo['dprint']               =  function(args) return(dprint(args))                   end
-- mano.foo['setwaypoint']          =  function(args) return(setwaypoint(args))              end
-- mano.foo['parseslashcommands']   =  function(args) return(mano.parseslashcommands(args))  end
--
--
-- end declarations
--
