$(document).ready(function() {
  var t = 4000;

  $('.ta-leaf em').delay('2000').fadeIn(3000);
  $('.ta-leaf ul > li:nth-child(1n)').each(function() {
    t += 2000;
    return $(this).delay(t).fadeIn(2000);
  });
});
