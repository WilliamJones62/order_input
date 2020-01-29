function getData(data) {
  var p1 = data.replace('[', "");
  var p2 = p1.replace(']', "");
  p1 = p2.replace(/"/g, "");
  p2 = p1.replace(/,/g, "");
  var data_array = p2.split(" ");
  data_array.shift();
  data_array.pop();
  return data_array;
}

function custName() {
  //* find customer matches with value in the customer code field
  var prefix = document.getElementById("custcode");
  var cust_prefix = prefix.value;
  var i = 0;
  var text = ' ';
  if (cust_prefix.length == 0 || !cust_prefix.trim()) {
    //* if the custcode prefix is now empty go back to customer list
    var names = document.getElementById("allnames").innerHTML;
    var names_array = getData(names);
    var name = document.getElementById("custname");
    name.options.length = 0;
    var o = document.createElement("option");
    o.selected = true;
    var arraylength = names_array.length;
    for (i = 0; i < arraylength; i++) {
      text = names_array[i].replace(/~/g, ' ');
      o.text = text.replace(/&amp;/g, '&');
      name.options.add(o, name.options.length);
      o.selected = false;
      o = document.createElement("option");
    }
  } else {
    //* Use custcode prefix to get list of names
    var custs = document.getElementById("allcusts").innerHTML;
    var custs_array = getData(custs);
    var names = document.getElementById("allnames").innerHTML;
    var names_array = getData(names);
    var name = document.getElementById("custname");
    name.options.length = 0;
    var o = document.createElement("option");
    o.selected = true;
    var arraylength = custs_array.length;
    var pos = 0;
    for (i = 0; i < arraylength; i++) {
      pos = custs_array[i].search(cust_prefix);
      if (pos == 0) {
      //* the cust code starts with the prefix entered by the user
        text = names_array[i].replace(/~/g, ' ');
        o.text = text.replace(/&amp;/g, '&');
        name.options.add(o, name.options.length);
        o.selected = false;
        o = document.createElement("option");
      }
    }
  }
}
function partDescriptions(id) {
  //* find matches for partcodes begining with value in part code field
  var prefix = document.getElementById(id);
  var part_prefix = prefix.value;
  var i = 0;
  if (part_prefix.length == 0 || !part_prefix.trim()) {
    //* if the partcode prefix is now empty go back to existing part list for this customer
    var descs = document.getElementById("descs").innerHTML;
    var descs_array = getData(descs);
    var desc = id.replace("partcode", "partdesc");
    var description = document.getElementById(desc);
    description.options.length = 0;
    var o = document.createElement("option");
    o.selected = true;
    var arraylength = descs_array.length;
    for (i = 0; i < arraylength; i++) {
      o.text = descs_array[i].replace(/~/g, ' ');
      description.options.add(o, description.options.length);
      o.selected = false;
      o = document.createElement("option");
    }
  } else {
    //* Use partcode prefix to get list of descriptions
      var descs = document.getElementById("alldescs").innerHTML;
      var descs_array = getData(descs);
      var codes = document.getElementById("allcodes").innerHTML;
      var codes_array = getData(codes);
      var u = id.replace("partcode", "uom");
      var uom = document.getElementById(u);
      uom.value = ' ';
      var desc = id.replace("partcode", "partdesc");
      var description = document.getElementById(desc);
      description.options.length = 0;
      var o = document.createElement("option");
      o.selected = true;
      var arraylength = descs_array.length;
      for (i = 0; i < arraylength; i++) {
        var pos = codes_array[i].search(part_prefix);
        if (pos == 0) {
        //* the part code starts with the prefix entered by the user
          o.text = descs_array[i].replace(/~/g, ' ');
          description.options.add(o, description.options.length);
          o.selected = false;
          o = document.createElement("option");
        }
      }
      var y = document.getElementById(desc).options;
      //* get description of first select element
      var desc_text = y['0'].text;
      var descs = document.getElementById("alldescs").innerHTML;
      var descs_array = getData(descs);
      var uoms = document.getElementById("alluoms").innerHTML;
      var uoms_array = getData(uoms);
      var arraylength = descs_array.length;
      var array_desc = ' ';
      for (i = 0; i < arraylength; i++) {
        //* find uom for first description
        array_desc = descs_array[i].replace(/~/g, ' ');
        if (array_desc == desc_text) {
          uom.value = uoms_array[i];
          break;
        }
      }

    }
  }

  function dateRequired() {
    var today = new Date();
    var format_today = today.getFullYear() + "-" + ("0"+(today.getMonth()+1)).slice(-2) + "-" + ("0" + today.getDate()).slice(-2);
    var tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);
    var format_tomorrow = tomorrow.getFullYear() + "-" + ("0"+(tomorrow.getMonth()+1)).slice(-2) + "-" + ("0" + tomorrow.getDate()).slice(-2);
    if ($('#fs_order_second_run').is(":checked")) {
      document.getElementById("fs_order_date_required").value = format_today;
    } else {
      document.getElementById("fs_order_date_required").value = format_tomorrow;
    }
  }

  function partUoms(id) {
    var p = id.replace("partdesc", "partcode");
    var prefix = document.getElementById(p);
    var u = id.replace("partdesc", "uom");
    var uom = document.getElementById(u);
    var part_prefix = prefix.value;
    if (part_prefix.length == 0 || !part_prefix.trim()) {
      //* work out UOM for previously bought parts
      var desc = document.getElementById(id);
      var uoms = document.getElementById("uoms").innerHTML;
      var uoms_array = getData(uoms);
      uom.value = uoms_array[desc.selectedIndex];
      if (uom.value == '~') {
        uom.value = ' ';
      }
    } else {
      //* figure out the UOM for new parts.
      var x = document.getElementById(id).selectedIndex;
      var y = document.getElementById(id).options;
      var desc = y[x].text;
      var descs = document.getElementById("alldescs").innerHTML;
      var descs_array = getData(descs);
      var uoms = document.getElementById("alluoms").innerHTML;
      var uoms_array = getData(uoms);
      var arraylength = descs_array.length;
      var array_desc = ' ';
      uom.value = ' ';
      for (i = 0; i < arraylength; i++) {
        array_desc = descs_array[i].replace(/~/g, ' ');
        if (array_desc == desc) {
          uom.value = uoms_array[i];
          break;
        }
      }
    }
  }
