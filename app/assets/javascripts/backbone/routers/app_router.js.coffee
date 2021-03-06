class VenmoGroups.Routers.AppRouter extends Backbone.Router
  initialize: (options) ->
    @groups = options.groups
    @user = options.user
    @friends = options.friends
    @friends_arr = options.friends_arr
    @transactions = options.transactions

  routes:
    'groups/edit/:id': 'groupEdit'
    'groups/new': 'groupNew'
    'groups/:action/:id': 'transactionNew'
    'groups/.*' : 'groupIndex'
    'transactions/new/:action/:id': 'transactionNew'
    'transactions/new/.*': 'transactionNew'
    '.*': 'index'

  groupEdit: (id) ->
    @renderSideView({ active: 'group' })
    group = @groups.get(id)
    view = new VenmoGroups.Views.Groups.EditView({
      model: group
      collection: @groups
      friends: @friends
      friends_arr: @friends_arr
    })
    $('#main-content').html(view.render().el)
    onebox = new VenmoGroups.Views.Components.AutoCompleteView({
      user: @user
      source: @friends_arr
      group: group
      model: group
      friends: @friends
    });
    $('#members-input').html(onebox.render().el)

  groupNew: ->
    @renderSideView({ active: 'group' })
    group = new VenmoGroups.Models.Group()
    view = new VenmoGroups.Views.Groups.NewView({
      collection: @groups
      model: group
    })
    $('#main-content').html(view.render().el)
    onebox = new VenmoGroups.Views.Components.AutoCompleteView({
      user: @user
      source: @friends_arr
      friends: @friends
      model: group
    });
    $('#members-input').html(onebox.render().el)

  groupIndex: ->
    @renderSideView({ active: 'group' })
    view = new VenmoGroups.Views.Groups.IndexView({
      collection: @groups
      user: @user
      friends: @friends
    })
    $('#main-content').html(view.render().el)

  transactionNew: (action, id) ->
    @renderSideView({ active: 'transaction' })
    group = if id then @groups.get(id) else null
    transaction = new VenmoGroups.Models.Transaction({group: group})
    view = new VenmoGroups.Views.Transactions.NewView({
      collection: @transactions
      action: action
      model: transaction
    })
    $('#main-content').html(view.render().el)
    onebox = new VenmoGroups.Views.Components.AutoCompleteView({
      user: @user
      source: @groups.toJSON().concat(@friends_arr)
      friends: @friends
      group: group
      model: transaction
      context: 'transaction'
    });
    $('#targets-input').html(onebox.render().el)

  index: ->
    @renderSideView({ active: 'index' })
    view = new VenmoGroups.Views.Transactions.IndexView({
      collection: @transactions
      user: @user
      friends: @friends
    })
    $('#main-content').html(view.render().el)
    

  renderSideView: (options) ->
    sidebar = new VenmoGroups.Views.Components.SideBarView({
      user: @user
    })
    $('#sidebar').html(sidebar.render(options).el)