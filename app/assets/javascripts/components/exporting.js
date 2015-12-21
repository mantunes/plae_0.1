$(document).ready(function() {
  var url = window.location.href;
  url_pdf = url.replace("reports", "reports.pdf");
  url_csv = url.replace("reports", "reports.csv");
  $('#pdf_export').attr("href", url_pdf);
  $('#csv_export').attr("href", url_csv);
})