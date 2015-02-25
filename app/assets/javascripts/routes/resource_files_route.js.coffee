App.ResourceFilesRoute = App.AuthenticatedRoute.extend

  model: ->
    @store.find "resourceFile"