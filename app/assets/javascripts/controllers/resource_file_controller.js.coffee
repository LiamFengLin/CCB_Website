App.ResourceFileController = Ember.Controller.extend

  needs: ['resourceFiles']

  fileName: Ember.computed.alias('content.fileName')
  fileThumbnailUrl: Ember.computed.alias('content.fileThumbnailUrl')

  isSelected: (->
    @get('controllers.resourceFiles.selectedFileName') == @get('fileName')
  ).property('controllers.resourceFiles.selectedFileName')
