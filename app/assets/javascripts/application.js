// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require backbone_datalink
//= require backbone/photoapp
//= require_tree .

var HTML5FeatureDetect = HTML5FeatureDetect || {};
HTML5FeatureDetect.isDragAndDropSupported = (function() {
  var div = document.createElement('div');
  return ('draggable' in div) || ('ondragstart' in div && 'ondrop' in div);
})();
HTML5FeatureDetect.isLocalStorageSupported = (function() {
  return !!window.localStorage;
})();

// add the dataTransfer property for use with the native `drop` event
// to capture information about files dropped into the browser window
$.event.props.push("dataTransfer");

console.log("HTML5 DragAndDrop="+HTML5FeatureDetect.isDragAndDropSupported);
console.log("HTML5 LocalStorage="+HTML5FeatureDetect.isLocalStorageSupported);