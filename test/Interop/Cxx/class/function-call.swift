// RUN: %target-swiftxx-frontend -I %S/Inputs -emit-silgen %s | %FileCheck --dump-input-filter=all %s

import Closure

// CHECK: sil [ossa] @$s4main14testNonTrivialyyF : $@convention(thin) () -> () {
// CHECK: %[[V0:.*]] = alloc_stack $NonTrivial
// CHECK: %[[V2:.*]] = function_ref @_ZN10NonTrivialC1Ev : $@convention(c) () -> @out NonTrivial
// CHECK: %[[V3:.*]] = apply %[[V2]](%[[V0]]) : $@convention(c) () -> @out NonTrivial
// CHECK: %[[V4:.*]] = function_ref @_Z5cfunc10NonTrivial : $@convention(c) (@in_cxx NonTrivial) -> ()
// CHECK: %[[V7:.*]] = apply %[[V4]](%[[V0]]) : $@convention(c) (@in_cxx NonTrivial) -> ()
// CHECK: destroy_addr %[[V0]] : $*NonTrivial
// CHECK: dealloc_stack %[[V0]] : $*NonTrivial

public func testNonTrivial() {
  cfunc(NonTrivial());
}

// CHECK: sil [ossa] @$s4main11testARCWeakyyF : $@convention(thin) () -> () {
// CHECK: %[[V0:.*]] = alloc_stack $ARCWeak
// CHECK: %[[V2:.*]] = function_ref @_ZN7ARCWeakC1Ev : $@convention(c) () -> @out ARCWeak
// CHECK: %[[V3:.*]] = apply %[[V2]](%[[V0]]) : $@convention(c) () -> @out ARCWeak
// CHECK: %[[V4:.*]] = function_ref @_Z12cfuncARCWeak7ARCWeak : $@convention(c) (@in ARCWeak) -> ()
// CHECK: %[[V7:.*]] = apply %[[V4]](%[[V0]]) : $@convention(c) (@in ARCWeak) -> ()
// CHECK-NOT: destroy_addr
// CHECK: dealloc_stack %[[V0]] : $*ARCWeak

public func testARCWeak() {
  cfuncARCWeak(ARCWeak());
}
