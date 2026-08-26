# Adding services

When adding a new service, you will need to specify it's configuration throughout several files depending on its use-case and requirements.

(TODO: Reduce the amount of files needed to be modfied to add new services)

All services:
- `modules/services/SERVICE_NAME.nix`
- `modules/services/default.nix`
- `hosts/HOST/hardening-assignments.nix`
 
If it needs to be accessible from the network:
- `modules/networking/port-map.nix`
- `hosts/HOST/caddy-conf.nix`
- `modules/networking/unbound.nix`

If it requires accessing from outside the wireguard network (LAN, or public internet):
- `hosts/HOST/fw-zones-conf.nix`


## Minimum requirements


First you'll need to define the module. The general rule of thumb is to declare just what's necessary for the program to run. If there are any specific service (not systemd) settings that are necessary or beneficial, include them too. Be sure to use: [NixOS Search - Options](https://search.nixos.org/options) to find options for your service.

`modules/services/SERVICE_NAME.nix`

```nix
{ ... }:
{
  services.SERVICE_NAME = {
    enable = true;
    # Other settings...
  };
}
```

You'll also need to add the serice to the default list of services (most likely); just append the name of the service to the imports list, this will add it to the host if it includes this module (TODO: Set it to the `server` role):

`modules/services/default.nix`

```nix
{ ... }:
{
  imports = [
    # ...
    ./SERVICE_NAME.nix
  ];
}
```

You should also harden the service; to do so, add it's systemd unit name into the specified file. Regardless of the contents of the list (but only so long as a list is defined) the unit will be applied the base profile which provides maximum hardening. If any of the settings causes breakage, you may specify additional profiles like "usesJIT" to ensure correct functioning. You should be deliberate with the profiles and only enable them iff they casue breakage. 

`hosts/HOST/hardening-assignments.nix`

```nix
{ ... }:
{
  ivy.hardening.services = {
    SERVICE_NAME = [ ];
    # OR
    SERVICE_NAME = [ "usesJIT" ];
  };
}
```

## Services accessible from the network

You'll probably want to access most of the services that you spin up from your clients, and preferably see a neat web-UI. To do so you'll need to set up Caddy and Unbound to recognize them, as well as configure their port in a way that does not conflict with other services.

To set the port, create an entry in `modules/networking/port-map.nix` and there place the name of your service in it's corresponding place, sorted by their port number. Services with a larger port number should go after, it's not alphabetical.

`modules/networking/port-map.nix`

```nix
{ lib, ... }:
{
  # ...
  config.ports = {
    # ...
    SERVICE_NAME = PORT_NUMBER;
    # ...
  };
}
```

You'll want to specify that port in the service config file. For most services, this option is under `services.SERVICE_NAME.port`.

`modules/services/SERVICE_NAME.nix`

```nix
{ config, ... }:
{
  service.SERVICE_NAME = {
    enable = true;
    port = config.ports.SERVICE_NAME;
    # ...
  };
}
```

You don't want to be specifying port numbers in your browser, so instead you'll access the service via a subdomain. Declare the subdomain in the caddy configuration. I like to keep my subdomains 3-4 letters long.

`hosts/HOST/caddy-conf.nix`

```nix
{ config, ... }:

let
  ports = config.ports;
in {
  caddy = {
    openFirewall = false;
    services = {
      "SUBDOMAIN" = ports.SERVICE_NAME;
```

To make that subdomain accessible, you'll need to add it to the DNS resolver, unbound. Modify it's config file to point it to your server IP address:

`modules/networking/unbound.nix`

```nix
{ ... }:

{
  services.unbound = {
    settings = {
      server = {
        # ...
        local-data = [
          ''"SUBDOMAIN.DOMAIN. IN A IP_ADDRESS"''
          # example:
          ''"cal.perseuslynx.dev. IN A 10.8.0.1"''
        ];
    # ...
```

If the service needs other ports than 443 or should be accessed from the LAN or from the public internet (DON'T do unless strictly necessary, and evaluate security implications!) you may add it's ports to the firewall config.

`modules/networking/fw-zones-conf.nix`

```nix
{config, ... }:

let
  ports = config.ports;
in {
  config.ivy.firewall-zones.zones = {

    # Anyone on the internet has access to these ports
    # Relay: open everywhere
    # Server: open in wg0, and to LAN IPs
    publicPorts = [
      # ...
      # Example:
      { port = ports.SERVICE_NAME;   proto = "tcp"; }
    ];

    # Devices in the LAN or WireGuard
    # Relay: open only in wg0
    # Server: open in wg0, and to LAN IPs
    lanPorts = [
      # ...
    ];

    # Only accessible through WireGuard
    # Relay: open only in wg0
    # Server: open only in wg0
    wgOnlyPorts = [
      # ...
   ];
  };
```

