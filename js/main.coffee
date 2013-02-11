requirejs.config {
  baseUrl: 'js/deps'
  paths: {
    collections: '../collections'
    views:       '../views'
    models:      '../models'
  }
  shim: {
    'backbone': {
      deps:    ['underscore']
      exports: 'Backbone'
    }
    'underscore': {
      exports: '_'
    }
  }
}

requestUrl = (webPageUrl) -> 'http://accessibility.egovmon.no/en/pagecheck2.0/?url=' + encodeURIComponent(webPageUrl) + '&export=json'

require(['jquery', 'underscore', 'backbone', 'collections/tests', 'models/test-run', 'views/navbar', 'views/home', 'views/test', 'views/iframe', 'views/result'], ($, _, Backbone, Tests, TestRun, NavbarView, HomeView, TestView, IframeView, ResultView) ->

  _.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
  }

  testRun = new TestRun(
    new Tests([
      {
        title:    'Title appropriate for web page'
        question: 'Is the title “European Commission” appropriate for this web page?'
      }
      {
        title:    'Web page looks attractive'
        question: 'Does this web page look attractive to you?'
      }
      {
        title:    'Does the title “Ireland in the driving seat” describe the section it belongs to?'
        question: 'Does the title “Ireland in the driving seat” describe the section it belongs to?'
      }
      {
        title:    'Baz'
        question: 'Baz'
        template: '#test-case-template2'
      }
      {
        title:    'Does the language English correspond to the language used on the site?'
        question: 'Does the language English correspond to the language used on the site?'
      }
    ])
  )

  console.log(requestUrl(testRun.get('webPage')))
  $.get(requestUrl(testRun.get('webPage')), (data) ->
    console.log(data)
  )

  AppRouter = Backbone.Router.extend({
    routes: {
      '':         'home'
      'test':     'test'
      'test/:id': 'test'
      'result':   'result'
    }
  })

  appRouter = new AppRouter()

  navbarView = new NavbarView({model: testRun})
  homeView = new HomeView()
  testView = new TestView({model: testRun})
  iframeView = new IframeView({model: testRun})
  resultView = new ResultView({model: testRun})

  do navbarView.render
  do iframeView.render

  activateView = (name) ->
    switch name
      when 'home'
        $('#test-nav-button').removeClass 'active'
        $('#result-nav-button').removeClass 'active'

        $('#iframe-view').stop(false, true).hide()
        do $('#test-view').hide
        do $('#result-view').hide
        $('#home-view').fadeIn 'fast'
      when 'test'
        $('#result-nav-button').removeClass 'active'
        $('#test-nav-button').addClass 'active'

        do $('#home-view').hide
        do $('#result-view').hide

        if testRun.get('currentTest') == 0
          $('#iframe-view').fadeIn('slow', () ->
            $('#test-view').slideDown 'fast'
          )
        else
          do $('#test-view').show
          do $('#iframe-view').show
      when 'result'
        $('#test-nav-button').removeClass 'active'
        $('#result-nav-button').addClass 'active'

        $('#iframe-view').stop(false, true).hide()
        do $('#home-view').hide
        $('#test-view').slideUp 'fast'
        $('#result-view').fadeIn 'fast'

  appRouter.on('route:home', () ->
    do homeView.render
    activateView 'home'
  )
  appRouter.on('route:test', (id) ->
    testRun.set('currentTest', if id == undefined then 0 else parseInt(id))
    do testView.render
    activateView 'test'
  )
  appRouter.on('route:result', () ->
    do resultView.render
    activateView 'result'
  )

  Backbone.history.start()
)
