define ['backbone'], (Backbone) ->
  Backbone.Model.extend {
    defaults: {
      'line':         undefined
      'column':       undefined
      'testResultId': undefined
      'testId':       undefined
      'testTitle':    undefined
      'category':     undefined
      'question':     undefined
      'answers':      undefined
      'template':     '#test-case-template'
      'answer':       undefined
    }
    getTestId: () ->
      return @.attributes.testId + '-' + @.attributes.testResultId
  }
