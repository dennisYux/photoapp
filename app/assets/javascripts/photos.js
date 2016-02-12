// Toggle like/unlike state
$(function(){
  $('.img-action .unliked, .img-action .liked').on('click', toggleLikePhoto);
});

function toggleLikePhoto() {
  var $this = $(this);
  var source = $this.data("source");
  var sourceId = $this.data("sourceId");
  var url = "/photos/"+source+"/"+sourceId+"/vote";
  var errorHandler = function(xhr, ajaxOptions, thrownError) {
    console.error(xhr.responseText);
  };

  if ($this.hasClass("unliked")) {
    var type = "POST";
    var successHandler = function(json) {
      $this.removeClass("unliked").addClass("liked");
    };
  } else if ($this.hasClass("liked")) {
    var type = "DELETE";
    var successHandler = function(json) {
      $this.removeClass("liked").addClass("unliked");
    };
  }
  // Send Ajax request with config
  $.ajax({
    type: type,
    url: url,
    success: successHandler,
    error: errorHandler
  });
}
