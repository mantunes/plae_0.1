/**
 * Anonymous self-running closure to avoid polluting the global namespace with
 * definitions that should be kept private.
 */
+function() {

  /**
   * Publicly accessible functions related to the reports rails
   * controller.
   * These can be called from anywhere like this:
   *   r.reports.function_name(arg1, arg2);
   *
   * You can declare your javascript controllers inside this namespace. They
   * should have the same name as your rails actions, but starting with an
   * underscore (so for the show action, the corresponding function would be
   * named _show).
   *
   * They will be called automatically by reins every time the corresponding
   * action renders an HTML view, or manually from a js.erb view by using the
   * call_reins_controller helper.
   */
  window.r.reports = {

    /**
     * Controller action corresponding to the #new rails action.
     *
     * This function is called on $.ready or page:load every time that the
     * "new" action renders an html view.
     */
    _index: function(params) {
      exporting();
      bar_chart(params);
      pie_chart(params);

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
     },


    /**
     * Controller action corresponding to the #show rails action.
     *
     * This function is called on $.ready or page:load every time that the
     * "show" action renders an html view.
     */
    // _show: function(params) {
    //   this.my_function(params.name);
    // },


    /**
     * You can also declare your own functions here.
     *
     * Call this one from anywhere like this:
     *   r.reports.my_function('John Doe');
     * Or from inside this namespace with:
     *   this.my_function('John Doe');
     */
    // my_function: function(name) {
    //   my_function2('Have a nice day ' + name + '!');
    // }

  };



  ////////////////////////////////////////////////////////////////////////////
  // Anything below this but still inside the anonymous function is private //
  ////////////////////////////////////////////////////////////////////////////

  /**
   * This is a private function. It can be called by any function inside this
   * closure, including the controllers above, but it's invisible to the outside
   * world.
   *
   * It can be called from anywhere inside this closure like this:
   *   my_function2('Hi there!');
   * It cannot be called from anywhere else.
   */
  function exporting() {
    var url = window.location.href;
    url_pdf = url.replace("reports", "reports.pdf");
    url_csv = url.replace("reports", "reports.csv");
    $('#pdf_export').attr("href", url_pdf);
    $('#csv_export').attr("href", url_csv);
  }

  function pie_chart(params) {
    var chart = new AmCharts.AmPieChart();
    chart.valueField = "total_time";
    chart.titleField = "name";
    chart.dataProvider = JSON.parse(params);
    chart.balloonText = "";
    chart.write("piechartdiv");
  }

  function bar_chart(params){
    var chart = new AmCharts.AmSerialChart();

    chart.dataProvider = JSON.parse(params);
    chart.categoryField = "name";
    chart.startDuration = 1;
    // category
    var categoryAxis = chart.categoryAxis;
    categoryAxis.labelRotation = 90;
    categoryAxis.gridPosition = "start";
    // value
    var valueAxis = new AmCharts.ValueAxis();
    valueAxis.duration = "ss";
    valueAxis.durationUnits = {DD:'d. ', hh:':', mm:':',ss:''};
    valueAxis.axisAlpha = 1;
    valueAxis.gridAlpha = 0;
    valueAxis.stackType = "regular";
    chart.addValueAxis(valueAxis);
    // graph
    var graph = new AmCharts.AmGraph();
    graph.valueField = "total_time";
    graph.balloonText = "[[category]]: [[value]]";
    graph.type = "column";
    graph.lineAlpha = 0;
    graph.fillAlphas = 0.7;
    chart.addGraph(graph);
    chart.write("chartdiv");
  }

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

}();
