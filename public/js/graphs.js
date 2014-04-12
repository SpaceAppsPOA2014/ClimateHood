var testData = [{key: "RCP 4.5", values: [{year: 2025, temperature: 20}, {year: 2026, temperature: 21}]},
               {key: "RCP 8.5", values: [{year: 2025, temperature: 21}, {year: 2026, temperature: 22}]}]

function Nvd3Graph() {
  var svg,
      chart;

  var initialize = function() {
    setupSvg();
    setupChart();
    renderChart();
    addEvents();
  };

    var setupSvg = function ( ) {
    var svgAttributes = {
      width: 700,
      height: 300,
      padding: 25,
      margin : {
        top: 5,
        right: 10,
        bottom: 5,
        left: 10
      }
    };

    svg = d3.select('#home svg');
    svg.style({
      'width': svgAttributes.width + svgAttributes.margin.left + svgAttributes.margin.right,
      'height': svgAttributes.height + svgAttributes.margin.top + svgAttributes.margin.bottom,
      'padding': svgAttributes.padding,
      'margin': '0 auto'
    });
    /*svg.datum( generateData() );*/
    svg.datum(testData);
    svg.transition().duration(500);
  };

  var setupChart = function ( ) {
    chart = nv.models.lineChart()
    chart.options({
      x: getX,
      y: getY,
      noData: "Not enough data to graph",
      transitionDuration: 500,
      showLegend: true,
      showXAxis: true,
      showYAxis: true,
      rightAlignYAxis: false,
    });

    chart.xAxis
      .tickFormat(xAxisFormatter)
      .axisLabel("Years");
    chart.yAxis
      .tickFormat(yAxisFormatter)
      .axisLabel("Temperature");
  };

  var renderChart = function ( ) {
    chart(svg);
  };

  var getX = function (point, index) {
    return point.year;
  };

  var getY = function (point, index) {
    return point.temperature;
  };

  var xAxisFormatter = function (xValue) {
    return d3.format(',d')(xValue);
  };

  var yAxisFormatter = function (yValue) {
    return yValue.toString();
  };

  var resizeCallback = function ( ) {
    console.log("resize callback triggered");
    chart.update();
  };

  var addEvents = function ( ) {
    nv.utils.windowResize( resizeCallback );
    chart.dispatch.on('stateChange', stateChangeCallback);
    chart.legend.dispatch.on('legendMouseover', legendMouseoverCallback);
  };

  var stateChangeCallback = function ( ) {
    console.log("state of the chart changed");
    console.log(arguments)
  };

  var legendMouseoverCallback = function ( ) {
    console.log("you moused over the legend");
  };

  return {
    initialize : initialize
  };
}

var myCallback = function ( ) {
  console.log("addGraph callback triggered");
};

var graph = new Nvd3Graph();
nv.addGraph(graph.initialize, myCallback);
