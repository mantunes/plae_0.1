$(document).ready(function() {
  $('.multiselect').multiselect({
    includeSelectAllOption: true,
    disableIfEmpty: true,
    buttonWidth: '200px'
  });

  $('.projectMultiselect').multiselect({
    disableIfEmpty: true,
    buttonWidth: '200px'
  });

  $('#project-div ul li:eq(0)').after('<li class="divider"></li>');
  $('#organization-div ul li:eq(0)').after('<li class="divider"></li>');

  var projectOptions = $('#project-div [value!="Without Project"][type="checkbox"]');
  var withoutProject = $('input[value="Without Project"]');

  withoutProject.click(function() {
    if($(this).prop("checked") == true) {
      $('.projectMultiselect').multiselect('deselectAll', true);
      withoutProject.prop('checked', true)
      projectOptions.prop('disabled', true);
    }
    else if($(this).prop("checked") == false){
      projectOptions.prop('disabled', false);
      selectAll.prop('disabled', false);
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