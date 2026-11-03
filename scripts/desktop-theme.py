#!/usr/bin/python3
"""Apply Omarchy color palettes without sourcing executable theme files."""
import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tomllib

HOME = Path.home()
ROOT = HOME / '.config/desktop-theme'
PALETTES = ROOT / 'palettes'
USER_PALETTES = ROOT / 'custom'


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_name(path.name + '.tmp')
    tmp.write_text(text)
    tmp.replace(path)


def validate(colors):
    required = ('accent selection muted background lighter_background foreground '
                'dark_foreground bright_foreground red yellow green blue magenta cyan').split()
    for key in required:
        if not re.fullmatch(r'#[0-9a-fA-F]{6}', colors.get(key, '')):
            raise ValueError(f'Missing or invalid theme color: {key}')
    for key, value in colors.items():
        if key not in ('name', 'mode') and not re.fullmatch(r'#[0-9a-fA-F]{6}', str(value)):
            raise ValueError(f'Invalid theme color: {key}')
    return colors


def themes():
    return {p.stem: p for folder in (PALETTES, USER_PALETTES)
            if folder.exists() for p in sorted(folder.glob('*.json'))}


def apply(name, no_reload=False):
    available = themes()
    if name not in available:
        raise ValueError(f'Unknown theme: {name}')
    c = validate(json.loads(available[name].read_text()))
    # Use a readable secondary foreground rather than the low-contrast ANSI black.
    muted = c.get('light_foreground', c['foreground'])
    mapping = dict(bg=c['background'], panel=c['lighter_background'], fg=c['foreground'],
                   muted=muted, accent=c['accent'], selection=c['selection'],
                   bright=c['bright_foreground'], red=c['red'], yellow=c['yellow'])
    css = ''.join(f'@define-color theme_{k} {v};\n' for k, v in mapping.items())
    write(ROOT / 'colors.css', css)
    write(HOME / '.config/waybar/colors.css', css)
    write(ROOT / 'colors.rasi', '* {\n' + ''.join(f'    {k}: {v};\n' for k, v in mapping.items()) + '}\n')
    write(ROOT / 'hyprland.lua', 'hl.config({ general = { col = {\n'
          + '    active_border = "rgba(' + c['accent'][1:] + 'ff)",\n'
          + '    inactive_border = "rgba(' + c['muted'][1:] + 'aa)",\n'
          + '} } })\n')
    ansi = [c['background'], c['red'], c['green'], c['yellow'], c['blue'], c['magenta'], c['cyan'], c['foreground'],
            c['dark_foreground'], c.get('bright_red', c['red']), c.get('bright_green', c['green']),
            c.get('bright_yellow', c['yellow']), c.get('bright_blue', c['blue']),
            c.get('bright_magenta', c['magenta']), c.get('bright_cyan', c['cyan']), c['bright_foreground']]
    write(ROOT / 'ghostty.conf', f'background = {c["background"]}\nforeground = {c["foreground"]}\n'
          + f'cursor-color = {c["accent"]}\nselection-background = {c["selection"]}\nselection-foreground = {c["foreground"]}\n'
          + ''.join(f'palette = {i}={color}\n' for i, color in enumerate(ansi)))
    write(ROOT / 'current.json', json.dumps({'name': name, 'source': str(available[name])}, indent=2) + '\n')
    print(f'Applied {name} to Waybar, Rofi, Hyprland borders and Ghostty.')
    if not no_reload:
        # External IPC is bounded; themes still save when no compositor is reachable.
        result = subprocess.run(['hyprctl', 'reload'], capture_output=True, text=True, timeout=5)
        if result.returncode:
            print('Saved. Run ~/.local/bin/reload-desktop.sh inside Hyprland to apply live changes.', file=sys.stderr)
        else:
            subprocess.run([str(HOME / '.local/bin/desktop-bar.sh'), 'restart'], timeout=10, check=False)
            subprocess.run(['pkill', '-USR2', '-u', str(os.getuid()), '-x', 'ghostty'], check=False)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--apply', metavar='THEME')
    group.add_argument('--import', dest='import_file', type=Path, metavar='COLORS.TOML')
    group.add_argument('--list', action='store_true')
    parser.add_argument('--name', help='Name for an imported palette')
    parser.add_argument('--no-reload', action='store_true')
    args = parser.parse_args()
    if args.import_file:
        name = args.name or args.import_file.parent.name
        if not re.fullmatch('[a-z0-9][a-z0-9-]*', name):
            raise ValueError('Theme names must contain lowercase letters, numbers and hyphens.')
        c = validate(tomllib.loads(args.import_file.read_text()))
        write(USER_PALETTES / (name + '.json'), json.dumps(c, indent=2) + '\n')
        print(f'Imported {name}. Apply with desktop-theme.py --apply {name}')
        return
    available = themes()
    if args.list:
        print('\n'.join(available))
        return
    name = args.apply
    if not name:
        names = list(available)
        current = json.loads((ROOT / 'current.json').read_text()).get('name') if (ROOT / 'current.json').exists() else ''
        labels = [n.replace('-', ' ').title() + ('  ✓' if n == current else '') for n in names]
        result = subprocess.run(['rofi', '-config', str(HOME / '.config/rofi/config.rasi'), '-dmenu',
                                 '-p', 'Theme', '-format', 'i', '-no-custom', '-theme-str',
                                 'listview { columns: 1; lines: 6; } entry { placeholder: "Choose a theme…"; } '
                                 'textbox { str: "Omarchy palettes · Enter apply · Esc cancel"; }'],
                                input='\n'.join(labels), text=True, capture_output=True)
        if result.returncode or not result.stdout.strip():
            return
        index = int(result.stdout.strip())
        if not 0 <= index < len(names):
            return
        name = names[index]
    apply(name, args.no_reload)


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError, subprocess.TimeoutExpired) as error:
        print(f'Theme error: {error}', file=sys.stderr)
        sys.exit(1)
