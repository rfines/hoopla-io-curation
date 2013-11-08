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
    console.log "flagging event"
    @publishEvent 'flagEvent', @model
  approve:()->
    console.log "approving event"
    @model.approve()
      

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
    ###
    td.dateText = @model.dateDisplayText()
    td.startTimeText = "#{@model.nextOccurrence()?.format("h:mm A")} - #{@model.nextOccurrenceEnd()?.format("h:mm A")}"
    nextStart = @model.nextOccurrence()
    nextEnd = @model.nextOccurrenceEnd()
    if !nextStart
      nextStart = _.find @model.get('occurrences'), (item)=>
        console.log item
        return item.start >= new Date()
      console.log nextStart
      nextStart = nextStart.start
    if !nextEnd
      nextEnd = _.find @model.get('occurrences'), (item)=>
        return item.start >= new Date()

    td.nextOccurrence = nextStart.utc().format("ddd, MMM Do")
    td.nextOccurrenceEnd = nextEnd.utc().format("ddd, MMM Do")
    startTime = nextStart.utc()
    endTime = nextStart?.utc()
    if endTime > startTime
      td.time = "#{startTime.format('h:mm a')} to #{endTime.format('h:mm a')}"
    else
      endTime = ''
      td.time= "#{startTime.format('h:mm a')}"
    ###
    
    td