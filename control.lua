--------------------------------------------------------------------------------
-- Mod bootstrap
--------------------------------------------------------------------------------
require("libs.enums.font_size_enum")
require("libs.enums.status_enum")

require("libs.helpers.debbug_helper")
require("libs.helpers.time_helper")
require("libs.helpers.player_helper")
require("libs.helpers.sprite_helper")
require("libs.helpers.table_helper")
require("libs.helpers.import_export_helper")
require("libs.helpers.gui_helper")
require("libs.helpers.string_helper")

require("libs.settings")
require("libs.tasks")
require("libs.states")

require("libs.gui")
require("libs.gui.main_frame")
require("libs.gui.task_list")
require("libs.gui.task_frame")
require("libs.gui.task_list")
require("libs.gui.task_view")
require("libs.gui.task_view_subtasks")
require("libs.gui.settings_frame")
require("libs.gui.confirm_dialog")
require("libs.gui.import_frame")
require("libs.gui.export_frame")
require("libs.gui.info_frame")
require("libs.gui.task_hud")

require("libs.events.on_gui_click")
require("libs.events.on_gui_elem_changed")
require("libs.events.on_gui_value_changed")
require("libs.events.on_gui_selection_state_changed")
require("libs.events.on_player_selected_area")
require("libs.events.on_gui_checked_state_changed")
require("libs.events.on_chart_tag_event")
require("libs.events.on_lua_shortcut")
require("libs.events.on_input")

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
