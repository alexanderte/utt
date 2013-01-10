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

require(['jquery', 'underscore', 'backbone', 'tests', 'test-run', 'views/navbar', 'views/home', 'views/test'], function($, _, Backbone, Tests, TestRun, NavbarView, HomeView, TestView) {
  _.templateSettings = {
    interpolate : /\{\{(.+?)\}\}/g
  };

  function _t(id, obj) {
    return _.template($(id).html(), obj === undefined ? {} : obj)
  }

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

  var ResultView = Backbone.View.extend({
    el: '#resultView',
    render: function () {
      this.$el.html(_t('#result-template'));
    }
  });

  var AppRouter = Backbone.Router.extend({
    routes: {
      '': 'home',
      'test': 'test',
      'test/:id': 'test',
      'result': 'result'
    }
  });

  var appRouter = new AppRouter();

  function activateTab(name) {
    switch (name) {
      case 'home':
        $('#test-nav-button').removeClass('active');
        $('#result-nav-button').removeClass('active');
        break;
      case 'test':
        $('#result-nav-button').removeClass('active');
        $('#test-nav-button').addClass('active');
        break;
      case 'result':
        $('#test-nav-button').removeClass('active');
        $('#result-nav-button').addClass('active');
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
    activateTab('home');

    $('iframe').stop(false, true).hide();
    $('#testView').hide();
    $('#resultView').hide();
    $('#homeView').fadeIn('fast');
  });
  appRouter.on('route:test', function (id) {
    if (id !== undefined)
      testRun.setCurrentTest(parseInt(id));
    else
      testRun.setCurrentTest(0);

    testView.render();

    activateTab('test');

    $('#homeView').hide();
    $('#resultView').hide();

    if (testRun.getCurrentTestId() === 0) {
      $('iframe').fadeIn('slow', function() {
        $('#testView').slideDown('fast');
      });
    }
    else {
      $('iframe').show();
      $('#testView').show();
    }
  });
  appRouter.on('route:result', function () {
    resultView.render();
    activateTab('result');

    $('iframe').stop(false, true).hide();
    $('#homeView').hide();
    $('#testView').slideUp('fast');
    $('#resultView').fadeIn('fast');
  });

  Backbone.history.start();
});
