template = require 'views/templates/event/riskyEvent'
View = require 'views/base/view'

module.exports = class RiskyEventItem extends View
  autoRender: true
  className: 'eventItem li-big'
  template: template
  mapped: false
  tagName:'li'
  events:
    'click .rejectEvent': "flag"
    'click .approveEvent': "approve"

  flag:()->
    @model.reject()
    
  approve:()->
    console.log "approving event"
    @model.approve()
    @publishEvent 'approveRiskyEvent', @model
      
  getTemplateData: ->
    td = super()
    td.name=@model.get('name')
    td.businessId = @model.get('business')
    td.businessName = @model.get('business').name
    td.createUser = @model.get('createUser')?.email
    td.riskReason = @model.get('riskReasons')?.toString()
    if @model.get('description')
      td.hasDescription = "True"
    else
      td.hasDescription = "False"
    if @model.get('media')?.length > 0
      td.hasImage = "True"
    else
      td.hasImage = "False"
    td