App.SignInModalView = Ember.View.extend

  isSignInChosen: true
  isSignUpChosen: false

  didInsertElement: ->
    @set "isSignInChosen", true
    @set "isSignUpChosen", false