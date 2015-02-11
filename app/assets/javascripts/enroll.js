$(document).on('click', '#paid', function() {
  $('fieldset.credit_card').slideDown('slow');
});

$(document).on('click', '#free', function() {
  $('fieldset.credit_card').slideUp('slow');
});