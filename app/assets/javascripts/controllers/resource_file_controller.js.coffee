App.ResourceFileController = Ember.Controller.extend

  needs: ['resourceFiles']

  fileName: Ember.computed.alias('content.fileName')
  fileThumbnailUrl: Ember.computed.alias('content.fileThumbnailUrl')

  isSelected: (->
    @get('controllers.resourceFiles.selectedFileName') == @get('fileName')
  ).property('controllers.resourceFiles.selectedFileName')

  isDisplayable: (->
    flag = false
    @get("controllers.resourceFiles.displayableEntries").forEach (entry) =>
      if entry.id == @get('content.id')
        flag = true
    return flag
  ).property("controllers.resourceFiles.displayableEntries")

