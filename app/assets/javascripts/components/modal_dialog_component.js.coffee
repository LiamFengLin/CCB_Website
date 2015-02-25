App.ModalDialogComponent = Ember.Component.extend
      
      actions:
        close: ->
          @sendAction()

      didInsertElement: ->
        @_super.apply(@, arguments)
        $(".modal-overlay").addClass(@get("modalClass"))
        

      willDestroyElement: ->
        @_super.apply(@, arguments)
        $(".modal-overlay").removeClass(@get("modalClass"))

