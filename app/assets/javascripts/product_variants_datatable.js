"use strict";
const ProductVariantsDatatable = function() {
  $.fn.dataTable.Api.register('column().title()', function() {
    return $(this.header()).text().trim();
  });

  const renderProductVariantsDataTable = function() {
    const table_element = $('#product_variants_datatable')

    if (!$('#product_variants_datatable')) {
      return true;
    }
    // begin first table
    const table = table_element.DataTable({
      responsive: true,
      dom: `<'row'<'col-sm-12'tr>>
      <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
      lengthMenu: [10, 25, 50, 100],
      pageLength: 10,
      language: {
        lengthMenu: 'Display _MENU_ variants',
        emptyTable: "No variants found.",
        info: "Showing _START_ to _END_ of _TOTAL_ variants",
        processing: "Processing...",
        infoEmpty: "No variants found.",
        zeroRecords: "No matching variants found",
        infoFiltered:  "(filtered from _MAX_ total variants)",
      },
      searchDelay: 150,
      processing: true,
      serverSide: true,
      ajax: table_element.data('source'),
      pagingType: "full_numbers",
      columns: [
        {data: "title"},
        {data: "sku"},
        {data: "inventory_quantity"}
      ],
        columnDefs: [
          {
            targets: 0,
            title: 'Variant',
            orderable: true,
            render: function(data, type, full, meta) {
              return `
                <a href="/admin/products/${full.product_id}/variants/${full.id}">
                  <div class="kt-user-card-v2">
                      <div class="kt-user-card-v2__pic">
                          <img src="${full.image_url}" class="img-thumbnail kt-marginless" alt="photo">
                      </div>
                      <div class="kt-user-card-v2__details">
                          <span class="kt-user-card-v2__name">` + full.title + `</span>
                      </div>
                  </div>
                </a>
              `;
            }
          }
        ]
    });

  };

  return {

    //main function to initiate the module
    init: function() {
      renderProductVariantsDataTable();
    }
  };
}();

jQuery(document).ready(function() {
  ProductVariantsDatatable.init();
});