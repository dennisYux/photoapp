Photoapp.Models.PhotoModel = Backbone.Model.extend({
  // Default properties
  defaults: {
    "isLiked": false
  }
});

Photoapp.Collections.PhotosCollection = Backbone.Collection.extend({
  // Reference to this collection's model.
  model: Photoapp.Models.PhotoModel
});