{config,lib,pkgs,inputs, ...}:
{
  environment.systemPackages = with pkgs; [
    pkgs.hello
  ];
}