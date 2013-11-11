template = require 'views/templates/event/eventItem'
View = require 'views/base/view'
Business = require 'models/business'

module.exports = class EventItem extends View
  autoRender: true
  className: 'eventItem li-big'
  template: template
  mapped: false
  tagName:'li'
  events:
    'click .flagEvent': "flag"
    'click .approveEvent': "approve"

  flag:()->
    @publishEvent 'flagEvent', @model
  approve:()->
    @model.approve()
  dispose:()->
    @$el.slideUp(200, ()=>
      super()
    )

  getTemplateData: ->
    td = super()
    td.name=@model.get('name')
    td.businessName = @model.get('business')?.name
    td.userEmail = @model.get('createUser')?.email
    if @model.get('description')
      td.hasDescription = "True"
    else
      td.hasDescription = "False"
    if @model.get('media')?.length > 0
      td.hasImage = "True"
    else
      td.hasImage = "False"
    td.riskReason = @model.get('riskReasons').toString()    
    td