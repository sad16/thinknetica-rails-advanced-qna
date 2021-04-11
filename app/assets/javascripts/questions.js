$(document).on('turbolinks:load', function(){
  $('.question-container').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).addClass('hidden');
    var questionId = $(this).data('questionId');
    $('form#edit-question-form-' + questionId).removeClass('hidden');
  })
});
