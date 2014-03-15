//This is an umbrella that defines all other views as subviews
//Presumably this was done so all views can see and interact with one another
(function() {
  define(['backbone', 'views/navbar', 'views/iframe', 'views/home', 'views/test', 'views/result'], function(Backbone, NavbarView, IframeView, HomeView, TestView, ResultView) {
    return Backbone.View.extend({
      initialize: function() {
        var homeView, iframeView, navbarView, resultView, testView;

		//Instantiate all of the views required by the frontend
		//Send exactly the same options list to all views
		//This includes variables and models
        navbarView = new NavbarView(this.options);
        iframeView = new IframeView(this.options);
        homeView = new HomeView(this.options);
        testView = new TestView(this.options);
        return resultView = new ResultView(this.options);
      }
    });
  });

}).call(this);
