// // loads the scene

// usingnamespace @import("mesh.zig");
// usingnamespace @import("scene.zig");

// const std = @import("std");
// // const vk = @import("../third-party/vulkan.zig");

// pub fn LoadScene(
//   allocator : * std.mem.Allocator,
//   filename : [] const u8,
//   createInfoVertexDescriptorLayout : CreateInfo_VertexDescriptorLayout,
// )
//   void
//   // !Scene
// {
//   // var scene : Scene = Scene.init(allocator);

//   // // assert filename
//   // if (filename.len <= 4) {
//   //   std.log.err("{}: '{}'", .{ "invalid filename", filename });
//   //   return scene;
//   // }

//   // // check extension TODO
//   // // if (filename[filename.len - 1]
//   // // for now assume it's OBJ

//   // const file = try std.fs.cwd().openFile(filename, .{ .read = true });

//   // var lineBuffer : [1024] u8 = undefined;

//   // var fileReader = file.reader();

//   // var vertexAttributeBuffers :
//   //   [VertexDescriptorAttributeType.length] std.ArrayList(f64) = undefined;

//   // { // init vertex attribute buffers
//   //   for (vertexAttributeBuffers) |_, idx| {
//   //     vertexAttributeBuffers[idx] =
//   //       std.ArrayList(f64).init(std.heap.c_allocator);
//   //   }
//   // }

//   // // deinit vertex attribute buffers
//   // defer {
//   //   for (vertexAttributeBuffers) |_, idx| vertexAttributeBuffers[idx].deinit();
//   // }

//   // var elementIndexBuffer = std.ArrayList(u32).init(std.heap.c_allocator);
//   // defer elementIndexBuffer.deinit();

//   // while (true) {
//   //   var lineBufferSlice =
//   //     try file.reader().readUntilDelimiterOrEof(lineBuffer[0..], '\n');

//   //   if (lineBufferSlice == null) { break; }

//   //   try
//   //     InterpretLine(
//   //       &scene, lineBufferSlice.?, &vertexAttributeBuffers, &elementIndexBuffer
//   //     );
//   // }

//   // // debug print out attributes

//   // {
//   //   var idx : u32 = 0;
//   //   while (idx < elementIndexBuffer.items.len) : (idx += 3) {
//   //     var vertex : u32 = 0;
//   //     while (vertex < 3) : (vertex += 1) {
//   //       var eidx = elementIndexBuffer.items[idx + vertex];
//   //       const originAttr =
//   //         vertexAttributeBuffers
//   //           [@enumToInt(VertexDescriptorAttributeType.origin)].items
//   //       ;
//   //     }
//   //   }
//   // }

//   // // debug print out lengths
//   // std.log.info("ORIGIN LENGTH: {}", .{vertexAttributeBuffers[0].items.len});
//   // std.log.info("ELEMIN LENGTH: {}", .{elementIndexBuffer.items.len});

//   // // TODO apply requested attribute conversions

//   // // TODO allocate buffers

//   // var mesh = (try scene.meshes.addOne());
//   // mesh.* = Mesh.init(allocator);

//   // // -- add submeshes
//   // var submesh = (try mesh.*.submeshes.addOne());
//   // submesh.* = Submesh {
//   //   .vertexDescriptorLayout = undefined,
//   //   .elementBufferSubregion =
//   //     BufferSubregion {
//   //       .offset = 0,
//   //       .length = elementIndexBuffer.items.len * @sizeOf(u32),
//   //     },
//   //   .elementBufferHandle = 0,
//   //   .elementBufferType = vk.IndexType.uint32,
//   //   .drawElements = @intCast(u32, elementIndexBuffer.items.len)
//   // };

//   // // copy the allocated information + createInfo descriptor layout description
//   // //   over
//   // for (vertexAttributeBuffers) |attr, idx| {
//   //   submesh.*.vertexDescriptorLayout.vertexAttributes[idx].bindingIndex =
//   //     createInfoVertexDescriptorLayout.vertexAttributes[idx].bindingIndex;

//   //   submesh.*.vertexDescriptorLayout.vertexAttributes[idx].underlyingType =
//   //     createInfoVertexDescriptorLayout.vertexAttributes[idx].underlyingType;

//   //   submesh.*.vertexDescriptorLayout.vertexAttributes[idx].bufferSubregion =
//   //     BufferSubregion {
//   //       .offset = 0,
//   //       .length = attr.items.len * @sizeOf(f32) // TODO fix this
//   //     };

//   //   // TODO fix this
//   //   submesh.*.vertexDescriptorLayout.vertexAttributes[idx].bufferHandle = 1;
//   // }

//   // submesh.*.elementBufferHandle = 0;

//   // { // -- index
//   //   var ib = (try scene.buffers.addOne());
//   //   ib.*.memory = std.ArrayList(u8).init(allocator);

//   //   try ib.*.memory.appendSlice(std.mem.sliceAsBytes(elementIndexBuffer.items));
//   // }

//   // // copy over buffers TODO this should be handled better
//   // { // -- vertex
//   //   for (vertexAttributeBuffers) |buffer, idx| {
//   //     var vb = (try scene.buffers.addOne());
//   //     vb.*.memory = std.ArrayList(u8).init(allocator);

//   //     var valueItr : usize = 0;
//   //     while (valueItr < buffer.items.len) {
//   //       switch (
//   //         submesh.*.vertexDescriptorLayout.vertexAttributes[idx].underlyingType
//   //       ) {
//   //         // TODO others
//   //         .float32_3 => {
//   //           const data = [3] f32 {
//   //             @floatCast(f32, buffer.items[valueItr + 0]),
//   //             @floatCast(f32, buffer.items[valueItr + 1]),
//   //             @floatCast(f32, buffer.items[valueItr + 2]),
//   //           };
//   //           valueItr += 3;

//   //           try vb.*.memory.appendSlice(std.mem.sliceAsBytes(data[0..]));
//   //         },
//   //         else => { unreachable; },
//   //       }
//   //     }
//   //   }
//   // }

//   // // add node to scene for OBJ
//   // (try scene.nodes.addOne()).* = Node { .meshHandle = 0, .parent = 0 };

//   // return scene;
// }

// /// Parses line, setting the parsed elements into the vector. Returns the number
// ///   of elements parsed for the vector
// fn ParseLineForVector(comptime T : type, vector : * [3] T, line : [] u8,) !u32
// {
//   var idxStart : u32 = 0;
//   var idxEnd : u32 = 1;

//   var idxVec : u32 = 0;

//   while (true) {
//     // skip whitespace in front
//     while (line[idxStart] == ' ') {
//       idxStart += 1;
//       idxEnd = idxStart+1;
//     }

//     // skip non-whitespace in back
//     if (idxEnd > line.len) { return error.ParsingFaceError; }

//     const atDigit : bool =
//           (idxEnd >= line.len) // only evaluate below if not OOB
//       or  (line[idxEnd] >= 'a' and line[idxEnd] <= 'f')
//       or  (line[idxEnd] >= 'A' and line[idxEnd] <= 'F')
//       or  (line[idxEnd] >= '0' and line[idxEnd] <= '9')
//       or  (line[idxEnd] == '.')
//       or  (line[idxEnd] == '-')
//       or  (line[idxEnd] == '+')
//     ;

//     if (idxEnd == line.len or !atDigit) {

//       // check if at end of line and there isn't anything to parse
//       if (idxEnd == line.len and idxStart+1 >= idxEnd) { break; }

//       // check if we've hit the limit of the vector
//       if (idxVec >= 3) { return error.ParsingFaceError; }

//       // -- parse float/int dependent on T

//       if (comptime (T == u32 or T == u64 or T == u16 or T == u8)) {
//         vector[idxVec] =
//           try std.fmt.parseUnsigned(T, line[idxStart..idxEnd], 0);
//       }

//       if (comptime (T == i32 or T == i64 or T == i16 or T == i8)) {
//         vector[idxVec] =
//           try std.fmt.parseInt(T, line[idxStart..idxEnd], 0);
//       }

//       if (comptime (T == f32 or T == f64)) {
//         vector[idxVec] = try std.fmt.parseFloat(T, line[idxStart..idxEnd]);
//       }

//       idxStart = idxEnd;
//       idxVec += 1;
//     }

//     idxEnd += 1;
//   }

//   return idxVec;
// }

// // fn InterpretLine(
// //   scene : * Scene,
// //   line : [] u8,
// //   vertexAttributeBuffers :
// //     * [VertexDescriptorAttributeType.length] std.ArrayList(f64),
// //   elementIndexBuffer : * std.ArrayList(u32),
// // ) !void
// // {
// //   if (line.len == 0) { return; }
// //   switch (line[0]) {
// //     'f' => {
// //       var faces : [3] u32 = undefined;

// //       const len = try ParseLineForVector(u32, &faces, line[1..]);
// //       if (len != 3) { return error.ParsingFaceError; }

// //       (try elementIndexBuffer.*.addOne()).* = faces[0]-1; // OBJ 1-indexe
// //       (try elementIndexBuffer.*.addOne()).* = faces[1]-1;
// //       (try elementIndexBuffer.*.addOne()).* = faces[2]-1;
// //     },
// //     'v' => {
// //       var vec : [3] f32 = undefined;

// //       const len = try ParseLineForVector(f32, &vec, line[1..]);
// //       if (len != 3) { return error.ParsingFaceError; }

// //       var vab =
// //         &vertexAttributeBuffers.*[
// //           @enumToInt(VertexDescriptorAttributeType.origin)
// //         ];

// //       (try vab.*.addOne()).* = vec[0];
// //       (try vab.*.addOne()).* = vec[1];
// //       (try vab.*.addOne()).* = vec[2];
// //     },
// //     else => {}
// //   }
// // }
