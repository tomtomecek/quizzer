var ready = function() {
  $('[data-toggle=popover]').popover('show');

  $('form').on('click', '.remove_fields', function(e) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').remove();
    e.preventDefault();
  });

  $('form').on('click', '.add_fields', function(e) {
    var id = $(this).data('id');
    var time = new Date().getTime();
    var regexp = new RegExp(id, 'g');
    var inserter = $(this).closest('.form-group').prev('.inserter');
    inserter.before($(this).data('fields').replace(regexp, time));
    e.preventDefault();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);