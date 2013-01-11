define(['underscore', 'backbone'], function(_, Backbone) {
  function _t(id, obj) {
    return _.template($(id).html(), obj === undefined ? {} : obj)
  }

  return Backbone.View.extend({
    el: '#navbar-view',
    render: function() {
      this.$el.html(_t('#navbar-template'));
    }
  });
});
