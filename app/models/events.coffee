Collection = require 'models/base/collection'
Event = require('models/event')

module.exports = class Events extends Collection
  model : Event
  start : moment().toDate().toISOString()
    
  comparator : (event) ->
    event.nextOccurrence(moment(@start))?.toDate().toISOString()