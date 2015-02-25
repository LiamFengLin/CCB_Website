App.PDFView = Ember.View.extend
  
  tagName: 'iframe'
  classNameBindings: ['isLoading:loading-effect']
  attributeBindings: ['src','width','height','frameborder']

  isLoading: true

  src: ""
  height: 680
  frameborder: 0

