define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#result-view'
    initialize: () ->
      this.model.bind('change:state', this.render, this)

      this.options.router.bind('all', (route) ->
        if route == 'route:result'
          do this.render
          do this.$el.show
        else
          do this.$el.hide
      , this)
    shouldHideAutomatedCheckerResults: () ->
      document.getElementById('hideAutomatedCheckerResults') == null or $('#hideAutomatedCheckerResults').is(':checked')
    transformResult: (result, verifyIndex, verifyCount, that) ->
      if result.line == 0
        result.line = '–'
      if result.column == 0
        result.column = '–'
      if result.category != 'verify'
        result.answer = '<em>Auto</em>'

        if that.shouldHideAutomatedCheckerResults()
          result.dimClass = 'dim'
        else
          result.dimClass = ''
      if result.category == 'verify' and verifyIndex < verifyCount
        result.testTitle = '<a href="' + window.location.href.split('#')[0] + '#test/' + verifyIndex + '">' + result.testTitle + '</a>'

      result.categoryCapitalized = result.category.charAt(0).toUpperCase() + result.category.slice(1)

      result
    render: () ->
      that = this

      if this.model.get('state') == 'error'
        this.$el.html(_.template($('#result-template-error').html(), { webPage: this.model.get('webPage') }))
      else if this.model.get('state') == 'loading'
        this.$el.html(_.template($('#result-template-loading').html(), { webPage: this.model.get('webPage') }))
      else
        results = []
        verifyIndex = 0
        _.each(this.model.get('tests').models, (element, index, list) ->
          results.push(that.transformResult(element.attributes, verifyIndex, that.model.testCount(), that))

          if element.attributes.category == 'verify'
            verifyIndex++
        )

        checked = ''
        if this.shouldHideAutomatedCheckerResults()
          checked = 'checked="checked"'

        this.$el.html(_.template($('#result-template').html(), { webPage: this.model.get('webPage'), tests: results, checked: checked }))
    events: { 'change #hideAutomatedCheckerResults': 'clickDim' }
    clickDim: (el) ->
      do this.render
  }