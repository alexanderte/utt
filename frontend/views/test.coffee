define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#test-view'
    events: {
      'click button.answer': 'clickAnswer'
    }
    initialize: () ->
      @render()

      @options.router.bind('all', (route, currentTest) ->
        if route is 'route:test'
          @options.testRun.set('currentTest', if currentTest == undefined then 0 else parseInt(currentTest))
          if @options.testRun.get('currentTest') == 0
            @$el.slideDown()
          else
            @$el.show()
        else
          @$el.hide()
      , this)

      @options.locale.on('change:locale', @render , this)
      @options.testRun.bind('change:state', @render, this)
      @options.testRun.bind('change:currentTest', @render, this)
    render: () ->
      switch @options.testRun.get('state')
        when 'error'
          @$el.html(_.template($('#test-error').html(), { 'webPage': @options.testRun.get('webPage') }))
        when 'loading'
          @$el.html(_.template($('#test-loading').html(), { 'webPage': @options.testRun.get('webPage') }))
        else
          if not @options.testRun.getCurrentTest()
            @$el.html(_.template($('#test-nothing-to-test').html(), { 'webPage': @options.testRun.get('webPage') }))
            return

          test = @options.testRun.getCurrentTest()
          that = this
          answers = _.map(test.get('answers'), (a) -> { value: a, _value: that.options.locale.translate('test_answer_' + a) })

          @$el.html(
            _.template($('#test-progress').html(), { 'progress': @options.testRun.progress() }) +
            _.template($(test.get('template')).html(), {
              '_question': @options.locale.translate('test_question_' + test.get('testId') + '-' + test.get('testResultId'), test.get('questionValues'))
              '_previousTest': @options.locale.translate('test_previous_test')
              '_skipTest': @options.locale.translate('test_skip_test')
              'answers': answers
              'nextUrl': @nextUrl()
              'previousUrl': @previousUrl()
              'previousExtraClass': @previousExtraClass()
            })
          )

          $('html, body').animate({ scrollTop: 0 }, 'fast')
    previousExtraClass: () ->
      if (@options.testRun.isAtFirst() == true)
        return 'disabled'
    previousUrl: () ->
      if (@options.testRun.isAtFirst() == true)
        return '#test/' + (@options.testRun.get('currentTest'))
      else
        return '#test/' + (@options.testRun.get('currentTest') - 1)
    nextUrl: () ->
      if (@options.testRun.isAtLast() == true)
        return '#result'
      else
        return '#test/' + (@options.testRun.get('currentTest') + 1)
    clickAnswer: (el) ->
      @options.testRun.setAnswer(el.currentTarget.value)
      if (@options.testRun.isAtLast() == true)
        return '#result'
      else
        @options.testRun.nextTest()
  }
