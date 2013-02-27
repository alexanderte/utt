define ['backbone', 'socketio', 'collections/tests'], (Backbone, io, Tests) ->
  Backbone.Model.extend {
    defaults: {
      'webPage':     'http://www.tingtun.no/'
      'currentTest': 0
      'state':     'loading'
    }
    verifyTests: () ->
      this.get('tests').where({category: 'verify'})
    nextTest: () ->
    previousTest: () ->
    getCurrentTest: () ->
      this.verifyTests()[this.get('currentTest')]

    initialize: (socket) ->
      this.set 'socket', socket
      this.set 'tests', []

      socket.emit('get tests', this.get('webPage'))

      that = this
      socket.on('tests', (data) ->
        if data == null
          that.set('state', 'error')
        else
          that.set 'tests', new Tests(data)
          that.set('state', 'loaded')
      )

      this.bind('change:webPage', this.fetchTests, this)
    fetchTests: () ->
      this.set('state', 'loading')
      this.get('socket').emit('get tests', this.get('webPage'))
    testCount: () ->
      Math.min(this.verifyTests().length, 10)
    progress: () ->
      parseInt((this.get('currentTest') / (this.testCount() - 1)) * 100)
    isAtLast: () ->
      this.get('currentTest') == (this.testCount() - 1)
    isAtFirst: () ->
      this.get('currentTest') == 0
    setAnswer: (answer) ->
      this.verifyTests()[this.get('currentTest')].set('answer', answer)
  }
