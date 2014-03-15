//Model that handles translation of text into different languages
//locale strings are stored in language-specific files in the backend and retrieved when necessary
(function() {
  define(['backbone', 'jed'], function(Backbone) {
    return Backbone.Model.extend({
      defaults: {
        '_socket': void 0,
        'locale': 'en',
        '_jed': void 0
      },
      initialize: function(socket) {
        var that;

        _.extend(this, Backbone.Events);
		//Socket (socketio) is being used  as an alternative to Backbone's built-in AJAX functionality
        this.set('_socket', socket);
        socket.emit('get locale', this.get('locale'));
        that = this;
        return socket.on('locale', function(data) {
          that.set('locale', data.locale);
          that.set('_jed', new Jed({
            locale_data: {
              messages: data.data
            }
          }));
		  //triggers an event that all listeners can respond to
		  //In this case the language of the UTT has been changed
          return that.trigger('change:locale');
        });
      },
      setLocale: function(locale) {
        return this.get('_socket').emit('get locale', locale);
      },
      translate: function(str, args) {
        return this.get('_jed').translate(str).fetch(args);
      }
    });
  });

}).call(this);
