attr = DS.attr
hasMany = DS.hasMany
belongsTo = DS.belongsTo

App.FlashMessage = DS.Model.extend

  message : attr 'string'
  type    : attr 'notice'