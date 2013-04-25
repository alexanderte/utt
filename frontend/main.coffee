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

require ['backbone', 'socketio', 'router', 'models/test-run', 'views/views', 'bootstrap', 'jed'], (Backbone, io, Router, TestRun, Views) ->
  router = new Router()
  socket = io.connect 'http://localhost:4563'
  testRun = new TestRun(socket)
  router.bind('all', (route) ->
    if route == 'route:home'
      testRun.set 'route', 'home'
    else if route == 'route:test'
      testRun.set 'route', 'test'
    else if route == 'route:result'
      testRun.set 'route', 'result'
  , this)
  views = new Views({ model: testRun, router: router })
  do Backbone.history.start
