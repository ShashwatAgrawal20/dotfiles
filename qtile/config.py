# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

################################################################
########################     IMPORTS     #######################
################################################################


import os
import re
import socket
import subprocess
from libqtile import qtile 
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.widget import Spacer, Backlight
from libqtile.widget.image import Image 


mod = "mod1"
terminal = "qterminal" # guess_terminal()
Primary_Menu = "dmenu_run"

################################################################
########################   KEYBINDINGS   #######################
################################################################

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

	# MANUALLY


    Key([mod], "p", lazy.spawn(Primary_Menu), desc="Launch Dmenu"),

]

################################################################
########################    WORKSPACES    ######################
################################################################

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


################################################################
########################     LAYOUTS      ######################
################################################################

layouts = [
    layout.Columns(border_focus = colors[3], margin = 2),
    #layout.Bsp(border_focus = colors[3], margin = 2),
    #layout.RatioTile(border_focus = colors[3], margin = 2),
    #layout.Tile(border_focus = colors[3], margin = 2),
	#layout.MonadTall(border_focus = colors[3], margin = 2),
	#layout.MonadWide(border_focus = colors[3], margin = 2),
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]


################################################################
########################      COLORS      ######################
################################################################

colors = [["#2B3339", "#2B3339"],  #background (dark grey) [0]
          ["#7C8377", "#7C8377"],  #light grey [1]
          ["#D5C9AB", "#D5C9AB"],  #forground (beige) [2]
          ["#6272a4", "#6272a4"],  #blue/grey) [3]
          ["#7FBBB3", "#7FBBB3"],  #blue [4]
          ["#A7C080", "#A7C080"],  #green [5]
          ["#E69875", "#E69875"],  #orange [6]
          ["#D196B3", "#D196B3"],  #pink [7]
          ["#A7C080", "#A7C080"],  #green [8]
          ['#ED8082', '#ED8080'],  #red [9]
          ["#D5C9AB", "#D5C9AB"]]  #beige [10]



widget_defaults = dict(
    font="Ubuntu Bold",
    fontsize=12,
    padding=2,
	background = colors[0],
)
extension_defaults = widget_defaults.copy()


################################################################
########################      TOPBAR      ######################
################################################################

screens = [
    Screen(
        top=bar.Bar(
            [
				widget.Image(
					filename = '~/.config/qtile/icon/python.png', 
					scale = 'False', 
					margin_x = 5, 
					mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(Primary_Menu)}
				), 

				widget.Sep(
					linewidth = 2, 
					padding =  5, 
					foreground = colors[2]
				),  

                widget.GroupBox(
					margin_x = 5, 
					active = colors[2], 
					inactive = colors[1], 
					highlight_color = ["#2B3339", "A7C080"], 
					highlight_method = 'line',
				),

                widget.Prompt(),

				widget.Sep(
					linewidth = 2, 
					padding =  5, 
					foreground = colors[2]
				),  

                widget.WindowName(
					foreground = colors[5]
				),

                widget.Chord(
                    chords_colors={
                        "launch": ("#ff5555", "#ff5555"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Systray(),

				widget.Sep(
					linewidth = 2, 
					padding =  5, 
					foreground = colors[2]
				),  
				
				widget.Net(
					interface = 'wlan0', 
					format = 'Net: {down} ↓↑ {up}', 
					padding = 5, 
					foreground = colors[7]
				), 

				widget.Sep(
					linewidth = 2, 
					padding =  5, 
					foreground = colors[2]
				),  
	
				widget.CPU(
			    format = ' {freq_current}GHz {load_percent}%',
                padding = 10,
                foreground = colors[10]
				),

				widget.Sep(
					linewidth = 2, 
					padding =  5, 
					foreground = colors[2]
				),  

				widget.Memory(
                    foreground = colors[4],
                    fmt = '  {}',
                    padding = 10

				),

				widget.Sep(
					linewidth = 2, 
					padding =  5, 
					foreground = '#ffffff'
				),  

                widget.Clock(
					format=' %a %d %m %Y |  %I:%M %p', 
					foreground = colors[2], 
					padding = 10, 
				),

				widget.Sep(
					linewidth = 2, 
					padding =  5, 
					foreground = '#ffffff'
				),  

                widget.QuickExit(
					fmt = ' ',
					foreground = colors[9],
					padding = 10
				),

            ],
            20,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


################################################################
########################   AUTOSTARTUP   #######################
################################################################

@hook.subscribe.startup_once
def autostart():
	home = os.path.expanduser('~/.config/qtile/autostart.sh')
	subprocess.call([home])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
