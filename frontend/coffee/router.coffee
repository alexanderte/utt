define ['backbone'], (Backbone) ->
  Backbone.Router.extend {
    routes: {
      '':         'home'
      'test':     'test'
      'test/:id': 'test'
      'result':   'result'
    }
  }
