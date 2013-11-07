Controller = require 'controllers/base/controller'
EventListView = require 'views/event/eventList'
Events = require 'models/events'
module.exports = class DashboardController extends Controller

  index: ->
    @view = new EventListView({region: 'main', collection:new Events()})