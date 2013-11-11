
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
