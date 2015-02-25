App.AuthenticatedRoute = Ember.Route.extend

  needs: ["application"]

  beforeModel: ->
    if !this.controllerFor("currentUser").get("isSignedIn")
      @redirectToLogin()

  redirectToLogin: ->
    @transitionTo("index")
    controller = @controllerFor("application")
    controller.send "openModal", "sign_in_modal"