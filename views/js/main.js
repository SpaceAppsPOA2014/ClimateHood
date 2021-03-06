function getSummaryInfo() {
  var year = $("#year").val();
  var month = $("#month").val();
  var state = $("#state").val();
  var duration = $("#duration").val();

  $.get("/api/summary",
    {year: year, month: month, state: state, duration: duration},
    processSummaryData);
}

function getGraphInfo() {
  var year = $("#year").val();
  var month = $("#month").val();
  var state = $("#state").val();
  var duration = $("#duration").val();

  $.get("/api",
      {year: year, month: month, state: state, duration: duration},
      processGraphData);
}

function paragraph(text){
    var t = "<p>";
    for(var i=0; i<arguments.length; i++){
        t += arguments[i];
    }
    t += "</p>";
    return t;
}

function processSummaryData(data){
    var panel = $("#panel");
    var d = JSON.parse(data);
    var maxTempRCP45 = parseFloat(d.max_temp_rcp45).toFixed(2);
    var maxTempRCP85 = parseFloat(d.max_temp_rcp85).toFixed(2);

    panel.append("If we keep using non-renewable resources, we may end up with a temperature of", maxTempRCP85);
    panel.append("At the other hand, we can burn less coal and have confortable ", maxTempRCP45, " degrees.");
}

function processGraphData(data){
  alert(data);
}

$(document).ready(function() { 
  $('#send').click(function() { 
      getSummaryInfo();
      getGraphInfo();
      return false;
  }); 

}); 
