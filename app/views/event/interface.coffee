template = require 'views/templates/interface'
View = require 'views/base/view'
Events = require 'models/events'
EventListView = require 'views/event/eventList'
RiskyEventListView = require 'views/event/riskyEvents'

module.exports = class InterfaceView extends View
  autoRender: true
  template : template
  attach: ->
    super()
    @collection = new Events()
    @collection.fetch 
      success: =>
        if @collection.length is 0
          @$el.find('.emptyState').show()
        @stopLoading()
      @subview('toCurate', new EventListView({container: @$el.find('.itemsToCurate'),collection:@collection}))
    @subview('riskyItems',new RiskyEventListView({container:@$el.find('.riskyItems'),collection:new Events()}))