App.ResourceFilesRoute = Ember.Route.extend

  model: ->
    @store.find "resourceFile"