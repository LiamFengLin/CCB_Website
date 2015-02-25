App.SignInModalController = Ember.Controller.extend

  needs: ["application"]

  isSignInChosen: false
  isSignUpChosen: true

  email: null
  password: null

  errorMessage: null

  shouldHideError: true

  reset: ->
    @setProperties
      email: null
      password: null
      errorMessage: null

  actions:
    signIn: ->
      $.ajax
        url: "/users/sign_in"
        method: "POST"
        data: 
          user:
            email: @get("email")
            password: @get("password")
      .then (data) =>
        location.reload()
        @send "closeModal"
      .fail (e) =>
        @set "controllers.application.signedIn", false
        @set "shouldHideError", false
        json = e.responseJSON
        
        if json?.message?
          @set "errorMessage", json.message
        else if json?.full_messages?
          @set "errorMessage", _.uniq(json.full_messages).join("; ") + "."
        else if e.responseText
          @set "errorMessage", e.responseText
        else
          @set "errorMessage", "Server Error."
