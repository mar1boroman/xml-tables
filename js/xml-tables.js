$(document).ready(function () {
  const selection = "#selectionDetails";
  const homePageLink = "#homepage";
  const viz2Dlink = "#vizpage2D";
  const viz3Dlink = "#vizpage3D";
  const topDiv = "#svgdiv";
  const viz2D = "#viz2D";
  const viz3D = "#viz3D";
  const htmlTableID = "#xml-table";

  removeSVG(topDiv);

  $(viz2Dlink).click(function () {
    graph2D(topDiv, viz2D, createHierarchy(htmlTableID), selection);
  });
  $(viz3Dlink).click(function () {
    graph3D(topDiv, viz3D, createHierarchy(htmlTableID));
  });

  $(homePageLink).click(function () {
    removeSVG(topDiv);
  });

  // Generic functions for search and export
  $("#search-input").on("keyup", function () {
    enableSearch($(this), htmlTableID);
  });

  $("#btn-export-csv").click(function () {
    exportHTMLTableToCSV(htmlTableID);
  });

  $("#btn-export-json").click(function () {
    tableToJson(htmlTableID);
  });

  // Formatting columns
  iterateThroughClass(".node-type-badge");
});

function graph2D(topDiv, viz2D, jsonData, selectionDetails) {
  // Clean up and re-load

  removeSVG(topDiv);
  addSVG(viz2D);

  // Initialize variables
  const data = jsonData;
  const r = 5;
  const links = data.links.map((d) => Object.create(d));
  const nodes = data.nodes.map((d) => Object.create(d));
  var radius = r; // radius of the nodes
  var height = window.innerHeight ? window.innerHeight : $(window).height();
  var width = $(window).width();

  const svg = d3
    .select(topDiv)
    .append("svg")
    .attr("width", "100%")
    .attr("height", "100%")
    .attr("id", "xml-graph")
    .attr("viewBox", [0, 0, width, height])
    .style("cursor", "crosshair")
    .call(
      d3
        .zoom()
        .extent([
          [0, 0],
          [width, height],
        ])
        .scaleExtent([1, 8])
        .on("zoom", zoomed)
    );

  const simulation = d3
    .forceSimulation(nodes)
    .force(
      "link",
      d3
        .forceLink(links)
        .id((d) => d.id)
        .distance(15)
        .strength(0.5)
    )
    .force("collide", d3.forceCollide(radius * 2))
    .force("charge", d3.forceManyBody().strength(-25))
    .force("center", d3.forceCenter(width / 2, height / 2));

  const link = svg
    .append("g")
    .attr("stroke", "#fff")
    .attr("stroke-opacity", 0.1)
    .selectAll("line")
    .data(links)
    .join("line")
    .attr("stroke-width", 1);

  const node = svg
    .append("g")
    .attr("stroke", "#fff")
    .selectAll("circle")
    .data(nodes)
    .join("circle")
    .attr("r", radius)
    .attr("fill", nodeColor())
    .on("mouseover", handleMouseOver)
    .on("mouseout", handleMouseOut)
    .call(drag(simulation));

  //Adding interactivity to all circle nodes
  svg.selectAll("circle").attr("stroke-width", 0.4);

  //Redraw logic
  simulation.on("tick", () => {
    link
      .attr("x1", (d) => d.source.x)
      .attr("y1", (d) => d.source.y)
      .attr("x2", (d) => d.target.x)
      .attr("y2", (d) => d.target.y);

    node.attr("cx", (d) => d.x).attr("cy", (d) => d.y);
  });

  //Internal Functions used by the above code

  function drag(simulation) {
    function dragstarted(event) {
      if (!event.active) simulation.alphaTarget(0.3).restart();
      event.subject.fx = event.subject.x;
      event.subject.fy = event.subject.y;
    }

    function dragged(event) {
      event.subject.fx = event.x;
      event.subject.fy = event.y;
    }

    function dragended(event) {
      if (!event.active) simulation.alphaTarget(0);
      event.subject.fx = null;
      event.subject.fy = null;
    }

    return d3
      .drag()
      .on("start", dragstarted)
      .on("drag", dragged)
      .on("end", dragended);
  }

  function nodeColor() {
    const scale = d3.scaleOrdinal(d3.schemeTableau10);
    return (d) => scale(d.nodetype);
  }

  function zoomed({ transform }) {
    node.attr("transform", transform);
    link.attr("transform", transform);
  }

  function handleMouseOver(d, i) {
    // find the neighboring nodes
    var nodeNeighbors = links
      .filter((link) => {
        return (
          link.source.index === d.target.__data__.index ||
          link.target.index === d.target.__data__.index
        );
      })
      .map(function (link) {
        return link.source.index === d.target.__data__.index
          ? link.target.index
          : link.source.index;
      });

    //Set all the links and circles to opacity 0.2
    d3.selectAll("circle").style("opacity", 0.2);
    d3.selectAll("link").style("opacity", 0.2);

    //Highlight the neighboring nodes and increase radius
    d3.selectAll("circle")
      .filter(function (node) {
        return nodeNeighbors.indexOf(node.index) > -1;
      })
      .style("opacity", 1)
      .transition()
      .duration(1)
      .attr("r", r * 2);

    // Highlight the current node and increase radius
    d3.select(this)
      .style("opacity", 1)
      .transition()
      .duration(1)
      .attr("r", r * 2);

    //Add title / tooltip for current node
    d3.select(this)
      .append("title")
      .text((d) => {
        return JSON.stringify({
          objectuid: d.id,
          nodename: d.nodename,
          nodevalue: d.nodevalue,
          nodetype: d.nodetype,
        });
      });

    // Create and populate the bottom right selection details card
    let title = JSON.parse($(d.target.firstChild).text());
    $(selectionDetails).html(
      '<div id="infocard" class="card" style="width: 18rem;">' +
        '<div class="card-header">Selection Details</div>' +
        '<ul class="list-group list-group-flush">' +
        '<li class="list-group-item"> ObjectUID : ' +
        title.objectuid +
        "</li>" +
        '<li class="list-group-item">  Node Name: ' +
        title.nodename +
        "</li>" +
        '<li class="list-group-item"> Node Value : ' +
        title.nodevalue +
        "</li>" +
        '<li class="list-group-item"> Node Value : ' +
        title.nodetype +
        "</li>" +
        "</ul>" +
        "</div>"
    );
  }

  function handleMouseOut(d, i) {
    //Revert the opacities and radius for all nodes and links
    d3.selectAll("circle").style("opacity", 1);
    d3.selectAll("circle").transition().duration(1).attr("r", r);
    d3.selectAll("path").style("opacity", 1);

    //Remove the title / tooltip DOM element
    d3.select(this).select("title").remove();
  }
}

function graph3D(topDiv, viz3D, jsonData) {
  // Clean up and re-load - faster load

  removeSVG(topDiv);
  addSVG(viz3D);

  const targetDiv = $(topDiv)[0];

  const Graph = ForceGraph3D()(targetDiv)
    .graphData(jsonData)
    .nodeAutoColorBy("nodetype")
    .nodeLabel(
      (node) => `( ${node.nodetype} ) ${node.nodename}: ${node.nodevalue}`
    )
    .onNodeClick((node) => {
      // Aim at node from outside it
      const distance = 40;
      const distRatio = 1 + distance / Math.hypot(node.x, node.y, node.z);

      Graph.cameraPosition(
        {
          x: node.x * distRatio,
          y: node.y * distRatio,
          z: node.z * distRatio,
        }, // new position
        node,
        1000
      );
    })
    .linkDirectionalParticles(4);
}

function createHierarchy(htmlTableID) {
  // Note that because of the way this HTML table is created
  // The target nodes will be (object-uid), which uniquely identify the row
  // Hence it will suffice to consider the target nodes as the complete list of nodes
  // The only missing node will be the root node, which is added seperately

  var hierarchy = { links: [], nodes: [] };

  $("table" + htmlTableID + " tbody tr").each((i, row) => {
    var linkRow = {};
    var nodeInfo = {};

    var source = $(row).attr("parent-uid") ? $(row).attr("parent-uid") : "root";
    var target = $(row).attr("object-uid");
    var nodename = $(row).attr("node-name");
    var nodevalue = $(row).attr("node-value");
    var nodetype = $(row).attr("node-type");

    linkRow["source"] = source;
    linkRow["target"] = target;

    hierarchy["links"].push(linkRow);

    nodeInfo["id"] = target;
    nodeInfo["nodename"] = nodename;
    nodeInfo["nodevalue"] = nodevalue;
    nodeInfo["nodetype"] = nodetype;

    hierarchy["nodes"].push(nodeInfo);
  });

  var rootNode = {};
  rootNode["id"] = "root";
  rootNode["nodename"] = "root";
  rootNode["nodevalue"] = "root";
  hierarchy["nodes"].push(rootNode);

  return hierarchy;
}

function removeSVG(divID) {
  d3.select(divID).remove();
}

function addSVG(divID) {
  d3.select(divID)
    .append("div")
    .attr("id", "svgdiv")
    .attr("class", "d-flex w-100 h-100 flex-row");

  d3.select(divID).append("div").attr("id", "selectionDetails");
}

function enableSearch(element, htmlTableID) {
  var value = $(element).val().toLowerCase();

  $(htmlTableID + " tbody tr").filter(function () {
    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
  });
}

function exportHTMLTableToCSV(htmlTableID, separator = ",") {
  //Select table records
  var records = document.querySelectorAll("table" + htmlTableID + " tr");
  // Build CSV String
  var csv = [];
  // console.log(records);
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

// Adding Export to JSON functionality
// Copied from https://j.hn/html-table-to-json/

function tableToJson(htmlTableID) {
  var table = $("table" + htmlTableID)[0];

  var headers = [];
  var data = [];
  // first row needs to be headers
  for (var i = 0; i < table.rows[0].cells.length; i++) {
    headers[i] = table.rows[0].cells[i].innerText
      .toLowerCase()
      .replace(/ /gi, "");
  }
  // go through cells
  for (var i = 1; i < table.rows.length; i++) {
    var tableRow = table.rows[i];
    var rowData = {};
    for (var j = 0; j < tableRow.cells.length; j++) {
      rowData[headers[j]] = tableRow.cells[j].innerText;
    }
    data.push(rowData);
  }

  var jsonBlob = JSON.stringify(data);

  var filename =
    document.baseURI
      .split(/(\\|\/)/g)
      .pop()
      .split(/(\.)/g)[0] + ".json";

  downloadJSONFile(jsonBlob, filename);
}

function downloadJSONFile(jsonBlob, filename) {
  var downloadLink = document.createElement("a");
  downloadLink.style.display = "none";
  downloadLink.setAttribute("target", "_blank");
  downloadLink.setAttribute(
    "href",
    "data:text/json;charset=utf-8," + encodeURIComponent(jsonBlob)
  );
  downloadLink.setAttribute("download", filename);
  document.body.appendChild(downloadLink);
  downloadLink.click();
  document.body.removeChild(downloadLink);
}

function iterateThroughClass(queryClass) {
  var records = document.querySelectorAll(queryClass);

  for (var i = 0; i < records.length; i++) {
    setNodeTypeBadge(records[i]);
  }
}

function setNodeTypeBadge(nodetype) {
  if (nodetype.innerText === "Root") {
    $(nodetype).addClass(" badge");
    $(nodetype).addClass(" bg-primary");
  } else if (nodetype.innerText === "Processing Instruction") {
    $(nodetype).addClass(" badge");
    $(nodetype).addClass(" bg-success");
  } else if (
    nodetype.innerText === "Element" ||
    nodetype.innerText === "Element:Composite"
  ) {
    $(nodetype).addClass(" badge");
    $(nodetype).addClass(" bg-warning");
  } else if (nodetype.innerText === "Text") {
    $(nodetype).addClass(" badge");
    $(nodetype).addClass(" bg-dark");
  } else if (nodetype.innerText === "Attribute") {
    $(nodetype).addClass(" badge");
    $(nodetype).addClass(" bg-info");
  } else if (nodetype.innerText === "Comment") {
    $(nodetype).addClass(" badge");
    $(nodetype).addClass(" bg-success");
  }
}
