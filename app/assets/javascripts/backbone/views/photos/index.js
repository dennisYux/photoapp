Photoapp.Views.PhotosIndexView = Backbone.View.extend({
  // HTML template
  template: JST["backbone/templates/photos/index"],

  initialize: function(options) {
    // Automatically set by backbone
    // this.collection = options.collection
    this.listenTo(this.collection, 'add', this.addOne);
    this.listenTo(this.collection, 'reset', this.addAll);
    this.listenTo(this.collection, 'sort', this.addAll);
    // this.listenTo(this.collection, 'all', _.debounce(this.render, 0));
  },

  addAll: function() {
    this.$el.find('.img-list').html('');
    this.collection.each(this.addOne, this);
  },

  addOne: function(model) {
    var view = new Photoapp.Views.PhotosThumbView({model: model, collection: this.collection});
    this.$el.find('.img-list').append(view.render().el);
  },

  // Populate the html to the dom
  render: function() {
    this.$el.html(this.template());
    this.addAll();
    return this;
  }
});