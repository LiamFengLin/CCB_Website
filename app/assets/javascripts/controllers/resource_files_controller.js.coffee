App.ResourceFilesController = Ember.ArrayController.extend

  itemController: 'resourceFile'

  selectedFileName: null

  filesNotSelected: true

  renderedPDFUrl: (->
    if @get("selectedFileName")
      @set "filesNotSelected", false  
      return "http://localhost:3000/resource_files/" + @get("selectedFileName")
  ).property("selectedFileName")

  actions:
    renderFile: (resourceFile) ->
      @set "selectedFileName", resourceFile.get('fileName')
