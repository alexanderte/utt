define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#test-view'
    render: () ->
      test = this.model.get('tests').at(this.model.get('currentTest'))

      this.$el.html(
        _.template($('#test-progress').html(), { 'progress': this.model.progress() }) +
        _.template($(test.get('template')).html(), {
          'question': test.get('question')
          'nextUrl': this.nextUrl()
        })
      )

      $('html, body').animate({ scrollTop: 0 }, 'fast')
    nextUrl: () ->
      if (this.model.isAtLast() == true)
        return '#result'
      else
        return '#test/' + (this.model.get('currentTest') + 1)
  }
