sand [![Build Status](https://travis-ci.org/NickTomlin/ruby-sand.svg?branch=master)](https://travis-ci.org/NickTomlin/ruby-sand) [![Gem Version](https://badge.fury.io/rb/sand.svg)](https://badge.fury.io/rb/sand)
===

A ruby gem for authorization in rack/sinatra applications. Code mostly stolen from [Pundit](https://github.com/elabs/pundit).

Usage
---

The [Pundit policy](https://github.com/elabs/pundit#policies) documentation provides an excellent introduction into creating defining policies.

Once you've built your policies, you can start to use sand. By default, you can include sand in your rack application like so:

```ruby
require 'sand'
use Sand::Middleware

class MyModel < MyOrm::Model
  # ...
end

class MyModelPolicy
  # ...
end

class Routes
  env['sand'].authorize(user, MyModel, :can_greet?)
  [200, {}, ['Hello world']]
end

MyRackApp = Rack::Builder.new do
  use Sand::Middleware
  run SandApp.new
end
```

This will add `authorize` and `policy_scope` underneath env['sand'], that you can call in your middleware / routes.

Sinatra users can access sand's middleware via helpers by adding `Sand::Helpers`:

```ruby
require 'sinatra'

use Sand::Helpers

get '/' do
  user = User.find(params[:user_id])
  accounts = policy_scope(user, Account)
  json accounts: accounts
end
```
