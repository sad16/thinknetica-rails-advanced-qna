$(document).on('turbolinks:load', function() {
  onAjaxSuccessSearch($('#questions-search-form'), questionTemplate);
  onAjaxSuccessSearch($('#answers-search-form'), answerTemplate);
  onAjaxSuccessSearch($('#comments-search-form'), commentTemplate);
  onAjaxSuccessSearch($('#users-search-form'), userTemplate);
});

function onAjaxSuccessSearch(form, template) {
  $(form)
    .on('ajax:success', function(response) {
      successSearch(response, template);
    })
    .on('ajax:error', function(response) {
      errorSearch(response);
    })
}

function successSearch(response, template) {
  var resultBlock = $('.result');
  resultBlock.html('');

  var data = response.detail[0].data;

  if (data.length !== 0) {
    $.each(data, function(index, item) {
      resultBlock.append(template(item));
    });
  } else {
    resultBlock.html('No result')
  }

  clearForm(response.currentTarget);
}
