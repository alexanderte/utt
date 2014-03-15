(function() {
//requirejs is used to load modules asynchronously
  requirejs.config({
    baseUrl: '.',
    paths: {
      jquery: '//code.jquery.com/jquery-1.9.1.min',
      bootstrap: '//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min',
      backbone: 'components/backbone',
      underscore: '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min',
      socketio: '//localhost:4563/socket.io/socket.io',
      jed: 'components/jed'
    },
	//shim is used to load modules that don't support AMD and can't be loaded asynchronously
    shim: {
      'bootstrap': {
        deps: ['jquery']
      },
      'backbone': {
        deps: ['underscore', 'jquery'],
        exports: 'Backbone'
      },
      'underscore': {
        exports: '_'
      },
      'socketio': {
        exports: 'io'
      }
    }
  });

  require(['backbone', 'socketio', 'router', 'models/locale', 'models/test-run', 'views/views', 'bootstrap', 'jed'], function(Backbone, io, Router, Locale, TestRun, Views) {
    var locale, socket;

	//'localhost' is replaced by the appropriate server when the deploy.sh script is run
	//Same with the port number
    socket = io.connect('http://localhost:4563');

	//locale is the vehicle for translating text into different languages
    locale = new Locale(socket);
    return locale.once('change:locale', function() {
      var router, views;

      router = new Router();

	  //'views' is an umbrella object that encapsulates all of the views used in this frontend
	  //Presumably this was done to allow views to interact with one another
      views = new Views({
        router: router,
        locale: locale,
        testRun: new TestRun(socket)
      });
      return Backbone.history.start();
    });
  });

}).call(this);
