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
        that = this
        results = []
        testIndex = 0
        _.each(@options.testRun.get('tests').models, (element, index, list) ->
          results.push(that.transformResult(element.attributes, testIndex, that.options.testRun.testCount(), that))

          if element.attributes.category == 'verify'
            testIndex++
        )

        checked = ''
        if @shouldHideAutomatedCheckerResults()
          checked = 'checked="checked"'

        @$el.html(_.template($('#result-template').html(), {
          tests: results,
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
    transformResult: (result, testIndex, testCount, that) ->
      if result.line == 0
        result.line = '–'
      if result.column == 0
        result.column = '–'
      if result.category != 'verify'
        result._answer = @options.locale.translate('result_answer_auto')

        if that.shouldHideAutomatedCheckerResults()
          result.dimClass = 'dim'
        else
          result.dimClass = ''
       else
        if not result.answer
          result._answer = '–'
        else
          result._answer = @options.locale.translate('test_answer_' + result.answer)


      if result.category == 'verify' and testIndex < testCount
        result.testTitle = '<a href="' + window.location.href.split('#')[0] + '#test/' + testIndex + '">' + result.testTitle + '</a>'

      result._category = @options.locale.translate('result_category_' + result.category)

      result
    shouldHideAutomatedCheckerResults: () ->
      document.getElementById('hideAutomatedCheckerResults') == null or $('#hideAutomatedCheckerResults').is(':checked')
    clickDim: (el) ->
      @render()
  }
