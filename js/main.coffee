requirejs.config {
  baseUrl: 'js/deps',
  paths: {
    collections: '../collections'
    views: '../views'
    models: '../models'
  },
  shim: {
    'backbone': {
      deps: ['underscore'],
      exports: 'Backbone'
    },
    'underscore': {
      exports: '_'
    }
  }
}

require(['jquery', 'underscore', 'backbone', 'collections/tests', 'models/test-run', 'views/navbar', 'views/home', 'views/test', 'views/iframe', 'views/result'], ($, _, Backbone, Tests, TestRun, NavbarView, HomeView, TestView, IframeView, ResultView) ->

  _.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
  }

  testRun = new TestRun(
    new Tests([
      {
        title:    'Title appropriate for web page',
        question: 'Is the title “European Commission” appropriate for this web page?',
      },
      {
        title:    'Web page looks attractive',
        question: 'Does this web page look attractive to you?',
      },
      {
        title:    'Does the title “Ireland in the driving seat” describe the section it belongs to?',
        question: 'Does the title “Ireland in the driving seat” describe the section it belongs to?'
      },
      {
        title:    'Baz',
        question: 'Baz',
        template: '#test-case-template2',
      },
      {
        title:    'Does the language English correspond to the language used on the site?',
        question: 'Does the language English correspond to the language used on the site?',
      }
    ])
  )

  AppRouter = Backbone.Router.extend({
    routes: {
      '':         'home',
      'test':     'test',
      'test/:id': 'test',
      'result':   'result'
    }
  })

  appRouter = new AppRouter()

  navbarView = new NavbarView({model: testRun})
  homeView = new HomeView()
  testView = new TestView({model: testRun})
  iframeView = new IframeView({model: testRun})
  resultView = new ResultView()

  navbarView.render()
  iframeView.render()

  activateView = (name) ->
    switch name
      when 'home'
        $('#test-nav-button').removeClass('active')
        $('#result-nav-button').removeClass('active')

        $('#iframe-view').stop(false, true).hide()
        $('#test-view').hide()
        $('#result-view').hide()
        $('#home-view').fadeIn('fast')
      when 'test'
        $('#result-nav-button').removeClass('active')
        $('#test-nav-button').addClass('active')

        $('#home-view').hide()
        $('#result-view').hide()

        if testRun.get('currentTest') == 0
          $('#iframe-view').fadeIn('slow', () ->
            $('#test-view').slideDown('fast')
          )
        else
          $('#test-view').show()
          $('#iframe-view').show()
      when 'result'
        $('#test-nav-button').removeClass('active')
        $('#result-nav-button').addClass('active')

        $('#iframe-view').stop(false, true).hide()
        $('#home-view').hide()
        $('#test-view').slideUp('fast')
        $('#result-view').fadeIn('fast')

  appRouter.on('route:home', () ->
    homeView.render()
    activateView('home')
  )
  appRouter.on('route:test', (id) ->
    testRun.set('currentTest', if id == undefined then 0 else parseInt(id))
    testView.render()
    activateView('test')
  )
  appRouter.on('route:result', () ->
    resultView.render()
    activateView('result')
  )

  Backbone.history.start()
)
