jQuery(document).ready(function() {
  $('.menu_drop').click(function() {
    $(this).parent().find('ul').toggle('slow');
  });

  $('.title_message').click(function() {
    $(this).parent().find('.content_form').toggle('slow');
  });
});
jQuery(document).ready(function(){
  var nowTemp = new Date();
  var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(),
    nowTemp.getDate(), 0, 0, 0, 0);
  var date_from = $('.date_from').datepicker({
    format: 'dd/mm/yyyy',
    onRender: function(date){
      return date.valueOf() < now.valueOf() ? 'disabled' : '';
    }
  }).on('changeDate', function(ev){
    var newDate = new Date(ev.date)
    newDate.setDate(newDate.getDate() + 1);
    date_to.setValue(newDate);
    date_from.hide();
    $('.date_to')[0].focus();
  }).data('datepicker');
  var date_to = $('.date_to').datepicker({
    format: 'dd/mm/yyyy',
    onRender: function(date) {
      return date.valueOf() <= date_from.date.valueOf() ? 'disabled' : '';
    }
  }).on('changeDate', function(ev){
    date_to.hide();
  }).data('datepicker');
});
