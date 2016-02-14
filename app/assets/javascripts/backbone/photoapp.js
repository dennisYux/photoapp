//= require_self
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./views
//= require_tree ./routers

window.Photoapp = {
  Models: {},
  Collections: {},
  Routers: {},
  Views: {},

  // Globals
  // Simply set as properties of Photoapp by taking advantage of
  // automatically reset when page reloads
  // For data persistence across pages, use window.localStorage
  _uniqueId: 0,
  _dragAndDropData: {},
  _trashData: {},
  // We should use window.localStorage to store 'isIntroductionShownBefore' tag without annoying user
  // Here we use global variable for demonstration purpose
  _isIntroductionShownBefore: {}
};