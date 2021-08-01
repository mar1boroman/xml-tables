function enableSearch(element, tableID = "XMLTable") {
  var value = $(element).val().toLowerCase();

  $("#" + tableID + " tbody tr").filter(function () {
    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
  });
}

function exportHTMLTableToCSV(tableID = "XMLTable", separator = ",") {
  //Select table records
  var records = document.querySelectorAll("table#" + tableID + " tr");

  // Build CSV String
  var csv = [];
  console.log(records);
  for (var i = 0; i < records.length; i++) {
    var record = [];
    var cols = records[i].querySelectorAll("td, th");

    for (var j = 0; j < cols.length; j++) {
      // Removing newlines and condensing multiple spaces to one
      var data = cols[j].innerText
        .replace(/(\r\n|\n|\r)/gm, "")
        .replace(/(\s\s)/gm, " ");

      // Escape double-quotes
      data = data.replace(/"/g, '""');

      // Double quoted escaped column value
      record.push('"' + data + '"');
    }

    csv.push(record.join(separator));
  }

  var csvBlob = csv.join("\n");
  var filename =
    document.baseURI
      .split(/(\\|\/)/g)
      .pop()
      .split(/(\.)/g)[0] + ".csv";

  downloadCSVFile(csvBlob, filename);
}

function downloadCSVFile(csvBlob, filename) {
  var downloadLink = document.createElement("a");
  downloadLink.style.display = "none";
  downloadLink.setAttribute("target", "_blank");
  downloadLink.setAttribute(
    "href",
    "data:text/csv;charset=utf-8," + encodeURIComponent(csvBlob)
  );
  downloadLink.setAttribute("download", filename);
  document.body.appendChild(downloadLink);
  downloadLink.click();
  document.body.removeChild(downloadLink);
}
