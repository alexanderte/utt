define ['backbone', 'socketio', 'collections/tests'], (Backbone, io, Tests) ->
  Backbone.Model.extend {
    defaults: {
      'webPage':     'http://www.tingtun.no/'
      'currentTest': 0
      'running':     false
    }
    initialize: (socket) ->
      this.set 'socket', socket
      this.set 'tests', []

      socket.emit('get tests', this.get('webPage'))

      that = this
      socket.on('tests', (data) ->
        that.set 'tests', new Tests(_.first(data, 10))
        that.set('running', true)
      )

      this.bind('change:webPage', this.fetchTests, this)
    fetchTests: () ->
      this.set('running', false)
      this.get('socket').emit('get tests', this.get('webPage'))
    progress: () ->
      parseInt((this.get('currentTest') / (this.get('tests').length - 1)) * 100)
    isAtLast: () ->
      this.get('currentTest') == (this.get('tests').length - 1)
    isAtFirst: () ->
      this.get('currentTest') == 0
  }
