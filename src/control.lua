require "defines"
require "util"

function onputitem(event)
  if isHolding("staff-of-teleportation", event.player_index) then
	local player = game.players[event.player_index]
	local charges = player.get_inventory(1).get_item_count("staff-of-teleportation-charge")

	if charges > 0 then
		moveFast(event.position, event.player_index)
		player.get_inventory(1).remove({name = "staff-of-teleportation-charge", count = 1})
	end
  end
end

function onbuiltentity(event)
  if event.created_entity.name == "staff-of-teleportation" then
    event.created_entity.destroy()	
	
	local player = game.players[event.player_index]
	player.insert({name="staff-of-teleportation", count=1})
    return
  end
end

function moveFast(targetpos, player_index)
	local player = game.players[player_index]
	local startpos = player.position
	local vector = deductPos(targetpos, startpos)
	local magnitude = (vector.x^2+vector.y^2)^0.5
	local max_magnitude = 0.7

	
	if magnitude > max_magnitude then
	
	  if vector.x < 0 then
	    vector.x = max_magnitude * -1.0
	  else
	    vector.x = max_magnitude 
	  end
	
	  if vector.y < 0 then
	    vector.y = max_magnitude * -1.0
	  else
	    vector.y = max_magnitude 
	  end
	end
	
	vector = {x=vector.x, y=vector.y}
	local telepos = addPos(startpos,vector)
	player.teleport(telepos)
end

function addPos(apos, bpos)
	if apos.x == nil then
		return {(apos[1] + bpos[1]), (apos[2] + bpos[2])}
	else
		return {x = (apos.x + bpos.x), y = (apos.y + bpos.y)}
	end
end

function deductPos(apos, bpos)
	if apos.x == nil then
		return {(apos[1] - bpos[1]), (apos[2] - bpos[2])}
	else
		return {x = (apos.x - bpos.x), y = (apos.y - bpos.y)}
	end
end


function isHolding(item_name, player_index)
  local holding_stack = game.players[player_index].cursor_stack
  if holding_stack.name == item_name and holding_stack.valid then
    return true
  end

  return false
end


game.on_event(defines.events.on_put_item, onputitem)
game.on_event(defines.events.on_built_entity, onbuiltentity)
game.on_event(defines.events.on_tick, ontick)
