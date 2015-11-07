data:extend(
{ 
  
  {
    type = "recipe",
    name = "staff-of-teleportation",
    enabled = "true",
    energy_required = 30,
    ingredients =
    {
      {"raw-wood", 100}
    },
	
    results = {
	  {type = "item", name = "staff-of-teleportation", amount = 2}
	},
  },
  {
    type = "recipe",
    name = "staff-of-teleportation-charge",
    enabled = "true",
    energy_required = 0.2,
    ingredients =
    {
      {"raw-wood", 1}
    },
	
    results = {
	  {type = "item", name = "staff-of-teleportation-charge", amount = 100}
	},
  },
}
)



