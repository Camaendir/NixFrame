{ pkgs, inputs, config, lib, ... }:
let 
	wallpaper = pkgs.fetchurl {
		url = "https://i.redd.it/r89mwwx8m5zc1.png";
		sha256 = "0mmg7dzk3ilfgh99g9pfwm4kxfgkd88397mk45lkg0y15f0f88qd";
	};
	startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
		clipse -listen
		${pkgs.waybar}/bin/waybar &
		${pkgs.swww}/bin/swww init &
		sleep 1
		${pkgs.swww}/bin/swww img ${wallpaper} &
		dunst
		amixer set Master mute
	'';
in
{
programs.rofi = {
	enable = true;
	extraConfig.modi = "drun,window";
	theme = "gruvbox-dark";
	terminal = "${config.programs.kitty.package}/bin/kitty";
};
programs.waybar = {
	enable = true;
	style = ''
	/* Keyframes */

@keyframes blink-critical {
	to {
		/*color: @white;*/
		background-color: @critical;
	}
}


/* Styles */

/* Colors (gruvbox) */
@define-color black	#282828;
@define-color red	#cc241d;
@define-color green	#98971a;
@define-color yellow	#d79921;
@define-color blue	#458588;
@define-color purple	#b16286;
@define-color aqua	#689d6a;
@define-color gray	#a89984;
@define-color brgray	#928374;
@define-color brred	#fb4934;
@define-color brgreen	#b8bb26;
@define-color bryellow	#fabd2f;
@define-color brblue	#83a598;
@define-color brpurple	#d3869b;
@define-color braqua	#8ec07c;
@define-color white	#ebdbb2;
@define-color bg2	#504945;


@define-color warning 	@bryellow;
@define-color critical	@red;
@define-color mode	@black;
@define-color unfocused	@bg2;
@define-color focused	@braqua;
@define-color inactive	@purple;
@define-color sound	@brpurple;
@define-color network	@purple;
@define-color memory	@braqua;
@define-color cpu	@green;
@define-color temp	@brgreen;
@define-color layout	@bryellow;
@define-color battery	@aqua;
@define-color date	@black;
@define-color time	@white;

/* Reset all styles */
* {
	border: none;
	border-radius: 0;
	min-height: 0;
	margin: 0;
	padding: 0;
	box-shadow: none;
	text-shadow: none;
	icon-shadow: none;
}

/* The whole bar */
#waybar {
	background: rgba(40, 40, 40, 0.8784313725); /* #282828e0 */
	color: @white;
	font-family: JetBrains Mono, Siji;
	font-size: 10pt;
	/*font-weight: bold;*/
}

/* Each module */
#battery,
#clock,
#cpu,
#language,
#memory,
#mode,
#network,
#pulseaudio,
#temperature,
#tray,
#backlight,
#idle_inhibitor,
#disk,
#user,
#mpris {
	padding-left: 8pt;
	padding-right: 8pt;
}

/* Each critical module */
#mode,
#memory.critical,
#cpu.critical,
#temperature.critical,
#battery.critical.discharging {
	animation-timing-function: linear;
	animation-iteration-count: infinite;
	animation-direction: alternate;
	animation-name: blink-critical;
	animation-duration: 1s;
}

/* Each warning */
#network.disconnected,
#memory.warning,
#cpu.warning,
#temperature.warning,
#battery.warning.discharging {
	color: @warning;
}

/* And now modules themselves in their respective order */

/* Current sway mode (resize etc) */
#mode {
	color: @white;
	background: @mode;
}

/* Workspaces stuff */
#workspaces button {
	/*font-weight: bold;*/
	padding-left: 2pt;
	padding-right: 2pt;
	color: @white;
	background: @unfocused;
}

/* Inactive (on unfocused output) */
#workspaces button.visible {
	color: @white;
	background: @inactive;
}

/* Active (on focused output) */
#workspaces button.focused {
	color: @black;
	background: @focused;
}

/* Contains an urgent window */
#workspaces button.urgent {
	color: @black;
	background: @warning;
}

/* Style when cursor is on the button */
#workspaces button:hover {
	background: @black;
	color: @white;
}

#window {
	margin-right: 35pt;
	margin-left: 35pt;
}

#pulseaudio {
	background: @sound;
	color: @black;
}

#network {
	background: @network;
	color: @white;
}

#memory {
	background: @memory;
	color: @black;
}

#cpu {
	background: @cpu;
	color: @white;
}

#temperature {
	background: @temp;
	color: @black;
}

#language {
	background: @layout;
	color: @black;
}

#battery {
	background: @battery;
	color: @white;
}

#tray {
	background: @date;
}

#clock.date {
	background: @date;
	color: @white;
}

#clock.time {
	background: @time;
	color: @black;
}

#custom-arrow1 {
	font-size: 11pt;
	color: @time;
	background: @date;
}

#custom-arrow2 {
	font-size: 11pt;
	color: @date;
	background: @layout;
}

#custom-arrow3 {
	font-size: 11pt;
	color: @layout;
	background: @battery;
}

#custom-arrow4 {
	font-size: 11pt;
	color: @battery;
	background: @temp;
}

#custom-arrow5 {
	font-size: 11pt;
	color: @temp;
	background: @cpu;
}

#custom-arrow6 {
	font-size: 11pt;
	color: @cpu;
	background: @memory;
}

#custom-arrow7 {
	font-size: 11pt;
	color: @memory;
	background: @network;
}

#custom-arrow8 {
	font-size: 11pt;
	color: @network;
	background: @sound;
}

#custom-arrow9 {
	font-size: 11pt;
	color: @sound;
	background: transparent;
}

#custom-arrow10 {
	font-size: 11pt;
	color: @unfocused;
	background: transparent;
}
	'';
	settings = [{
		"layer" = "top";
	"position" = "top";

	"modules-left" = [
		"hyprland/mode"
		"hyprland/workspaces"
		"custom/arrow10"
		"hyprland/window"
	];

	"modules-right" = [
		"custom/arrow9"
		"pulseaudio"
		"custom/arrow8"
		"network"
		"custom/arrow7"
		"memory"
		"custom/arrow6"
		"cpu"
		"custom/arrow5"
		"temperature"
		"custom/arrow4"
		"battery"
		"custom/arrow3"
		"hyprland/language"
		"custom/arrow2"
		"tray"
		"clock#date"
		"custom/arrow1"
		"clock#time"
	];

	#// Modules

	"battery" = {
		"interval" = 10;
		"states" = {
			"warning" = 30;
			"critical" = 15;
		};
		"format-time" = "{H}:{M:02}";
		"format" = "{icon}   {capacity}% ({time})";
		"format-charging" = "  {capacity}% ({time})";
		"format-charging-full" = "  {capacity}%";
		"format-full" = "{icon}   {capacity}%";
		"format-alt" = "{icon}   {power}W";
		"format-icons" = [
			""
			""
			""
			""
			""
		];
		"tooltip" = false;
	};

	"clock#time" = {
		"interval" = 10;
		"format" = "{:%H:%M}";
		"tooltip" = false;
	};

	"clock#date" = {
		"interval" = 20;
		"format" = "{:%e %b %Y}";
		"tooltip" = false;
	#	//"tooltip-format" = "{:%e %B %Y}"
	};

	"cpu" = {
		"interval" = 5;
		"tooltip" = false;
		"format" = "   {usage}%";
		"format-alt" = "   {load}";
		"states" = {
			"warning" = 70;
			"critical" = 90;
		};
	};

	"hyprland/language" = {
		"format" = "";
		"min-length" = 5;
		"tooltip" = false;
	};

	"memory" = {
		"interval" = 5;
		"format" = "   {used:0.1f}G/{total:0.1f}G";
		"states" = {
			"warning" = 70;
			"critical" = 90;
		};
		"tooltip" = false;
	};

	"network" = {
		"interval" = 5;
		"format-wifi" = "   {essid} ({signalStrength}%)";
		"format-ethernet" = "   {ifname}";
		"format-disconnected" = "No connection";
		"format-alt" = "IP: {ipaddr}/{cidr}";
		"tooltip" = false;
	};

	"hyprland/mode" = {
		"format" = "{}";
		"tooltip" = false;
	};

	"hyprland/window" = {
		"format" = "{}";
		"max-length" = 30;
		"separate-outputs" = true;
		"tooltip" = false;
	};

	"hyprland/workspaces" = {
		"disable-scroll-wraparound" = true;
		"smooth-scrolling-threshold" = 4;
		"enable-bar-scroll" = true;
		"format" = "{name}";
		"on-click" = "activate";
		"on-scroll-up" = "hyprctl dispatch workspace e+1";
		"on-scroll-down" = "hyprctl dispatch workspace e-1";
	};

	"pulseaudio" = {
		"format" = "{icon}  {volume}%";
		"format-bluetooth" = "{icon}   {volume}%";
		"format-muted" = "";
		"format-icons" = {
			"headphone" = "";
			"hands-free" = "";
			"headset" = "";
			"phone" = "";
			"portable" = "";
			"car" = "";
			"default" = ["" ""];
		};
		"scroll-step" = 1;
		"on-click" = "amixer set Master toggle";
		"tooltip" = false;
	};

	"temperature" = {
		"critical-threshold" = 90;
		"interval" = 5;
		"format" = "{icon} {temperatureC}°";
		"format-icons" = [
			""
			""
			""
			""
			""
		];
		"tooltip" = false;
	};

	"tray" = {
		"icon-size" = 18;
		#//"spacing" = 10
	};

	"custom/arrow1" = {
		"format" = "";
		"tooltip" = false;
	};

	"custom/arrow2" = {
		"format" = "";
		"tooltip" = false;
	};

	"custom/arrow3" = {
		"format" = "";
		"tooltip" = false;
	};

	"custom/arrow4" = {
		"format" = "";
		"tooltip" = false;
	};

	"custom/arrow5" = {
		"format" = "";
		"tooltip" = false;
	};

	"custom/arrow6" = {
		"format" = "";
		"tooltip" = false;
	};

	"custom/arrow7" = {
		"format" = "";
		"tooltip" = false;
	};

	"custom/arrow8" = {
		"format" = "";
		"tooltip" = false;
	};

	"custom/arrow9" = {
		"format" = "";
		"tooltip" = false;
	};

	"custom/arrow10" = {
		"format" = "";
		"tooltip" = false;
	};
	}];
};

wayland.windowManager.hyprland = {
    enable = true;
    settings = {
	exec-once = ''${startupScript}/bin/start'';
	general = {
		layout = "dwindle";
		gaps_in = 14;
		gaps_out = 20;
		border_size = 3;
		"col.active_border" = "0x88ff1111";
		"col.inactive_border" = "0x88aaaaaa";
	};
	"$mod" = "SUPER";
	monitor = [
		"desc:BOE 0x0BCA, preferred, auto-right, auto"
		"desc:Samsung Electric Company S34J55x H4ZN300188,  preferred, 0x0, auto"
		"desc:Samsung Electric Company S24F350 H4ZJ804091,  preferred, auto-left, auto"
	];
	
	"$terminal" = "kitty";
	"$menu" = "rofi -show window";
	"$fileManager" = "dolphin";	
	workspace = [
	  "1, monitor:DP-8, default:true"
	  "2, monitor:DP-7, default:true"
	  "3, monitor:eDP-1, default:true"
	];
	bind = [
	  "$mod, SPACE, exec, rofi -show drun -show-icons"
	  "ALT, SPACE, exec, $terminal"
	  "$mod, M, exec, rofi -show window"
	  "$mod, Tab, cyclenext,"
	  "$mod, Tab, bringactivetotop,"
	  "$mod, 1, workspace, 1"
	  "$mod, 2, workspace, 2"
	  "$mod, 3, workspace, 3"
	  "$mod, 4, workspace, 4"
	  "$mod, 5, workspace, 5"
	  "$mod, 6, workspace, 6"
	  "$mod, 7, workspace, 7"
	  "$mod, 8, workspace, 8"
	  "$mod, 9, workspace, 9"
	  "$mod, 0, workspace, 10"
	  "$mod, right, workspace, m+1"
	  "$mod, left, workspace, m-1"
	  "$mod, Q, killactive,"
	  "$mod SHIFT, 1, movetoworkspace, 1" 
	  "$mod SHIFT, 2, movetoworkspace, 2" 
	  "$mod SHIFT, 3, movetoworkspace, 3" 
	  "$mod SHIFT, 4, movetoworkspace, 4" 
	  "$mod SHIFT, 5, movetoworkspace, 5" 
	  "$mod SHIFT, 6, movetoworkspace, 6" 
	  "$mod SHIFT, 7, movetoworkspace, 7" 
	  "$mod SHIFT, 8, movetoworkspace, 8" 
	  "$mod SHIFT, 9, movetoworkspace, 9" 
	  "$mod SHIFT, 0, movetoworkspace, 10"
	  "$mod SHIFT, right, movetoworkspace, m+1"
	  "$mod SHIFT, left, movetoworkspace, m-1"
	  "$mod, S, togglespecialworkspace, magic"
	  "$mod SHIFT, S, movetoworkspace, special:magic" 
	  "$mod, left, workspace, l"
	  "$mod, right, workspace, r"
	  "$mod, up, workspace, u"
	  "$mod, down, movefocus, d"
	  "$mod CONTROL, left, moveactive, -30 0"
	  "$mod CONTROL, right, moveactive, 30 0"
	  "$mod CONTROL, up, moveactive, 0 30"
	  "$mod CONTROL, down, moveactive, 0 -30"
	  "$mod, V, exec, $terminal --class clipse -e zsh -c 'clipse'"
	];
	bindm = [
	  "$mod, mouse:272, movewindow"
	  "$mod, mouse:273, resizewindow"
	];
	input = {
	  kb_layout = "us";
	  follow_mouse = "1";
	  natural_scroll = true;
          touchpad = {
            natural_scroll = true;
          };
	};
	gestures = {
	  workspace_swipe = true;
	};
	decoration = {
		rounding = 10;
		blur = {
			enabled = true;
			size = 8;
			passes = 1;
		};
	};
	animations = {
		enabled = 1;
		animation = [
			"windows, 1, 3, default"
			"border, 1, 3, default"
			"fadeIn, 1, 3, default"
			"workspaces, 1, 3, default"
		];
	};
	windowrulev2 = [
		"suppressevent maximize, class:.*"
		"float,class:(clipse)"
		"size 622 652,class:(clipse)"
	];
	dwindle = {
		pseudotile = 0;
	};
	windowrule = [
		"float, Rofi"
		"center, Rofi"
		"pin, Rofi"
		"stayfocused, Rofi"
		"dimaround, Rofi"
		"maxsize 3000 650, Rofi"
		"opacity 0.80, kitty"
		"opacity 0.70, Rofi"
	];
    };
  };
}
