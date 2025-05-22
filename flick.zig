pub fn main() void {
    if (0 == RegisterHotKey(null, 0, 0x4001, 0xDB)) return;
    if (0 == RegisterHotKey(null, 1, 0x4001, 0xDD)) return;
    var msg: MSG = undefined;
    while (GetMessageA(&msg, null, 0, 0) > 0) {
        defer _ = DispatchMessageA(&msg);
        if (0x0312 != msg.message) continue;
        switch (msg.wParam) {
            else => {},
            0 => {
                _ = SendInput(1, &.{
                    .mi(.{ .dwFlags = 1, .dx = -127 }),
                }, @sizeOf(INPUT));
            },
            1 => {
                _ = SendInput(3, &.{
                    .mi(.{ .dwFlags = 1, .dx = 127 }),
                    .mi(.{ .dwFlags = 2 }),
                    .mi(.{ .dwFlags = 1, .dx = 127 }),
                }, @sizeOf(INPUT));
                Sleep(10);
                _ = SendInput(1, &.{
                    .mi(.{ .dwFlags = 4 }),
                }, @sizeOf(INPUT));
            }
        }
    }
}

extern "kernel32" fn Sleep(u32) callconv(.winapi) void ;
extern "user32" fn RegisterHotKey(?HWND, i32, u32, u32) callconv(.winapi) i32;
extern "user32" fn GetMessageA(*MSG, ?HWND, u32, u32) callconv(.winapi) i32;
extern "user32" fn DispatchMessageA(*const MSG) callconv(.winapi) isize;
extern "user32" fn SendInput(cInputs: u32, pInputs: [*]const INPUT, cbSize: i32) callconv(.winapi) u32;

const HWND = *const opaque{};

const INPUT = extern struct {
    type: u32,
    input: extern union {
        mi: MOUSEINPUT,
        ki: KEYBDINPUT,
        hi: HARDWAREINPUT,
    },
    const MOUSEINPUT = extern struct {
        dx: i32 = 0,
        dy: i32 = 0,
        mouseData: i32 = 0,
        dwFlags: u32 = 0,
        time: u32 = 0,
        dwExtraInfo: usize = 0,
    };
    const KEYBDINPUT = extern struct {
        wVK: u16 = 0,
        wScan: u16 = 0,
        dwFlags: u32 = 0,
        time: u32 = 0,
        dwExtraInfo: usize = 0,
    };
    const HARDWAREINPUT = extern struct {
        uMsg: u32 = 0,
        wParamL: u16 = 0,
        wParamH: u16 = 0,
    };
    fn mi(m: MOUSEINPUT)    INPUT { return .{ .type = 0, .input = .{.mi = m} }; }
    fn ki(k: KEYBDINPUT)    INPUT { return .{ .type = 1, .input = .{.ki = k} }; }
    fn hi(h: HARDWAREINPUT) INPUT { return .{ .type = 2, .input = .{.hi = h} }; }
};

const MSG = extern struct {
    hWnd: ?HWND,
    message: u32,
    wParam: usize,
    lParam: isize,
    time: u32,
    pt: [2]i32,
    lPrivate: u32,
};
