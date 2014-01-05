var image = document.getElementById('logo');

image.addEventListener('mouseover', function() { 
  image.setAttribute('style','-webkit-filter: brightness(1.05)'); 
}, false);

image.addEventListener('mouseout', function() { 
  image.setAttribute('style','-webkit-filter: brightness(1.0)'); 
}, false);

function sortFlasksByBrand() {
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
  aval = a.getAttribute('brand').toLowerCase();
  bval = b.getAttribute('brand').toLowerCase();
  comparison = aval.localeCompare(bval);

  // Maufacturers are the same, so instead sort by name within that manufacturer.
  if (comparison == 0) {
    aval = a.getAttribute('name').toLowerCase();
    bval = b.getAttribute('name').toLowerCase();
    comparison = aval.localeCompare(bval);
  }

  return comparison;
}

function sortByDateAdded(a, b) {
  var aval, bval;
  aval = a.getAttribute('added');
  bval = b.getAttribute('added');
  // If time is the same, sort by alpha.
  return aval > bval ? -1 : (aval < bval ? 1 : sortByHouse(a, b))
}

function sortByFormula(a, b) {
  var aval, bval;
  aval = a.getAttribute('formula');
  bval = b.getAttribute('formula');
  // If formula is the same, sort by alpha.
  return aval > bval ? -1 : (aval < bval ? 1 : sortByHouse(a, b))
}

//$(".testclick").click(sortFlasksByHouse);

function updateJuice(juiceID,field,checkbox) {
  value = (checkbox.checked ? 1 : 0);

  $.ajax({
    // following line "/person_juice" followed by ? to signify parameters are following
    // "/person_juice?juice_id=14&wished_for=true"
    url: "/person_juice?juice_id=" + juiceID + "&" + field + "=" + value,
    type: "PUT",
  }).done(function() { alert("Added to " + field  + ".") });
}

