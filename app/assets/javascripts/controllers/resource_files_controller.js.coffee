App.ResourceFilesController = Ember.ArrayController.extend

  itemController: 'resourceFile'

  selectedFileName: null

  filesNotSelected: false

  displayableEntries: Ember.A([])

  displayableEntryIndices: [] 

  fileAddressBase: "/resource_files/"

  # if resourceFile.isDisplayable
  getExt: (fileName) ->
    fileName.split('.').slice(-1)[0]

  renderedPDFUrl: (->
    fileName = @get("selectedFileName")
    if fileName
      ext = @getExt(fileName)
      if ext == "pdf"
        @toPDFViewer()
        @set "filesNotSelected", false  
        return @get('fileAddressBase') + @get("selectedFileName")
    defaultResourceFileName = this.get('content.content')[0].get('fileName')
    return @get('fileAddressBase') + defaultResourceFileName
  ).property("selectedFileName", "content")

  renderedAudioUrl: (->
    fileName = @get("selectedFileName")
    if fileName
      ext = @getExt(fileName)
      if ext == "mp3"
        @toAudio()
        @set "filesNotSelected", false  
        $(".audio-control").attr("src", @get('fileAddressBase') + @get("selectedFileName"))
        return @get('fileAddressBase') + @get("selectedFileName")
    return ""
  ).observes("selectedFileName", "content")

  intialSetSlide: (->
    @setSlide(0)
  ).observes("content")

  stepNumber: 0

  toAudio: ->
    Ember.run.scheduleOnce "afterRender", =>  
      $('.multimedia-container').animate {left: "-100%"}, 
        duration: 600
        easing: 'swing'

  toPDFViewer: ->
    Ember.run.scheduleOnce "afterRender", =>  
      $('.multimedia-container').animate {left: "0%"}, 
        duration: 600
        easing: 'swing'    

  stepNext: ->
    numResouceFiles = @get('content.length')
    if @get('stepNumber') < numResouceFiles
      nextStep = @get('stepNumber') + 1
      @set "stepNumber", nextStep
      Ember.run.scheduleOnce "afterRender", =>  
        towards = "-#{nextStep * 25}%"
        $('.resource-list-container').animate {left: towards}, 
          duration: 600
          easing: 'swing'

  stepPrevious: ->
    if @get('stepNumber') > 0
      previousStep = @get('stepNumber') - 1
      @set "stepNumber", previousStep
      Ember.run.scheduleOnce 'afterRender', =>
        towards = "-#{previousStep * 25}%"
        $('.resource-list-container').animate {left: towards},
          duration: 600
          easing: 'swing'    

  setToLastStep: ->
    lastStep = "-#{@get('stepNumber') * 25}%"
    $('.resource-list-container').css('left', lastStep)    

  setToFront: ->
    $('.resource-list-container').css('left', "0%")    

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

    goToStepPrevious: ->
      @stepPrevious()

    goToStepNext: ->
      @stepNext()

    seeMoreToggle: ->
      if @get("shouldSeeMore")
        $('.resource-list-container').css('width', '1000%')
        @set("shouldSeeMore", false)
        @set("shouldHideButton", false)
        @setToLastStep()
      else
        $('.resource-list-container').css('width', '100%')
        @set("shouldSeeMore", true)
        @set("shouldHideButton", true)
        @setToFront()