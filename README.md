# Welcome to Quizzer

[![Build Status](https://travis-ci.org/tomtomecek/quizzer.svg)](https://travis-ci.org/tomtomecek/quizzer) [![Code Climate](https://codeclimate.com/github/tomtomecek/quizzer/badges/gpa.svg)](https://codeclimate.com/github/tomtomecek/quizzer) [![Test Coverage](https://codeclimate.com/github/tomtomecek/quizzer/badges/coverage.svg)](https://codeclimate.com/github/tomtomecek/quizzer) [![Circle CI](https://circleci.com/gh/tomtomecek/quizzer/tree/master.svg?style=shield&circle-token=f47aaaa83e457e1b1052b299a93eb716c215ec12)](https://circleci.com/gh/tomtomecek/quizzer/tree/master)

![quizzer_logo](https://user-images.githubusercontent.com/7385469/37671211-8627f5f8-2c6b-11e8-8176-939b6979107b.gif)

Ruby on Rails application for building unique quizzes with admin/user interface, e-commerce, and certification. The application was built by using Test Driven Development, GitHub Flow, and Agile Planning.

**IMPORTANT**: The code in this repository is _legacy_ (from 2015) and is no longer maintained.

### Features

* Sign up and sign in for students via 3rd party - GitHub.
* Forgetten password and 'Remember me'.
* Admin area with multiple actor roles - Instructor, Teaching Assistant.
* Possibility of paid Signature track and credit card payment via Stripe.
* Downloadable PDF and shareable certificate on LinkedIn.
* File upload to Amazon S3.
* Quiz questions and answers can be written in Markdown.
* Syntax highlighting support for markdown code blocks.
* Continuous Integration - Builds on Travis CI and CircleCI.
* Continuous Deployment - from CircleCI to Heroku.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You need to be able to setup developer account with 3rd party services:

* GitHub (Required only for student track)
* AWS    (Optional)
* Stripe (Required only for student track)

In order to run specs, you will need to install PhantomJS. Homebrew installation of PhantomJS:

```shell
brew update
brew install phantomjs
```

And same way for PostgreSQL.

### Installing

I originally used Ruby 2.1.5 and version was upgraded to 2.3.6, but any version before 2.4 should work without issues.

```shell
git clone git@github.com:tomtomecek/quizzer.git && cd quizzer
bundle install
bundle exec rake db:create db:schema:load
figaro install
```

If you want to seed some data.

```shell
bundle exec rake db:seed
```

## Running the tests

```shell
bundle exec rspec spec
```

I also used [zeus](https://github.com/burke/zeus) to enhance local development.

## Deployment

Project is continuously deployed via CircleCI to Heroku, when all tests pass on master branch.

See the setup of config.yml - [here](https://github.com/tomtomecek/quizzer/blob/master/.circleci/config.yml).

## Built With

* [Ruby on Rails](http://rubyonrails.org/) - The web framework used
* [PostgreSQL](https://www.postgresql.org/) - Database used
* [Wicked PDF](https://github.com/mileszs/wicked_pdf) - PDF Generation with wkhtmltopdf
* [Omniauth GitHub](https://github.com/omniauth/omniauth-github) - Student Sign up/in provider
* [Stripe](https://stripe.com/) - Credit card payments processing
* [LinkedIn](https://www.linkedin.com) - Certificates uploaded to
* [Amazon S3](https://aws.amazon.com/s3/) - Storage for course files
* [Mailgun](https://www.mailgun.com/) - Email provider
* [Sidekiq](https://github.com/mperham/sidekiq) - For background jobs
* [Parsley.js](http://parsleyjs.org/) - Frontend form validation
* [Sentry](https://sentry.io/welcome/) - Production error monitoring
* [Font Awesome](https://fontawesome.com/) - Icons used
* [jQuery](https://jquery.com/) - Javascript framework used
* [Twitter Bootstrap](https://getbootstrap.com/docs/3.3/) - HTML/CSS framework used
* [RSpec](http://rspec.info/documentation/) - BDD test framework used
* [Capybara](https://github.com/teamcapybara/capybara) - Acceptance test framework used

## Authors

* **Tomas Tomecek** - [tomtomecek](https://github.com/tomtomecek)

## Acknowledgments

* Huge thanks to Chris Lee and Kevin Wang - for inspiration, mentoring and knowledge
* Thanks to Brandon Conway - for development advice and hunt on some bugs
* Quiz inspiration came from [Vienna.rb](https://www.meetup.com/vienna-rb/)
