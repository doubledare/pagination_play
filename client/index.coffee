Recipes = new Meteor.Collection("recipes")
RecipesPaged = new Meteor.Collection("recipes_paged")

recipes_page_token = 'recipes.page'
recipes_page_size_token = 'recipes.pagesize'

Meteor.autosubscribe ()->
	Meteor.subscribe('recipes_paged', Session.get( recipes_page_token ) || 0, Session.get( recipes_page_size_token ) || 5)

Meteor.subscribe( 'recipes' )

Template.main.recipeList = ()->
	RecipesPaged.find({})

Template.main.totalRecipes = ()->
	Recipes.find({}).count()

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