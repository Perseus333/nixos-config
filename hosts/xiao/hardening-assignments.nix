{ ... }:

{
  ivy.hardening.services = {
    # By default all contain default settings
    # TODO: remove caddy from Xiao completely
    caddy                   = [ "stateless" "lowPortBinding" ];
  };
}
