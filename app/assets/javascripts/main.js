jQuery(document).ready(function() {
  $('.menu_drop').click(function() {
    $(this).parent().find('ul').toggle('slow');
  });

  $('.title_message').click(function() {
    $(this).parent().find('.content_form').toggle('slow');
  });
});
