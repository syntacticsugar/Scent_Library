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

  // Compare by manufacturer first.
  var aval, bval;
  aval = a.getAttribute('data-house').toLowerCase();
  bval = b.getAttribute('data-house').toLowerCase();
  comparison = aval.localeCompare(bval);

  // Maufacturers are the same, so instead sort by name within that manufacturer.
  if (comparison == 0) {
    aval = a.getAttribute('data-name').toLowerCase();
    bval = b.getAttribute('data-name').toLowerCase();
    comparison = aval.localeCompare(bval);
  }

  return comparison;
}

$(".testclick").click(sortFlasksByHouse);
