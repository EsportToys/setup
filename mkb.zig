const preferred_delay = 150;

const cursor_theme = "Windows Default (extra large)";

const cursors = .{
    .{ "AppStarting", "%SystemRoot%\\cursors\\aero_working_xl.ani" },
    .{ "Arrow",       "%SystemRoot%\\cursors\\aero_arrow_xl.cur"   },
    .{ "Crosshair",   ""                                           },
    .{ "Hand",        "%SystemRoot%\\cursors\\aero_link_xl.cur"    },
    .{ "Help",        "%SystemRoot%\\cursors\\aero_helpsel_xl.cur" },
    .{ "IBeam",       ""                                           },
    .{ "No",          "%SystemRoot%\\cursors\\aero_unavail_xl.cur" },
    .{ "NWPen",       "%SystemRoot%\\cursors\\aero_pen_xl.cur"     },
    .{ "SizeAll",     "%SystemRoot%\\cursors\\aero_move_xl.cur"    },
    .{ "SizeNESW",    "%SystemRoot%\\cursors\\aero_nesw_xl.cur"    },
    .{ "SizeNS",      "%SystemRoot%\\cursors\\aero_ns_xl.cur"      },
    .{ "SizeNWSE",    "%SystemRoot%\\cursors\\aero_nwse_xl.cur"    },
    .{ "SizeWE",      "%SystemRoot%\\cursors\\aero_ew_xl.cur"      },
    .{ "UpArrow",     "%SystemRoot%\\cursors\\aero_up_xl.cur"      },
    .{ "Wait",        "%SystemRoot%\\cursors\\aero_busy_xl.ani"    },
    .{ "Pin",         "%SystemRoot%\\cursors\\aero_pin_xl.cur"     },
    .{ "Person",      "%SystemRoot%\\cursors\\aero_person_xl.cur"  },
};

const datetime = .{
    .{ "iMeasure",    "0"                 },
    .{ "sLongDate",   "ddd, MMMM d, yyyy" },
    .{ "sShortDate",  "ddd yyyy-MM-dd"    },
    .{ "sShortTime",  "h:mm:ss tt"        },
    .{ "sTimeFormat", "h:mm:ss tt"        },
    .{ "s1159",       "AM"                },
    .{ "s2359",       "PM"                },
};

const gamedvr = .{
    .{ "GameDVR_Enabled",                       0 },
    .{ "GameDVR_FSEBehavior",                   2 },
    .{ "GameDVR_FSEBehaviorMode",               2 },
    .{ "GameDVR_EFSEFeatureFlags",              0 },
    .{ "GameDVR_HonorUserFSEBehaviorMode",      1 },
    .{ "GameDVR_DXGIHonorFSEWindowsCompatible", 1 },
};

const misc_opts = .{
    .{ "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CabinetState", "FullPath",                 1 },
    .{ "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ControlPanel", "AllItemsIconView",         2 },
    .{ "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",     "ShowSecondsInSystemClock", 1 },
    .{ "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",     "UseCompactView",           1 },
    .{ "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",     "LaunchTo",                 1 },
    .{ "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",     "HideFileExt",              0 },
    .{ "Software\\Microsoft\\Windows\\CurrentVersion\\Search",                 "SearchboxTaskbarMode",     0 },
    .{ "Software\\Microsoft\\Multimedia\\Audio",                               "UserDuckingPreference",    3 },
};

pub fn main() void {
    // mouse preferences
    var accel: [3]i32 = .{ 0, 0, 0 }; // must be mutable memory even for setmouse
    _ = SystemParametersInfoA(.SETMOUSE, 0, @intFromPtr(&accel), 1);
    _ = SystemParametersInfoA(.SETMOUSESPEED, 0, 10, 1);

    // keyboard preferences
    _ = SystemParametersInfoA(.SETKEYBOARDCUES, 0, 1, 1);
    _ = SystemParametersInfoA(.SETKEYBOARDPREF, 1, 0, 1);
    _ = SystemParametersInfoA(.SETKEYBOARDDELAY, 0, 0, 1);
    _ = SystemParametersInfoA(.SETKEYBOARDSPEED, 31, 0, 1);
    _ = SystemParametersInfoA(.SETFILTERKEYS, @sizeOf(FILTERKEYS), @intFromPtr(&FILTERKEYS.init(1, 0, preferred_delay, 1, 0)), 1);
    _ = SystemParametersInfoA(.SETTOGGLEKEYS, @sizeOf(TOGGLEKEYS), @intFromPtr(&TOGGLEKEYS.init(58)), 1);
    _ = SystemParametersInfoA(.SETSTICKYKEYS, @sizeOf(STICKYKEYS), @intFromPtr(&STICKYKEYS.init(506)), 1);

    // hover options
    _ = SystemParametersInfoA(.SETMOUSEHOVERTIME, preferred_delay, 0, 1);
    _ = SystemParametersInfoA(.SETMENUSHOWDELAY, preferred_delay, 0, 1);

    // animations
    _ = SystemParametersInfoA(.SETUIEFFECTS, 0, 1, 1);
    _ = SystemParametersInfoA(.SETSELECTIONFADE, 0, 1, 1);
    _ = SystemParametersInfoA(.SETCLIENTAREAANIMATION, 0, 1, 1);
    _ = SystemParametersInfoA(.SETMENUANIMATION, 0, 0, 1);
    _ = SystemParametersInfoA(.SETMENUFADE, 0, 0, 1);
    _ = SystemParametersInfoA(.SETTOOLTIPANIMATION, 0, 0, 1);
    _ = SystemParametersInfoA(.SETTOOLTIPFADE, 0, 0, 1);
    _ = SystemParametersInfoA(.SETCOMBOBOXANIMATION, 0, 0, 1);
    _ = SystemParametersInfoA(.SETLISTBOXSMOOTHSCROLLING, 0, 0, 1);
    _ = SystemParametersInfoA(.SETANIMATION, @sizeOf(ANIMATIONINFO), @intFromPtr(&ANIMATIONINFO.init(false)), 1);

    // mouse cursor appearance
    inline for (cursors) |cursor| {
        const name, const path = cursor;
        _ = RegSetKeyValueA(.CURRENT_USER, "Control Panel\\Cursors", name, .EXPAND_SZ, path.ptr, path.len + 1);
    }
    _ = RegSetKeyValueA(.CURRENT_USER, "Control Panel\\Cursors", null, .SZ, cursor_theme, cursor_theme.len + 1);
    _ = SystemParametersInfoA(.SETCURSORS, 0, 0, 1);
    _ = SystemParametersInfoA(.SETCURSORSHADOW, 0, 0, 1);

    // date-time format
    inline for (datetime) |format| {
        const key, const fmt = format;
        _ = RegSetKeyValueA(.CURRENT_USER, "Control Panel\\International", key, .SZ, fmt.ptr, fmt.len + 1);
    }

    // disable fullscreen optimizations
    inline for (gamedvr) |opt| {
        const key, var val: u32 = opt;
        _ = RegSetKeyValueA(.CURRENT_USER, "System\\GameConfigStore", key, .DWORD, &val, @sizeOf(u32));
    }

    // misc registry options
    inline for (misc_opts) |opt| {
        const path, const key, var val: u32 = opt;
        _ = RegSetKeyValueA(.CURRENT_USER, path, key, .DWORD, &val, @sizeOf(u32));
    }
}

const ANIMATIONINFO = extern struct {
    cbSize: u32 = @sizeOf(ANIMATIONINFO),
    iMinAnimate: i32 = 0,
    fn get() ?ANIMATIONINFO {
        var cfg: ANIMATIONINFO = .{};
        return if (0 != SystemParametersInfoA(.GETANIMATION, @sizeOf(ANIMATIONINFO), @intFromPtr(&cfg), 0)) cfg else null;
    }
    fn init(enabled: bool) ANIMATIONINFO {
        return .{ .iMinAnimate = if (enabled) 1 else 0 };
    }
};

const FILTERKEYS = extern struct {
    cbSize: u32 = @sizeOf(FILTERKEYS),
    dwFlags: FKF = .{},
    iWaitMSec: u32 = 0,
    iDelayMSec: u32 = 150,
    iRepeatMSec: u32 = 1,
    iBounceMSec: u32 = 0,
    const FKF = packed struct(u32) {
        FILTERKEYSON: bool = false,
        AVAILABLE: bool = false,
        HOTKEYACTIVE: bool = false,
        CONFIRMHOTKEY: bool = false,
        HOTKEYSOUND: bool = false,
        INDICATOR: bool = false,
        CLICKON: bool = false,
        _: u25 = 0,
    };
    fn get() ?FILTERKEYS {
        var cfg: FILTERKEYS = .{};
        return if (0 != SystemParametersInfoA(.GETFILTERKEYS, @sizeOf(FILTERKEYS), @intFromPtr(&cfg), 0)) cfg else null;
    }
    fn init(flags: u32, wait: u32, delay: u32, repeat: u32, bounce: u32) FILTERKEYS {
        return .{ 
            .dwFlags = @bitCast(flags),
            .iWaitMSec = wait,
            .iDelayMSec = delay,
            .iRepeatMSec = repeat,
            .iBounceMSec = bounce,
        };
    }
};

const TOGGLEKEYS = extern struct {
    cbSize: u32 = @sizeOf(TOGGLEKEYS),
    dwFlags: TKF = .{},
    const TKF = packed struct(u32) {
        TOGGLEKEYSON: bool = false,
        AVAILABLE: bool = false,
        HOTKEYACTIVE: bool = false,
        CONFIRMHOTKEY: bool = false,
        HOTKEYSOUND: bool = false,
        INDICATOR: bool = false,
        _: u26 = 0,
    };
    fn get() ?TOGGLEKEYS {
        var cfg: TOGGLEKEYS = .{};
        return if (0 != SystemParametersInfoA(.GETTOGGLEKEYS, @sizeOf(TOGGLEKEYS), @intFromPtr(&cfg), 0)) cfg else null;
    }
    fn init(flags: u32) TOGGLEKEYS {
        return .{ .dwFlags = @bitCast(flags) };
    }
};

const STICKYKEYS = extern struct {
    cbSize: u32 = @sizeOf(STICKYKEYS),
    dwFlags: SKF = .{},
    const SKF = packed struct(u32) {
        STICKYKEYSON: bool = false,
        AVAILABLE: bool = false,
        HOTKEYACTIVE: bool = false,
        CONFIRMHOTKEY: bool = false,
        HOTKEYSOUND: bool = false,
        INDICATOR: bool = false,
        AUDIBLEFEEDBACK: bool = false,
        TRISTATE: bool = false,
        TWOKEYSOFF: bool = false,
        _: u7 = 0,
        LSHIFTLOCKED: bool = false,
        RSHIFTLOCKED: bool = false,
        LCTLLOCKED: bool = false,
        RCTLLOCKED: bool = false,
        LALTLOCKED: bool = false,
        RALTLOCKED: bool = false,
        LWINLOCKED: bool = false,
        RWINLOCKED: bool = false,
        LSHIFTLATCHED: bool = false,
        RSHIFTLATCHED: bool = false,
        LCTLLATCHED: bool = false,
        RCTLLATCHED: bool = false,
        LALTLATCHED: bool = false,
        RALTLATCHED: bool = false,
        LWINLATCHED: bool = false,
        RWINLATCHED: bool = false,
    };
    fn get() ?STICKYKEYS {
        var cfg: STICKYKEYS = .{};
        return if (0 != SystemParametersInfoA(.GETSTICKYKEYS, @sizeOf(STICKYKEYS), @intFromPtr(&cfg), 0)) cfg else null;
    }
    fn init(flags: u32) STICKYKEYS {
        return .{ .dwFlags = @bitCast(flags) };
    }
};

extern "user32" fn SystemParametersInfoA(
    uiAction: SPI,
    uiParam: u32, // must be zero if not used
    pvParam: usize, // must be null if not used
    fWinIni: u32,
) callconv(.winapi) i32;

const SPI = enum(u32) {
    GETFILTERKEYS = 0x0032,
    GETTOGGLEKEYS = 0x0034,
    GETSTICKYKEYS = 0x003A,
    GETANIMATION = 0x0048,

    SETMOUSE = 0x0004,
    SETMOUSESPEED = 0x0071,
    SETKEYBOARDDELAY = 0x0017,
    SETKEYBOARDSPEED = 0x000B,
    SETFILTERKEYS = 0x0033,
    SETTOGGLEKEYS = 0x0035,
    SETSTICKYKEYS = 0x003B,
    SETKEYBOARDCUES = 0x100B,
    SETKEYBOARDPREF = 0x0045,
    SETMOUSEHOVERTIME = 0x0067,
    SETMENUSHOWDELAY = 0x006B,

    SETCURSORS = 0x0057,
    SETCURSORSHADOW = 0x101B,

    SETUIEFFECTS = 0x103F, // master switch of al UI animation

    SETCLIENTAREAANIMATION = 0x1043, // animate controls and elements inside windows
    SETANIMATION = 0x0049, // animate windows when minimzing and maximizing

    SETMENUANIMATION = 0x1003, // slide menu into view
    SETMENUFADE = 0x1013, // fade menu into view
    SETTOOLTIPANIMATION = 0x1017, // slide tooltip into view
    SETTOOLTIPFADE = 0x1019, // fade tooltip into view
    SETSELECTIONFADE = 0x1015, // fade out menu items after clicking

    SETCOMBOBOXANIMATION = 0x1005, // slide open combo boxes

    SETLISTBOXSMOOTHSCROLLING = 0x1007, // smooth scroll list boxes
    _,
};

extern "Advapi32" fn RegSetKeyValueA(
    HKEY,
    ?[*:0]const u8,
    ?[*:0]const u8,
    REG,
    ?*const anyopaque,
    u32,
) callconv(.winapi) i32;

const HKEY = *const opaque{
    const CLASSES_ROOT               : HKEY = @ptrFromInt(0x80000000);
    const CURRENT_USER               : HKEY = @ptrFromInt(0x80000001);
    const LOCAL_MACHINE              : HKEY = @ptrFromInt(0x80000002);
    const USERS                      : HKEY = @ptrFromInt(0x80000003);
    const PERFORMANCE_DATA           : HKEY = @ptrFromInt(0x80000004);
    const CURRENT_CONFIG             : HKEY = @ptrFromInt(0x80000005);
    const DYN_DATA                   : HKEY = @ptrFromInt(0x80000006);
    const CURRENT_USER_LOCAL_SETTINGS: HKEY = @ptrFromInt(0x80000007);
    const PERFORMANCE_TEXT           : HKEY = @ptrFromInt(0x80000050);
    const PERFORMANCE_NLSTEXT        : HKEY = @ptrFromInt(0x80000060);
};

const REG = enum(u32) {
    NONE = 0,
    SZ = 1,
    EXPAND_SZ = 2,
    BINARY = 3,
    DWORD = 4,
    DWORD_BIG_ENDIAN = 5,
    LINK = 6,
    MULTI_SZ = 7,
    RESOURCE_LIST = 8,
    FULL_RESOURCE_DESCRIPTOR = 9,
    RESOURCE_REQUIREMENTS_LIST = 10,
    QWORD = 11,
};
