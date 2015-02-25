App.SignUpModalController = Ember.Controller.extend

  needs: ["application", "flashMessage"]

  isSignInChosen: true
  isSignUpChosen: false

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
    signUp: ->
      $.ajax
        url: "/users"
        method: "POST"
        data: 
          user:
            email: @get("email")
            password: @get("password")
      .then (data) =>
        @get('controllers.flashMessage').notice("Thank you for signing up. Please wait for administrative approval of your account.")
        @send "closeModal"
      .fail (e) =>
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
