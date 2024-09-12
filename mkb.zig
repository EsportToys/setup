const std = @import("std");
const win = std.os.windows;
const WINAPI = win.WINAPI;

extern "user32" fn SystemParametersInfoA(
    uiAction: SPI,
    uiParam: u32, // must be zero if not used
    pvParam: usize, // must be null if not used
    fWinIni: u32,
) callconv(WINAPI) i32;

const SPI = enum(u32) {
    SETMOUSE = 0x0004,
    SETMOUSESPEED = 0x0071,
    SETKEYBOARDDELAY = 0x0017,
    SETKEYBOARDSPEED = 0x000B,
    SETFILTERKEYS = 0x0033,
    SETKEYBOARDCUES = 0x100B,
    SETKEYBOARDPREF = 0x0045,
    SETMOUSEHOVERTIME = 0x0067,
    SETMENUSHOWDELAY = 0x006B,
    _,
};

pub fn main() void {
    const delay = 150;

    // mouse preferences
    var accel: [3]i32 = .{0,0,0}; // must be mutable memory even for setmouse
    _ = SystemParametersInfoA(SPI.SETMOUSE, 0, @intFromPtr(&accel), 1);
    _ = SystemParametersInfoA(SPI.SETMOUSESPEED, 0, 10, 1);

    // keyboard preferences
    _ = SystemParametersInfoA(SPI.SETKEYBOARDCUES, 0, 1, 1);
    _ = SystemParametersInfoA(SPI.SETKEYBOARDPREF, 1, 0, 1);
    _ = SystemParametersInfoA(SPI.SETKEYBOARDDELAY, 0, 0, 1);
    _ = SystemParametersInfoA(SPI.SETKEYBOARDSPEED, 31, 0, 1);

    const FILTERKEYS = extern struct {
        cbSize: u32 = @sizeOf(@This()),
        dwFlags: u32,
        iWaitMSec: u32,
        iDelayMSec: u32,
        iRepeateMSec: u32,
        iBounceMSec: u32,
    };
    var cfg: FILTERKEYS = .{
        .dwFlags = 1,
        .iWaitMSec = 0,
        .iDelayMSec = delay,
        .iRepeateMSec = 1,
        .iBounceMSec = 0,
    };
    _ = SystemParametersInfoA(SPI.SETFILTERKEYS, cfg.cbSize, @intFromPtr(&cfg), 1);

    // hover options
    _ = SystemParametersInfoA(SPI.SETMOUSEHOVERTIME, delay, 0, 1);
    _ = SystemParametersInfoA(SPI.SETMENUSHOWDELAY, delay, 0, 1);
}
