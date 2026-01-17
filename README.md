# HTB Ruby

A Ruby gem for interacting with the [Hack The Box](https://www.hackthebox.com/) API v4.

## Important: Base URI Change

The HTB API base URI has changed from the legacy `www.hackthebox.com` to `labs.hackthebox.com`. This gem uses the correct, updated base URI.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'htb'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install htb
```

## Configuration

You'll need an HTB API token. You can obtain one from your [HTB Account Settings](https://app.hackthebox.com/profile/settings).

### Interactive Login (Recommended)

The easiest way to configure your token:

```bash
htb login
```

This will:
1. Prompt you for your API token (input is masked)
2. Validate the token with HTB
3. Save it securely to `~/.htbrc` (with 600 permissions)

### Environment Variable

Alternatively, set an environment variable (takes priority over config file):

```bash
export HTB_API_TOKEN=your_token_here
```

### Managing Configuration

```bash
htb config   # Show current configuration
htb login    # Set/update API token
htb logout   # Remove saved token
```

## CLI Usage

The gem includes a full-featured command-line interface.

### Quick Start

```bash
# First time? Login to save your token
htb login

# Show your profile
htb me

# Show current status (VM + VPN)
htb status

# List machines
htb machines list
htb machines list --retired
htb machines list --sp

# Get machine info
htb machines info Gavel
htb machines info 811

# Spawn/terminate machines
htb spawn 811
htb terminate 811

# Or using subcommands
htb vm spawn 811
htb vm terminate 811
htb vm reset 811
htb vm extend 811

# Submit flags
htb machines own 811 --flag "HTB{...}"
```

### All CLI Commands

```bash
# Main commands
htb status              # Show VM and VPN status
htb me                  # Show your profile
htb spawn MACHINE_ID    # Spawn a machine (shortcut)
htb terminate MACHINE_ID # Terminate a machine (shortcut)
htb version             # Show version

# Machine commands
htb machines list       # List active machines
htb machines list --retired  # List retired machines
htb machines list --sp  # List Starting Point machines
htb machines info NAME  # Show machine details
htb machines active     # Show active machine
htb machines play ID    # Start machine (free VPN)
htb machines stop       # Stop current machine
htb machines own ID --flag FLAG  # Submit a flag
htb machines search QUERY  # Search machines
htb machines recommended   # Show recommendations

# VM commands
htb vm spawn ID         # Spawn machine (VIP/SP)
htb vm terminate ID     # Terminate machine
htb vm reset ID         # Reset machine
htb vm extend ID        # Extend time
htb vm status           # Show VM status
htb vm active           # Show active VM

# User commands
htb users me            # Your profile
htb users info USER_ID  # User profile by ID
htb users activity USER_ID  # User activity
htb users bloods USER_ID    # User's first bloods
htb users badges USER_ID    # User's badges
htb users subscriptions     # Your subscriptions

# Challenge commands
htb challenges list     # List challenges
htb challenges list --retired  # Retired challenges
htb challenges info ID  # Challenge details
htb challenges start ID # Start a challenge
htb challenges stop ID  # Stop a challenge
htb challenges spawn ID # Spawn instance
htb challenges own ID --flag FLAG  # Submit flag
htb challenges categories  # List categories
htb challenges active   # Show active challenge

# VPN commands
htb vpn status          # Connection status
htb vpn servers         # List VPN servers
htb vpn switch ID       # Switch server
htb vpn regenerate      # Regenerate config
htb vpn labs            # List labs
htb vpn prolabs         # List Pro Labs
htb vpn endgames        # List Endgames
htb vpn fortresses      # List Fortresses
```

## Ruby Library Usage

```ruby
require 'htb'

# Configure globally
HTB.configure do |config|
  config.api_token = ENV['HTB_API_TOKEN']
end

# Or create a client directly
client = HTB::Client.new(api_token: ENV['HTB_API_TOKEN'])
```

## Library Examples

### Machines

```ruby
client = HTB::Client.new(api_token: ENV['HTB_API_TOKEN'])

# List all machines
machines = client.machines.list

# Get machine profile
machine = client.machines.profile("Gavel")  # by name
machine = client.machines.profile(811)       # by ID

# Get active machine
active = client.machines.active

# Get retired machines
retired = client.machines.retired

# Get Starting Point machines
sp = client.machines.starting_point

# Submit a flag
client.machines.own(machine_id: 811, flag: "HTB{...}", difficulty: 50)
```

### VM Management (Spawn/Terminate)

```ruby
# Spawn a machine (VIP/Starting Point)
client.vm.spawn(811)

# Get VM status
status = client.vm.status

# Get active VM
active = client.vm.active

# Terminate a machine
client.vm.terminate(811)

# Reset a machine
client.vm.reset(811)

# Extend machine time
client.vm.extend(811)
```

### Users

```ruby
# Get current user info
me = client.users.me

# Get user profile by ID
user = client.users.profile(12345)

# Get user activity
activity = client.users.activity(12345)

# Get user badges
badges = client.users.badges(12345)

# Get subscriptions
subs = client.users.subscriptions
```

### Challenges

```ruby
# List all challenges
challenges = client.challenges.list

# Get challenge info
challenge = client.challenges.info(123)

# Start a challenge
client.challenges.start(123)

# Submit flag
client.challenges.own(challenge_id: 123, flag: "HTB{...}", difficulty: 50)

# Stop a challenge
client.challenges.stop(123)
```

### VPN

```ruby
# Get VPN servers
servers = client.vpn.servers

# Get connection status
status = client.vpn.status

# Get available labs
labs = client.vpn.labs

# Get Prolabs list
prolabs = client.vpn.prolabs

# Get Endgames list
endgames = client.vpn.endgames
```

## API Endpoints Reference

This gem implements the HTB v4 API endpoints. The base URI is `https://labs.hackthebox.com/api/v4`.

### Machines
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/machine/list` | List all machines |
| GET | `/machine/profile/{id_or_name}` | Get machine profile |
| GET | `/machine/active` | Get active machine |
| POST | `/machine/play/{machine_id}` | Play machine (free VPN) |
| POST | `/machine/stop` | Stop machine |
| POST | `/machine/own` | Submit flag |
| GET | `/machine/recommended` | Get recommended machines |
| GET | `/machine/list/retired` | List retired machines |
| GET | `/machine/list/sp` | List Starting Point machines |

### VM Management
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/vm/spawn` | Spawn a machine (VIP/SP) |
| POST | `/vm/terminate` | Terminate a machine |
| POST | `/vm/reset` | Reset a machine |
| POST | `/vm/extend` | Extend machine time |
| GET | `/vm/status` | Get VM status |
| GET | `/vm/active` | Get active VM |

### Users
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/user/info` | Get current user info |
| GET | `/user/profile/basic/{user_id}` | Get user profile |
| GET | `/user/profile/basic/me` | Get own profile |
| GET | `/user/profile/activity/{user_id}` | Get user activity |
| GET | `/user/profile/bloods/{user_id}` | Get user bloods |
| GET | `/user/profile/badges/{user_id}` | Get user badges |

### Challenges
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/challenge/list` | List all challenges |
| GET | `/challenge/info/{id}` | Get challenge info |
| POST | `/challenge/start/{id}` | Start a challenge |
| POST | `/challenge/stop/{id}` | Stop a challenge |
| POST | `/challenge/own` | Submit flag |
| GET | `/challenge/categories/list` | Get categories |

### VPN & Labs
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/connections/servers` | Get VPN servers |
| GET | `/connections/status` | Get VPN status |
| GET | `/labs/list` | Get labs list |
| GET | `/prolab/list` | Get Prolabs list |
| GET | `/endgame/list` | Get Endgames list |

## Error Handling

```ruby
begin
  client.machines.profile("nonexistent")
rescue HTB::AuthenticationError => e
  puts "Invalid API token"
rescue HTB::NotFoundError => e
  puts "Resource not found"
rescue HTB::RateLimitError => e
  puts "Rate limited, slow down"
rescue HTB::Error => e
  puts "API error: #{e.message}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aluminumio/htb-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Disclaimer

This gem is not officially affiliated with or endorsed by Hack The Box. Use responsibly and in accordance with HTB's Terms of Service.
