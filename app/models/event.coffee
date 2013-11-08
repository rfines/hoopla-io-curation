Model = require 'models/base/model'
module.exports = class Event extends Model
  urlRoot : "/api/event"
  nextOccurrence: ->
    if @get('nextOccurrence')?.start
      return moment.utc(@get('nextOccurrence').start)
    else
      return undefined

  nextOccurrenceEnd: ->
    if @get('nextOccurrence')?.end
      return moment.utc(@get('nextOccurrence').end)
    else
      return undefined

  lastOccurrence: ->
    if @get('prevOccurrence')?.start
      return moment.utc(@get('prevOccurrence').start)
    else
      return @nextOccurrence()

  dateDisplayText: ->
    now = moment.utc()
    ne = @nextOccurrence()
    if ne
      next = ne
      days = ne.startOf('day').diff(now.startOf('day'), 'days', true)
      if days > 1
        return next.format('MM/DD/YYYY')        
      else
        if days < 1
          return 'Today'
        else if days is 1
          return 'Tomorrow'
        else
          return @nextOccurrence().format('MM/DD/YYYY') || moment(@endDate).format('MM/DD/YYYY') || moment(@startDate).format('MM/DD/YYYY')
    else
      if @lastOccurrence()
        return @lastOccurrence().format('MM/DD/YYYY')
      else
        return ''

  getStartDate: ->
    if @get('occurrences')?.length > 0
      return moment.utc(_.first(@get('occurrences')).start)
    else
      if @get('schedules')?[0]
        return moment.utc(@get('schedules')[0].start)
      else
        return undefined     

  getEndDate: ->
    if @get('occurrences')?.length > 0
      return moment(_.first(@get('occurrences')).end)
    else
      if @get('schedules')?[0]
        return moment(@get('schedules')[0].end)
      else
        return undefined  


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
    @set 'curatorApproved', true
    @save({}, {success:(err)->
      console.log err if err
    })
  reject:()->
    @set 'curatorApproved', false
    @save({}, {success:(err)->
      console.log err if err
    })
