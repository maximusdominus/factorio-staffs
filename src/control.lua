if not sot then sot = {} end
if not sot.config then sot.config = {} end

require("config")

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
  local max_magnitude = sot.config.max_magnitude
  local scale = max_magnitude / magnitude

  -- uniformly scale the vector down so that we can only move the character
  -- a maximum distance each hop
  if magnitude > max_magnitude then
	  vector = {x=(vector.x * scale), y=(vector.y * scale)}
	end

  -- scale everything down by how far away they clicked from the character
  -- cap the zone of control to a distance of 50
  local speed_magnitude = magnitude
  local speed_magnitude_max = sot.config.speed_magnitude_max

  if speed_magnitude > speed_magnitude_max then
    speed_magnitude = speed_magnitude_max
  end
  local speed_scale = speed_magnitude / speed_magnitude_max
  vector = {x=(vector.x * speed_scale), y=(vector.y * speed_scale)}

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

function initGlobal()
  if not global then global = {} end
  if not global.sot then global.sot = {} end
  if not global.sot.players then global.sot.players = {} end
end

function setNextPosition(position, player_index)
  initGlobal()
  if not global.sot.players[player_index] then global.sot.players[player_index] = {} end
  global.sot.players[player_index].next_position = position
end

function removeStaffCharge(player_index)
  local player = game.players[player_index]

  local inv_charges = player.get_inventory(1).get_item_count("staff-of-teleportation-charge")
  local bar_charges = player.get_quickbar().get_item_count("staff-of-teleportation-charge")
  local inv = false
  if inv_charges > 0 then
      inv = player.get_inventory(1)
  else
    if bar_charges > 0 then
      inv = player.get_quickbar()
    end
  end

  if not inv then return false end

  inv.remove({name = "staff-of-teleportation-charge", count=1})
  return true
end

function teleportPlayer(player_index)
  if game.tick % sot.config.tick_rate > 0 then return false end
  initGlobal()

  if global.sot.players[player_index] == nil then
    global.sot.players[player_index] = {}
	  return false
  end

  local next_position = global.sot.players[player_index].next_position
  if next_position == nil then return false end

  if removeStaffCharge(player_index) then
	  moveFast(next_position, player_index)
	  global.sot.players[player_index].next_position = nil
  end
end


function ontick(event)
  for _, player in pairs(game.players) do
     teleportPlayer(player.index)
  end
end

script.on_event(defines.events.on_put_item, onputitem)
script.on_event(defines.events.on_built_entity, onbuiltentity)
script.on_event(defines.events.on_tick, ontick)
