// RUN: not %target-swift-frontend -DSHADOWED -typecheck %s 2>&1 | %FileCheck --check-prefix=SHADOWED %s
// RUN: not %target-swift-frontend -typecheck %s 2>&1 | %FileCheck --check-prefix=NOT_SHADOWED %s

#if SHADOWED
struct String {} // Shadow Swift.String
#endif

let x: Any = ""
let y: Swift.String = x // Verify fix-it
// FIXME: error and warning arguments should use the same disambiguation mechanism as fix-its.
// SHADOWED: error: cannot convert value of type 'Any' to specified type 'String'
// NOT_SHADOWED: error: cannot convert value of type 'Any' to specified type 'String'
// SHADOWED: as! Swift.String{{$}}
// NOT_SHADOWED: as! String{{$}}

struct Foo<T> {}
let a: Any = ""
let b: Foo<Swift.String> = a // Verify fix-it
// The shadowed fix-it is more verbose than necessary, but at least it's correct.
// SHADOWED: error: cannot convert value of type 'Any' to specified type 'Foo<String>'
// NOT_SHADOWED: error: cannot convert value of type 'Any' to specified type 'Foo<String>'
// SHADOWED: as! diags_with_shadowed_types.Foo<Swift.String>{{$}}
// NOT_SHADOWED: as! Foo<String>{{$}}

struct A {}

struct B {
  #if SHADOWED
  struct A{}
  #endif

  func test() {
    let x: Any = ""
    let y: diags_with_shadowed_types.A = x
  }
}
// SHADOWED: cannot convert value of type 'Any' to specified type 'A'
// SHADOWED: as! diags_with_shadowed_types.A
// NOT_SHADOWED: cannot convert value of type 'Any' to specified type 'A'
// NOT_SHADOWED: as! A
