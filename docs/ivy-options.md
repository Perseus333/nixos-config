## ivy\.firewall-zones\.relay\.externalInterface

Public-facing NIC on the relay host\.

*Type:*
string

*Default:*

```nix
"ens6"
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.relay\.target

WireGuard IP of the server that publicPorts are forwarded to\.

*Type:*
string

*Default:*

```nix
"10.8.0.1"
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.lanPorts

Ports accessible from the local network and WireGuard clients\.

*Type:*
list of (submodule)

*Default:*

```nix
[ ]
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.lanPorts\.\*\.port

Public-facing port\.

*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.lanPorts\.\*\.proto

Protocol used, supports only TCP or UDP\. For services with both, use two entries

*Type:*
one of “tcp”, “udp”

*Default:*

```nix
"tcp"
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.lanPorts\.\*\.targetPort

Remapping, specify only if internal port targeted is different than the public port\.

*Type:*
null or 16 bit unsigned integer; between 0 and 65535 (both inclusive)

*Default:*

```nix
null
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.publicPorts

Ports exposed to the public internet\.

*Type:*
list of (submodule)

*Default:*

```nix
[ ]
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.publicPorts\.\*\.port

Public-facing port\.

*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.publicPorts\.\*\.proto

Protocol used, supports only TCP or UDP\. For services with both, use two entries

*Type:*
one of “tcp”, “udp”

*Default:*

```nix
"tcp"
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.publicPorts\.\*\.targetPort

Remapping, specify only if internal port targeted is different than the public port\.

*Type:*
null or 16 bit unsigned integer; between 0 and 65535 (both inclusive)

*Default:*

```nix
null
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.wgOnlyPorts

Ports accessible only via WireGuard\.

*Type:*
list of (submodule)

*Default:*

```nix
[ ]
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.wgOnlyPorts\.\*\.port

Public-facing port\.

*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.wgOnlyPorts\.\*\.proto

Protocol used, supports only TCP or UDP\. For services with both, use two entries

*Type:*
one of “tcp”, “udp”

*Default:*

```nix
"tcp"
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.firewall-zones\.zones\.wgOnlyPorts\.\*\.targetPort

Remapping, specify only if internal port targeted is different than the public port\.

*Type:*
null or 16 bit unsigned integer; between 0 and 65535 (both inclusive)

*Default:*

```nix
null
```

*Declared by:*
 - modules/networking/firewall-zones\.nix

## ivy\.hardening\.enable

Whether to enable custom service hardening\.

*Type:*
boolean

*Default:*

```nix
true
```

*Declared by:*
 - modules/base/hardening-profiles\.nix

## ivy\.hardening\.services

Attrset of service names mapped to profiles besides base

*Type:*
attribute set of list of (one of “lowPortBinding”, “netAdmin”, “offline”, “stateless”, “unManagedUsers”, “usesJIT”, “usesNspawn”)

*Default:*

```nix
{ }
```

*Declared by:*
 - modules/base/hardening-profiles\.nix

## ivy\.roles\.relay\.enable

Whether to enable Public relay role\. Forwards traffic to the server…

*Type:*
boolean

*Default:*

```nix
false
```

*Example:*

```nix
true
```

*Declared by:*
 - modules/base/roles\.nix

## ivy\.roles\.server\.enable

Whether to enable home server role\. Hosts services and is not exposed to the internet…

*Type:*
boolean

*Default:*

```nix
false
```

*Example:*

```nix
true
```

*Declared by:*
 - modules/base/roles\.nix

## ivy\.roles\.server\.adblock\.enable

Whether to enable SteveP blacklist (full) into Unbound’s blocklist…

*Type:*
boolean

*Default:*

```nix
false
```

*Example:*

```nix
true
```

*Declared by:*
 - modules/base/roles\.nix

## ivy\.roles\.server\.cert-manager\.enable

Whether to enable automated Let’s Encrypt SSL certificates with acme-dns\.

*Type:*
boolean

*Default:*

```nix
false
```

*Example:*

```nix
true
```

*Declared by:*
 - modules/base/roles\.nix

## ivy\.zfs\.enable

Whether to enable Enable ZFS configuration\.

*Type:*
boolean

*Default:*

```nix
false
```

*Example:*

```nix
true
```

*Declared by:*
 - modules/base/zfs\.nix

