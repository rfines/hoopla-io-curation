CollectionView = require 'views/base/collection-view'
Events = require 'models/events'
EventItem = require 'views/event/eventItem'
template = require 'views/templates/event/eventList'
module.exports = class EventList extends CollectionView
  autoRender: true
  className: 'eventList'
  template: template
  mapped: false
  
  attach: ->
    @collection.fetch 
      success: =>
        @$el.empty()
        if @collection.length is 0
          @$el.find('.emptyState').show()
        @stopLoading()