# rollout_control

rollout_control is a JSON/REST API for [rollout](https://github.com/FetLife/rollout).

This enables control of rollout from Hubot with a [Hubot script](https://github.com/hired/hubot-rollout-control). Maybe you can think of some other uses!

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

### Hubot script installation

Add **hubot-rollout-control** to dependencies in Hubot's `package.json` file:

```json
"dependencies": {
  "hubot": ">= 2.6.0",
  "hubot-scripts": ">= 2.5.0",
  "hubot-rollout-control": ">= 0.0.2"
}
```

Add **hubot-rollout-control** to Hubot's `external-scripts.json`:

```json
["hubot-rollout-control"]
```

* Set `HUBOT_ROLLOUT_CONTROL_URL` to point to where you mounted rollout_control. For example: `http://my-super-app.com/rollout`.
* Set `HUBOT_ROLLOUT_CONTROL_USERNAME` to your configured rollout basic auth username (same as `ROLLOUT_CONTROL_USERNAME` above).
* Set `HUBOT_ROLLOUT_CONTROL_PASSWORD` to your configured rollout basic auth password (same as `ROLLOUT_CONTROL_PASSWORD` above).

If everything is set up correctly, you can now control rollout with Hubot.

=====

**aaron**<br />
hubot rollout features<br />
**hubot**<br />
experimental_feature (0%)<br />
kittens (50%), groups: [ cat_lovers ], users: [ 14 ]<br />
**aaron**<br />
hubot rollout activate experimental_feature<br />
**hubot**<br />
experimental_feature has been activated<br />
**aaron**<br />
hubot rollout activate_user kittens 75<br />
**hubot**<br />
kittens has been activated for user with id 75<br />
**aaron**<br />
hubot rollout features<br />
**hubot**<br />
experimental_feature (100%)<br />
kittens (50%), groups: [ cat_lovers ], users: [ 14, 75 ]<br />

=====

## Open Source by [Hired](https://hired.com/?utm_source=opensource&utm_medium=rollout_control&utm_campaign=readme)

We are Ruby developers ourselves, and we use all of our open source projects in production. We always encourge forks, pull requests, and issues. Get in touch with the Hired Engineering team at _opensource@hired.com_.

## License

rollout_control project is MIT licensed. See MIT-LICENSE file for more details.
