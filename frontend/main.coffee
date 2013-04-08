requirejs.config {
  baseUrl: '.'
  paths: {
    jquery:      'http://code.jquery.com/jquery-1.9.1.min'
    backbone:    'deps/backbone'
    underscore:  'http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min'
    socketio:    'http://localhost:4563/socket.io/socket.io'
  }
  shim: {
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

require ['backbone', 'socketio', 'router', 'models/test-run', 'views/views'], (Backbone, io, Router, TestRun, Views) ->
  router = new Router()
  socket = io.connect 'http://localhost:4563'
  testRun = new TestRun(socket)
  views = new Views({ model: testRun, router: router })
  do Backbone.history.start
