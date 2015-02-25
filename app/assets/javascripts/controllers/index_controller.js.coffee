App.IndexController = Ember.Controller.extend Ember.Evented,

  rotatingImageIndex: 0

  rotatingImage: "/assets/slide_show1.jpg"

  rotatingImageList: ["/assets/slide_show1.jpg", "/assets/slide_show2.jpg", "/assets/slide_show3.jpg", "/assets/slide_show4.jpg"
  , "/assets/slide_show5.jpg", "/assets/slide_show6.jpg", "/assets/slide_show7.jpg", "/assets/slide_show8.jpg"]

  setSlide: (offset) ->
    nextIndex = (@get('rotatingImageIndex') + offset) % @get("rotatingImageList.length")
    if nextIndex < 0
      nextIndex += @get("rotatingImageList.length")
    @set('rotatingImageIndex', nextIndex)
    rotatingImageList = @get('rotatingImageList')
    @trigger 'photoTransitionEffect'
    @set('rotatingImage', rotatingImageList[@get('rotatingImageIndex')])

  schedule: (->
    @set("rotatingImageIndex", 0)
    setInterval => 
      @setSlide(1)
    , 10000
    ).on('init')

  actions:

    userSetSlide: (offset) ->
      @setSlide(offset)

  	toggle: ->
      if @get("is-toggled")
        @set("is-toggled", false)
      else
        @set("is-toggled", true)
