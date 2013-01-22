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
    previousTest: () ->
      if this.get('currentTest') == 0
        return false

      this.set('currentTest', this.get('currentTest') - 1)
      return true
    nextTest: () ->
      if (this.get('currentTest') == (this.get('tests').length - 1))
        return false

      this.set('currentTest', this.get('currentTest') + 1);
      return true
    isAtLast: () ->
      this.get('currentTest') == (this.get('tests').length - 1)
  }
