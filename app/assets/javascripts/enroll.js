function showCreditCardFields(arg) {
  var $creditCard = $('fieldset.credit_card');
  if (arg) {
    $creditCard.slideDown('slow');
  } else {
    $creditCard.slideUp('slow');
  }
  $('#stripeSubmit, input[type=submit]').remove();
}

function handleStripeToken(form, token) {
  var $tokenField = form.find('input[name=stripeToken]');
  if ($tokenField.size()) {
    $tokenField.val(token);
  } else {
    var $newTokenField = $('<input type=hidden name=stripeToken />').val(token);
    form.append($newTokenField);
  }
}

function submitEnrollment(form) {
  var $paidSubmitButton = $('<input style="display: none" type=submit />');
  form.append($paidSubmitButton);
  $paidSubmitButton.trigger('click');
  $paidSubmitButton.remove();
  $('#stripeSubmit').prop('disabled', false);
}

function stripeResponseHandler(status, response) {
  var $form = $('#new_enrollment');
  var $errors = $form.find('.payment-errors');

  if (response.error) {
    $errors.slideDown();
    $errors.text(response.error.message);
    $('#stripeSubmit').prop('disabled', false);
  } else {
    $errors.slideUp();
    handleStripeToken($form, response.id);
    submitEnrollment($form);
  }
}

$(document).on('click', '#paid', function() {
  var $paidButton = $('<button type=button class="btn btn-primary btn-lg btn-tealeaf" id="stripeSubmit"><span class="glyphicon glyphicon-certificate"></span>Enroll now!</button>');
  showCreditCardFields(true);
  $('.modal-footer').append($paidButton);
});

$(document).on('click', '#free', function() {
  var $freeButton = $('<input class="btn btn-default btn-lg" name="commit" type="submit" value="Enroll now!">');
  showCreditCardFields(false);
  $('input[name=stripeToken]').remove();
  $('.modal-footer').append($freeButton);
});

$('fieldset.credit_card').on('keydown', function(event) {
  if (event.keyCode == 13) {
    event.preventDefault();
    $('#stripeSubmit').trigger('click');
  }
});

$(document).on('click', '#stripeSubmit', function(event) {
  var $form = $(this).closest('form');
  $(this).prop('disabled', true);
  Stripe.card.createToken($form, stripeResponseHandler);
  event.preventDefault();
});

$(document).on('click', 'button[data-dismiss=modal]', function() {
  $('body').removeClass('modal-open');
  $('.modal').remove();
  $('html, body').animate({
     scrollTop: $(".navbar").offset().top
  }, 2000);
});
