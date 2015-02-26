App.AuthenticatedRoute = Ember.Route.extend

  needs: ["application"]

  # beforeModel: ->
  #   if not @auth.isSignedIn
  #     @redirectToLogin()
      
  redirectToLogin: ->
    @transitionTo("index")
    controller = @get("controllers.application")
    controller.send "openModal", "sign_in_modal"