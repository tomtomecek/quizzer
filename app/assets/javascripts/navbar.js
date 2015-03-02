$(window).on('scroll', function() {
  var scroll = $(window).scrollTop();

  if (scroll >= 80) {
    $('nav').addClass('fix-bar');
  } else {
    $('nav').removeClass('fix-bar');
  }
});
