$(document).on('turbolinks:load', function() {
  loadGists();
});

function loadGists() {
  $.each($('.gist'), function(index, value) {
    $(value).removeClass('gist');
    var gistId = $(value).data('gistId');
    var linkId = $(value).data('linkId');

    $.ajax({
      url: `https://api.github.com/gists/${gistId}`,
      type: 'GET',
      success: function(result) {
        $.each(result.files, function(index, file) {
          $(`#${linkId}_${gistId}`).append(`<p>${file.filename}</p><p>${file.content}</p>`)
        });
      },
      error: function(error) {
        console.log(error)
      }
    })
  });
}

