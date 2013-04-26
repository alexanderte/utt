requirejs.config {
  baseUrl: '.'
  paths: {
    jquery:      '//code.jquery.com/jquery-1.9.1.min'
    bootstrap:   '//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min'
    backbone:    'components/backbone'
    underscore:  '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min'
    socketio:    '//localhost:4563/socket.io/socket.io'
    jed:         'components/jed'
  }
  shim: {
    'bootstrap': {
      deps:    ['jquery']
    }
    'backbone': {
      deps:    ['underscore', 'jquery']
      exports: 'Backbone'
    }
    'underscore': {
      exports: '_'
    }
    'socketio': {
      exports: 'io'
    }
  }
}

require ['backbone', 'socketio', 'router', 'models/locale', 'models/test-run', 'views/views', 'bootstrap', 'jed'], (Backbone, io, Router, Locale, TestRun, Views) ->
  socket = io.connect 'http://localhost:4563'
  locale = new Locale(socket)
  locale.once 'change:locale', () ->
    router = new Router()
    views = new Views {
      router:  router
      locale:  locale
      testRun: new TestRun(socket)
    }
    Backbone.history.start()
