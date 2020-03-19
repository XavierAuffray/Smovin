const form = document.querySelector('.form')

form.addEventListener('submit', function(event) {
  event.preventDefault();
  const base_rent = document.getElementById('base_rent');
  const region = document.getElementById('region');
  const start_date = document.getElementById('start_date');
  const signed_on = document.getElementById('signed_on');
  const url = 'http://localhost:4567/v1/indexations'
  const object = {
    base_rent: `${base_rent.value}`,
    region: `${region.value}`,
    start_date: `${start_date.value}`,
    signed_on: `${signed_on.value}`
  }
  const output = JSON.stringify(object)
  fetch(url, {method: 'post', body: output})
  .then(function(response) {
    console.log(response)
    return response.blob();
  })
  .then((data) => console.log(data))
  // .then(function(myBlob) {
  //   const objectURL = URL.createObjectURL(myBlob);
  //   console.log(objectURL)
  //   myImage.src = objectURL;
  // });
});

// , mode: 'no-cors'
