Recipes = new Meteor.Collection("recipes")
RecipesCounts = new Meteor.Collection("recipes_counts")

recipes_page_token = 'recipes.page'
recipes_page_size_token = 'recipes.pagesize'

Meteor.autosubscribe ()->
	Meteor.subscribe('recipes', Session.get( recipes_page_token ) || 0, Session.get( recipes_page_size_token ) || 10)

Meteor.subscribe("recipes_counts")

Template.main.recipeList = ()->
	Recipes.find({})

Template.main.totalRecipes = ()->
	console.log "Template.main.totalRecipes"
	counter = RecipesCounts.findOne({})
	if counter?
		counter.count
	else
		null

Template.main.pageNumbers = ()->
	console.log "page numbers called"
	counter = RecipesCounts.findOne({})
	pagesize = Session.get( recipes_page_size_token ) || 10
	if counter?
		count = counter.count
		page_count = Math.ceil( count / pagesize )
		result = []
		for num in [1..page_count]
			result.push {pagenum: num}
		result

Template.main.events =
	"click #nextPage": (e,t)->
		page = Session.get( recipes_page_token )
		if !page?
			page = 0
		page += 1
		console.log "page+", page
		Session.set( recipes_page_token, page )
		false

	"click #prevPage": (e,t)->
		page = Session.get( recipes_page_token )
		if !page?
			page = 1
		page = Math.max( page - 1, 0 )
		console.log "page-", page
		Session.set( recipes_page_token, page )
		false

	"change #pageSizeSelect": (e,t)->
		value = parseInt( e.currentTarget.value )
		if value?
			Session.set recipes_page_size_token, value
		false

	"click .pagination ul li a": (e,t)->
		text = e.currentTarget.text
		num = parseInt( text )
		if num?
			Session.set( recipes_page_token, num - 1 )
		false