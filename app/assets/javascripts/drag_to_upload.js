$(document).ready(function(){
  Dropzone.autoDiscover = false;

  var $attachment = $('[data-dropzone]');
  var $submit = $('#comment_submit');

  $attachment.dropzone({
    maxFileSize: 25,
    paramName: 'ticket[comments_attributes][0][attachment]',
    autoProcessQueue: false,
    init: function() {
      var myDropzone = this;

      // First change the button to actually tell Dropzone to process the queue.
      this.element.querySelector("input[type=submit]").addEventListener("click", function(e) {
        // Make sure that the form isn't actually being sent.
        e.preventDefault();
        e.stopPropagation();
        myDropzone.processQueue();
        setTimeout('location.reload()', 2000);
      });
    }
  });
});
