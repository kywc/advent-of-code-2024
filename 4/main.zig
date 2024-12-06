var text: [140][140]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(&text);
const alloc = fba.allocator();

//  const Direction = enum(i2) {
//     fwd = 1,
//     rev = -1,
//     nul = 0,
// };
const Progress = enum(i3) {
    Mb = -3,
    Ab = -2,
    Sb = -1,
    Z = 0,
    Xf = 1,
    Mf = 2,
    Af = 3,
};
const ReadPtr = struct {
    stat: Progress,
    ptr: *[_]u8,
};
