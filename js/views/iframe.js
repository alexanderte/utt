define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
  return Backbone.View.extend({
    el: '#iframe-view',
    render: function() {
      this.$el.html(_.template($('#iframe-template').html(), { 'url': this.model.get('webPage') }));
    },
    initialize: function() {
      this.model.bind('change', this.render, this);
    }
  });
});
