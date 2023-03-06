# How to build

Login to Vodafone dockerhub
- `docker login -u USERNAME_IN_1_PASS -p PASS_IN_1_PASS`

Downlad oracle tools
- `git submodule init && git submodule update`

Build the image
- `docker build . -t fingertips_dockerfile`

Push the image
- `docker push vf19cmi/fingertips_dockerfile`
