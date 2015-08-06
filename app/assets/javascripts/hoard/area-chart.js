var Hoard = Hoard || {};

Hoard.renderAreaChart = function (containerSelector, rawData) {

  var self = this;
  var data = [];
  for (var key in rawData) {
    var row = {
      date: key,
      close: rawData[key]
    }
    console.log(key, rawData[key], row);
    data.push(row);
  }

  var container = $(containerSelector);

  var margin = {
    top: 30,
    right: 0,
    bottom: 30,
    left: 50
  };
  var width = container.width() - margin.left - margin.right;
  var height = 150 - margin.top - margin.bottom;

  var parseDate = d3.time.format("%Y-%m-%d %H:%M:%S UTC").parse;

  var x = d3.time.scale()
    .range([0, width]);

  var y = d3.scale.linear()
    .range([height, 0]);

  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

  var yAxis = d3.svg.axis()
    .scale(y)
    .ticks(5)
    .orient("left");

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

  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    // .append("text")
    // .attr("transform", "rotate(-90)")
    // .attr("y", 1)
    // .attr("dy", ".71em")
    // .style("text-anchor", "end")
    // .text("Count");

};
