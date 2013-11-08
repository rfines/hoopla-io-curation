template = require 'views/templates/event/riskyEvent'
View = require 'views/base/view'

module.exports = class RiskyEventItem extends View
  autoRender: true
  className: 'eventItem'
  template: template
  mapped: false
  tagName:'li'
  events:
    'click .rejectEvent': "flag"
    'click .approveEvent': "approve"

  flag:()->
    console.log "flagging event"
    @publishEvent 'flagEvent', @model
  approve:()->
    console.log "approving event"
    @model.approve()
    @publishEvent 'approveRiskyEvent', @model
      
  getTemplateData: ->
    td = super()
    td.name=@model.get('name')
    td.businessId = @model.get('business')
    td.businessName = "Some Business"
    if @model.get('description')
      td.hasDescription = "True"
    else
      td.hasDescription = "False"
    if @model.get('media')?.length > 0
      td.hasImage = "True"
    else
      td.hasImage = "False"
    
    td