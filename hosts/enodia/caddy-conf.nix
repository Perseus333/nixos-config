{ ... }:

{
  caddy = {
    proxyTarget = "10.8.0.1";
    openFirewall = true;
    services = {
      "git" = 3000;
    };
  };
}
