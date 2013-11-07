template = require 'views/templates/event/eventItem'
View = require 'views/base/view'
Business = require 'models/business'

module.exports = class EventItem extends View
  autoRender: false
  className: 'eventItem'
  template: template
  mapped: false
  
  loadAndRender: =>
    if @model.has('host')
      match = _.find Chaplin.datastore.businesses, (b) =>
        return b.id is @model.get('host')
      if match
        @business = match
        @render()
      else
        @business = new Business()
        @business.id = @model.get('host')
        @business.fetch
          success: =>
            Chaplin.datastore.businesses.push @business
            @render()
    else if @model.has('business')
      match = _.find Chaplin.datastore.businesses, (b) =>
        return b.id is @model.get('business')
      if match
        @business = match
        @render()
      else
        @business = new Business()
        @business.id = @model.get('business')
        @business.fetch
          success: =>
            Chaplin.datastore.businesses.push @business
            @render()
    else
      @render()

  getTemplateData: ->
    td = super()
    td.name=@model.get('name')
    td.i = @model.imageUrl({height:150, width:266}) || '/client/images/default-event.jpg' 
    td.businessId = @model.get('business')
    td.businessName = @business.get('name') if @business
    td.isRecurring = @model.get('scheduleText')?.length > 0
    start = moment.utc(@collection.start || new Date()).startOf('day')
    td.nextOccurrence = @model.nextOccurrence(start).utc().format("ddd, MMM Do")    
    startTime = @model.nextOccurrence()?.utc()
    endTime = @model.nextOccurrenceEnd()?.utc()
    if endTime > startTime
      td.time = "#{startTime.format('h:mm a')} to #{endTime.format('h:mm a')}"
    else
      endTime = ''
      td.time= "#{startTime.format('h:mm a')}"
    td