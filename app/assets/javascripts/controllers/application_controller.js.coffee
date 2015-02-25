App.ApplicationController = Ember.Controller.extend Ember.Evented,

  needs: ["flashMessage"]

  shouldHideDropDownMenu: true

  init: ->
    flashMessage = @store.createRecord "flashMessage",
      type: "notice"
      message: ""
    @set "flashMessage", flashMessage

  actions:

    toggleDropDownMenu: ->
      toggledValue = !@get("shouldHideDropDownMenu")
      @set "shouldHideDropDownMenu", toggledValue

    userClick: (dest) ->
      @transitionToRoute('index')
      @trigger "viewShouldScrollToSection", dest

    signOut: ->
      $.ajax
        url: '/users/sign_out'
        method: 'DELETE'
      .then (data) =>
        location.reload()