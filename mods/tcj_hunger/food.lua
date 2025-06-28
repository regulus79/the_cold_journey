



core.register_craftitem("tcj_hunger:bread", {
	description = "Bread",
	inventory_image = "tcj_bread.png",
	on_use = tcj_hunger.item_eat(3)
})