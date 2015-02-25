attr = DS.attr
hasMany = DS.hasMany
belongsTo = DS.belongsTo

App.User = DS.Model.extend

  email                : attr 'string'
  password             : attr 'string'