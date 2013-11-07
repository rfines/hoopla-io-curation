Model = require 'models/base/model'
ImageUtils = require 'utils/imageUtils'


module.exports = class Event extends Model
  
  urlRoot : "/api/curation/event"

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