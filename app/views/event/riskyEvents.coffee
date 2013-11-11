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
    'removeEvent mediator': "removeEventFromCollection"
  events:
    'click .reject-all-btn': "rejectAll"
  attach: ->
    super
  getTemplateData: ->
    td = super()
  flagEvent:(eventModel)->
    @collection.add eventModel
  approveEvent:(eventModel)->
    @collection.remove eventModel
  rejectAll:()->
    rejectIt = (item, cb)=>
      item.reject()
      cb()
    async.eachLimit @collection.models,5, rejectIt, (err)->
      console.log err if err
  removeEventFromCollection:(eventModel)=>
    @collection.remove eventModel