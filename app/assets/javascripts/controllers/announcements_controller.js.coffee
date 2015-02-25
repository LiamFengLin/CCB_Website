App.AnnouncementsController = Ember.ArrayController.extend

  loadAnnoucements: (->
    promise = @store.find "announcement"
    promise.then (data) =>
      @set "content", data
  ).on('init')