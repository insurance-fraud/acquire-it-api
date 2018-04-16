[![Build Status](https://semaphoreci.com/api/v1/insurance-fraud/acquire-it-api/branches/master/shields_badge.svg)](https://semaphoreci.com/insurance-fraud/acquire-it-api)

# acquire-it-api

API that checks whether insurances can be bought

## Running

Running is easy, just do:

```bash
docker-compose build
docker-compose run acquire-it-api.web rake db:setup db:migrate
docker-compose up
```
