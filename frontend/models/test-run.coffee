define ['backbone', 'socketio', 'collections/tests', 'jquery', 'jed'], (Backbone, io, Tests, $) ->
  Backbone.Model.extend {
    defaults: {
      'webPage':     'http://www.tingtun.no/'
      'currentTest': 0
      'state':       'loading'
      'language':    'en'
      'route':       'home'
      'jed':         undefined
    }
    foo: () ->
      return 'bar'
    verifyTests: () ->
      this.get('tests').where({category: 'verify'})
    nextTest: () ->
    previousTest: () ->
    getCurrentTest: () ->
      this.verifyTests()[this.get('currentTest')]

    updateLanguage: (thisArg, callback) ->
      that = this
      $.getJSON 'locale/' + that.get('language') + '.json', (data) ->
        console.log 1
        that.set 'jed', new Jed({ locale_data: { messages: data[that.get('language')] } })
        console.log that.get('jed').translate('question_SC3.1.2-2-11').fetch(['foo', 'bar', 'baz'])
        if callback
          callback.apply(thisArg)
    initialize: (socket) ->
      _.extend(this, Backbone.Events)
      console.log 0
      this.updateLanguage this, () ->
        console.log 2
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
        this.trigger('appLoaded')
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
    setWebPage: (url) ->
      addProtocol = (url) ->
        if url.substring(0, 7) isnt 'http://' and url.substring(0, 8) isnt 'https://'
          'http://' + url
        else
          url

      this.set 'webPage', addProtocol(url)
    setLanguage: (languageCode) ->
      console.log(languageCode)
      this.set 'language', languageCode
      this.updateLanguage(this, () ->
        this.trigger('languageUpdated')
      )
    translate: (str, args) ->
      console.log('str')
      console.log(str)
      this.get('jed').translate(str).fetch(args)
  }
