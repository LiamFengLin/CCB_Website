App.AuthenticatedRoute = App.ApplicationRoute.extend

  needs: ["application"]

  beforeModel: ->
    if not @get("auth.signedIn")
      @redirectToLogin()
      
  redirectToLogin: ->
    @transitionTo("index")
    @openModalNonAction("sign_in_modal")