define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
  return Backbone.View.extend({
    el: '#result-view',
    render: function() {
      this.$el.html(_.template($('#result-template').html()));
    }
  });
});
