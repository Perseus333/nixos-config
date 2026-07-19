# Imperative Networking

This is a guide for the steps outside of the NixOS config that need to be carried out in order for the networking of this setup to work.

## VPS Firewalls

The following ports should be enabled in the VPS firewall:

|Port|Type|Use|
|---|---|---|
|1558|UDP|Wireguard|
|53|TCP|DNS|
|53|UDP|DNS|

You may also want to enable, during setup only port 22 and 4684, UDP for initial SSH access when wireguard is not enabled. Remember to close them afterwards even though the firewall policies in NixOS block them.

## Registering ACME

If you don't have the domain set up yet you will need to register it to Let's Encrypt. This section is to be run on `venti`.

1. In `modules/networking/acme-dns.nix` set the value `services.acme-dns.settings.api.disable_registration` to `false` and rebuild nixos.

2. Then, get your credentials with:

```sh
curl -sX POST http://localhost:8055/register | jq .
```

You should get an output similar to:

```json
{
  "username": "UUID_USERNAME",
  "password": "PASSWORD",
  "fulldomain": "UUID_SUBDOMAIN.auth.DOMAIN.TLD",
  "subdomain": "UUID_SUBDOMAIN",
  "allowfrom": []
}
```

3. Create the file `/var/lib/acme/acme-dns.json` and populate it as follows, where JSON_BLOCK is the output that you got from the previous step.

```json
{
  "DOMAIN.TLD": {
    JSON_BLOCK
  },
  "*.DOMAIN.TLD": {
    JSON_BLOCK
  }
}
```

4. Update the permissions of the file:

```sh
chown acme:acme /var/lib/acme/acme-dns.json
chmod 600 /var/lib/acme/acme-dns.json
```

5. It would be advisable to restart the acme-dns service to make sure that the changes apply.

## DNS records

In Porkbun, or whatever your registrar may be, you will need to set up the DNS records so that acme-dns works and does the DNS-01 Challenge successfully. The records that need to be set are the following, where ACME_DNS_FULL_DOMAIN is the value of `fulldomain` in the previous section JSON_BLOCK that you got from the register command.

|Type|Host|Value|Use|
|---|---|---|---|
|A|*.perseuslynx.dev|XIAO_IP|Subdomains|
|ALIAS|perseuslynx.dev|perseus333.github.io|Base domain (this may change if self-hosting the website)|
|CNAME|_acme-challenge.perseuslynx.dev|ACME_DNS_FULL_DOMAIN|DNS-01 Challenge|
|NS|auth.perseuslynx.dev|acme-ns.perseuslynx.dev.|Name server|

## Renewing ACME & Closing Registration
On `venti` the ACME renewal will take place.

1. After setting the DNS records wait at least 2 minutes.
2. Trigger the renewal service, but before doing so, try setting:
`security.acme.certs."DOMAIN.TLD".dnsPropagationCheck` to `true`, if you encounter issues with DNS propagation try turning it back to false.

```sh
systemctl start acme-order-renew-DOMAIN.TLD.service
```

3. On a separate window, it is helpful to monitor the progress:
```sh
journalctl -u acme-order-renew-perseuslynx.dev.service -f
```

4. Wait some minutes, if everything went right, you should be able to access your subdomains via Wireguard!
