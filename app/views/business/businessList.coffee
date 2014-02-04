CollectionView = require 'views/base/collection-view'
Businesses = require 'models/businesses'
BusinessItem = require 'views/business/businessItem'
template = require 'views/templates/business/businessList'

module.exports = class BusinessList extends CollectionView
  autoRender: true
  className: 'businessList list-unstyled'
  template: template
  mapped: false
  itemView: BusinessItem
  tagName: 'ul'
    
  attach: ->
    super 
    @collection.on('add', @render, this)
    @collection.on('reset',@render,this)
    @collection.on('remove', @render, this)
    @subscribeEvent "businessRemoved", @destroy
  removeBusinessFromCollection:(businessModel)=>
    @collection.remove businessModel
  destroy: (model) =>
    destroyConfirm = confirm("Delete this Business?")
    if destroyConfirm
      m = model
      @collection.remove(model)
      m.destroy()
         