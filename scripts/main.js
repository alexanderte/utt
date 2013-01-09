var B = Backbone;

function _t(id, obj) {
  return _.template($(id).html(), obj === undefined ? {} : obj)
}

_.templateSettings = {
  interpolate : /\{\{(.+?)\}\}/g
};

var Test = B.Model.extend({
  defaults: {
    'title': undefined,
    'question': undefined,
    'answers': ['Yes', 'No', 'Unsure'],
    'template': '#test-case-template',
    'result': { 'answer': undefined, 'comment': '' }
  }
});

var Tests = B.Collection.extend({
  model: Test
});

var TestRun = B.Model.extend({
  defaults: {
    'webPage': 'http://ec.europa.eu/index_en.htm',
    '_currentTest': 0,
    'tests': tests
  },
  progress: function() {
    return parseInt((this.get('_currentTest') / (tests.length - 1)) * 100);
  },
  currentTest: function() {
    return tests.at(this.get('_currentTest'));
  },
  previousTest: function() {
    if (this.get('_currentTest') === 0)
      return false;

    this.set('_currentTest', this.get('_currentTest') - 1);
    return true;
  },
  nextTest: function() {
    if (this.get('_currentTest') === (tests.length - 1))
      return false;

    this.set('_currentTest', this.get('_currentTest') + 1);
    return true;
  },
});

var tests = new Tests([
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
  },
]);

var testRun = new TestRun();

var Home = Backbone.View.extend({
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
var Test = Backbone.View.extend({
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
var Result = Backbone.View.extend({
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

var home = new Home();
var test = new Test();
var result = new Result();

var router = new Router();
router.on('route:home', function () {
  home.render();
  $('#test-nav-button').removeClass('active');
  $('#result-nav-button').removeClass('active');
  $('.page-extra').html('');
});
router.on('route:test', function () {
  test.render();
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
