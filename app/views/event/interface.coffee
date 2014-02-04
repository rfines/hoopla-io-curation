template = require 'views/templates/interface'
View = require 'views/base/view'
Events = require 'models/events'
EventListView = require 'views/event/eventList'
RiskyEventListView = require 'views/event/riskyEvents'
Businesses = require 'models/businesses'
BusinessList = require 'views/business/businessList'

module.exports = class InterfaceView extends View
  autoRender: true
  template : template
  attach: ->
    super()
    @startLoading()
    @subscribeEvent "showBusinesses", @showBusinesses
    @subscribeEvent "hideBusinesses", @hideBusinesses
    @collection = new Events()
    @collection.fetch 
      success: =>
        if @collection.length is 0
          @$el.find('.emptyState').show()
        businesses = new Businesses()
        businesses.fetch
          success:=>
            @stopLoading()
            if businesses.length is 0
              @$el.find(".noBusinesses").show()
            @$el.find(".business-count").html("Total Businesses: #{businesses.models.length}")
            @subview('businessList', new BusinessList({container:@$el.find('.businessList'), collection:businesses}))
            @subview('toCurate', new EventListView({container: @$el.find('.itemsToCurate'),collection:@collection}))
            @subview('riskyItems',new RiskyEventListView({container:@$el.find('.riskyItems'),collection:new Events()}))
   
  showBusinesses:()=>
    @$el.find('.eventListContainer').hide()
    @$el.find('.businessListContainer').slideDown()
    
  hideBusinesses:()=>
    @$el.find('.businessListContainer').hide()
    @$el.find('.eventListContainer').slideDown()