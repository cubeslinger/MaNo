--
-- Addon       _mano_init.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
local addon, mano = ...

local function getzoneinfos()

   local player, zonetext, locationtext, zoneid, playerid =  nil, nil, nil, nil, nil

   player         =  Inspect.Unit.Detail("player")

	if	player.zone	then

		zoneid      	=  player.zone
		locationtext  	=  player.locationName
		zonedata			=  Inspect.Zone.Detail(zoneid)
		playerid			=	player.id

		if zonedata ~= nil and next(zonedata) ~= nil  then
			zonetext    =  zonedata.name
		else
			print(string.format("getzoneinfos: ERROR, zonedata =(%s)", zonedata))
		end
	end

-- 	print(string.format("player=(%s)\nzonetext=(%s)\nlocationtext=(%s)\nzoneid=(%s)\nplayerid=(%s)\n", player, zonetext, locationtext, zoneid, playerid))

   return zonetext, locationtext, zoneid, playerid
end


local function splitquotedstringbyspace(text)

   local retval   =  {}

--    local text = [[I "am" 'the text' and "some more text with '" and "escaped \" text"]]
   local spat, epat, buf, quoted = [=[^(['"])]=], [=[(['"])$]=]

   for str in text:gmatch("%S+") do

      local squoted = str:match(spat)
      local equoted = str:match(epat)
      local escaped = str:match([=[(\*)['"]$]=])

      if squoted and not quoted and not equoted then
         buf, quoted = str, squoted
      elseif buf and equoted == quoted and #escaped % 2 == 0 then
         str, buf, quoted = buf .. ' ' .. str, nil, nil
      elseif buf then
         buf = buf .. ' ' .. str
      end
      if not buf then
         local piece =  (str:gsub(spat,""):gsub(epat,""))
--          print(piece)
         table.insert(retval, piece)
      end
   end
   if buf then print("Missing matching quote for "..buf) end

   return retval
end

--
-- rounds a number to the nearest decimal places
--
local function rounddecimal(val, decimal)

   if (decimal) then
      return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
   else
      return math.floor(val+0.5)
   end

end

local function findexactcategoryname(category)

   local retval   =  nil

   if category ~= nil then

      local lowcasecategory  =  category:lower()

      for _, tbl in pairs({mano.categories, mano.sharedcategories}) do
         for _, db in pairs(tbl) do
            if db.name:lower():find(lowcasecategory) ~= nil then
               retval   =  db.name
               break
            end
         end
      end
   end

   return retval
end
local function findexactzonename(zonename)

   local retval   =  nil

   if zonename ~= nil then

      local lowcasezonename   =  zonename:lower()
      local zntbl             =  nil
      for _, zntbl in pairs(mano.db.geo.zones) do

         if zntbl.zonename:lower():find(lowcasezonename) ~= nil then
            retval   =  { zntbl.zonename, zntbl.zoneid }
            break
         end
      end
   end

   return retval
end


local function split(pString, pPattern)

   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)

   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end

   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end

   return Table
end


local function getcategoryicon(category)

   local icon  =  nil
   local tbl   =  {}
   local db    =  {}

   for _, tbl in pairs({mano.categories, mano.sharedcategories}) do
      for _, db in pairs(tbl) do
         if category == db.name then icon  =  db.icon   break end
      end
   end

   return   icon
end


-- local function userinputcancel()
--
--    return {}
-- end

local function manualaddnote(params)

   local ERROR    =  ""
   local t        =  {}
   local tokens   =  {}
   local token    =  nil
   local zonename =  nil
   local zoneid   =  nil

   tokens   =  splitquotedstringbyspace(params)

   -- Sintax:
   -- /mano new category zone x z y label [note] [shared]
   --        1     2      3   4 5 6  7      [8]    [9]
   --
   -- [shared] is false if missing, true any other value
   --
   if tokens[1] ~= nil and    -- "new"          (action)
      tokens[2] ~= nil and    -- "category"     (mandatory)
      tokens[3] ~= nil and    -- "zonename"     (mandatory)
      tokens[4] ~= nil and    -- X coordinate   (mandatory)
      tokens[5] ~= nil and    -- Z coordinate   (mandatory)
      tokens[6] ~= nil and    -- Y coordinate             (mandatory)
      tokens[7] ~= nil then   -- Label          (mandatory)

--       print(string.format("ACCEPTING INPUT FOR:\n  category: %s\n  zone: %s\n  XYZ: %s, %s, %s\n  Label: %s\n  Note: %s\n  Shared: %s",
--                                                    tokens[2],
--                                                                    tokens[3],
--                                                                                     tokens[4],
--                                                                                         tokens[5],
--                                                                                              tokens[6],
--                                                                                                   tokens[7],
--                                                                                                                 tokens[8] or 'nil',
--                                                                                                                             tokens[9] or 'false'
--                         )
--       )

      local categoryname   =  findexactcategoryname(tokens[2])
      local zonetbl        =  findexactzonename(tokens[3])
      if zonetbl ~= nil and next(zonetbl) ~= nil then
         zonename, zoneid  =  unpack(zonetbl)
      end

      if zonename ~= nil then

         if zoneid   ~= nil   then

            if categoryname   ~= nil   then

               t.label              =  tokens[7]
               t.text               =  tokens[8]      or ""
               t.category           =  categoryname   or "Default"
               t.shared             =  tokens[9]      or false
               t.playerpos          =  {}
               t.playerpos.x        =  mano.f.rounddecimal(tonumber(tokens[4]), 2) or 0
               t.playerpos.z        =  mano.f.rounddecimal(tonumber(tokens[5]), 2) or 0
               t.playerpos.y        =  mano.f.rounddecimal(tonumber(tokens[6]), 2) or 0
               t.playerpos.zoneid   =  zoneid
               t.playerpos.zonename =  zonename
               t.playerpos.name     =  mano.player.unitname
            else
               ERROR =  ERROR .. "Can't understand Category: " .. tokens[2] .. "\n"
            end
         else
            ERROR =  ERROR .. "Can't get zoneid for Zonename: " .. tokens[3] .. "\n"
         end
      else
         ERROR =  ERROR .. "Can't understand Zone: " .. tokens[3] .. "\n"
      end
   end


   if ERROR ~= "" then
      print("ERROR: " .. ERROR .. "\nSintax: /mano new category zone x z y label [note] [shared]")
   else
      -- Commit Note
      local noterecord  =  nil

      if t.shared == true  then  noterecord     =  mano.sharednote.new(t, { shared=true })   -- add note to Shared Notes Db
                           else  noterecord     =  mano.mapnote.new(t, { shared=false })     -- add note to User Notes Db
      end


      -- we show new note only if we are in the same zone of new note
      local current  =  mano.mapnote.getplayerposition()

      if zonename == current.zonename then
         mano.gui.shown.window.loadlistbyzoneid(zoneid)
      else
--          print("note not in current zone, not showing.")
      end

      print("Succesfully added note in ".. zonename .. ".")
   end

   return
end

local function parseslashcommands(params)

   for i in string.gmatch(params, "%S+") do

      if i  == "add" then

			if mano.mapnoteinput.initialized then
            local isonscreen  =  mano.mapnoteinput.o.window:GetVisible()
         else
            local isonscreen  =  false
         end

         if not isonscreen then
            local t     =  {}
            t.playerpos =  mano.mapnote.getplayerposition()
            mano.mapnoteinput:show('new', t)
         else
--             print("Input Form already on Screen")
         end
      end

      if i == "new"  then
         local retval = manualaddnote(params)
      end

   end

   return
end

--
-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
-- function tprint (tbl, indent)
--
function dumptable(tbl, indent)

   if not indent then indent = 0 end

   for k, v in pairs(tbl) do

      formatting = string.rep("  ", indent) .. '[' .. k .. ']' .. ": "

      if type(v) == "table" then
         print(formatting)
         dumptable(v, indent+1)
      else
         if type(v) == "function"  or
            type(v) == "boolean"   then
            print(formatting .. tostring(v))
         else
            if v ~= nil then
               print(formatting .. v)
            else
               print(formatting .. 'nil')
            end
         end
      end
   end
end


-- only print if debug is on
local function dprint(...) if mano.flags.debug == true then print(...) end end

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

   if x and z then
      local retval = Command.Map.Waypoint.Set(x, z)
   end

   local X, Z = Inspect.Map.Waypoint.Get("player")

--    print(string.format("Waypoint added in: %s, at %s, %s", zonename, X, Z))
	print(string.format("Waypoint added in: %s, at %.0f, %.0f", zonename, X, Z))

   return X, Z
end


--
-- Handles
--
--	mano.geo                   =	__geodata()
--	mano.zonetimer             =  __timer()
mano.geo                   =	Library.LibGeoData.geodata()
mano.zonetimer             =  Library.LibTimer.timer()

--
--
-- DBs
--
mano.db                    =  {}
mano.db.notes              =  {}
mano.db.geo                =	mano.geo.db
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
-- User Config Flags
--
mano.config                =  {}
mano.config.autocheckzone  =  true
mano.config.checkzonetimer =  10
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
mano.gui.visible				=	true
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
mano.gui.color.lightgreen  =  {  0,  6,  0, .5}
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
mano.f.userinputdelete     =  userinputdelete
mano.f.getcategoryicon     =  getcategoryicon
mano.f.splitstring         =  split
mano.f.rounddecimal        =  rounddecimal
mano.f.parseslashcommands  =  parseslashcommands
mano.f.getzoneinfos			=	getzoneinfos
mano.f.menu						=	Library.LibMenus.menu
mano.f.findexactzonename	=	findexactzonename

mano.foo                   =  {
                              round                 =  round,
                              updateguicoordinates  =  updateguicoordinates,
                              dprint                =  dprint,
                              setwaypoint           =  setwaypoint,
                              parseslashcommands    =  parseslashcommands,
                              dumptable             =  dumptable,
                              }
--
-- Player's Cached Info
--
mano.player                =  {}
--
-- Default Categories
--
mano.categories            =  {}
mano.lastcategoryidx       =  0
mano.sharedcategories      =  {}
mano.lastsharedcategoryidx =  0
--
-- Bases
--
mano.base                  =  {}
mano.base.usercategories   =  {  [1]   =  {  name="Default",            icon="macro_icon_clover.dds" },
                                 [2]   =  {  name="Artifacts",          icon="artifact_bundle.dds" },
                                 [3]   =  {  name="Crafting",           icon="outfitter1.dds" },
                                 [4]   =  {  name="Villain",            icon="target_portrait_roguepoint.png.dds" },
                                 [5]   =  {  name="User0",              icon="macro_icon_crown.dds" },
                                 [6]   =  {  name="User1",              icon="macro_icon_arrow.dds" },
                                 [7]   =  {  name="User2",              icon="macro_icon_no.dds" },
                                 [8]   =  {  name="User3",              icon="macro_icon_radioactive.dds" },
                                 [9]   =  {  name="User4",              icon="macro_icon_sad.dds" },
                                 [10]  =  {  name="User5",              icon="macro_icon_skull.dds" },
                                 [11]  =  {  name="User6",              icon="macro_icon_smile.dds" },
                                 [12]  =  {  name="User7",              icon="macro_icon_heart.dds" },
                                 [13]  =  {  name="User8",              icon="macro_icon_support.dds" },
                                 [14]  =  {  name="User9",              icon="macro_icon_tank.dds" },
                              }
mano.base.sharedcategories =  mano.base.usercategories
mano.base.filter				=	{  [1]	=	true,
                                 [2]   =	true,
                                 [3]   =	true,
                                 [4]   =	true,
                                 [5]   =	true,
                                 [6]   =	true,
                                 [7]   =	true,
                                 [8]   =	true,
                                 [9]   =	true,
                                 [10]  =	true,
                                 [11]  =	true,
                                 [12]  =	true,
                                 [13]  =	true,
                                 [14]  =	true,
                              }
--
-- end declarations
--
