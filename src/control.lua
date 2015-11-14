require "defines"
require "util"

function onputitem(event)
  if isHolding("staff-of-teleportation", event.player_index) then
 
	local player = game.players[event.player_index]
	local cursor_stack = player.cursor_stack
	
	if cursor_stack.valid_for_read and cursor_stack.can_set_stack then
	  cursor_stack.set_stack({name="staff-of-teleportation", count=10})
	  setNextPosition(event.position, event.player_index)
	end
  end
end

function onbuiltentity(event)
  if event.created_entity.name == "staff-of-teleportation" then
	event.created_entity.destroy()	
    return
  end
end

function moveFast(targetpos, player_index)
	local player = game.players[player_index]
	local startpos = player.position
	local vector = deductPos(targetpos, startpos)
	local magnitude = (vector.x^2+vector.y^2)^0.5
	local max_magnitude = 10

	
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
  local cursor_stack = game.players[player_index].cursor_stack
  if not cursor_stack.valid_for_read then return false end
  if cursor_stack.name == item_name then return true end

  return false
end

function initGlob()
  if glob == nil then 
    glob = {} 
	glob.players = {}
	return true
  end
  
  return false
end

function setNextPosition(position, player_index)
  initGlob()
  if not glob.players[player_index] then glob.players[player_index] = {} end
  glob.players[player_index].next_position = position
end

function removeStaffCharge(player_index)
  local player = game.players[player_index]
  local charges = player.get_inventory(1).get_item_count("staff-of-teleportation-charge")
  if charges > 0 then
    player.get_inventory(1).remove({name = "staff-of-teleportation-charge", count = 1})
    return true
  else 
    return false
  end	
end

function teleportPlayer(player_index)
  if game.tick % 15 > 0 then return false end
  if initGlob() then return false end

  if glob.players[player_index] == nil then 
    glob.players[player_index] = {}
	return false
  end
  
  
  local next_position = glob.players[player_index].next_position
  if next_position == nil then return false end
 
  if removeStaffCharge(player_index) then
	moveFast(next_position, player_index)
	glob.players[player_index].next_position = nil
  end	
end


function ontick(event)
  for player_index,player in ipairs(game.players) do
    teleportPlayer(player_index)
  end
end

game.on_event(defines.events.on_tick, ontick)
game.on_event(defines.events.on_put_item, onputitem)
game.on_event(defines.events.on_built_entity, onbuiltentity)
game.on_event(defines.events.on_tick, ontick)
