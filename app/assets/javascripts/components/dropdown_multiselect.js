$(document).ready(function() {
  $('.multiselect').multiselect({
    includeSelectAllOption: true
  });

  $('select.multiselect').change(function() {
    sendRequest($(this));
  });

});

function sendRequest(className) {
 var dataToSend = $('.multiselect').serialize();
 console.log(dataToSend);
 var url = window.location.href + '/update_users';
 $.ajax({
   type:'GET',
   url: url,
   data: dataToSend,
   success:function(data) {
     console.log(data);
   }
 });
}