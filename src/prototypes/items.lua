data:extend(
{
  {
    type = "mining-tool",
    name = "staff-of-teleportation",
    icon = "__staff-of-teleportation__/graphics/icons/staff_of_teleportation.png",
    flags = {"goes-to-quickbar"},
	  subgroup = "energy-pipe-distribution",
    damage = 0,
    durability = 1000,
    order = "d-c",
    speed = 4,
	  place_result = "staff-of-teleportation",
    stack_size = 100,
	  enabled = true
  },
  {
    type = "container",
    name = "staff-of-teleportation",
    icon = "__staff-of-teleportation__/graphics/icons/staff_of_teleportation.png",
    flags = {"placeable-neutral", "player-creation","placeable-off-grid"},
    max_health = 1000,
    inventory_size = 1,
    picture =
    {
      filename = "__staff-of-teleportation__/graphics/icons/staff_of_teleportation.png",
      width = 32,
      height = 32,
      shift = {0, 0}
    }
  },
  {
    type = "item",
    name = "staff-of-teleportation-charge",
    icon = "__staff-of-teleportation__/graphics/icons/staff_of_teleportation_charge.png",
	  flags = {},
	  subgroup = "energy-pipe-distribution",
    order = "d-d",
    stack_size = 100000,
	  enabled = true
  },
}
)
