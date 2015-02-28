App.ResourceFilesController = Ember.ArrayController.extend

  itemController: 'resourceFile'

  selectedFileName: null

  filesNotSelected: true

  displayableEntries: Ember.A([])

  displayableEntryIndices: [] 

  renderedPDFUrl: (->
    if @get("selectedFileName")
      @set "filesNotSelected", false  
      return "http://localhost:3000/resource_files/" + @get("selectedFileName")
  ).property("selectedFileName")

  intialSetSlide: (->
    @setSlide(0)
  ).observes("content")

  setSlide: (offset) ->
    content = @get("content")
    if @get("displayableEntries.length") == 0
      @set "displayableEntries", Ember.A([]).pushObject(content.objectsAt([0, 1, 2]))
      @set "displayableEntryIndices", [0, 1, 2]
    else
      indices = @get('displayableEntryIndices')
      length = @get('content.length')
      indices[0] = (indices[0] + offset + length) % length
      indices[1] = (indices[1] + offset + length) % length
      indices[2] = (indices[2] + offset + length) % length
      newEntries = content.filter ((item, index) ->
        return indices.contains(index)
      )
      @set "displayableEntries", newEntries

  actions:
    renderFile: (resourceFile) ->
      @set "selectedFileName", resourceFile.get('fileName')

    userSetSlide: (offset) ->
      @setSlide(offset)