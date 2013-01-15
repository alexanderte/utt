define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
  return Backbone.View.extend({
    el: '#iframe-view',
    render: function() {
      this.$el.html(_.template($('#iframe-template').html()));
    }
  });
});
