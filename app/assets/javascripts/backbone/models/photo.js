Photoapp.Models.PhotoModel = Backbone.Model.extend({
  // Default properties
  defaults: {
    "isLiked": false
  },

  initialize: function() {
    this.set("uid", window._uniqueId += 1);
  }
});

Photoapp.Collections.PhotosCollection = Backbone.Collection.extend({
  // Reference to this collection's model.
  model: Photoapp.Models.PhotoModel
});