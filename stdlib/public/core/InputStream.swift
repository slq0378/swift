//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftShims

/// Returns `Character`s read from standard input through the end of the
/// current line or until EOF is reached, or `nil` if EOF has already been
/// reached.
///
/// If `strippingNewline` is `true`, newline characters and character
/// combinations will be stripped from the result.  This is the default.
///
/// Standard input is interpreted as `UTF-8`.  Invalid bytes
/// will be replaced by Unicode [replacement characters](http://en.wikipedia.org/wiki/Specials_(Unicode_block)#Replacement_character).
public func readLine(strippingNewline: Bool = true) -> String? {
  var linePtrVar: UnsafeMutablePointer<CChar>? = nil
  var readBytes = swift_stdlib_readLine_stdin(&linePtrVar)
  if readBytes == -1 {
    return nil
  }
  _sanityCheck(readBytes >= 0,
    "unexpected return value from swift_stdlib_readLine_stdin")
  if readBytes == 0 {
    return ""
  }

  let linePtr = linePtrVar!
  if strippingNewline {
    // FIXME: Unicode conformance.  To fix this, we need to reimplement the
    // code we call above to get a line, since it will only stop on LF.
    //
    // <rdar://problem/20013999> Recognize Unicode newlines in readLine()
    //
    // Recognize only LF and CR+LF combinations for now.
    let cr = CChar(UInt8(ascii: "\r"))
    let lf = CChar(UInt8(ascii: "\n"))
    if readBytes == 1 && linePtr[0] == lf {
      return ""
    }
    if readBytes >= 2 {
      switch (linePtr[readBytes - 2], linePtr[readBytes - 1]) {
      case (cr, lf):
        readBytes -= 2
        break
      case (_, lf):
        readBytes -= 1
        break
      default:
        ()
      }
    }
  }
  let result = String._fromCodeUnitSequenceWithRepair(UTF8.self,
    input: UnsafeMutableBufferPointer(
      start: UnsafeMutablePointer<UTF8.CodeUnit>(linePtr),
      count: readBytes)).0
  _swift_stdlib_free(linePtr)
  return result
}
