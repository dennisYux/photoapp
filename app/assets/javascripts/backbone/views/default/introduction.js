Photoapp.Views.IntroductionView = Backbone.View.extend({
  // HTML template
  template: JST["backbone/templates/default/introduction"],
  // Events to listen
  events: {
    "click .toggle-intr": "toggle",
  },

  initialize: function(options) {
    // Default not to show
    this.isShown = false;
  },

  // Populate the html to the dom
  render: function() {
    this.$el.html(this.template());
    this.syncOuterContainer();
    return this;
  },

  toggle: function() {
    this.isShown = !this.isShown;
    this.syncOuterContainer();
  },

  syncOuterContainer: function() {
    if (this.isShown) {
      // Set localStorage and remove not-shown-before class if first time show
      if (!window.localStorage.getItem("isIntroductionShownBefore")) {
        window.localStorage.setItem("isIntroductionShownBefore", true);
        $("#main-container").removeClass("introduction-not-shown-before");
      }
      $("#main-container").addClass("introduction-shown");
    } else {
      // Add not-shown-before class if no localStorage data
      if (!window.localStorage.getItem("isIntroductionShownBefore")) {
        $("#main-container").addClass("introduction-not-shown-before");
      }
      $("#main-container").removeClass("introduction-shown"); 
    }
  },
});