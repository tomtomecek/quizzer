$(document).on('click', '#paid', function() {
  $('fieldset.credit_card').slideDown('slow');
});

$(document).on('click', '#free', function() {
  $('fieldset.credit_card').slideUp('slow');
});


$(document).on('submit', '#new_enrollment', function(event) {
  var $form = $(this);
  alert("ready - from form submission");
  $form.find('#button-submit').prop('disabled', true);
  Stripe.card.createToken($form, stripeResponseHandler);
  return false;
});

function stripeResponseHandler(status, response) {
  var $form = $('#new_enrollment');

  alert("ready - from stripeResponseHandler");
  if (response.error) {
    $form.find('.payment-errors').text(response.error.message);
    $form.find('#button-submit').prop('disabled', false);
  } else {
    var token = response.id;
    $form.append($('<input type="hidden" name="stripe_token" />').val(token));
    $form.get(0).submit();
  }
};