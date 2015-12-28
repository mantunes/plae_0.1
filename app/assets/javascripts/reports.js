$(document).ready(function() {
  var chart = new AmCharts.AmSerialChart();
  var chartData = $('.temp_information').data('temp')

  chart.dataProvider = chartData;
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
  valueAxis.stackType = "regular"; // we use stacked graphs to make color fills
  chart.addValueAxis(valueAxis);
  // GRAPH
  var graph = new AmCharts.AmGraph();
  graph.valueField = "total_time";
  graph.balloonText = "[[category]]: [[value]]";
  graph.type = "column";
  graph.lineAlpha = 0;
  graph.fillAlphas = 0.7;
  chart.addGraph(graph);
  chart.write("chartdiv");

  var chart = new AmCharts.AmPieChart();
  chart.valueField = "total_time";
  chart.titleField = "name";
  chart.dataProvider = chartData;
  chart.write("piechartdiv");
});