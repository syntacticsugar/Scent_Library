var image = document.getElementById('logo');

image.addEventListener('mouseover', function() { 
  image.setAttribute('style','-webkit-filter: brightness(1.05)'); 
}, false);

image.addEventListener('mouseout', function() { 
  image.setAttribute('style','-webkit-filter: brightness(1.0)'); 
}, false);

function sortFlasksByHouse() {
  console.log("sorting list");
  $(".flasks li").sort(sortByHouse).appendTo(".flasks");
}

function sortByHouse(a, b) {
  // uses `localCompare` to get region specific string sorting
  console.log("comparing elements");
  var aval, bval;
  aval = a.getAttribute('data-house');
  bval = b.getAttribute('data-house');
  return aval.localeCompare(bval);
}

$(".testclick").click(sortFlasksByHouse);
