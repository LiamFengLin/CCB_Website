App.ResourceFilesController = Ember.ArrayController.extend

  itemController: 'resourceFile'

  selectedFileName: null

  filesNotSelected: false

  displayableEntries: Ember.A([])

  displayableEntryIndices: [] 

  fileAddressBase: "/resource_files/"

  renderedPDFUrl: (->
    if @get("selectedFileName")
      @set "filesNotSelected", false  
      return @get('fileAddressBase') + @get("selectedFileName")
    defaultResourceFileName = this.get('content.content')[0].get('fileName')
    return @get('fileAddressBase') + defaultResourceFileName
  ).property("selectedFileName", "content")

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