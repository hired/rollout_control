# rollout_control

rollout_control is a JSON/REST API for [rollout](https://github.com/FetLife/rollout).

## Installation

Add the gem to your Rails project `Gemfile`:

```ruby
gem 'rollout_control'
```

Then mount the engine in `config/routes.rb`:

```ruby
MyApp::Application.routes.draw do

  # ... all your other routes here ...

  mount RolloutControl::Engine, at: '/rollout'

  # You can mount the engine wherever you want, it does not have to be `'/rollout'`.
end
```

Add an initializer for additional configuration. If you already have a `rollout.rb` initializer
you can just add to that.

```ruby
# config/initializers/rollout.rb

$rollout = Rollout.new($redis)

RolloutControl.configure do |rc|
  rc.rollout = $rollout

  rc.basic_auth_username = ENV['ROLLOUT_CONTROL_USERNAME']
  rc.basic_auth_password = ENV['ROLLOUT_CONTROL_PASSWORD']
end
```

Actually, if you have everything configured as above you don't have to add this configuration at
all! rollout_control will automatically assume your rollout instance is in the `$rollout` global
and that the environment variables `ROLLOUT_CONTROL_USERNAME` and `ROLLOUT_CONTROL_PASSWORD`
configure basic auth.

Note that basic auth is on by default. **If you do not configure basic auth nothing will work**.

If you want to use your own authentication scheme then you can disable basic auth.

```ruby
RolloutControl.configure do |rc|
  rc.rollout = $rollout

  # No basic auth - endpoints will be unprotected.
  # You generally should not do this unless you have your own auth set up.
  rc.unprotected = true
end
```

## License

This project uses MIT licensed. See MIT-LICENSE file for more details.
