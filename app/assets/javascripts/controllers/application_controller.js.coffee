App.ApplicationController = Ember.Controller.extend Ember.Evented,

  shouldHideDropDownMenu: true

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