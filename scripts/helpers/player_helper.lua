PlayerHelper = {}

function PlayerHelper.get_player_by_id(id)
  for _, player in pairs(game.players) do
    if player.index == id then
      return player
    end
  end
end

function PlayerHelper.get_player_by_name(name)
  for _, player in pairs(game.players) do
    if player.name == name then
      return player
    end
  end
end
