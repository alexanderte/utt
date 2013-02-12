requirejs.config {
  baseUrl: 'js/deps'
  paths: {
    collections: '../collections'
    views:       '../views'
    models:      '../models'
    app:         '..'
    socketio:    'http://localhost:8000/socket.io/socket.io'
  }
  shim: {
    'backbone': {
      deps:    ['underscore']
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

require ['backbone', 'socketio', 'app/router', 'models/test-run', 'views/views'], (Backbone, io, Router, TestRun, Views) ->
  router = new Router()
  socket = io.connect 'http://localhost:8000'
  testRun = new TestRun(socket)
  views = new Views({ model: testRun, router: router })
  do Backbone.history.start
