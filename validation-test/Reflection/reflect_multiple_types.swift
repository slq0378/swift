// RUN: rm -rf %t && mkdir -p %t
// RUN: %target-build-swift -lswiftSwiftReflectionTest %s -o %t/reflect_multiple_types
// RUN: %target-run %target-swift-reflection-test %t/reflect_multiple_types 2>&1 | FileCheck %s --check-prefix=CHECK-%target-ptrsize
// REQUIRES: objc_interop
// REQUIRES: executable_test

import SwiftReflectionTest
import Foundation

class TestClass {
    var t00: Array<Int>
    var t01: Bool
    var t02: Character
    var t03: Dictionary<Int, Int>
    var t04: Double
    var t05: Float
    var t06: Int
    var t07: Int16
    var t08: Int32
    var t09: Int64
    var t10: Int8
    var t11: NSArray
    var t12: NSNumber
    var t13: NSSet
    var t14: NSString
    var t15: Set<Int>
    var t16: String
    var t17: UInt
    var t18: UInt16
    var t19: UInt32
    var t20: UInt64
    var t21: UInt8
    init(
        t00: Array<Int>,
        t01: Bool,
        t02: Character,
        t03: Dictionary<Int, Int>,
        t04: Double,
        t05: Float,
        t06: Int,
        t07: Int16,
        t08: Int32,
        t09: Int64,
        t10: Int8,
        t11: NSArray,
        t12: NSNumber,
        t13: NSSet,
        t14: NSString,
        t15: Set<Int>,
        t16: String,
        t17: UInt,
        t18: UInt16,
        t19: UInt32,
        t20: UInt64,
        t21: UInt8
    ) {
        self.t00 = t00
        self.t01 = t01
        self.t02 = t02
        self.t03 = t03
        self.t04 = t04
        self.t05 = t05
        self.t06 = t06
        self.t07 = t07
        self.t08 = t08
        self.t09 = t09
        self.t10 = t10
        self.t11 = t11
        self.t12 = t12
        self.t13 = t13
        self.t14 = t14
        self.t15 = t15
        self.t16 = t16
        self.t17 = t17
        self.t18 = t18
        self.t19 = t19
        self.t20 = t20
        self.t21 = t21
    }
}

var obj = TestClass(
    t00: [1, 2, 3],
    t01: true,
    t02: "A",
    t03: [1: 3, 2: 2, 3: 1],
    t04: 123.45,
    t05: 123.45,
    t06: 123,
    t07: 123,
    t08: 123,
    t09: 123,
    t10: 123,
    t11: [1, 2, 3],
    t12: 123,
    t13: [1, 2, 3, 3, 2, 1],
    t14: "Hello, NSString!",
    t15: [1, 2, 3, 3, 2, 1],
    t16: "Hello, Reflection!",
    t17: 123,
    t18: 123,
    t19: 123,
    t20: 123,
    t21: 123
)

reflect(object: obj)

// CHECK-64: Reflecting an object.
// CHECK-64: Instance pointer in child address space: 0x{{[0-9a-fA-F]+}}
// CHECK-64: Type reference:
// CHECK-64: (class reflect_multiple_types.TestClass)

// CHECK-64: Type info:
// CHECK-64: <null type info>

// CHECK-32: Reflecting an object.
// CHECK-32: Instance pointer in child address space: 0x{{[0-9a-fA-F]+}}
// CHECK-32: Type reference:
// CHECK-32: (class reflect_multiple_types.TestClass)

// CHECK-32: Type info:
// CHECK-32: <null type info>

reflect(any: obj)

// CHECK-64: Reflecting an existential.
// CHECK-64: Instance pointer in child address space: 0x{{[0-9a-fA-F]+}}
// CHECK-64: Type reference:
// CHECK-64: (class reflect_multiple_types.TestClass)

// CHECK-64: Type info:
// CHECK-64: (reference kind=strong refcounting=native)

// CHECK-32: Reflecting an existential.
// CHECK-32: Instance pointer in child address space: 0x{{[0-9a-fA-F]+}}
// CHECK-32: Type reference:
// CHECK-32: (class reflect_multiple_types.TestClass)

// CHECK-32: Type info:
// CHECK-32: (reference kind=strong refcounting=native)

doneReflecting()

// CHECK-64: Done.

// CHECK-32: Done.
