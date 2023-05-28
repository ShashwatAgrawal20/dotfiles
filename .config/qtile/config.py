################################################################
########################     IMPORTS     #######################
################################################################

import os
import subprocess
from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.dgroups import simple_key_binder
import colors

mod = "mod1"
myTerminal = "kitty"  # guess_terminal()
myBrowser = "chromium"
Primary_Menu = "rofi -show drun"
Secondary_Menu = "dmenu_run"
colors, backgroundColor, foregroundColor, workspaceColor, chordsColor = colors.doomone()

################################################################
########################   KEYBINDINGS   #######################
################################################################

keys = [
    # Reloading & Shutting down
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Moving the Focus
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(),
        desc="Move window focus to other window"),
    # Shuffling the windows
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Window Actions (Size)
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key(
        [mod, "control"],
        "h",
        lazy.layout.shrink(),
        lazy.layout.decrease_nmaster(),
        desc="Grow window to the left",
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.grow(),
        lazy.layout.increase_nmaster(),
        desc="Grow window to the right",
    ),
    Key(
        [mod, "control"],
        "j",
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        desc="Grow window down",
    ),
    Key(
        [mod, "control"],
        "k",
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        desc="Grow window up",
    ),
    Key([mod], "r", lazy.layout.reset(), desc="Reset all window sizes"),
    Key([mod], "n", lazy.layout.normalize(),
        desc="Normalize window size ratio"),
    Key(
        [mod],
        "m",
        lazy.layout.maximize(),
        desc="Toggle window between minimum & maximum size",
    ),
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
    # Layout Actions
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod, "shift"],
        "Tab",
        lazy.layout.rotate(),
        lazy.layout.flip(),
        desc="Flipping the layout",
    ),
    # Window Action
    Key(
        [mod, "shift"],
        "f",
        lazy.window.toggle_floating(),
        desc="Toggle floating window",
    ),
    # Launching Stuff
    Key([mod], "p", lazy.spawn(Primary_Menu),
        desc="Launch Rofi"),  # Launching rofi
    Key([mod], "d", lazy.spawn(Secondary_Menu),
        desc="Launch Dmenu"),  # Launching Dmenu
    Key([mod], "Return", lazy.spawn(myTerminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(myBrowser), desc="Launch Browser"),


    # Custom Scripts
    Key([mod, "shift"], "u", lazy.spawn(
        "bash ~/.local/bin/volumechanger up", shell=True),
        desc="Increases Volume"),
    Key([mod, "shift"], "d", lazy.spawn(
        "bash ~/.local/bin/volumechanger down", shell=True),
        desc="Increases Volume"),
    Key([mod, "shift"], "m", lazy.spawn(
        "bash ~/.local/bin/volumechanger mute", shell=True),
        desc="Increases Volume"),
]

################################################################
########################    WORKSPACES    ######################
################################################################

groups = [
    Group(name="1", label="", layout="monadtall"),
    Group(name="2", label="", layout="monadtall"),
    Group(name="3", label="", layout="monadtall"),
    Group(name="4", label="", layout="monadtall"),
    Group(name="5", label="󰒱", layout="monadtall"),
    Group(name="6", label="", layout="monadtall"),
    Group(name="7", label="", layout="monadtall"),
    Group(name="8", label="", layout="monadtall"),
]

dgroups_key_binder = simple_key_binder(mod)


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
                desc="Switch to & move focused window to group {}".format(
                    i.name),
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

layout_theme = {
    "margin": 4,
    "border_width": 2,
    "border_focus": colors[8],
    "border_normal": backgroundColor,
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Floating(**layout_theme),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font", fontsize=12, padding=2, background=backgroundColor
)
extension_defaults = widget_defaults.copy()

################################################################
########################      Top Bar     ######################
################################################################

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Image(
                    filename="~/.config/qtile/icon/python.png",
                    scale="False",
                    margin=5,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(Primary_Menu)},
                ),
                widget.Sep(linewidth=1, padding=10, foreground=colors[2]),
                widget.GroupBox(
                    font="JetBrainsMono Nerd Font",
                    fontsize=16,
                    margin_y=2,
                    margin_x=4,
                    padding_y=6,
                    padding_x=6,
                    borderwidth=2,
                    disable_drag=True,
                    active=colors[4],
                    inactive=foregroundColor,
                    hide_unused=False,
                    rounded=False,
                    highlight_method="line",
                    highlight_color=[backgroundColor, backgroundColor],
                    this_current_screen_border=colors[5],
                    this_screen_border=colors[7],
                    other_screen_border=colors[6],
                    other_current_screen_border=colors[6],
                    urgent_alert_method="line",
                    urgent_border=colors[9],
                    urgent_text=colors[1],
                    foreground=foregroundColor,
                    background=backgroundColor,
                    use_mouse_wheel=False,
                ),
                widget.Sep(linewidth=1, padding=10, foreground=colors[2]),
                widget.TaskList(
                    icon_size=0,
                    font="JetBrainsMono Nerd Font",
                    foreground=colors[2],
                    background=backgroundColor,
                    borderwidth=1,
                    border=colors[1],
                    margin=0,
                    padding=10,
                    highlight_method="block",
                    title_width_method="uniform",
                    urgent_alert_method="border",
                    urgent_border=colors[1],
                    rounded=False,
                    txt_floating="🗗 ",
                    txt_maximized="🗖 ",
                    txt_minimized="🗕 ",
                ),
                widget.Sep(linewidth=1, padding=10, foreground=colors[2]),
                widget.TextBox(
                    text="",
                    fontsize=14,
                    font="JetBrainsMono Nerd Font",
                    foreground=colors[9],
                ),
                widget.Net(
                    # interface='wlan0',
                    format="{down} ↓↑ {up}",
                    padding=5,
                    foreground=foregroundColor,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(myTerminal + " -e nmtui")
                    },
                ),
                widget.Sep(linewidth=0, padding=10),
                widget.TextBox(
                    text="",
                    fontsize=14,
                    font="JetBrainsMono Nerd Font",
                    foreground=colors[7],
                ),
                widget.CPU(
                    font="JetBrainsMono Nerd Font",
                    update_interval=1.0,
                    format="{freq_current}GHz {load_percent}%",
                    foreground=foregroundColor,
                    padding=5,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(myTerminal + " -e htop")
                    },
                ),
                widget.Sep(linewidth=0, padding=10),
                widget.TextBox(
                    text="󰍛",
                    fontsize=14,
                    font="JetBrainsMono Nerd Font",
                    foreground=colors[3],
                ),
                widget.Memory(
                    font="JetBrainsMono Nerd Font",
                    foreground=foregroundColor,
                    fmt="{}",
                    padding=5,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(myTerminal + " -e htop")
                    },
                ),
                widget.Sep(linewidth=0, padding=10),
                widget.TextBox(
                    text="",
                    fontsize=14,
                    font="JetBrainsMono Nerd Font",
                    foreground=colors[10],
                ),
                widget.Clock(
                    format="%a %d %m %Y |%I:%M %p",
                    foreground=foregroundColor,
                    padding=10,
                ),
                widget.Sep(linewidth=1, padding=10, foreground=colors[2]),
                widget.CurrentLayoutIcon(
                    scale=0.5, foreground=foregroundColor, background=backgroundColor
                ),
                widget.Systray(),
            ],
            # 20,
            size=36,
            background=backgroundColor,
            margin=4,
            opacity=0.8,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
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
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
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
