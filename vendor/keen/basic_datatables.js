"use strict";
var KTDatatablesBasicBasic = function() {

  var initTable1 = function() {
    var table = $('#order_datatable');
    if (!table) {
      console.log("could not find basic datatable")
      return true;
    }
    // begin first table
    table.dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": table.data('source'),
      "pagingType": "full_numbers",
      "columns": [
        {"data": "id"},
        {"data": "date"},
        {"data": "financial_status"},
        {"data": "fulfillment_status"},
      ]
      });
  };

  return {

    //main function to initiate the module
    init: function() {
      initTable1();
    }
  };
}();

jQuery(document).ready(function() {
  KTDatatablesBasicBasic.init();
});