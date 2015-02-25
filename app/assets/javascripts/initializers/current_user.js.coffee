Ember.Application.initializer
  name: 'currentUser'

  initialize: (container) ->
    store = container.lookup('store:main')
    attributes = $('meta[name="current-user"]').attr('content')

    if attributes
      user = store.push('user', store.serializerFor(App.User).normalize(App.User, JSON.parse(attributes)))
      controller = container.lookup('controller:currentUser').set('content', user)

      container.typeInjection('controller', 'currentUser', 'controller:currentUser')