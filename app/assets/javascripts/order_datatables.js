"use strict";
var KTDatatablesBasicBasic = function() {
  $.fn.dataTable.Api.register('column().title()', function() {
    return $(this.header()).text().trim();
  });

  var renderOrderDataTable = function() {
    var table_element = $('#order_datatable')

    if (!$('#order_datatable')) {
      return true;
    }
    // begin first table
    var table = table_element.DataTable({
      responsive: true,
      dom: `<'row'<'col-sm-12'tr>>
      <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
      lengthMenu: [10, 25, 50, 100],
      pageLength: 10,
      language: {
        lengthMenu: 'Display _MENU_ orders',
        emptyTable: "No orders found.",
        info: "Showing _START_ to _END_ of _TOTAL_ orders",
        processing: "Processing...",
        infoEmpty: "No orders found.",
        zeroRecords: "No matching orders found",
        infoFiltered:  "(filtered from _MAX_ total orders)",
      },
      searchDelay: 150,
      processing: true,
      serverSide: true,
      ajax: table_element.data('source'),
      pagingType: "full_numbers",
      columns: [
        {data: "store_name"},
        {data: "number"},
        {data: "date"},
        {data: "financial_status"},
        {data: "fulfillment_status"},
        {data: "actions"}
      ],
      order: [[ 2, "desc" ]],
      initComplete: function() {
        this.api().columns().every(function() {
          var column = this;
          switch (column.title()) {
            case 'Store':
              var array = ["Kigurumi", "Kigurumi USA"];
              array.forEach(function(value) {
                $('.kt-input[data-col-index="0"]').append('<option value="' + value + '">' + value + '</option>');
              });
              break;

            case 'Financial Status':
              var values_object = {
                'Pending': 'pending',
                'Authorized': 'authorized',
                'Partially paid': 'partially_paid',
                'Paid': 'paid',
                'Partially refunded': 'partially_refunded',
                'Refunded': 'refunded',
                'Voided': 'voided'
              };
              Object.keys(values_object).forEach(function(k) {
                $('.kt-input[data-col-index="3"]').append('<option value="' + values_object[k] + '">' + k + '</option>');
              });
              break;

            case 'Fulfillment Status':
              var values_object = {
                'Fulfilled': 'fulfilled',
                'Partial': 'partial',
                'Unfulfilled': 'unfulfilled'
              };
              Object.keys(values_object).forEach(function(k) {
                $('.kt-input[data-col-index="4"]').append('<option value="' + values_object[k] + '">' + k + '</option>');
              });
              break;
          }
        });
      },
      columnDefs: [
        {
          targets: -1,
          title: 'Actions',
          orderable: false,
          render: function(data, type, full, meta) {
            return `
              <a href="${full.order_link}" target="_blank" class="btn btn-sm btn-clean btn-icon btn-icon-md" title="View in Shopify">
                <i class="la la-external-link"></i>
              </a>
            `;
          },
        },
        {
          targets: 3,
          render: function(data, type, full, meta) {
            var status = {
              'Pending': 'kt-badge--primary',
              'Authorized': 'kt-badge--metal',
              'Partially paid': 'kt-badge--primary',
              'Paid': 'kt-badge--success',
              'Partially refunded': 'kt-badge--primary',
              'Refunded': 'kt-badge--warning',
              'Voided': 'kt-badge--primary',
            };
            if (typeof status[data] === 'undefined') {
              return data;
            }
            return '<span class="kt-badge ' + status[data] + ' kt-badge--inline kt-badge--pill">' + data + '</span>';
          }
        },
        {
          targets: 4,
          render: function(data, type, full, meta) {
            var status = {
              'Fulfilled': 'kt-badge--success',
              'Unfulfilled': 'kt-badge--danger',
              'Partial': 'kt-badge--warning'
            };
            if (typeof status[data] === 'undefined') {
              return data;
            }
            return '<span class="kt-badge ' + status[data] + ' kt-badge--inline kt-badge--pill">' + data + '</span>';
          },
        }
      ]
    });

    var filter = function() {
      var val = $.fn.dataTable.util.escapeRegex($(this).val());
      table.column($(this).data('col-index')).search(val ? val : '', false, false).draw();
    };

    var asdasd = function(value, index) {
      var val = $.fn.dataTable.util.escapeRegex(value);
      table.column(index).search(val ? val : '', false, true);
    };

    $('#m_search').on('click', function(e) {
      e.preventDefault();
      var params = {};
      $('.kt-input').each(function() {
        var i = $(this).data('col-index');
        if (params[i]) {
          params[i] += '|' + $(this).val();
        }
        else {
          params[i] = $(this).val();
        }
      });
      $.each(params, function(i, val) {
        // apply search params to datatable
        table.column(i).search(val ? val : '', false, false);
      });
      table.table().draw();
    });

    $('#m_reset').on('click', function(e) {
      e.preventDefault();
      $('.kt-input').each(function() {
        $(this).val('');
        table.column($(this).data('col-index')).search('', false, false);
      });
      table.table().draw();
    });

    $('#m_datepicker').datepicker({
      todayHighlight: true,
      templates: {
        leftArrow: '<i class="la la-angle-left"></i>',
        rightArrow: '<i class="la la-angle-right"></i>',
      },
    });

  };

  return {

    //main function to initiate the module
    init: function() {
      renderOrderDataTable();
    }
  };
}();

jQuery(document).ready(function() {
  KTDatatablesBasicBasic.init();
});