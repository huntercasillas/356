$(document).ready(function() {
                $("#cityField").keyup(function(event) {
                    var url = "http://bioresearch.byu.edu/cs260/jquery/getcity.cgi?q="+$("#cityField").val();
                  $.getJSON(url,function(data) {
                    var everything;
                    everything = "<ul>";
                    $.each(data, function(i,item) {
                      everything += "<li> "+data[i].city;
                    });
                    everything += "</ul>";
                  })
                  .done(function() { //console.log('getJSON request succeeded!'); 
                  })
                  .fail(function(jqXHR, textStatus, errorThrown) { 
                    //console.log('getJSON request failed! ' + textStatus); 
                    //console.log("incoming "+jqXHR.responseText);
                  })
                  .always(function() { //console.log('getJSON request ended!');
                  });
                  
                  if(event.which == 13) {
                      $("#weatherButton").click();
                  }
                });
                
                //On clicking the weather button, put the text from the input
                //into the textarea
                $("#weatherButton").click(function(event) {
                   var cityInput = $("#cityField").val();
                   $("#displayCity").text(cityInput);
                   var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=imperial"
                    + "&appid=89e8dca515a4b52d710830cc0ba931ff&q=" + encodeURI(cityInput);
                    processWeatherRequest(weatherUrl);
                   event.preventDefault();
                });
                
                $("#stackButton").click(function(event) {
                   var stackSearch = $("#stackInput").val();
                   var url="https://api.stackexchange.com/2.2/search?order=desc&sort=activity"
                    + "&intitle=" + stackSearch + "&site=stackoverflow";
                    $.ajax({
                       url: url,
                       dataType: "json",
                       success: function(data) {
                           var questionList = "";
                           
                           if(data.items.length > 7) {
                             document.getElementById("results").innerHTML = "Top 8 Results:";
                           } else if(data.items.length == 0) {
                             document.getElementById("results").innerHTML = "No Results Found";
                             questionList = "";
                            $("#stack").html(questionList);

                           }
                           
                           for(var i=0; i<8; i++) { //data.items.length; i++) {
                               var question = data.items[i].title;
                               var questionUrl = data.items[i].link;
                               questionList += "<li><a href='" + questionUrl + "'>" + question + "</a></li>";
                           }
                           $("#stack").html(questionList);
                       }
                    });
                   event.preventDefault(); 
                });
                
                $("#stackInput").keyup(function(event) {
                   if(event.which == 13) {
                       $("#stackButton").click();
                   } 
                });
                
            });
            
            function processWeatherRequest(url) {
                
                $.ajax({
                    url: url,
                    dataType: "json",
                    success: function(data) {
                        
                        var location = data.name;
                        var weather = data.weather[0].main;
                        var temp = data.main.temp;
                        
                        var info = "<li>Location: " + location + "</li>";
                        info += "<li>Temperature: " + temp + "° Fahrenheit</li>";
                        info += "<li>Weather: " + weather + "</li>";
                        $("#weather ul").html(info);
                    }
                });
            }
            
            
            function autocomplete(inp, arr) {
  /*the autocomplete function takes two arguments,
  the text field element and an array of possible autocompleted values:*/
  var currentFocus;
  /*execute a function when someone writes in the text field:*/
  inp.addEventListener("input", function(e) {
      var a, b, i, val = this.value;
      /*close any already open lists of autocompleted values*/
      closeAllLists();
      if (!val) { return false;}
      currentFocus = -1;
      /*create a DIV element that will contain the items (values):*/
      a = document.createElement("DIV");
      a.setAttribute("id", this.id + "autocomplete-list");
      a.setAttribute("class", "autocomplete-items");
      /*append the DIV element as a child of the autocomplete container:*/
      this.parentNode.appendChild(a);
      /*for each item in the array...*/
      for (i = 0; i < arr.length; i++) {
        /*check if the item starts with the same letters as the text field value:*/
        if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
          /*create a DIV element for each matching element:*/
          b = document.createElement("DIV");
          /*make the matching letters bold:*/
          b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
          b.innerHTML += arr[i].substr(val.length);
          /*insert a input field that will hold the current array item's value:*/
          b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
          /*execute a function when someone clicks on the item value (DIV element):*/
          b.addEventListener("click", function(e) {
              /*insert the value for the autocomplete text field:*/
              inp.value = this.getElementsByTagName("input")[0].value;
              /*close the list of autocompleted values,
              (or any other open lists of autocompleted values:*/
              closeAllLists();
          });
          a.appendChild(b);
        }
      }
  });
  /*execute a function presses a key on the keyboard:*/
  inp.addEventListener("keydown", function(e) {
      var x = document.getElementById(this.id + "autocomplete-list");
      if (x) x = x.getElementsByTagName("div");
      if (e.keyCode == 40) {
        /*If the arrow DOWN key is pressed,
        increase the currentFocus variable:*/
        currentFocus++;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 38) { //up
        /*If the arrow UP key is pressed,
        decrease the currentFocus variable:*/
        currentFocus--;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 13) {
        /*If the ENTER key is pressed, prevent the form from being submitted,*/
        e.preventDefault();
        if (currentFocus > -1) {
          /*and simulate a click on the "active" item:*/
          if (x) x[currentFocus].click();
        }
      }
  });
  function addActive(x) {
    /*a function to classify an item as "active":*/
    if (!x) return false;
    /*start by removing the "active" class on all items:*/
    removeActive(x);
    if (currentFocus >= x.length) currentFocus = 0;
    if (currentFocus < 0) currentFocus = (x.length - 1);
    /*add class "autocomplete-active":*/
    x[currentFocus].classList.add("autocomplete-active");
  }
  function removeActive(x) {
    /*a function to remove the "active" class from all autocomplete items:*/
    for (var i = 0; i < x.length; i++) {
      x[i].classList.remove("autocomplete-active");
    }
  }
  function closeAllLists(elmnt) {
    /*close all autocomplete lists in the document,
    except the one passed as an argument:*/
    var x = document.getElementsByClassName("autocomplete-items");
    for (var i = 0; i < x.length; i++) {
      if (elmnt != x[i] && elmnt != inp) {
        x[i].parentNode.removeChild(x[i]);
      }
    }
  }
  /*execute a function when someone clicks in the document:*/
  document.addEventListener("click", function (e) {
      closeAllLists(e.target);
  });
}

/*An array containing all the country names in the world:*/
var countries = ["Alpine","Altamont","Alton","Altonah","American Fork",
                "Aneth","Annabella","Antimony","Aurora","Axtell","Bear River City",
                "Beaver","Beryl","Bicknell","Bingham Canyon","Blanding","Bluebell",
                "Bluff","Bonanza","Boulder","Bountiful","Brian Head","Brigham City",
                "Bryce","Bryce Canyon","Cache Junction","Cannonville","Castle Dale",
                "Cedar City","Cedar Valley","Centerfield","Centerville","Central",
                "Chester","Circleville","Cisco","Clarkston","Clawson","Clearfield",
                "Cleveland","Clinton","Coalville","Collinston","Corinne","Cornish",
                "Croydon","Dammeron Valley","Delta","Deweyville","Draper","Duchesne",
                "Duck Creek Village","Dugway","Dutch John","East Carbon","Echo",
                "Eden","Elberta","Elmo","Elsinore","Emery","Enterprise","Ephraim",
                "Escalante","Eureka","Fairview","Farmington","Fayette","Ferron",
                "Fielding","Fillmore","Fort Duchesne","Fountain Green","Fruitland",
                "Garden City","Garland","Garrison","Glendale","Glenwood","Goshen",
                "Grantsville","Green River","Greenville","Greenwich","Grouse Creek",
                "Gunlock","Gunnison","Gusher","Hanksville","Hanna","Hatch","Heber City",
                "Helper","Henefer","Henrieville","Hiawatha","Hildale","Hill AFB",
                "Hinckley","Holden","Honeyville","Hooper","Howell","Huntington",
                "Huntsville","Hurricane","Hyde Park","Hyrum","Ibapah","Ivins","Jensen",
                "Joseph","Junction","Kamas","Kanab","Kanarraville","Kanosh","Kaysville",
                "Kenilworth","Kingston","Koosharem","La Sal","La Verkin","Lake Powell",
                "Laketown","Lapoint","Layton","Leamington","Leeds","Lehi","Levan",
                "Lewiston","Lindon","Loa","Logan","Lyman","Lynndyl","Magna","Manila",
                "Manti","Mantua","Mapleton","Marysvale","Mayfield","Meadow","Mendon",
                "Mexican Hat","Midvale","Midway","Milford","Millville","Minersville",
                "Moab","Modena","Mona","Monroe","Montezuma Creek","Monticello","Morgan",
                "Moroni","Mount Carmel","Mount Pleasant","Mountain Home","Myton","Neola",
                "Nephi","New Harmony","Newcastle","Newton","North Salt Lake","Oak City",
                "Oakley","Oasis","Ogden","Orangeville","Orderville","Orem","Panguitch",
                "Paradise","Paragonah","Park City","Park Valley","Parowan","Payson",
                "Peoa","Pine Valley","Pleasant Grove","Plymouth","Portage","Price",
                "Providence","Provo","Randlett","Randolph","Redmond","Richfield","Richmond",
                "Riverside","Riverton","Rockville","Roosevelt","Roy","Rush Valley",
                "Saint George","Salem","Salina","Salt Lake City","Sandy","Santa Clara",
                "Santaquin","Scipio","Sevier","Sigurd","Smithfield","Snowville",
                "South Jordan","South Willard","Spanish Fork","Spring City","Springdale",
                "Springville","Sterling","Stockton","Summit","Sunnyside","Syracuse","Tabiona",
                "Talmage","Teasdale","Thompson","Tooele","Toquerville","Torrey","Tremonton",
                "Trenton","Tridell","Tropic","Vernal","Vernon","Veyo","Virgin","Wales",
                "Wallsburg","Washington","Wellington","Wellsville","Wendover","West Jordan",
                "Whiterocks","Willard","Woodruff","Woods Cross"];

/*initiate the autocomplete function on the "cityField" element, and pass along the countries array as possible autocomplete values:*/
autocomplete(document.getElementById("cityField"), countries);
