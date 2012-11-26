Recipes = new Meteor.Collection("recipes")

# (page)-> is a function definition
Meteor.publish 'recipes', ()->
	Recipes.find {}, {sort: {date: -1}}

# (page)-> is a function definition
Meteor.publish('recipes_paged', (page, page_size)->
	console.log "server setting page", page
	Recipes.find {}, {limit: page_size, skip: page_size * page, sort: {date: -1}})

Meteor.startup ()->
	d = new Date()
	console.log "Server started", d

	# quick and dirty random text generation
	if Recipes.find({}).count() < 1
		for num in [1..10]
			console.log "creating random data", num
			texts = ["aaa", "bbb", "ccc", "ddd", "eee", "fff", "ggg", "hhh", "iii", "jjj"]
			for text in texts
				d.setTime( Math.random() * 1000000000000 )
				recipe = { title: text + num, date: d.toJSON() }
				console.log recipe
				Recipes.insert recipe
