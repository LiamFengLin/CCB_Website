attr = DS.attr

App.Announcement = DS.Model.extend

  name:         attr 'string'
  time:         attr 'number'
  humanizedTime: attr 'string'
  description:  attr 'string'

  humanizedTime: (->
    if @get("time")
      time = new Date(1000 * @get("time"))
      options = {hour:'numeric',minute:'numeric',month:'short', day:'numeric'}
      time.toLocaleTimeString('en-US', options)
  ).property('time')
  
