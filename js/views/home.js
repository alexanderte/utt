define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
  return Backbone.View.extend({
    el: '#home-view',
    render: function() {
      this.$el.html(_.template($('#home-template').html()));
    }
  });
});
