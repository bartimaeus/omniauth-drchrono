# OmniAuth DrChrono OAuth2 Strategy

A DrChrono OAuth2 strategy for OmniAuth.

For more details, read the DrChrono documentation: https://www.drchrono.com/api/

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-drchrono'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-drchrono

## Usage

Register your application with DrChrono to receive an API key: https://www.drchrono.com/api/

This is an example that you might put into a Rails initializer at `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :drchrono, ENV['DRCHRONO_CLIENT_ID'], ENV['DRCHRONO_CLIENT_SECRET'], :scope => 'user:read patients:read patients:summary:read'
end
```

You can now access the OmniAuth DrChrono OAuth2 URL: `/auth/drchrono`.

## Granting Member Permissions to Your Application

With the DrChrono API, you have the ability to specify which permissions you want users to grant your application.
For more details, read the DrChrono documentation: https://www.drchrono.com/api/

You can configure the scope option:

```ruby
provider :drchrono, ENV['DRCHRONO_CLIENT_ID'], ENV['DRCHRONO_CLIENT_SECRET'], :scope => 'user:read'
```

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request
