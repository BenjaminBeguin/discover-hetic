## Install

Install bundler to manage project gem's
```
$ gem install bundler
```

Install all gems
```
$ bundle install
```

Initiate a new database
```
$ bundle exec rake db:create
```

Create the database from project model
```
$ bundle exec rake db:migrate
```

*If you have no datas yet, generate random ones*
```
$ bundle exec rake db:seed
```

Start rails server
```
$ rails s
```


## Install Front Workflow

Install npm packages
```
$ npm install
```

Launch gulp and browser-sync on localhost:3001
```
$ gulp
```