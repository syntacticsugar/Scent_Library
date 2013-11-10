
function sortFlasksByHouse() {
  console.log("sorting list");
  $(".flasks li").sort(sortByHouse).appendTo(".flasks");
}

function sortByHouse(a,b) {
  console.log("comparing elements");
  if (a.getAttribute('data-house') < b.getAttribute('data-house')) {
    console.log("a is less");
    return 1;
  } else {
    console.log("b is less");
    return -1;
  }
}
