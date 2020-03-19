const form = document.querySelector('.form')

form.addEventListener('submit', function(event) {
  event.preventDefault();
  const base_rent = document.getElementById('base_rent');
  const region = document.getElementById('region');
  const start_date = document.getElementById('start_date');
  const signed_on = document.getElementById('signed_on');
  const object = {
    base_rent: `${base_rent.value}`,
    region: `${region.value}`,
    start_date: `${start_date.value}`,
    signed_on: `${signed_on.value}`
  }
  output = JSON.stringify(object)
  console.log(output)
});
