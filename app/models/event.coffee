Model = require 'models/base/model'
module.exports = class Event extends Model
  urlRoot : "/api/event"

  imageUrl: (options) ->
    media = @get('media')
    if media?.length > 0
      opts = {}
      opts = {crop: 'fill', height: options.height, width: options.width} if options
      imgUrl = $.cloudinary.url(ImageUtils.getId(media[0].url), opts)  
      imgUrl = imgUrl.replace("w_#{options.width}", "w_#{options.width},f_auto") if options
      return imgUrl
    else
      return undefined
      
  approve:()->
    url = "#{baseUrl}api/curate/event/#{@get('_id')}/approve"
    $.ajax
      type:"POST"
      contentType:"application/json" 
      headers: {'content-type':'appliation/json'}
      url:url
      error:(jqXHR, textStatus, errorThrown)=>
        return false
      success: (data, textStatus, jqXHR)=>
        @publishEvent 'removeEvent', @
  reject:()->
    url = "#{baseUrl}api/curate/event/#{@get('_id')}/reject"
    $.ajax
      type:"POST"
      contentType:"application/json"
      headers: {'content-type':'appliation/json'}
      url:url
      error:(jqXHR, textStatus, errorThrown)=>
        return false
      success: (data, textStatus, jqXHR)=>
        @publishEvent 'removeEvent', @
