  $(document).ready(function() {

    $('#not_called').DataTable({
      scrollY: "35vh",
      scrollCollapse: true,
      paging: false,
      autoWidth: true,
      responsive: true,
      retrieve: true,
      dom: 'Bfrtip',
      buttons: [
        {
        extend: 'print',
        title: 'Not Contacted This Week'
        }
      ]
    });

    $('#not_ordered').DataTable({
      scrollY: "35vh",
      scrollCollapse: true,
      paging: false,
      autoWidth: true,
      responsive: true,
      retrieve: true,
      dom: 'Bfrtip',
      buttons: [
        {
        extend: 'print',
        title: 'Not Ordered This Week'
        }
      ]
    });

    $('#normal_dt').DataTable({
      scrollY: "30vh",
      scrollCollapse: true,
      paging: false,
      autoWidth: true,
      responsive: true,
      retrieve: true,
      columnDefs: [ {
          targets: [ 0 ],
          orderData: [ 0, 1 ]
      }, {
          targets: [ 1 ],
          orderData: [ 1, 0 ]
      }, {
          targets: [ 4 ],
          orderData: [ 4, 0 ]
      } ],
      dom: 'Bfrtip',
      buttons: [
        {
        extend: 'print',
        }
      ]
    });

    $('#listtab').DataTable({
      scrollY: "30vh",
      scrollCollapse: true,
      paging: false,
      autoWidth: true,
      responsive: true,
      retrieve: true
    });

  });
