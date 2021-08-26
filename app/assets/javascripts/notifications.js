$(document).on('turbolinks:load', function() {
  onAjaxSuccessSubscribeNotification($('.subscribe-notification-link'));
  onAjaxSuccessUnsubscribeNotification($(`.unsubscribe-notification-link`));
});

function onAjaxSuccessSubscribeNotification(elem) {
  $(elem)
    .on('ajax:success', function(response) {
      successSubscribeNotification(response, this);
    })
    .on('ajax:error', function(response) {
      errorSubscribeNotification(response, this);
    })
}

function successSubscribeNotification(response, elem) {
  var notification = response.detail[0]['notification'];
  var notificationBlock = $(elem).closest('.notification');
  insertUnsubscribeNotificationLink(notification, notificationBlock);
  onAjaxSuccessUnsubscribeNotification(notificationBlock.find('.unsubscribe-notification-link'));
}

function insertUnsubscribeNotificationLink(notification, notificationBlock) {
  var unsubscribeNotificationLink = `<p><a class="unsubscribe-notification-link" rel="nofollow" data-method="delete" data-remote="true" href="/notifications/${notification.id}">Unsubscribe</a></p>`
  notificationBlock.html(unsubscribeNotificationLink);
}

function onAjaxSuccessUnsubscribeNotification(elem) {
  $(elem).on('ajax:success', function(response) {
    successUnsubscribeNotification(response, this);
  });
}

function successUnsubscribeNotification(response, elem) {
  var notification = response.detail[0]['notification'];
  var notificationBlock = $(elem).closest('.notification');
  insertSubscribeNotificationLink(notification, notificationBlock);
  onAjaxSuccessSubscribeNotification(notificationBlock.find('.subscribe-notification-link'));
}

function insertSubscribeNotificationLink(notification, notificationBlock) {
  var subscribeNotificationLink = `<p><a class="subscribe-notification-link" rel="nofollow" data-method="post" data-remote="true" href="/questions/${notification.question_id}/notifications">Subscribe</a></p>`
  notificationBlock.html(subscribeNotificationLink);
}

function errorSubscribeNotification(response, elem) {
  var errors = response.detail[0]['errors'];
  var notificationBlock = $(elem).closest('.notification');
  notificationBlock.append(errors);
}