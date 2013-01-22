define ['backbone'], (Backbone) ->
  Backbone.Model.extend {
    defaults: {
      'webPage': 'http://ec.europa.eu/index_en.htm'
      'currentTest': 0
    }
    initialize: (tests) ->
      this.set 'tests', tests
    progress: () ->
      parseInt((this.get('currentTest') / (this.get('tests').length - 1)) * 100)
    isAtLast: () ->
      this.get('currentTest') == (this.get('tests').length - 1)
  }
