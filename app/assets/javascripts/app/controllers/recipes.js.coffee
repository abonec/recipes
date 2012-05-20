$ = jQuery.sub()
Recipe = App.Recipe

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Recipe.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('recipes/new')

  back: ->
    @navigate '/recipes'

  submit: (e) ->
    e.preventDefault()
    recipe = Recipe.fromForm(e.target).save()
    @navigate '/recipes', recipe.id if recipe

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Recipe.find(id)
    @render()
    
  render: ->
    @html @view('recipes/edit')(@item)

  back: ->
    @navigate '/recipes'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/recipes'

class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Recipe.find(id)
    @render()

  render: ->
    @html @view('recipes/show')(@item)

  edit: ->
    @navigate '/recipes', @item.id, 'edit'

  back: ->
    @navigate '/recipes'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Recipe.bind 'refresh change', @render
    Recipe.fetch()
    
  render: =>
    recipes = Recipe.all()
    @html @view('recipes/index')(recipes: recipes)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/recipes', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/recipes', item.id
    
  new: ->
    @navigate '/recipes/new'
    
class App.Recipes extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/recipes/new':      'new'
    '/recipes/:id/edit': 'edit'
    '/recipes/:id':      'show'
    '/recipes':          'index'
    
  default: 'index'
  className: 'stack recipes'