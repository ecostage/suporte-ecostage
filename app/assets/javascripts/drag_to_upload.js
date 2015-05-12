$(document).ready(function(){
  Dropzone.autoDiscover = false;

  var $attachment_form = $('[data-dropzone]');
  var dropzoned = false;

  $attachment_form.on('dragover', function(){
    if(dropzoned) { return };

    $attachment_form.dropzone({
      maxFileSize: 25,
      paramName: 'ticket[comments_attributes][0][attachment]',
      autoProcessQueue: false,
      init: function() {
        var dropzone = this;

        // First change the button to actually tell Dropzone to process the queue.
        this.element.querySelector("input[type=submit]").addEventListener("click", function(e) {
          // Make sure that the form isn't actually being sent.
          e.preventDefault();
          e.stopPropagation();
          dropzone.processQueue();
        });

        dropzone.on('success', function(){
          location.reload();
        });
      }
    });

    dropzoned = true;

    $attachment_form.find('.comment_dropzone').removeClass('hidden');
  });
});
