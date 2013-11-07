View = require 'views/base/view'

module.exports = class Detail extends View
  autoRender: false

  initialize: ->
    super
    @loadAndRender()

  loadAndRender: =>
    @model.fetch
      success: =>
        @render()

  attach: =>
    super()
    @publishEvent 'adjustTitle', "#{@model.get('name')} - Hoopla Io Curation Interface" 
    @initMap()

  initMap: =>   
    mapLatLng = new google.maps.LatLng(@model.get('location').geo.coordinates[1], @model.get('location').geo.coordinates[0])
    mapOptions =
      zoom: 15
      center: mapLatLng
      disableDefaultUI: true
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map(document.getElementById("map_#{@model.id}"), mapOptions)        
    google.maps.event.trigger(map, "resize")
    marker = new google.maps.Marker({position: mapLatLng, map: map})

  getTemplateData: =>
    td = super
    td.i = @model.imageUrl()
    for sl in @model.get('socialMediaLinks')
      td[sl.target.toLowerCase()] = sl.url
    td.hasSocialMediaLinks = @model.get('socialMediaLinks')?.length > 0
    
    td    