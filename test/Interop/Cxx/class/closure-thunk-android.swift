// RUN: %target-swiftxx-frontend -I %S/Inputs -emit-silgen %s | %FileCheck --dump-input-filter=all %s

// REQUIRES: OS=linux-android

import Closure

// CHECK: sil [ossa] @$s4main18testClosureToBlockyyF : $@convention(thin) () -> () {
// CHECK: %[[V0:.*]] = function_ref @$s4main18testClosureToBlockyyFySo10NonTrivialVcfU_ : $@convention(thin) (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V1:.*]] = thin_to_thick_function %[[V0]] : $@convention(thin) (@in_guaranteed NonTrivial) -> () to $@callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V2:.*]] = alloc_stack $@block_storage @callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V3:.*]] = project_block_storage %[[V2]] : $*@block_storage @callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: store %[[V1]] to [trivial] %[[V3]] : $*@callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V7:.*]] = function_ref @$sSo10NonTrivialVIegn_ABIeyBn_TR : $@convention(c) (@inout_aliasable @block_storage @callee_guaranteed (@in_guaranteed NonTrivial) -> (), @in_guaranteed NonTrivial) -> ()
// CHECK: %[[V6:.*]] = init_block_storage_header %[[V2]] : $*@block_storage @callee_guaranteed (@in_guaranteed NonTrivial) -> (), invoke %[[V7]] : $@convention(c) (@inout_aliasable @block_storage @callee_guaranteed (@in_guaranteed NonTrivial) -> (), @in_guaranteed NonTrivial) -> (), type $@convention(block) (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V8:.*]] = copy_block %[[V6]] : $@convention(block) (@in_guaranteed NonTrivial) -> ()
// CHECK: dealloc_stack %[[V2]] : $*@block_storage @callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V11:.*]] = function_ref @_Z5cfuncU13block_pointerFv10NonTrivialE : $@convention(c) (@convention(block) (@in_guaranteed NonTrivial) -> ()) -> ()
// CHECK: apply %[[V11]](%[[V8]]) : $@convention(c) (@convention(block) (@in_guaranteed NonTrivial) -> ()) -> ()
// CHECK: destroy_value %[[V8]] : $@convention(block) (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V12:.*]] = tuple ()
// CHECK: return %[[V12]] : $()

// CHECK: sil shared [transparent] [serialized] [reabstraction_thunk] [ossa] @$sSo10NonTrivialVIegn_ABIeyBn_TR : $@convention(c) (@inout_aliasable @block_storage @callee_guaranteed (@in_guaranteed NonTrivial) -> (), @in_guaranteed NonTrivial) -> () {
// CHECK: bb0(%[[V0:.*]] : $*@block_storage @callee_guaranteed (@in_guaranteed NonTrivial) -> (), %[[V1:.*]] : $*NonTrivial):
// CHECK: %[[V2:.*]] = project_block_storage %[[V0]] : $*@block_storage @callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V3:.*]] = load [copy] %[[V2]] : $*@callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V4:.*]] = begin_borrow %[[V3]] : $@callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V7:.*]] = apply %[[V4]](%[[V1]]) : $@callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: end_borrow %[[V4]] : $@callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V8:.*]] = tuple ()
// CHECK: destroy_value %[[V3]] : $@callee_guaranteed (@in_guaranteed NonTrivial) -> ()
// CHECK: return %[[V8]] : $()

// NonTrivial is destroyed by the caller.
public func testClosureToBlock() {
  cfunc({NonTrivial in})
}

// CHECK: sil [ossa] @$s4main20testClosureToFuncPtryyF : $@convention(thin) () -> () {
// CHECK: %[[V0:.*]] = function_ref @$s4main20testClosureToFuncPtryyFySo10NonTrivialVcfU_To : $@convention(c) (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V1:.*]] = enum $Optional<@convention(c) (@in_guaranteed NonTrivial) -> ()>, #Optional.some!enumelt, %[[V0]] : $@convention(c) (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V2:.*]] = function_ref @_Z6cfunc2PFv10NonTrivialE : $@convention(c) (Optional<@convention(c) (@in_guaranteed NonTrivial) -> ()>) -> ()
// CHECK: %[[V3:.*]] = apply %[[V2]](%[[V1]]) : $@convention(c) (Optional<@convention(c) (@in_guaranteed NonTrivial) -> ()>) -> ()
// CHECK: %[[V4:.*]] = tuple ()
// CHECK: return %[[V4]] : $()

// CHECK: sil private [thunk] [ossa] @$s4main20testClosureToFuncPtryyFySo10NonTrivialVcfU_To : $@convention(c) (@in_guaranteed NonTrivial) -> () {
// CHECK: bb0(%[[V0:.*]] : $*NonTrivial):
// CHECK: %[[V1:.*]] = alloc_stack $NonTrivial
// CHECK: copy_addr %[[V0]] to [init] %[[V1]] : $*NonTrivial
// CHECK: %[[V3:.*]] = function_ref @$s4main20testClosureToFuncPtryyFySo10NonTrivialVcfU_ : $@convention(thin) (@in_guaranteed NonTrivial) -> ()
// CHECK: %[[V4:.*]] = apply %[[V3]](%[[V1]]) : $@convention(thin) (@in_guaranteed NonTrivial) -> ()
// CHECK: destroy_addr %[[V1]] : $*NonTrivial
// CHECK: dealloc_stack %[[V1]] : $*NonTrivial
// CHECK: return %[[V4]] : $()

public func testClosureToFuncPtr() {
 cfunc2({N in})
}
