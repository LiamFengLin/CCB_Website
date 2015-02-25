App.IndexView = Ember.View.extend

  photoTransitionEffectEvent: (->
    @controller.on 'photoTransitionEffect', -> 
      Ember.run.scheduleOnce "afterRender", =>
        $("#slide_show1").css({ opacity: 0.7 })
        $('#slide_show1').fadeTo(300, 1)
  ).on('didInsertElement')
