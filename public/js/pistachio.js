var image = document.getElementById('logo');

image.addEventListener('mouseover', function() { 
  image.setAttribute('style','-webkit-filter: brightness(1.05)'); 
}, false);

image.addEventListener('mouseout', function() { 
  image.setAttribute('style','-webkit-filter: brightness(1.0)'); 
}, false);

function sortFlasksByHouse() {
  $(".flasks li").sort(sortByHouse).appendTo(".flasks");
}

function sortFlasksByDateAdded() {
  $(".flasks li").sort(sortByDateAdded).appendTo(".flasks");
}

function sortFlasksByFormula() {
  $(".flasks li").sort(sortByFormula).appendTo(".flasks");
}

function sortByHouse(a, b) {
  // uses `localCompare` to get region specific string sorting
  
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

function sortByDateAdded(a, b) {
  var aval, bval;
  aval = a.getAttribute('data-date-added');
  bval = b.getAttribute('data-date-added');
  // If time is the same, sort by alpha.
  return aval > bval ? -1 : (aval < bval ? 1 : sortByHouse(a, b))
}

function sortByFormula(a, b) {
  var aval, bval;
  aval = a.getAttribute('data-formula');
  bval = b.getAttribute('data-formula');
  // If formula is the same, sort by alpha.
  return aval > bval ? -1 : (aval < bval ? 1 : sortByHouse(a, b))
}

$(".testclick").click(sortFlasksByHouse);
