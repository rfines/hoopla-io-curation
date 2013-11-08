Controller = require 'controllers/base/controller'
Interface = require 'views/event/interface'
Events = require 'models/events'
SiteView = require 'views/site-view'
HeaderView = require 'views/header'
module.exports = class DashboardController extends Chaplin.Controller
  beforeAction: ->
    @compose 'site', SiteView
    @compose 'header', HeaderView
  index: ->
    @view = new Interface({region:'main', autoRender:true})