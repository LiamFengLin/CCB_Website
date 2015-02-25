App.Store = DS.Store.extend
  adapter: DS.ActiveModelAdapter
 
  $ ->
    token = $("meta[name=\"csrf-token\"]").attr("content")
    $.ajaxPrefilter (options, originalOptions, xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", token