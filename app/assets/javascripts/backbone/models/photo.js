Photoapp.Models.PhotoModel = Backbone.Model.extend({
  // Default properties
  defaults: {
    "isLiked": false,
    "isRemoved": false
  },

  initialize: function() {
    this.set("uid", Photoapp._uniqueId += 1);
  }
});

Photoapp.Collections.PhotosCollection = Backbone.Collection.extend({
  // Reference to this collection's model.
  model: Photoapp.Models.PhotoModel
});