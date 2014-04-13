function update_info() {
  year = $("#year")
  month = $("#month")
  state = $("#state")
  duration = $("#duration")

  url = "/api?year=" + year + "&month=" + month "&state=" + state + "&duration=" + duration
  $.get(url,
    function(data) {
      alert(data)
  });
}

$(document).ready(function() { 

  $('#send').submit(function(){

    alert("Thank you for your upload!"); 

    return false;
  });
  $('#send').click(function() { 


    alert("Thank you for your upload!"); 
    return false;
  }); 

}); 
