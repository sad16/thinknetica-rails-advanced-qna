$(document).on('turbolinks:load', function() {
  onAjaxSuccessGlobalSearch($('#global-search-form'));
});

function onAjaxSuccessGlobalSearch(form) {
  $(form)
    .on('ajax:success', function(response) {
      successGlobalSearch(response);
    })
    .on('ajax:error', function(response) {
      errorSearch(response);
    })
}

function successGlobalSearch(response) {
  var resultBlock = $('.result');
  resultBlock.html('');

  var data = response.detail[0];

  if (data.length !== 0) {
    $.each(data, function(index, wrapper) {
      var item = wrapper.wrapper;
      var type = Object.keys(item)[0];
      var data = Object.values(item)[0];

      resultBlock.append(getTemplate(type, data));
    });
  } else {
    resultBlock.html('No result')
  }

  clearForm(response.currentTarget);
}

function getTemplate(type, data) {
  switch (type) {
    case 'question':
      var template = questionTemplate(data)
      break;
    case 'answer':
      var template = answerTemplate(data)
      break;
    case 'comment':
      var template = commentTemplate(data)
      break;
    case 'user':
      var template = userTemplate(data)
      break;
  }

  return template;
}
