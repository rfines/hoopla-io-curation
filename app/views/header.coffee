View = require 'views/base/view'
template = require 'views/templates/header'

module.exports = class HeaderView extends View
  autoRender: true
  className: 'header'
  region: 'header'
  template: template

  initialize: ->
    super
  events:
    "click .businessesLink":"showBusinesses"
    "click .eventsLink": "hideBusinesses"
  showBusinesses:()=>
    @$el.find(".businessesLink").addClass("active")
    @$el.find(".eventsLink").removeClass("active")
    @publishEvent 'showBusinesses'
  hideBusinesses:()=>
    @$el.find(".businessesLink").removeClass("active")
    @$el.find(".eventsLink").addClass("active")
    @publishEvent 'hideBusinesses'
    