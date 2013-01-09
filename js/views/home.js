define(['underscore', 'backbone'], function(_, Backbone) {
  function _t(id, obj) {
    return _.template($(id).html(), obj === undefined ? {} : obj)
  }

  return Backbone.View.extend({
    el: '.page',
    events: {
      'click #get-started-btn': 'getStarted'
    },
    render: function() {
      this.$el.html(_t('#introduction-template'));
    },
    getStarted: function() {
      router.navigate('/test', true);
    }
  });
});
