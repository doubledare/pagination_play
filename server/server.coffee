Recipes = new Meteor.Collection("recipes")
RecipesCounts = new Meteor.Collection("recipes_counts")

# (page)-> is a function definition
Meteor.publish('recipes', (page, page_size)->
	console.log "server setting page", page
	Recipes.find {}, {limit: page_size, skip: page_size * page, sort: {date: -1}})

Meteor.publish 'recipes_counts', ()->
	uuid = Meteor.uuid()
	self = @

	unthrottled_count = ()->
		count = Recipes.find({}).count()
		self.set('recipes_counts', uuid, {count: count})
		self.flush()

	setCount = _.throttle( unthrottled_count, 50 )

	handle = Meteor._InvalidationCrossbar.listen({collection: "recipes"}, (notification, complete)->
		setCount()
		complete())

	setCount()
	self.complete()
	self.flush()

	self.onStop ()->
		handle.stop()
		self.unset( "recipes_counts", uuid, ["count"])
		self.flush()

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
