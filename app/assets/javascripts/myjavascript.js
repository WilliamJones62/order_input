  $(document).ready(function() {

    $('#listtab').DataTable({
      scrollY: "30vh",
      scrollCollapse: true,
      paging: false,
      autoWidth: true,
      responsive: true,
      retrieve: true
    });

  });
