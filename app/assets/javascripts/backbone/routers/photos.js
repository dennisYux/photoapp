Photoapp.Routers.PhotosRouter = Backbone.Router.extend({
  routes: {
    "":       "index",
    "photos": "index"
  },

  initialize: function(options) {
    this.$container = $('#body-section');
    this.photos = new Photoapp.Collections.PhotosCollection();
    this.photos.reset(options.photos);
  },

  index: function() {
    var view = new Photoapp.Views.PhotosIndexView({collection: this.photos});
    this.$container.html(view.render().el);
  }
});