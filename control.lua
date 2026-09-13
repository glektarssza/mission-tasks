--------------------------------------------------------------------------------
-- Mod bootstrap
--------------------------------------------------------------------------------
require("scripts.enums.font_size_enum")
require("scripts.enums.status_enum")

require("scripts.helpers.debbug_helper")
require("scripts.helpers.time_helper")
require("scripts.helpers.player_helper")
require("scripts.helpers.sprite_helper")
require("scripts.helpers.table_helper")
require("scripts.helpers.import_export_helper")
require("scripts.helpers.gui_helper")
require("scripts.helpers.string_helper")

require("scripts.settings")
require("scripts.tasks")
require("scripts.states")

require("scripts.gui")
require("scripts.gui.main_frame")
require("scripts.gui.task_list")
require("scripts.gui.task_frame")
require("scripts.gui.task_list")
require("scripts.gui.task_view")
require("scripts.gui.task_view_subtasks")
require("scripts.gui.settings_frame")
require("scripts.gui.confirm_dialog")
require("scripts.gui.import_frame")
require("scripts.gui.export_frame")
require("scripts.gui.info_frame")
require("scripts.gui.task_hud")

require("scripts.events.on_gui_click")
require("scripts.events.on_gui_elem_changed")
require("scripts.events.on_gui_value_changed")
require("scripts.events.on_gui_selection_state_changed")
require("scripts.events.on_player_selected_area")
require("scripts.events.on_gui_checked_state_changed")
require("scripts.events.on_chart_tag_event")
require("scripts.events.on_lua_shortcut")
require("scripts.events.on_input")

require("commands")

-- Called whenever the game or mod state needs to be (re)initialized.
-- Provides interface for everyone already on the map (save load).
local function initialize_mod()
  Tasks.start()
  Settings.start()
  Gui.start()

  for _, player in pairs(game.players) do
    Gui.destroy_all(player)
    Gui.init_player_gui(player)
  end

  TaskHud.redraw()
end

script.on_init(initialize_mod) -- novo jogo

script.on_configuration_changed(initialize_mod) -- versão/gráfico mudou

script.on_event(defines.events.on_player_joined_game, function(event)
  local player = game.get_player(event.player_index)
  if player and player.valid then
    Gui.destroy_all(player)
    Gui.init_player_gui(player)
    TaskHud.redraw(player)
  end

end)
