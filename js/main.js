requirejs.config({
  shim: {
    'backbone': {
      deps: ['underscore'],
      exports: 'Backbone'
    },
    'underscore': {
      exports: '_'
    }
  }
});

require(['jquery', 'underscore', 'backbone', 'tests', 'test-run', 'views/navbar', 'views/home', 'views/test', 'views/result'], function($, _, Backbone, Tests, TestRun, NavbarView, HomeView, TestView, ResultView) {
  _.templateSettings = {
    interpolate : /\{\{(.+?)\}\}/g
  };

  var testRun = new TestRun(
    new Tests([
      {
        title: 'Title appropriate for web page',
        question: 'Is the title “European Commission” appropriate for this web page?',
      },
      {
        title: 'Web page looks attractive',
        question: 'Does this web page look attractive to you?',
      },
      {
        title: 'Does the title “Ireland in the driving seat” describe the section it belongs to?',
        question: 'Does the title “Ireland in the driving seat” describe the section it belongs to?'
      },
      {
        title: 'Baz',
        question: 'Baz',
        'template': '#test-case-template2',
      },
      {
        title: 'Does the language English correspond to the language used on the site?',
        question: 'Does the language English correspond to the language used on the site?',
      }
    ])
  );

  var AppRouter = Backbone.Router.extend({
    routes: {
      '': 'home',
      'test': 'test',
      'test/:id': 'test',
      'result': 'result'
    }
  });

  var appRouter = new AppRouter();

  function activateView(name) {
    switch (name) {
      case 'home':
        $('#test-nav-button').removeClass('active');
        $('#result-nav-button').removeClass('active');
        $('iframe').stop(false, true).hide();
        $('#test-view').hide();
        $('#result-view').hide();
        $('#home-view').fadeIn('fast');

        break;
      case 'test':
        $('#result-nav-button').removeClass('active');
        $('#test-nav-button').addClass('active');
        $('#home-view').hide();
        $('#result-view').hide();

        if (testRun.getCurrentTestId() === 0) {
          $('iframe').fadeIn('slow', function() {
            $('#test-view').slideDown('fast');
          });
        }
        else {
          $('iframe').show();
          $('#test-view').show();
        }

        break;
      case 'result':
        $('#test-nav-button').removeClass('active');
        $('#result-nav-button').addClass('active');
        $('iframe').stop(false, true).hide();
        $('#home-view').hide();
        $('#test-view').slideUp('fast');
        $('#result-view').fadeIn('fast');
        break;
    }
  }

  var homeView = new HomeView();
  var testView = new TestView({model: testRun});
  var resultView = new ResultView();
  var navbarView = new NavbarView();

  navbarView.render();
  $('#navbar-view').animate({opacity: 1});

  appRouter.on('route:home', function () {
    homeView.render();
    activateView('home');
  });
  appRouter.on('route:test', function (id) {
    testRun.setCurrentTest(id === undefined ? 0 : parseInt(id));
    testView.render();
    activateView('test');
  });
  appRouter.on('route:result', function () {
    resultView.render();
    activateView('result');
  });

  Backbone.history.start();
});
