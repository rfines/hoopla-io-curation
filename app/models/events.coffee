Collection = require 'models/base/collection'
Event = require('models/event')

module.exports = class Events extends Collection
  model : Event
  url: "/api/curation/event"