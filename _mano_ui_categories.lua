--
-- Addon       _mano_ui_categories.lua
-- Author      marcob@marcob.org
-- StartDate   25/06/2017
--

local addon, mano = ...

function __mano_ui_categories(categories)
   -- the new instance
   local self =   {
         -- public fields go in the instance table
                     initialized       =  false,
                     db                =  {}
                     catmenu           =  {}
                  }

   local function loaddb(db)

      if db ~= nil and next(db) ~= nil then
         self.db  =  db
      else
         self.db  =  {}
      end

      return self
   end

   local function menuchoice(idx)

      mano.events.catmenutrigger(self.db[idx])
      self.catmenu.flip()

      return
   end

   local function create_menu()

      self.catmenu         =  {}
      self.catmenu.voices  =  {}
      for idx, category in ipairs(db) do
         table.insert(self.catmenu.voices,   {  "name    =  \'" .. category .. "\'",
                                                "callback=  { " .. menuchoice .. ", " .. idx .. ", \'close\' }",
                                             }
                     )

--       self.catmenu   =  {
--                            voices      =  {  {  name     =  "Load DB",
--                                                 callback =  "_submenu_",
--                                                 submenu  =  {  voices   =  {  { name   =  "Puzzles"   },
--                                                                               { name   =  "Cairns"    },
--                                                                            },
--                                                             },
--                                              },
--                                              {  name     =  "Add Note Here!",
--                                                 callback =  { mano.foo["parseslashcommands"], "add", 'close' },
--                                              },
--                                           },
--                         }

      return
   end



   self =   loaddb(categories)

   return self

end

