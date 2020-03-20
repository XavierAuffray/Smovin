const form = document.querySelector('.form')

form.addEventListener('submit', function(event) {
  event.preventDefault();
  const base_rent = document.getElementById('base_rent');
  // const region = document.getElementById('region');
  const start_date = document.getElementById('start_date');
  const signed_on = document.getElementById('signed_on');
  const url = 'http://localhost:4567/v1/indexations'
  const object = {
    base_rent: `${base_rent.value}`,
    // region: `${region.value}`,
    start_date: `${start_date.value}`,
    signed_on: `${signed_on.value}`
  }
  const output = JSON.stringify(object)
  fetch(url, {method: 'post', body: output})
  .then(function(response) {
    return response.json();
  })
  .then(function(data) {
    const new_rent = data['new_rent']
    const answer = document.getElementById('answer')
    answer.innerHTML = "";
    const content = `<h3>NEW RENT => ${new_rent} €</h3>`
    answer.insertAdjacentHTML('beforeend', content)
    answer.classList.remove('hidden')
  })
});

