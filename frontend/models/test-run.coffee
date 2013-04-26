define ['backbone', 'socketio', 'collections/tests'], (Backbone, io, Tests) ->
  Backbone.Model.extend {
    defaults: {
      'webPage':     'http://www.tingtun.no/'
      'state':       'loading'
      'tests':       []
      'currentTest': 0
    }
    initialize: (socket) ->
      _.extend(this, Backbone.Events)
      this.set 'socket', socket

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
    verifyTests: () ->
      this.get('tests').where({category: 'verify'})
    nextTest: () ->
      this.set('currentTest', this.get('currentTest') + 1)
    previousTest: () ->
      this.set('currentTest', this.get('currentTest') - 1)
    getCurrentTest: () ->
      if this.get('tests').length == 0
        null
      else
        this.verifyTests()[this.get('currentTest')]
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
      this.trigger 'change:answer'
    setWebPage: (url) ->
      addProtocol = (url) ->
        if url.substring(0, 7) isnt 'http://' and url.substring(0, 8) isnt 'https://'
          'http://' + url
        else
          url

      this.set 'webPage', addProtocol(url)
  }
