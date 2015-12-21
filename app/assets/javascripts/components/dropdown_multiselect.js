$(document).ready(function() {
  $('.multiselect').multiselect({
    includeSelectAllOption: true,
    disableIfEmpty: true,
    buttonWidth: '200px'
  });
   $('.projectMultiselect').multiselect({
    buttonWidth: '200px',
    disableIfEmpty: true
  });

  $('#project-div label:eq(1)').css("font-weight", "bold");
  $('#project-div ul li:eq(1)').after('<li class="divider"></li>');
  $('#organization-div ul li:eq(0)').after('<li class="divider"></li>');

  var projectOptions = $('#project-div input[value!=""][type="checkbox"]');
  var selectAllInput = $('#project-div input:eq(0)');

  selectAllInput.click(function(){
    if($(this).prop("checked") == true) {
      projectOptions.prop('checked', true);
    }else if($(this).prop('checked') == false){
      projectOptions.prop('checked', false);
    }
  });

  $('#project-div input:eq(1)').click(function() {
    if($(this).prop("checked") == true) {
      projectOptions.prop('checked', false);
      projectOptions.prop('disabled',true);
      $('#project-div input:eq(0)').prop('disabled',true);
      $('#project-div input:eq(0)').prop('checked',false);
    }
    else if($(this).prop("checked") == false){
      projectOptions.prop('disabled', false);
      $('#project-div input:eq(0)').prop('disabled',false);
    }
  });

  $('select.multiselect.updatable').change(function() {
    sendRequest($(this));
  });
});

function sendRequest(className) {
  var dataToSend = className.serialize();
  var url = '/reports'+ '/update_users';
  $.ajax({
    type:'GET',
    url: url,
    data: dataToSend,
    success:function(data) {
      updateUsersDropdown(data);
    }
  });
}

function updateUsersDropdown(data) {
  var elements = data.elements;
  var usersSelector = $('#users');
  usersSelector.empty();

  for (i = 0; i < elements.length ; i++) {
    var opt = $('<option/>');
    opt.attr('value', elements[i][0]);
    opt.text(elements[i][1]);
    opt.appendTo(usersSelector);
  }
  usersSelector.multiselect('rebuild');
  $('#user-div ul li:eq(0)').after('<li class="divider"></li>');

}