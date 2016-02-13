Photoapp.Views.PhotosThumbView = Backbone.View.extend({
  // Outer div class name
  className: "img-container",
  // HTML template
  template: JST["backbone/templates/photos/thumb"],
  // Events to listen
  events: {
    "click .destroy": "clear",
    "click .toggle-liked": "toggleLiked"
  },

  initialize: function(options) {
    // Automatically set by backbone
    // this.collection = options.collection
    // this.model = options.model    
    this.listenTo(this.model, 'change', this.render);
    this.listenTo(this.model, 'destroy', this.remove);
  },

  // Populate the html to the dom
  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  // Toggle photo isLiked
  toggleLiked: function() {
    var _this = this;
    var isLiked = this.model.get("isLiked");
    var type = isLiked ? "DELETE" : "POST";
    // Have to specify .json
    var url = "/photos/"+this.model.get("source")+"/"+this.model.get("source_id")+"/vote.json";
    var errorHandler = function(xhr) {
      console.error(xhr.responseText);
    };
    var successHandler = function(data) {
      _this.model.set("isLiked", !isLiked);
      _this.model.trigger('change', _this.model, {});
    };
    // JQuery ajax
    $.ajax({
      type: type,
      url: url,
      success: successHandler,
      error: errorHandler
    });
  },

  clear: function() {
    // If persistence needed
    // this.model.destroy();
    // Otherwise, trigger a 'destroy' event
    // Let backbone do the magic by deleting model from any collection containing it
    this.model.trigger('destroy', this.model, {});
  }
});