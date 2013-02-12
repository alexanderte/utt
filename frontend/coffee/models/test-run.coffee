define ['backbone', 'socketio', 'collections/tests'], (Backbone, io, Tests) ->
  Backbone.Model.extend {
    defaults: {
      'webPage':     'http://www.tingtun.no/'
      'currentTest': 0
      'running':     'loading'
    }
    initialize: (socket) ->
      this.set 'socket', socket
      this.set 'tests', []

      socket.emit('get tests', this.get('webPage'))

      that = this
      socket.on('tests', (data) ->
        if data == null
          that.set('running', 'error')
        else
          that.set 'tests', new Tests(_.first(data, 10))
          that.set('running', 'loaded')
      )

      this.bind('change:webPage', this.fetchTests, this)
    fetchTests: () ->
      this.set('running', 'loading')
      this.get('socket').emit('get tests', this.get('webPage'))
    progress: () ->
      parseInt((this.get('currentTest') / (this.get('tests').length - 1)) * 100)
    isAtLast: () ->
      this.get('currentTest') == (this.get('tests').length - 1)
    isAtFirst: () ->
      this.get('currentTest') == 0
  }
