define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#test-view'
    initialize: () ->
      this.model.bind('change:state', this.render, this)

      this.options.router.bind('all', (route, currentTest) ->
        if route == 'route:test'
          this.model.set('currentTest', if currentTest == undefined then 0 else parseInt(currentTest))
          do this.render
          if this.model.get('currentTest') == 0
            do this.$el.slideDown
          else
            do this.$el.show
        else
          do this.$el.hide
      , this)
    render: () ->
      if this.model.get('state') == 'error'
        this.$el.html(
          _.template($('#test-error').html(), { 'webPage': this.model.get('webPage') })
        )
      else if this.model.get('state') == 'loading'
        this.$el.html(
          _.template($('#test-loading').html(), { 'webPage': this.model.get('webPage') })
        )
      else if this.model.getCurrentTest() == undefined
        this.$el.html(
          _.template($('#test-nothing-to-test').html(), { 'webPage': this.model.get('webPage') })
        )
      else
        test = this.model.getCurrentTest()
        console.log(test.get('answers'))

        answers = _.map(test.get('answers'), (a) -> { value: a, _value: this.model.translate('test_answer_' + a) })
        console.log(answers)

        this.$el.html(
          _.template($('#test-progress').html(), { 'progress': this.model.progress() }) +
          _.template($(test.get('template')).html(), {
            '_question': this.model.translate('test_question_' + test.get('testId') + '-' + test.get('testResultId'), test.get('questionValues'))
            '_previousTest': this.model.translate('test_previous_test')
            '_skipTest': this.model.translate('test_skip_test')
            'answers': answers
            'nextUrl': this.nextUrl()
            'previousUrl': this.previousUrl()
            'previousExtraClass': this.previousExtraClass()
          })
        )

        $('html, body').animate({ scrollTop: 0 }, 'fast')
    previousExtraClass: () ->
      if (this.model.isAtFirst() == true)
        return 'disabled'
    previousUrl: () ->
      if (this.model.isAtFirst() == true)
        return '#test/' + (this.model.get('currentTest'))
      else
        return '#test/' + (this.model.get('currentTest') - 1)
    nextUrl: () ->
      if (this.model.isAtLast() == true)
        return '#result'
      else
        return '#test/' + (this.model.get('currentTest') + 1)
    events: { 'click input#answer': 'clickAnswer' }
    clickAnswer: (el) ->
      this.model.setAnswer($('input#answer:checked').val())
  }
