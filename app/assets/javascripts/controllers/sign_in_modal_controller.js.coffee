App.SignInModalController = Ember.Controller.extend

  needs: ["application", 'flashMessage']

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

  signInUser: ->
    @auth.signIn(
      data: 
        email: @get("email")
        password: @get("password")
        remember: @get("remember")
    ).then (data) =>
      @get('controllers.flashMessage').notice('You have successfully signed in.')
      @send "closeModal"
    .catch (e) =>
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


  actions:
    signIn: ->
      @signInUser()