App.ResourceFileController = Ember.Controller.extend

  needs: ['resourceFiles']

  fileName: Ember.computed.alias('content.fileName')

  isSelected: (->
    @get('controllers.resourceFiles.selectedFileName') == @get('fileName')
  ).property('controllers.resourceFiles.selectedFileName')
