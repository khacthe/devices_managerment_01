jQuery(document).ready(function() {
  $('.menu_drop').click(function() {
    $(this).parent().find('ul').toggle('slow');
  });
});
