var Hoard = Hoard || {};

Hoard.renderAreaChart = function (containerSelector, rawData, customOptions) {

  var self = this;
  var data = [];
  var options = customOptions || {};
  var container = $(containerSelector);

  // Build data set
  (function () {
    var row;
    for (var key in rawData) {
      var row = {
        date: key,
        close: rawData[key]
      }
      data.push(row);
    }
  }());

  // Dimensions
  var margin;
  if (options['xAxis'] === 'off') {
    margin = {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0,
    }
  } else {
    margin = {
      top: 30,
      right: 0,
      bottom: 30,
      left: 0
    };
  }
  var width = container.width() - margin.left - margin.right;
  var height = 150 - margin.top - margin.bottom;

  // Date parser
  var parseDate = d3.time.format("%Y-%m-%d %H:%M:%S UTC").parse;

  // Axis
  var x = d3.time.scale()
    .range([0, width]);

  var y = d3.scale.linear()
    .range([height, 0]);

  var xAxis, yAxis;
  if (options['margin'] === 'off') {
    xAxis = null;
  } else {
    var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom");
  }
  var yAxis = d3.svg.axis()
    .scale(y)
    .ticks(3)
    .tickSize(width, 0)
    .orient("right");

  var area = d3.svg.area()
    .x(function(d) { return x(d.date); })
    .y0(height)
    .y1(function(d) { return y(d.close); });

  var svg = d3.select(containerSelector).append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  data.forEach(function(d) {
    d.date = parseDate(d.date);
    d.close = +d.close;
  });

  x.domain(d3.extent(data, function(d) { return d.date; }));
  y.domain([0, d3.max(data, function(d) { return d.close; })]);

  svg.append("path")
    .datum(data)
    .attr("class", "area")
    .attr("d", area);

  if (xAxis) {
    svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);
  }

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .call(function customAxis(g) {
      g.selectAll("text")
        .attr("x", width / 2)
        .attr("y", -8)
        .style('text-anchor', 'middle');
    })
    // .append("text")
    // .attr("transform", "rotate(-90)")
    // .attr("y", 1)
    // .attr("dy", ".71em")
    // .style("text-anchor", "end")
    // .text("Count");

};
