Photoapp.Views.PhotosThumbView = Backbone.View.extend({
  // Outer div class name
  className: "img-container",
  // Outer div attributes
  attributes: {
    draggable: true
  },
  // HTML template
  template: JST["backbone/templates/photos/thumb"],
  // Events to listen
  events: {
    "click .img-trash": "clear",
    "click .img-like":  "toggleLiked",

    // Drag and drop
    "dragstart": "dragStartHandler",
    "dragenter": "dragEnterHandler",
    "dragover": "dragOverHandler",
    "drop": "dropHandler",
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

    /////// JS + CSS ///////
    // Bootstrap tooltips
    this.$el.find('.img-share').tooltip({
      title: "Not implemented yet",
      container: "body"
    });
    // Visibility
    if (this.model.get("isLiked")) {
      this.$el.find(".img-action").css("opacity", 1)
              .find(".img-like").css("opacity", 1);
    }

    if (this.model.get("uid") == Photoapp._dragAndDropData.uid) {
      this.renderDragEffect();
    }
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
    // If there was a PhotosThumbView to be removed
    // Remove it
    var model = Photoapp._trashData.model;
    if (model) {
      // If persistence needed
      // this.model.destroy();
      // Otherwise, trigger a 'destroy' event
      // Let backbone do the magic by deleting model from any collection containing it
      model.trigger('destroy', model, {});
    }

    // Mark current model as remove candidate
    // Get cleared when collection redraws
    this.model.set("isRemoved", true);
    // Mark current PhotosThumbView as a remove candidate
    // To be removed if another one follows
    this.$el.removeClass("img-restored").addClass("img-removed");

    // Remember last trashed photo
    Photoapp._trashData.model = this.model;

    // Notification and entry for restore
    var $notice = $('<div/>').addClass("notice-item");
    var $undo = $('<a/>').addClass("notice-action").text("Undo").on("click", function(){
      // Restore status, animation and clear trashData
      this.model.set("isRemoved", false);
      this.$el.addClass("img-restored").removeClass("img-removed");
      Photoapp._trashData.model = null;

      this.dismissNotice();

    }.bind(this));

    $('#notice-list').html($notice.append("Photo removed! ").append($undo));
  },

  ////////////////////////
  // We have push dataTransfer props of native drag event to JQuery event
  // Use ev.dataTransfer (=ev.originalEvent.dataTransfer) for convenience
  dragStartHandler: function(ev) {
    this.dismissNotice();
    Photoapp._dragAndDropData.uid = this.model.get("uid");
    this.renderDragEffect();
  },

  dragEnterHandler: function(ev) {
    if (this.model.get("uid") != Photoapp._dragAndDropData.uid) {
      var dragModels = this.collection.where({uid: Photoapp._dragAndDropData.uid});
      var oldIndex = this.collection.indexOf(dragModels[0]);
      var newIndex = this.collection.indexOf(this.model);
      var startIndex = Math.min(oldIndex, newIndex);
      var endIndex = Math.max(oldIndex, newIndex);
      var model = this.collection.models.splice(oldIndex, 1);
      this.collection.models.splice(newIndex, 0, model[0]);
      this.collection.trigger("reset", {startIndex: startIndex, endIndex: endIndex});
    }
  },

  dragOverHandler: function(ev) {
    ev.preventDefault();
  },

  dropHandler: function(ev) {
    // Clear dragAndDropData
    Photoapp._dragAndDropData.uid = null;
    this.removeDragEffect();
  },

  // Setup effect for dragging element
  renderDragEffect: function() {
    this.$el.addClass("img-dragging");
  },

  removeDragEffect: function() {
    this.$el.removeClass("img-dragging");
  },

  dismissNotice: function() {
    var $notices = $("#notice-list").children();
    $notices.addClass('notice-dismissed');
    setTimeout(function(){
      $notices.remove();
    }, 300);
  }
});








