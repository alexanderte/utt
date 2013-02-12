define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#result-view'
    initialize: () ->
      this.options.router.bind('all', (route) ->
        if route == 'route:result'
          do this.render
          do this.$el.show
        else
          do this.$el.hide
      , this)
    render: () ->
      results = []
      _.each(this.model.get('tests').models, (element, index, list) ->
        results.push({ id: element.get('resultId'), url: document.location.href + '#/test/' + index, description: element.get('description'), answer: element.get('answer')})
      )
      this.$el.html(_.template($('#result-template').html(), { webPage: this.model.get('webPage'), tests: results }))
  }
