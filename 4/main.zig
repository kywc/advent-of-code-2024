var text: [140][140]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(&text);
const alloc = fba.allocator();

const Direction = enum(i2) {
    fwd = 1,
    rev = -1,
    nul = 0,
};
const Progress = enum(u2) {
    X = 0,
    M = 1,
    A = 2,
    S = 3,
};
const ReadPtr = struct {
    dir: Direction,
    stat: Progress,
    ptr: *u8,
};
