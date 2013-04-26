define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#result-view'
    events: {
      'change #hideAutomatedCheckerResults': 'clickDim'
    }
    initialize: () ->
      @render()

      @options.router.bind('all', (route) ->
        if route is 'route:result'
          @$el.show()
        else
          @$el.hide()
      , this)

      @options.locale.on('change:locale', @render , this)
      @options.testRun.bind('change:state', @render, this)
      @options.testRun.on('change:answer', @render, this)
    render: () ->
      if @options.testRun.get('state') == 'error'
        @$el.html(_.template($('#result-template-error').html(), { webPage: @options.testRun.get('webPage') }))
      else if @options.testRun.get('state') == 'loading'
        @$el.html(_.template($('#result-template-loading').html(), { webPage: @options.testRun.get('webPage') }))
      else
        tests = []
        verifyTests = @options.testRun.getVerifyTests()

        for test in @options.testRun.get('tests').models
          tests.push(@transformResult(test, verifyTests))

        tests.sort((a, b) ->
          if a.index > b.index
            1
          else
            -1
        )

        checked = ''
        if @shouldHideAutomatedCheckerResults()
          checked = 'checked="checked"'

        @$el.html(_.template($('#result-template').html(), {
          tests: tests,
          checked: checked
          _resultsForWebPage: @options.locale.translate('result_results_for_web_page', @options.testRun.get('webPage')),
          _hideAutomated: @options.locale.translate('result_hide_automated'),
          _category: @options.locale.translate('result_category'),
          _line: @options.locale.translate('result_line'),
          _column: @options.locale.translate('result_column'),
          _testId: @options.locale.translate('result_test_id'),
          _testResultId: @options.locale.translate('result_test_result_id'),
          _testTitle: @options.locale.translate('result_test_title'),
          _answer: @options.locale.translate('result_answer'),
          _answer_auto: @options.locale.translate('result_answer_auto')
        }))
    transformResult: (result, verifyTests) ->
      index = _.indexOf(verifyTests, result)

      if result.get('category') is 'verify'
        if index isnt -1
          result.set 'testTitle', '<a href="' + window.location.href.split('#')[0] + '#test/' + index + '">' + result.get('testTitle') + '</a>'
          result.set 'index', index
        else
          result.set 'index', 5000
      else
          result.set 'index', 10000

      if result.get('line') is 0
        result.set 'line', '–'
      if result.get('column') is 0
        result.set 'column', '–'

      if result.get('category') isnt 'verify'
        result.set '_answer', @options.locale.translate('result_answer_auto')

        if @shouldHideAutomatedCheckerResults()
          result.set 'dimClass', 'dim'
        else
          result.set 'dimClass', ''
       else
        if not result.get('answer')
          result.set '_answer', '–'
        else
          result.set '_answer', @options.locale.translate('test_answer_' + result.get('answer'))

      result.set '_category', @options.locale.translate('result_category_' + result.get('category'))
      result.toJSON()
    shouldHideAutomatedCheckerResults: () ->
      document.getElementById('hideAutomatedCheckerResults') == null or $('#hideAutomatedCheckerResults').is(':checked')
    clickDim: (el) ->
      @render()
  }
