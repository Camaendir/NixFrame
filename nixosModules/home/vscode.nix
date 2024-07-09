{ inputs, lib, config, pkgs, ...}:
{
	programs.vscode = {
		enable = true;
		userSettings = {
			nix = {
				serverPath = "/run/current-system/sw/bin/nixd";
				enableLanguageServer = true;
			};
		};
		extensions = with pkgs.vscode-extensions; [];
	};
}
