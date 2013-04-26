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
      @set 'socket', socket

      socket.emit('get tests', @get('webPage'))

      that = this
      socket.on('tests', (data) ->
        if data == null
          that.set('state', 'error')
        else
          that.set 'tests', new Tests(data)
          that.set('state', 'loaded')
      )

      @bind('change:webPage', @fetchTests, this)
    fetchTests: () ->
      @set('state', 'loading')
      @get('socket').emit('get tests', @get('webPage'))
    getVerifyTests: () ->
      _.first(@get('tests').where({category: 'verify'}), 10)
      @get('tests').where({category: 'verify'})
    getCurrentTest: () ->
      if @get('tests').length == 0
        null
      else
        @getVerifyTests()[@get('currentTest')]
    progress: () ->
      parseInt((@get('currentTest') / (@getVerifyTests().length - 1)) * 100)
    isAtFirst: () ->
      @get('currentTest') == 0
    isAtLast: () ->
      @get('currentTest') == (@getVerifyTests().length - 1)
    setAnswer: (answer) ->
      @getVerifyTests()[@get('currentTest')].set('answer', answer)
      @trigger 'change:answer'
    setWebPage: (url) ->
      addProtocol = (url) ->
        if url.substring(0, 7) isnt 'http://' and url.substring(0, 8) isnt 'https://'
          'http://' + url
        else
          url

      @set 'webPage', addProtocol(url)
  }
