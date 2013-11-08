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
  attach: ->
    super 
  flagEvent:(eventModel)->
    @collection.remove eventModel
  approveRiskyEvent:(eventModel)->
    @collection.add eventModel
  approveAll:()->
    console.log "Approving all events in the collection"
    approveIt = (item, cb)=>
      item.set 'curatorApproved', true
      item.save({}, {success:(err)=>
        if err
          console.log err
          cb err
        else
          cb() if cb
      })
    async.each @collection.models, approveIt, (err)->
      console.log err if err
