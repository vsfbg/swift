// RUN: %target-swiftxx-frontend -I %S/Inputs -emit-silgen %s | %FileCheck --dump-input-filter=all %s

// REQUIRES: OS=windows-msvc

import Closure

// CHECK: sil [ossa] @$s4main14testNonTrivialyyF : $@convention(thin) () -> () {
// CHECK: %[[V0:.*]] = alloc_stack $NonTrivial
// CHECK: %[[V2:.*]] = function_ref @??0NonTrivial@@QEAA@XZ : $@convention(c) () -> @out NonTrivial
// CHECK: %[[V3:.*]] = apply %[[V2]](%[[V0]]) : $@convention(c) () -> @out NonTrivial
// CHECK: %[[V4:.*]] = function_ref @?cfunc@@YAXUNonTrivial@@@Z : $@convention(c) (@in NonTrivial) -> ()
// CHECK: %[[V7:.*]] = apply %[[V4]](%[[V0]]) : $@convention(c) (@in NonTrivial) -> ()
// CHECK: dealloc_stack %[[V0]] : $*NonTrivial

public func testNonTrivial() {
  cfunc(NonTrivial());
}
