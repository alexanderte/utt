//The view that displays the top navigation bar
(function() {
  define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
    return Backbone.View.extend({
	  //'el' is the element that will contain this view
      el: '#navbar-view',
      events: {
        'click button#set-web-page': 'setWebPage',
        'click a.language': 'changeLanguage'
      },
      initialize: function() {
        this.render();
		//Render this view for all pages
        this.options.router.bind('all', this.render, this);
		//When the user changes the page language, re-render this view
        this.options.locale.on('change:locale', this.render, this);
		//If the test running state changes (can be 'loading', 'error', 'ready' etc), re-render this view
        return this.options.testRun.bind('change:state', this.render, this);
      },
      render: function() {
	  	//Compile and render the HTML template for this view
		//All templates are held in the 'index.html' file
        return this.$el.html(_.template($('#navbar-template').html(), {
          webPage: this.options.testRun.get('webPage'),
          language: this.options.locale.get('locale'),
          state: this.options.testRun.get('state'),
          route: this.getCurrentRoute(),
          _test: this.options.locale.translate('navbar_test'),
          _results: this.options.locale.translate('navbar_results'),
          _language: this.options.locale.translate('navbar_language'),
          _languageEnglish: this.options.locale.translate('navbar_language_english'),
          _languageNorwegian: this.options.locale.translate('navbar_language_norwegian'),
          _set: this.options.locale.translate('navbar_set')
        }));
      },
      getCurrentRoute: function() {
        if (!Backbone.history.fragment) {
          return 'home';
        } else if (Backbone.history.fragment.substr(0, 4) === 'test') {
          return 'test';
        } else {
          return Backbone.history.fragment;
        }
      },
	  //Change the web page in the 'testRun' model to reflect what's in the "Enter web page" edit box
      setWebPage: function() {
        this.options.testRun.setWebPage($('#web-page').val());
		//Navigate to the 'test' page/view, and trigger an event letting all listeners know this has happened
        return this.options.router.navigate('test', {
          trigger: true
        });
      },
	  //When the user changes the page language...
      changeLanguage: function(e) {
	    //reset the language in the 'locale' model
        return this.options.locale.setLocale(e.currentTarget.dataset['language']);
      }
    });
  });

}).call(this);
