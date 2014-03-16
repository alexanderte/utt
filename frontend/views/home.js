//The view responsible for displaying the UTT landing page
(function() {
  define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
    return Backbone.View.extend({
	  //'el' is the element that will contain this view
      el: '#home-view',
      events: {
        'click button#set-web-page-2': 'setWebPage'
      },
      initialize: function() {
        this.render();
		//Only show this view if the page is 'homme'
        this.options.router.bind('all', function(route) {
          if (route === 'route:home') {
            return this.$el.show();
          } else {
            return this.$el.hide();
          }
        }, this);
		//If the user changes the page language, re-render this view in the new language
        this.options.locale.on('change:locale', this.render, this);
		//If the test running state changes (can be 'loading', 'error', 'ready' etc), re-render this view
		//Effectively this means hide the view since the results page will be showing by then
        this.options.testRun.bind('change:state', this.render, this);
		//If the web page being tested changes in the 'testRun' model
		//Update the URL in the 'web page' edit box in this view
        return this.options.testRun.bind('change:webPage', function() {
          return $('#web-page-2').val(this.options.testRun.get('webPage'));
        }, this);
      },
      render: function() {
	    //Change the heading to match the page content
		//$("#mainHeading").html(this.options.locale.translate('home_user_testing_tool')).focus();
	  //Compile and render the HTML template for this view
	  //All templates are held in the 'index.html' file
        this.$el.html(_.template($('#home-template').html(), {
          webPage: this.options.testRun.get('webPage'),
          description: this.options.locale.translate('home_description'),
          enterWebPage: this.options.locale.translate('home_enter_web_page'),
          startTesting: this.options.locale.translate('home_start_testing'),
          reportIssue: this.options.locale.translate('home_report_issue'),
          state: this.options.testRun.get('state')
        }));
		//Set focus to the "Enter web page" edit box
        return $('#web-page-2').focus();
      },
	  //Change the web page in the 'testRun' model to reflect what's in the "Enter web page" edit box
      setWebPage: function() {
        this.options.testRun.setWebPage($('#web-page-2').val());
		//Navigate to the 'test' page/view, and trigger an event letting all listeners know this has happened
        return this.options.router.navigate('test', {
          trigger: true
        });
      }
    });
  });

}).call(this);
