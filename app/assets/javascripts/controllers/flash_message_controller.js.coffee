App.FlashMessageController = Ember.ObjectController.extend

  needs: ["application"]

  notice: (message) ->
    controller = @get("controllers.application")
    update = =>
      $(".flash-message-container").clearQueue().slideDown(2000).delay(4000).slideUp(1000)
      controller.get("flashMessage").setProperties
        type: "notice"
        message: message

    if controller.get("flashMessage.message")
      controller.set("flashMessage.message", "")
      Ember.run.later ->
        update()
      , 500
    else
      update()