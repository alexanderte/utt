define(['underscore', 'backbone'], function(_, Backbone) {
  function _t(id, obj) {
    return _.template($(id).html(), obj === undefined ? {} : obj)
  }

  return Backbone.View.extend({
    el: '#testView',
    initialize: function() {
    },
    render: function() {
      var test = this.model.currentTest();

      this.$el.html(
        _t('#test-progress', { 'progress': this.model.progress() }) +
        _t(test.get('template'), {
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
    initialize: function() {
      _.bindAll(this, "render");
      this.model.bind('change', this.render);
    },
  });
});
