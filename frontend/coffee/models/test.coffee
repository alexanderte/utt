define ['backbone'], (Backbone) ->
  Backbone.Model.extend {
    defaults: {
      'resultId':    undefined
      'description': undefined
      'question':    undefined
      'answers':     undefined
      'template':    '#test-case-template'
      'answer':      undefined
    }
  }
