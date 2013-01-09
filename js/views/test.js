define(['underscore', 'backbone'], function(_, Backbone) {
  function _t(id, obj) {
    return _.template($(id).html(), obj === undefined ? {} : obj)
  }

  return Backbone.View.extend({
    el: '.page',
    initialize: function() {
    },
    render: function() {
      var test = this.model.currentTest();

      this.$el.html(
        _t('#test-progress', { 'progress': this.model.progress() }) +
        _t(test.get('template'), {
          'question': test.get('question')
        })
      );

      $("html, body").animate({ scrollTop: 0 }, "fast");
    },
    renderTestIframe: function() {
      return '<iframe src="http://ec.europa.eu/index_en.htm" sandbox="allow-forms allow-scripts"></iframe>';
    },
    initialize: function() {
      _.bindAll(this, "render");
      this.model.bind('change', this.render);
    },
    events: {
      'click #next-button': 'nextButtonClick'
    },
    nextButtonClick: function(e) {
      console.log(e.target.value);
      if (this.model.nextTest() == false)
        router.navigate('/result', true);
    },
  });
});
