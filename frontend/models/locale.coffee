define ['backbone', 'jed'], (Backbone) ->
  Backbone.Model.extend {
    defaults: {
      '_socket': undefined
      'locale': 'en'
      '_jed':    undefined
    }
    initialize: (socket) ->
      _.extend(this, Backbone.Events)
      @set '_socket', socket
      socket.emit 'get locale', @get('locale')
      that = this
      socket.on 'locale', (data) ->
        that.set 'locale', data.locale
        that.set '_jed', new Jed({ locale_data: { messages: data.data }})
        that.trigger 'change:locale'
    setLocale: (locale) ->
      @get('_socket').emit('get locale', locale)
    translate: (str, args) ->
      @get('_jed').translate(str).fetch(args)
  }
