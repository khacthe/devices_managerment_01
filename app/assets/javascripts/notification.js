$(document).ready(function(){
  (function() {
    App.notifications = App.cable.subscriptions.create({
      channel: 'NotificationsChannel'
    },
    {
      connected: function() {},
      disconnected: function() {},
      received: function(data) {
        $('#show_notifition_'+data['user_id']).prepend('<li class="read_false">'
        + '<a href="'+ data['link'] +'" data-id="'+ data['id']+'">'
        + data['notification'] + '</a></li>');
        return this.update_counter(data['user_id']);
      },
      update_counter: function(user_id) {
        var $counter, val;
        $counter = $('#badge-dange_'+ user_id);
        val = parseInt($counter.text());
        val++;
        $counter.text(val);
      }
    });
  }).call(this);
});
