// RUN: %target-typecheck-verify-swift

func f(_ x: Int...) {}
func f2(x: String, y: Int..., z: String) {}
func f3(_ x: String...) {}
struct HasVariadicSubscript {
  subscript(bar: Int...) -> Int {
    get { 42 }
  }
}
let closure: ((Int...) -> Void) = {
  (args: Int...) in
}

f(1,2,3)
f([1,2,3] as Int...)
closure([1,2,3] as Int...)
let x: [Int] = [1,2,3] + [4]
f(x as Int...)
f((x.map { $0 + 1 }) as Int...)
f([] as Int...)

f2(x: "Hello,", y: 1,2,3, z: "world!")
f2(x: "Hello again,", y: [1,2,3] as Int..., z: "world!")
f2(x: "Hello yet again,", y: x as Int..., z: "world!")

f3(["\(1)", "\(2)"] as String...)

func overloaded(x: [Int]) {}
func overloaded(x: Int...) {}
overloaded(x: x as Int...)

f([1,2,3] as Int..., 3, 4) // expected-error {{#variadic cannot be used alongside additional variadic arguments}}
f(1, 2, [1,2,3] as Int...) // expected-error {{#variadic cannot be used alongside additional variadic arguments}}
f(1, 2, [1,2,3] as Int..., 3, 4) // expected-error {{#variadic cannot be used alongside additional variadic arguments}}
f([1,2,3] as Int..., 3, 4, [1,2,3] as Int...) // expected-error {{#variadic cannot be used alongside additional variadic arguments}}
f([1,2,3] as Int..., [1,2,3] as Int...) // expected-error {{#variadic cannot be used alongside additional variadic arguments}}

f(1 as Int...) // expected-error {{expression type '[_]' is ambiguous without more context}}

f([1,2,3])
f(x)

class A {}
class B: A {}
protocol P {}
struct S: P {}
struct S2 {}
func takesA(_ x: A...) {}
func takesP(_ x: P...) {}
takesA([A(), A()] as A...)
takesA([B(), B()] as A...)
takesA([B(), B()] as B...)
takesA([S2()] as A...) // expected-error {{cannot convert value of type 'S2' to expected element type 'A'}}
takesP([S(), S(), S()] as P...)
takesP([S2()] as P...) // expected-error {{argument type '[S2]' does not conform to expected type 'P'}}

f(([1,2,3] as Int...) as Int...) // expected-error {{coercion to variadic arguments is only allowed in an argument position}}
let y = [1,2,3] as Int... // expected-error {{coercion to variadic arguments is only allowed in an argument position}}
x as Int... // expected-error {{coercion to variadic arguments is only allowed in an argument position}}
(x as Int...) + x // expected-error {{coercion to variadic arguments is only allowed in an argument position}}

func takesArray(_ x: [Int]) {}
takesArray([1,2,3] as Int...) // expected-error {{cannot invoke 'takesArray' with an argument list of type '(Int...)'}}
// expected-note@-1 {{expected an argument list of type '([Int])'}}
takesArray(x as Int...) // expected-error {{cannot invoke 'takesArray' with an argument list of type '(Int...)'}}
// expected-note@-1 {{expected an argument list of type '([Int])'}}
takesArray(1 as Int...)
