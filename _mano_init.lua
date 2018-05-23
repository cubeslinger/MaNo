--
-- Addon       _mano_init.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
local addon, mano = ...

-- mano.addon           =  Inspect.Addon.Detail(Inspect.Addon.Current())["name"]
-- mano.version         =  Inspect.Addon.Detail(Inspect.Addon.Current())["toc"]["Version"]
--
--
-- DBs
--
mano.notes                 =  {}
--
-- Initialization flags
--
mano.init                  =  {}
mano.init.startup          =  false
--
mano.flags                 =  {}
mano.flags.trackartifacts  =  false
--
--
-- GUI
--
mano.gui                   =  {}
mano.gui.x                 =  0
mano.gui.y                 =  0
mano.gui.width             =  280

--
mano.gui.mmbtn	            =  {}
mano.gui.mmbtn.height      =  38
mano.gui.mmbtn.width       =  38
mano.gui.mmbtn.x           =  0
mano.gui.mmbtn.y           =  0
mano.gui.mmbtn.obj         =  nil
--
mano.gui.borders           =  {}
mano.gui.borders.left      =  2
mano.gui.borders.right     =  2
mano.gui.borders.bottom    =  2
mano.gui.borders.top       =  2
--
mano.color                 =  {}
mano.color.black           =  {  0,  0,  0, .5}
mano.color.deepblack       =  {  0,  0,  0,  1}
mano.color.red             =  { .2,  0,  0, .5}
mano.color.green           =  {  0,  1,  0, .5}
mano.color.blue            =  {  0,  0,  6, .1}
mano.color.lightblue       =  {  0,  0, .4, .1}
mano.color.darkblue        =  {  0,  0, .2, .1}
mano.color.grey            =  { .5, .5, .5, .5}
mano.color.darkgrey        =  { .2, .2, .2, .5}
mano.color.yellow          =  {  1,  1,  0, .5}
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
mano.gui.font              =  {}
mano.gui.font.size         =  12
--
mano.gui.shown             =  {}
--
-- end
--
