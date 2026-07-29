# Common Darwin base configuration
# Always applied - independent of any dot.* option
{ username, ... }:
{
  config = {
    system.primaryUser = username;
  };
}
