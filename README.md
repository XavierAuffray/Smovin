# Smovin welcome challenge

## Context
Smovin is a digital real estate assistant that helps landlords and property managers with the financial follow-up and administration of their tenants and properties.

Through an online platform, we aim at solving most challenges one can be facing during rental management.

## Objectives

During this challenge you will be tested on several aspects:
- We want to make sure you have the minimal technical skills required to thrive at Smovin and help us become a big player on the real estate market.
- Being able to learn new things quickly and adapt to an unfamiliar situation is also important to us 🎓!
- We want assess your capacity at finding solutions on your own by going through the adequate documentation and apply those to the problem at hand 🕵️‍♀️.
- We would like to see an elegant solution for the challenge. Structure you code, keep things simple and we'll be friends 🤜🤛.
- Finally, we want to make sure you are able to craft a solution based on a set of given requirements as this is what we, at Smovin, will expect from you on a day-to-day basis 🔣.

Remember that there is no single solution for a specific problem. As long as the requirements are met, every solution is correct. However, based on how your solution is crafted we will be able rate the quality of your solution. Moreover, make sure to only submit a solution that covers **ALL** requirements.

## Challenge

### Context

During the life of a rental contract, owners are allowed by law to increase the monthly rent on a yearly basis, this is called the indexation. The maximum rent increase that can be applied to a rental contract can be calculated based on a set of given parameters:
- Location of the rental unit
- Start date of the rental contract
- Base rent of the rental contract
- Date of signature of the rental contract
- Belgian health index

### Specifications

We want you to build a small webpage where a owner could go and compute his rent after indexation based on some parameters.

This webpage has to be composed out of two main elements:
1) A simple backend server coded in NodeJS or Ruby, as you prefer.
2) A simple frontend single page application using HTML and VanillaJS or the framework of your choice (VueJS or ReactJS).

#### Backend requirements

In order to be able to compute the new rent you will need to retrieve the `base_index` and the `current_index` from the belgian health indexes. In order to do so, an endpoint (`https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/indexes/:BASE/:YEAR-:MONTH`) has been made available to you and can be queried as follows:
```sh
  curl https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/indexes/2004/2000-01
```
and will return a JSON formatted as follows:
```json
  {
    "index": {
      "MS_SMOOTH_IDX": 91.37,
      "MS_WT_CPI": 1000,
      "MS_CPI_IDX": 91.19,
      "MS_HLTH_IDX": 91.67,
      "SK": "2000_01",
      "NM_BASE_YR": 2004,
      "NM_MTH": 1,
      "NM_YR": 2000,
      "PK": "2004"
      }
  }
```
The health index can be found under the `MS_HLTH_IDX` key. This index is to be used in order to compute the rent after indexation as follows:
- **Base month**: The month before the signature date of the contract (eg: the contract was signed on *01/09/2010*, the base month equals *01/08/2010*)
- **Base**: The value of the base is `max(i)` where `i` is included in `[1988, 1996, 2004, 2013]` and `i <= year(base month)`
- **Base index**: The value of the index of the **base month** and the **base** that can be found by making a request to the endpoint presented above*.
- **Current month**: The month preceding the last "birthday" of the contract. (eg: suppose we are the *01/01/2020*, if the contract started on *01/09/2010*, then the last birthday is *01/09/2019* therefore the current month is *august 2019*)
- **Current index**: The value of the index of the **current month** and the **base** that can be found by making a request to the endpoint presented above*.
- **Base rent** of the rental contract is the rent that had been agreed on between the owner and the tenant at the start of the contract
- The **formulae** can be written as follows: `(base_rent * current_index) / base_index`

*To be sure you understand well how to retrieve the `base_index` and the `current_index`, here is a simple example:
  - Suppose the contract was **signed on** *25/07/2010*, then the **base month** equals *01/06/2010*, the corresponding **base** would be *2004* as it is the highest value in `[1988, 1996, 2004, 2013]` and `<= 2010` which is the year of the base month. The corresponding **base index** that can be found in the belgian health indexes is *112.74*, the index of *june 2010* with base *2004*.
  - Suppose that for the same contract we have a **start date** of *01/09/2010*, and the last birthday of this contract is *01/09/2019*, then the month preceding this birthday is *august 2019* and the **current index** is the index of that month with base *2004* that can be found in the belgian health indexes and equals *131.72*.

You server should accept an api call formatted as follows:

**URL** : `/v1/indexations`

**Method** : `POST`

**Auth required** : NO

**Body** :

```json
  {
    "base_rent": 500,
    "region": "brussels",
    "start_date": "2010-09-01",
    "signed_on": "2010-07-25"
  }
```

**Requirements**:
- `base_rent` :  Required + Positive
- `region` :  Required + Included in ["brussels", "wallonia", "flanders"]
- `start_date` :  Required + Cannot be in the future
- `signed_on` :  Required + Cannot be in the future

***Response in case of success:***

**Code** : `200`

**Content**:
```json
  {
    "new_rent":  584.18,
    "base_index": 112.74,
    "current_index": 131.72
  }
```

***Response in case of error (some body parameters are missing or invalid):***

**Code**: `400`

**Content**:
```json
  {
    "new_rent": ["must_be_positive"],
    "signed_on": ["missing"]
  }
```

If you decide to code your backend in:
- **NodeJS**, checkout [express](https://expressjs.com/en/starter/installing.html) which is a server with an easy setup. Many other solutions exist though.
- **Ruby**, checkout [sinatra](https://github.com/sinatra/sinatra) for your server (please 🙏 do not create a Rails project for this, this is an overkill 💣💣💣).

Do not forget to setup [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) headers in order to be able to perform calls to the api from your frontend. this can easily be done by using for:
- **NodeJS**, the [cors](https://www.npmjs.com/package/cors) middleware package and use it as follows (if you are using express)
  ```js
    const express = require('express')
    const cors = require('cors')
    const app = express()

    const corsOptions = {
      origin: "*", // THE ORIGIN OF YOUR FRONTEND
      optionsSuccessStatus: 200
    }

    app.use(cors(corsOptions))
  ```
- **Ruby**, the [sinatra/cross_origin](https://www.rubydoc.info/gems/sinatra-cross_origin/0.3.2/Sinatra) module and use it as follows (if you are using sinatra)
  ```ruby
    require 'sinatra'
    require "sinatra/cross_origin"

    configure do
      enable :cross_origin
    end

    before do
      response.headers["Access-Control-Allow-Origin"] = "*"
    end

    # ROUTES ...

    options "*" do
      response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
      response.headers["Access-Control-Allow-Origin"] = "*"
      200
    end
  ```

#### Frontend requirements

Create a simple single page application.

If you plan to use VueJS (yes we ❤️❤️❤️ this front-end framework) Checkout the following [link](https://vuejs.org/v2/guide/installation.html) for installation instructions. Please do not use the CDN version of VueJS 😌 but use the Vue CLI instead. Setting up a vue project is fairly easy:
- `npm install -g @vue/cli` for installing the vue CLI
- `vue create NAME_OF_YOUR_PROJECT` for creating your vue project
- `npm install` from inside your projects directory
- `npm run serve` to start your development server

Your application should:
- Contain a form on which you can fill in the required information: `base_rent`, `region`, `start_date` and `signed_on`.
- You should validate the input data. Feel free to install validation packages if needed (eg: [vuelidate](https://vuelidate.js.org/)) or perform your validations on your own.
- You should perform the api call with the form parameters. For this you can also install packages if you wish (eg: [axios](https://github.com/axios/axios)) or simply use the [fetch](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch) api.
- You should display the results of the api call to the user.

On the design side of things, feel free to experiment and express the Picasso inside you 👨‍🎨. Or just use a UI library to make your design sleek.

Below, you will find a mockup containing the minimal information we expect to find in your frontend.

For the input form:
![alt text](images/mockup_form.png "Title")

For the result:
![alt text](images/mockup_result.png "Title")


#### Bonuses

1) We would be very happy to see your code tested using the testing framework of your choice 🧪
2) Linting is not a crime 💍


### Practicalities

We will review your code once you send us the link to the github repository on which your solution is available to [alexis@smovin.be](mailto:alexis@smovin.be?subject=Smovin%20welcome%20challenge).

Save your code in a single repository containing at least:
1) the `web` folder with your frontend
2) the `api` folder containing your backend
3) a `package.json` file containing at least a `dev` script in order for us to be able to run `npm run dev` to start the backend and frontend servers


