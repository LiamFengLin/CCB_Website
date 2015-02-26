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
      @auth.signOut(
        data: 
          email: @get("auth.user.email")
      ).then (data) =>
        @get('controllers.flashMessage').notice("You have signed out.")
      .catch (e) =>
        json = e.responseJSON
        if json?.message?
          errorMessage = json.message
        else if json?.full_messages?
          errorMessage = _.uniq(json.full_messages).join("; ") + "."
        else if e.responseText
          errorMessage = e.responseText
        else
          errorMessage = "Server Error."
        @get('controllers.flashMessage').notice(errorMessage)