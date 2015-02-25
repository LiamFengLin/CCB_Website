App.ApplicationRoute = Ember.Route.extend

  actions:
    openModal: (modalName, model) ->
      controller = @controllerFor(modalName)
      controller.model = model
      @render modalName,
        into: 'application'
        outlet: 'modal'
        controller: controller

      controller.reset()

      Ember.run.scheduleOnce "afterRender", =>
        $('.modal-overlay, .modal').addClass('show')

    closeModal: ->
      @disconnectOutlet
        outlet: 'modal'
        parentView: 'application'

      Ember.run.scheduleOnce "afterRender", =>
        $('.modal-overlay, .modal').removeClass('show')