--
-- Addon       _mano_init.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
local addon, mano = ...

-- mano.addon           =  Inspect.Addon.Detail(Inspect.Addon.Current())["name"]
-- mano.version         =  Inspect.Addon.Detail(Inspect.Addon.Current())["toc"]["Version"]
--
-- MiniMapButton
--
mano.gui             =  {}
mano.gui.mmbtnheight =  38
mano.gui.mmbtnwidth  =  38
mano.gui.mmbtnx      =  0
mano.gui.mmbtny      =  0
mano.gui.mmbtnobj    =  nil
--
-- Initialization flags
--
mano.init            =  {}
mano.init.startup    =  false
--
