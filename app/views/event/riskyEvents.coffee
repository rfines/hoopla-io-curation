CollectionView = require 'views/base/collection-view'
Events = require 'models/events'
EventItem = require 'views/event/riskyEventItem'
template = require 'views/templates/event/riskyEventList'

module.exports = class RiskyEventList extends CollectionView
  autoRender: true
  className: 'riskyEventList list-unstyled'
  template: template
  mapped: false
  itemView: EventItem
  tagName: 'ul'
  listen:
    'flagEvent mediator':"flagEvent"
    'approveRiskyEvent mediator':"approveEvent"
    'click .reject-all-btn': "rejectAll"
    'removeEvent mediator': "removeEventFromCollection"
  attach: ->
    super
  getTemplateData: ->
    td = super()
  flagEvent:(eventModel)->
    @collection.add eventModel
  approveEvent:(eventModel)->
    @collection.remove eventModel
  rejectAll:()->
    console.log "rejecting all events"
  removeEventFromCollection:(eventModel)=>
    @collection.remove eventModel