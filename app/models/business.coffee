Model = require 'models/base/model'
ImageUtils = require 'utils/imageUtils'

module.exports = class Business extends Model

  urlRoot : "/api/business"
  owner:undefined
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

  getOwners:(cb)=>
    url = "api/business/#{@.id}/user"
    $.ajax
      type: 'GET'
      url: url
      success: (data, textStatus, jqXHR)=>
        @owner = data
        cb null, data
      error:(jqXHR, textStatus, errorThrown)=>
        cb errorThrown,null
  transfer:(body, cb)=>
    url="api/business/#{@.id}/transfer"
    $.ajax
      type:'POST'
      contentType:"application/json"
      headers: {'content-type':"application/json"}
      url:url
      data:body
      processData:false
      error:(jqXHR, textStatus, errorThrown)=>
        console.log textStatus
        console.log errorThrown
        console.log jqXHR
        cb errorThrown
      success: (data, textStatus, jqXHR)=>
        cb data
