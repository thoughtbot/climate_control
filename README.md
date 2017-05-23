# Climate Control

Easily manage your environment.

## Installation

Add this line to your application's Gemfile:

    gem 'climate_control'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install climate_control

## Usage

Climate Control can be used to temporarily assign environment variables
within a block:

```ruby
ClimateControl.modify CONFIRMATION_INSTRUCTIONS_BCC: 'confirmation_bcc@example.com' do
  sign_up_as 'john@example.com'
  confirm_account_for_email 'john@example.com'
  current_email.should bcc_to('confirmation_bcc@example.com')
end
```

## RSpec metadata

ClimateControl provides easy integration with RSpec using metadata. To set this
up, call `ClimateControl.configure_rspec_metadata!`, you can add this to your `spec_helper.rb`.

Once you've done that, you can have an example group or example use
ClimateControl by passing `:climate_control` as an additional argument after the description
string as key of a hash of configuration like.

```ruby
it 'have the correct current_email', climate_control: { CONFIRMATION_INSTRUCTIONS_BCC: 'confirmation_bcc@example.com' } do
  sign_up_as 'john@example.com'
  confirm_account_for_email 'john@example.com'
  current_email.should bcc_to('confirmation_bcc@example.com')
end
```

To modify the environment for an entire set of tests in RSpec, you can use this on a `describe`:

```ruby
describe Thing, 'name', climate_control: { CONFIRMATION_INSTRUCTIONS_BCC: 'confirmation_bcc@example.com' } do
  # ... tests

end
```

Environment variables assigned within the block will be preserved;
essentially, the code should behave exactly the same with and without the
block, except for the overrides. Transparency is crucial because the code
executed within the block is not for `ClimateControl` to manage or modify. See
the tests for more detail about the specific behaviors.

## Why Use Climate Control?

By following guidelines regarding environment variables outlined by the
[twelve-factor app](http://12factor.net/config), testing code in an isolated
manner becomes more difficult:

* avoiding modifications and testing values, we introduce mystery guests
* making modifications and testing values, we introduce risk as environment
  variables represent global state

Climate Control modifies environment variables only within the context of the
block, ensuring values are managed properly and consistently.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

climate_control is copyright 2012-2017 Joshua Clayton and thoughtbot, inc. It is free software and may be redistributed under the terms specified in the [LICENSE.txt](https://github.com/thoughtbot/climate_control/blob/master/LICENSE.txt) file.
