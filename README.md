Gotcha API
============

Gotcha where I want 'cha

## DESCRIPTION

The public facing API for the [Gotcha iOS App](https://github.com/donmiller/Gotcha-iOS). Provides the heavy lifting of all the data.

## INSTALLATION

### Clone the repository

```
> git clone https://github.com/jwright/gotcha-api.git
> cd gotcha-api
```

### Install the dependencies

```
bundle install
```

### Run the sever locally

```
bundle exec rails server
```

Your api should now be running at `http://localhost:3000`

## RUNNING TESTS

[RSpec](http://rspec.info/) is used to create behavior-driven specs for the project. It is set as the default rake task for the project.

If there are pending database migrations, you must first migrate the test database.

```
bundle exec rails db:test:prepare
```

You can then run the tests with the following:

```
bundle exec rake
```

## DEVELOPMENT

### Database migrations

## DEPLOYMENT

## CONTRIBUTING

1. Clone the repository `git clone https://github.com/jwright/gotcha-api`
1. Create a feature branch `git checkout -b my-awesome-feature`
1. Codez!
1. Commit your changes (small commits please)
1. Push your new branch `git push origin my-awesome-feature`
1. Create a pull request `hub pull-request -b jwright:master -h jwright:my-awesome-feature`
