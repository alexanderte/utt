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

require(['jquery', 'underscore', 'backbone', 'tests', 'test-run'], function($, _, Backbone, Tests, TestRun) {
  function _t(id, obj) {
    return _.template($(id).html(), obj === undefined ? {} : obj)
  }

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

  var HomeView = Backbone.View.extend({
    el: '.page',
    events: {
      'click #get-started-btn': 'getStarted'
    },
    render: function() {
      this.$el.html(_t('#introduction-template'));
    },
    getStarted: function() {
      router.navigate('/test', true);
    }
  });
  var TestView = Backbone.View.extend({
    el: '.page',
    render: function() {
      var test = testRun.currentTest();

      console.log(testRun.progress());

      this.$el.html(
        _t('#test-progress', { 'progress': testRun.progress() }) +
        _t(test.get('template'), {
          'question': test.get('question')
        })
      );

      $("html, body").animate({ scrollTop: 0 }, "fast");
    },
    renderTestIframe: function() {
      return '<iframe src="http://ec.europa.eu/index_en.htm" sandbox="allow-forms allow-scripts"></iframe>';
    },
    initialize: function() {
      _.bindAll(this, "render");
      testRun.bind('change', this.render);
    },
    events: {
      'click #next-button': 'nextButtonClick'
    },
    nextButtonClick: function(e) {
      console.log(e.target.value);
      if (testRun.nextTest() == false)
        router.navigate('/result', true);
    },
  });
  var ResultView = Backbone.View.extend({
    el: '.page',
    render: function () {
      this.$el.html(_t('#result-template'));
    }
  });

  var Router = Backbone.Router.extend({
    routes: {
      '': 'home',
      'test': 'test',
      'result': 'result'
    }
  });

  var home = new HomeView();
  var testView = new TestView();
  var result = new ResultView();

  var router = new Router();
  router.on('route:home', function () {
    home.render();
    $('#test-nav-button').removeClass('active');
    $('#result-nav-button').removeClass('active');
    $('.page-extra').html('');
  });
  router.on('route:test', function () {
    testView.render();
    $('#result-nav-button').removeClass('active');
    $('#test-nav-button').addClass('active');
    $('.page-extra').html('<iframe src="http://ec.europa.eu/index_en.htm" sandbox="allow-forms allow-scripts"></iframe>');
  });
  router.on('route:result', function () {
    result.render();
    $('#test-nav-button').removeClass('active');
    $('#result-nav-button').addClass('active');
    $('.page-extra').html('');
  });

  Backbone.history.start();
});
