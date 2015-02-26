App.ApplicationRoute = Ember.Route.extend

  openModalNonAction: (modalName, model) ->
    controller = @controllerFor(modalName)
    controller.model = model
    @render modalName,
      into: 'application'
      outlet: 'modal'
      controller: controller

    controller.reset()

    Ember.run.scheduleOnce "afterRender", =>
      $('.modal-overlay, .modal').addClass('show')

  actions:
    openModal: (modalName, model) ->
      @openModalNonAction(modalName, model)
      
    closeModal: ->
      @disconnectOutlet
        outlet: 'modal'
        parentView: 'application'

      Ember.run.scheduleOnce "afterRender", =>
        $('.modal-overlay, .modal').removeClass('show')