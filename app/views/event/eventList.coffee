CollectionView = require 'views/base/collection-view'
Events = require 'models/events'
EventItem = require 'views/event/eventItem'
template = require 'views/templates/event/eventList'

module.exports = class EventList extends CollectionView
  autoRender: true
  className: 'eventList list-unstyled'
  template: template
  mapped: false
  itemView: EventItem
  tagName: 'ul'
  listen:
    'flagEvent mediator':"flagEvent"
    'click .approveAll' :"approveAll"
    'approveRiskyEvent' :'approveRiskyEvent'
    'removeEvent mediator': "removeEventFromCollection"
  attach: ->
    super 
  flagEvent:(eventModel)->
    @collection.remove eventModel
  approveRiskyEvent:(eventModel)->
    @collection.add eventModel
  approveAll:()->
    console.log "Approving all events in the collection"
    approveIt = (item, cb)=>
      item.approve()
      cb()
    async.each @collection.models, approveIt, (err)->
      console.log err if err
  removeEventFromCollection:(eventModel)=>
    @collection.remove eventModel
