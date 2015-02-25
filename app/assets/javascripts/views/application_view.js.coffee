App.ApplicationView = Ember.View.extend

  viewShouldScrollToSectionFirst: (->
    @controller.on 'viewShouldScrollToSection', (dest) -> 
      Ember.run.scheduleOnce "afterRender", =>
        scrollHeight = $(dest).position().top - $('#nav').height() + 1
        $('html, body').animate({scrollTop : scrollHeight}, 800, 'swing')
  ).on('didInsertElement')