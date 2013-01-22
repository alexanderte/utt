define ['backbone'], (Backbone) ->
  Backbone.Model.extend {
    defaults: {
      'title':    undefined
      'question': undefined
      'answers':  ['Yes', 'No', 'Unsure']
      'template': '#test-case-template'
      'result':   { 'answer': undefined, 'comment': '' }
    }
  }
