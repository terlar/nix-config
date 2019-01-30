#!/usr/bin/env python3
#
# Move and resize window into screen corners.
# works with multiple, horizontally aligned displays.
#
# Requirements:
# * Python3.7 (for dataclass)
# * wmctrl
# * xdotool
# * xwininfo
# pip: screeninfo, click
#
import logging

import re
import subprocess
from dataclasses import dataclass

import click
from screeninfo import Monitor, get_monitors

logger = logging.getLogger()
monitors = get_monitors()


@dataclass
class WindowDimension:
    abs_left_x: int
    abs_left_y: int
    rel_left_x: int
    rel_left_y: int
    width: int
    height: int


def get_active_window_id() -> str:
    """
    Get window ID of currently active window
    """
    return subprocess.check_output(['xdotool', 'getactivewindow']).decode().strip()


def reset_window():
    """
    Reset window maximizations so move-resize actually works
    """
    subprocess.call(
        ['wmctrl', '-i', '-r', get_active_window_id(), '-b', 'remove,maximized_vert,maximized_horz'])


def window_move_resize(x: int, y: int, width: int, height: int):
    """
    Move and resize window
    """
    reset_window()
    cmd = ['wmctrl', '-i', '-r', get_active_window_id(), '-e', f'1,{x},{y},{width},{height}']
    logger.debug(f"Running cmd: '{' '.join(cmd)}'")
    return subprocess.check_output(cmd)


def get_monitor(x) -> Monitor:
    """
    Get monitor belonging to screen coordinate
    """
    for i, monitor in enumerate(monitors):
        logger.debug(f"monitor {i} width: {monitor.width}")
        logger.debug(f"monitor {i} height: {monitor.height}")
        logger.debug(f"monitor {i} x: {monitor.x}")
        logger.debug(f"monitor {i} y: {monitor.y}\n")

        if monitor.x <= x <= monitor.x + monitor.width:
            return monitor


def get_window_dimensions() -> WindowDimension:
    win_info = subprocess.check_output(['xwininfo', '-id', get_active_window_id()]).decode()
    logger.debug(win_info)
    abs_left_x = int(re.findall('Absolute upper-left X:  (\d*)', win_info)[0])
    abs_left_y = int(re.findall('Absolute upper-left Y:  (\d*)', win_info)[0])
    rel_left_x = int(re.findall('Relative upper-left X:  (\d*)', win_info)[0])
    rel_left_y = int(re.findall('Relative upper-left Y:  (\d*)', win_info)[0])
    width = int(re.findall('Width: (\d*)', win_info)[0])
    height = int(re.findall('Height: (\d*)', win_info)[0])
    return WindowDimension(
        abs_left_x=abs_left_x, abs_left_y=abs_left_y,
        rel_left_x=rel_left_x, rel_left_y=rel_left_y,
        width=width, height=height)


def configure_logging(verbose: int):
    loglevel = logging.WARNING
    if verbose >= 2:
        loglevel = logging.DEBUG
    elif verbose >= 1:
        loglevel = logging.INFO
    logging.basicConfig(level=loglevel)


@click.command()
@click.option('-v', '--verbose', count=True)
@click.argument('direction', type=click.Choice([
    'top', 'top-right', 'right', 'bottom-right', 'bottom', 'bottom-left', 'left', 'top-left',
    'left-display', 'right-display', 'fullscreen']))
def move_window(verbose, direction):
    configure_logging(verbose)
    dimension = get_window_dimensions()
    win_mon = get_monitor(dimension.abs_left_x)
    logger.debug(f"window monitor: {win_mon}")

    if direction == 'top':
        window_move_resize(
            win_mon.x, win_mon.y,
            win_mon.width, int(win_mon.height / 2))

    if direction == 'top-right':
        window_move_resize(
            win_mon.x + int(win_mon.width / 2), win_mon.y,
            int(win_mon.width / 2), int(win_mon.height / 2))

    elif direction == 'right':
        window_move_resize(
            win_mon.x + int(win_mon.width / 2), win_mon.y,
            int(win_mon.width / 2), win_mon.height)

    if direction == 'bottom-right':
        window_move_resize(
            win_mon.x + int(win_mon.width / 2), win_mon.y + int(win_mon.height / 2),
            int(win_mon.width / 2), int(win_mon.height / 2))

    elif direction == 'bottom':
        window_move_resize(
            win_mon.x, win_mon.y + int(win_mon.height / 2),
            win_mon.width, int(win_mon.height / 2))

    if direction == 'bottom-left':
        window_move_resize(
            win_mon.x, win_mon.y + int(win_mon.height / 2),
            int(win_mon.width / 2), int(win_mon.height / 2))

    elif direction == 'left':
        window_move_resize(
            win_mon.x, win_mon.x,
            int(win_mon.width / 2), win_mon.height)

    elif direction == 'top-left':
        window_move_resize(
            win_mon.x, win_mon.y,
            int(win_mon.width / 2), int(win_mon.height / 2))

    elif direction == 'left-display':
        window_move_resize(
            0, 0,
            win_mon.width, win_mon.height)

    elif direction == 'right-display':
        window_move_resize(
            win_mon.width + 1, 0,
            dimension.width, dimension.height)

    elif direction == 'fullscreen':
        window_move_resize(
            win_mon.x, win_mon.y,
            win_mon.width - 10, win_mon.height)


if __name__ == '__main__':
    move_window()
