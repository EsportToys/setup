const slider_id = 0x0420;

var label: HWND = undefined;
var slider: HWND = undefined;

pub fn main() void {
    const main_style = WS_VISIBLE | WS_CAPTION | WS_SYSMENU;

    var rect: [4]i32 = .{ 0, 0, 256, 64 };
    _ = AdjustWindowRect(&rect, main_style, 0);

    const hwnd = CreateWindowExA(
        0, "Message", "Set Key Repeat Delay", main_style,
        CW_USEDEFAULT, CW_USEDEFAULT, rect[2] - rect[0], rect[3] - rect[1],
        null, null, null, null,
    ) orelse return;

    slider = CreateWindowExA(
        0, "msctls_trackbar32", null, WS_VISIBLE | WS_CHILD | TBS_AUTOTICKS,
        0,0, 256, 32,
        hwnd, @ptrFromInt(slider_id), null, null,
    ) orelse return;

    label = CreateWindowExA(
        0, "Static", null, WS_VISIBLE | WS_CHILD | SS_CENTER | SS_CENTERIMAGE,
        0, 32, 256, 32,
        hwnd, null, null, null,
    ) orelse return;

    var filter: FILTERKEYS = .{};
    _ = SystemParametersInfoA(0x0032, @sizeOf(FILTERKEYS), @intFromPtr(&filter), 0);

    var buf: [255:0]u8 = @splat(0);
    _ = std.fmt.bufPrintZ(&buf, "Key Repeat Delay: {d} ms", .{ filter.iDelayMSec }) catch {};

    const lim: packed struct (usize) {
        lo: u16 = 0,
        hi: u16 = 0,
        _: if (@sizeOf(usize) == 8) u32 else u0 = 0,
    } = .{
        .lo = 100,
        .hi = 200,
    };

    _ = SendMessageA(slider, TBM_SETRANGE, 0, @bitCast(lim));
    _ = SendMessageA(slider, TBM_SETTICFREQ, 10, 0);
    _ = SendMessageA(slider, TBM_SETPOS, 1, filter.iDelayMSec);
    _ = SetWindowTextA(label, &buf);
    _ = SetWindowLongPtrA(hwnd, -4, @bitCast(@intFromPtr(&wndProc)));

    var msg: MSG = undefined;

    while (GetMessageA(&msg, hwnd, 0, 0) > 0) {
        _ = DispatchMessageA(&msg);
    }
}

fn wndProc(hwnd: HWND, uMsg: u32, wParam: usize, lParam: isize) callconv(.winapi) isize {
    if (uMsg == WM_NOTIFY and wParam == slider_id) {
        var buf: [255:0]u8 = @splat(0);
        const val: usize = @bitCast(SendMessageA(slider, TBM_GETPOS, 0, 0));
        _ = std.fmt.bufPrintZ(&buf, "Key Repeat Delay: {d} ms", .{ val }) catch {};
        _ = SetWindowTextA(label, &buf);
        _ = SystemParametersInfoA(0x0033, @sizeOf(FILTERKEYS), @intFromPtr(&FILTERKEYS.init(1, 0, @truncate(val), 1, 0)), 1);
    }
    return DefWindowProcA(hwnd, uMsg, wParam, lParam);
}

const std = @import("std");
const win = std.os.windows;

const CW_USEDEFAULT: i32 = @bitCast(@as(u32, 0x80000000));
const WS_VISIBLE = 0x10000000;
const WS_CHILD = 0x40000000;
const WS_CAPTION = 0x00C00000;
const WS_SYSMENU = 0x00080000;
const TBS_AUTOTICKS = 0x00000001;
const SS_CENTER = 0x00000001;
const SS_CENTERIMAGE = 0x00000200;

const WM_NOTIFY = 0x004E;
const WM_HSCROLL = 0x0114;
const WM_USER = 0x0400;
const TBM_GETPOS = WM_USER + 0;
const TBM_SETPOS = WM_USER + 5;
const TBM_SETRANGE = WM_USER + 6;
const TBM_SETTICFREQ = WM_USER + 20;

const HWND = win.HWND;

const MSG = extern struct {
    hWnd: ?HWND,
    message: u32,
    wParam: usize,
    lParam: isize,
    time: u32,
    pt: [2]i32,
    lPrivate: u32,
};

const FILTERKEYS = extern struct {
    cbSize: u32 = @sizeOf(FILTERKEYS),
    dwFlags: u32 = 0,
    iWaitMSec: u32 = 0,
    iDelayMSec: u32 = 150,
    iRepeatMSec: u32 = 1,
    iBounceMSec: u32 = 1,
    fn init(flags: u32, wait: u32, delay: u32, repeat: u32, bounce: u32) FILTERKEYS {
        return .{ 
            .dwFlags = flags,
            .iWaitMSec = wait,
            .iDelayMSec = delay,
            .iRepeatMSec = repeat,
            .iBounceMSec = bounce,
        };
    }
};

extern "user32" fn CreateWindowExA(u32, ?[*:0]const u8, ?[*:0]const u8, u32, i32, i32, i32, i32, ?HWND, ?win.HMENU, ?win.HMODULE, ?*anyopaque) callconv(.winapi) ?HWND;
extern "user32" fn AdjustWindowRect(*[4]i32, u32, i32) callconv(.winapi) i32;
extern "user32" fn SetWindowTextA(*anyopaque, ?[*:0]const u8) callconv(.winapi) i32;
extern "user32" fn SendMessageA(*const anyopaque, u32, usize, isize) callconv(.winapi) isize;
extern "user32" fn GetMessageA(*MSG, ?HWND, u32, u32) callconv(.winapi) i32;
extern "user32" fn DispatchMessageA(*const MSG) callconv(.winapi) isize;
extern "user32" fn DefWindowProcA(*anyopaque, u32, usize, isize) callconv(.winapi) isize;
extern "user32" fn SetWindowLongPtrA(*const anyopaque, i32, isize) callconv(.winapi) isize;
extern "user32" fn SystemParametersInfoA(u32, u32, usize, u32) callconv(.winapi) i32;