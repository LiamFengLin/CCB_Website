App.SignUpModalController = Ember.Controller.extend

  needs: ["application"]

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
