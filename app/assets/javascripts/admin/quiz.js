ready = function() {
  $('[data-toggle=popover]').popover('show');

  $('form').on('click', '.remove_fields', function(e) {
    var fieldset = $(this).closest('fieldset');
    fieldset.prev('input[type=hidden]').val('1');
    fieldset.fadeOut(function() {
      $(this).remove();
    });
    e.preventDefault();
  });

  $('form').on('click', '.add_fields', function(e) {
    $('form').parsley().destroy();
    var id       = $(this).data('id');
    var time     = new Date().getTime();
    var regexp   = new RegExp(id, 'g');
    var inserter = $(this).closest('.form-group').prev('.inserter');
    inserter.before($(this).data('fields').replace(regexp, time));
    $('form').parsley();
    e.preventDefault();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);