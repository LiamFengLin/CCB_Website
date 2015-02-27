attr = DS.attr
hasMany = DS.hasMany
belongsTo = DS.belongsTo

App.ResourceFile = DS.Model.extend

  fileName                 : attr 'string'
  fileUrl                  : attr 'string'
  fileThumbNailUrl         : attr 'string'
