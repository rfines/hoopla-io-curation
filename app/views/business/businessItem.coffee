template = require 'views/templates/business/businessItem'
View = require 'views/base/view'
Business = require 'models/business'

module.exports = class BusinessItem extends View
  autoRender: true
  className: 'businessItem li-big'
  template: template
  mapped: false
  tagName:'li'
  owner:undefined
  events: 
    "click .transferButton":"transfer"
    "click .deleteBusiness" : "destroy"
  dispose:()->
    @$el.slideUp(200, ()=>
      super()
    )

  getTemplateData: ->
    td = super()
    td.location = @model.get('location')?.address
    td

  attach:()=>
    super()
    @$el.find("#modal_#{@model.id}").on('show.bs.modal', (e)=>
      @getOwners()
    )

  getOwners:()=>
    @model.getOwners((err,data)=>
      if err
        console.log err
      else if data and data.length>0
        @owner = data
        @$el.find(".ownersDiv").html(@ownerEmail())
      else
        @$el.find(".ownersDiv").html("No Owner")
    )

  transfer:()=>
    v= @$el.find("#newOwnerEmail").val() 
    if v and v.length >0
      @$el.find("##{@model.id}_error").hide()
      @$el.find("##{@model.id}_email_error").hide()
      @$el.find("##{@model.id}_email_error").parent().removeClass("has-error")
      o = @ownerEmail()
      b = {
        newOwner: v
        oldOwner: o if o != "No Owner"
      }
      @model.transfer(JSON.stringify(b), (response)=>
        console.log response
        if response.success is false
          @publishError(response)
        else
          @$el.find("#success_#{@model.id}").show()
          @$el.find("#success_#{@model.id}").html("Business successfully transferred to #{v}") 
          setTimeout ( ->
            @$el.find("#success_#{@model.id}").hide()
          ), 5000
          @$el.find("#modal_#{@model.id}").modal('hide')
      )
    else
      @publishError()
  publishError:(err)=>
    if not err
      @$el.find("##{@model.id}_email_error").show()
      @$el.find("##{@model.id}_email_error").parent().addClass("has-error")
    else
      @$el.find("##{@model.id}_error").show()
      @$el.find("##{@model.id}_error_span").html(err.message)
      
  ownerEmail:()=>
    if @owner
      if _.isArray @owner
        if @owner.length >1
          return  _.pluck(@owner, "email")?.join(", ")
        else if @owner.length is 1
          return @owner[0].email
        else
          return "No Owner"
      else if _.isObject
        return @owner.email
    else 
      return "No Owner"
  destroy:()=>
    @publishEvent "businessRemoved", @model
    @dispose()