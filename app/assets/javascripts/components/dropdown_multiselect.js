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

  var projectOptions = $('#project-div input[value!="Select all"][value!="Without Project"][type="checkbox"]');
  var withoutProject = $('input[value="Without Project"]');
  var selectAll = $('input[value="Select all"]');


  selectAll.click(function(){
    if($(this).prop("checked") == true) {
      projectOptions.prop('checked', true);
    }else if($(this).prop('checked') == false){
      projectOptions.prop('checked', false);
    }
  });

  projectOptions.click(function() {
    if(selectAll.prop("checked") == true) {
      selectAll.prop("checked", false);
    }
  });

  withoutProject.click(function() {
    if($(this).prop("checked") == true) {
      projectOptions.prop('checked', false);
      projectOptions.prop('disabled',true);
      selectAll.prop('checked', false);
      selectAll.prop('disabled', true);
    }
    else if($(this).prop("checked") == false){
      projectOptions.prop('disabled', false);
      selectAll.prop('disabled',false);
    }
    console.log(projectOptions);
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