//Thiss view creates an iframe that displays the page being tested
(function() {
  define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
    return Backbone.View.extend({
	//'el' is the element that will contain this view
      el: '#iframe-view',
      initialize: function() {
        this.render();
		//Only show this view if we're on the 'test' page and there's not an error
        this.options.router.bind('all', function(route) {
          if (route === 'route:test') {
            if (this.options.testRun.get('state') !== 'error') {
              return this.$el.show();
            }
          } else {
            return this.$el.hide();
          }
        }, this);
		//Re-render this iframe if the web page being tested changes
        return this.options.testRun.bind('change:webPage', this.render, this);
      },
      render: function() {
	    //Compile and render the HTML template for this view
	    //All templates are held in the 'index.html' file
        return this.$el.html(_.template($('#iframe-template').html(), {
          'webPage': this.options.testRun.get('webPage')
        }));
      }
    });
  });

}).call(this);
