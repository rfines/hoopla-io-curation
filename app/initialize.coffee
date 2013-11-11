Application = require 'application'
routes = require 'routes'
CookieManager = require 'cookieManager'
Datastore = require 'datastore'

$ ->
  Chaplin.datastore = new Datastore()
  Chaplin.cookieManager = new CookieManager()
  new Application {
    title: 'Hoopla Curation Interface',
    controllerSuffix: '-controller',
    routes
  }