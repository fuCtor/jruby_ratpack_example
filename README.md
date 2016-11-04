[![Build Status](https://travis-ci.org/fuCtor/jruby_ratpack_example.svg?branch=master)](https://travis-ci.org/fuCtor/jruby_ratpack_example)

Launch

docker build --rm -t url_expander . 

First case:
docker-compose up 

Second case:
docker run -ti -p 0.0.0.0:3000:3000 url_expander bin/run.sh  

And run benchmark:
ab -l -n 1000 -c 10  http://localhost:3000/status 
