define(['underscore', 'backbone'], function(_, Backbone) {
  return Backbone.View.extend({
    el: '#test-view',
    render: function() {
      var test = this.model.currentTest();

      this.$el.html(
        _.template($('#test-progress').html(), { 'progress': this.model.progress() }) +
        _.template($(test.get('template')).html(), {
          'question': test.get('question'),
          'nextURL': this.nextURL()
        })
      );

      $("html, body").animate({ scrollTop: 0 }, "fast");
    },
    nextURL: function() {
      if (this.model.nextTestId() === false)
        return '#result';
      else
        return '#test/' + this.model.nextTestId();
    },
  });
});
