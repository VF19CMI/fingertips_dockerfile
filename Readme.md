# How to build

### Image for Circle CI

Login to Vodafone dockerhub
- `docker login -u USERNAME_IN_1_PASS -p PASS_IN_1_PASS`

Download oracle tools
- `git submodule init && git submodule update`

Build the image
- `docker build . -t fingertips_dockerfile`

Push the image
- `docker push vf19cmi/fingertips_dockerfile`

### Image for ruby BE only, ruby version (2.7.1)

Build the image
- `docker build -f Dockerfile.ruby_2.7.1 -t vf19cmi/fingertips-ruby .`

Push the image
- `docker push vf19cmi/fingertips_ruby`


## Build older version of ruby 2.6.2

Removed rbenv to keep images simpler

Build the image
- `docker build -f Dockerfile.ruby_2.6.2 -t vf19cmi/fingertips-ruby-2_6_2 .`

Push the image
- `docker push vf19cmi/fingertips-ruby-2_6_2`
