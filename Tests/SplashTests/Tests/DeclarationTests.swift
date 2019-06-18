/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest
import Splash

final class DeclarationTests: SyntaxHighlighterTestCase {
    func testFunctionDeclaration() {
        let components = highlighter.highlight("func hello(world: String) -> Int")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("hello(world:"),
            .whitespace(" "),
            .token("String", .type),
            .plainText(")"),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("Int", .type)
        ])
    }

    func testRequiredFunctionDeclaration() {
        let components = highlighter.highlight("required func hello()")

        XCTAssertEqual(components, [
            .token("required", .keyword),
            .whitespace(" "),
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("hello()")
        ])
    }

    func testPublicFunctionDeclarationWithDocumentationEndingWithDot() {
        let components = highlighter.highlight("""
        /// Documentation.
        public func hello()
        """)

        XCTAssertEqual(components, [
            .token("///", .comment),
            .whitespace(" "),
            .token("Documentation.", .comment),
            .whitespace("\n"),
            .token("public", .keyword),
            .whitespace(" "),
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("hello()")
        ])
    }

    func testFunctionDeclarationWithEmptyExternalLabel() {
        let components = highlighter.highlight("func a(_ b: B)")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("a("),
            .token("_", .keyword),
            .whitespace(" "),
            .plainText("b:"),
            .whitespace(" "),
            .token("B", .type),
            .plainText(")")
        ])
    }

    func testFunctionDeclarationWithKeywordArgumentLabel() {
        let components = highlighter.highlight("func a(for b: B)")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("a(for"),
            .whitespace(" "),
            .plainText("b:"),
            .whitespace(" "),
            .token("B", .type),
            .plainText(")")
        ])
    }

    func testGenericFunctionDeclarationWithKeywordArgumentLabel() {
        let components = highlighter.highlight("func perform<O: AnyObject>(for object: O) {}")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("perform<O:"),
            .whitespace(" "),
            .token("AnyObject", .type),
            .plainText(">(for"),
            .whitespace(" "),
            .plainText("object:"),
            .whitespace(" "),
            .token("O", .type),
            .plainText(")"),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testGenericFunctionDeclarationWithoutConstraints() {
        let components = highlighter.highlight("func hello<A, B>(a: A, b: B)")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("hello<A,"),
            .whitespace(" "),
            .plainText("B>(a:"),
            .whitespace(" "),
            .token("A", .type),
            .plainText(","),
            .whitespace(" "),
            .plainText("b:"),
            .whitespace(" "),
            .token("B", .type),
            .plainText(")")
        ])
    }

    func testGenericFunctionDeclarationWithSingleConstraint() {
        let components = highlighter.highlight("func hello<T: AnyObject>(t: T)")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("hello<T:"),
            .whitespace(" "),
            .token("AnyObject", .type),
            .plainText(">(t:"),
            .whitespace(" "),
            .token("T", .type),
            .plainText(")")
        ])
    }

    func testGenericFunctionDeclarationWithMultipleConstraints() {
        let components = highlighter.highlight("func hello<A: AnyObject, B: Sequence>(a: A, b: B)")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("hello<A:"),
            .whitespace(" "),
            .token("AnyObject", .type),
            .plainText(","),
            .whitespace(" "),
            .plainText("B:"),
            .whitespace(" "),
            .token("Sequence", .type),
            .plainText(">(a:"),
            .whitespace(" "),
            .token("A", .type),
            .plainText(","),
            .whitespace(" "),
            .plainText("b:"),
            .whitespace(" "),
            .token("B", .type),
            .plainText(")")
        ])
    }

    func testGenericFunctionDeclarationWithGenericParameter() {
        let components = highlighter.highlight("func value<T>(at keyPath: KeyPath<Element, T>) -> T? {}")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("value<T>(at"),
            .whitespace(" "),
            .plainText("keyPath:"),
            .whitespace(" "),
            .token("KeyPath", .type),
            .plainText("<"),
            .token("Element", .type),
            .plainText(","),
            .whitespace(" "),
            .token("T", .type),
            .plainText(">)"),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("T", .type),
            .plainText("?"),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testFunctionDeclarationWithGenericReturnType() {
        let components = highlighter.highlight("""
        func array() -> Array<Element> { return [] }
        """)

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("array()"),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("Array", .type),
            .plainText("<"),
            .token("Element", .type),
            .plainText(">"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("return", .keyword),
            .whitespace(" "),
            .plainText("[]"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testGenericStructDeclaration() {
        let components = highlighter.highlight("struct MyStruct<A: Hello, B> {}")

        XCTAssertEqual(components, [
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("MyStruct<A:"),
            .whitespace(" "),
            .token("Hello", .type),
            .plainText(","),
            .whitespace(" "),
            .plainText("B>"),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testClassDeclaration() {
        let components = highlighter.highlight("""
        class Hello {
            var required: String
            var optional: Int?
        }
        """)

        XCTAssertEqual(components, [
            .token("class", .keyword),
            .whitespace(" "),
            .plainText("Hello"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("required:"),
            .whitespace(" "),
            .token("String", .type),
            .whitespace("\n    "),
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("optional:"),
            .whitespace(" "),
            .token("Int", .type),
            .plainText("?"),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testCompactClassDeclarationWithInitializer() {
        let components = highlighter.highlight("class Foo { init(hello: Int) {} }")

        XCTAssertEqual(components, [
            .token("class", .keyword),
            .whitespace(" "),
            .plainText("Foo"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("init", .keyword),
            .plainText("(hello:"),
            .whitespace(" "),
            .token("Int", .type),
            .plainText(")"),
            .whitespace(" "),
            .plainText("{}"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testClassDeclarationWithDeinit() {
        let components = highlighter.highlight("class Foo { deinit {} }")

        XCTAssertEqual(components, [
            .token("class", .keyword),
            .whitespace(" "),
            .plainText("Foo"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("deinit", .keyword),
            .whitespace(" "),
            .plainText("{}"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testClassDeclarationWithMultipleProtocolConformances() {
        let components = highlighter.highlight("class MyClass: ProtocolA, ProtocolB {}")

        XCTAssertEqual(components, [
            .token("class", .keyword),
            .whitespace(" "),
            .plainText("MyClass:"),
            .whitespace(" "),
            .token("ProtocolA", .type),
            .plainText(","),
            .whitespace(" "),
            .token("ProtocolB", .type),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testSubclassDeclaration() {
        let components = highlighter.highlight("class ViewController: UIViewController { }")

        XCTAssertEqual(components, [
            .token("class", .keyword),
            .whitespace(" "),
            .plainText("ViewController:"),
            .whitespace(" "),
            .token("UIViewController", .type),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testProtocolDeclaration() {
        let components = highlighter.highlight("""
        protocol Hello {
            var property: String { get set }
            func method()
        }
        """)

        XCTAssertEqual(components, [
            .token("protocol", .keyword),
            .whitespace(" "),
            .plainText("Hello"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("property:"),
            .whitespace(" "),
            .token("String", .type),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("get", .keyword),
            .whitespace(" "),
            .token("set", .keyword),
            .whitespace(" "),
            .plainText("}"),
            .whitespace("\n    "),
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("method()"),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testProtocolDeclarationWithAssociatedTypes() {
        let components = highlighter.highlight("""
        protocol Task {
            associatedtype Input
            associatedtype Error: Swift.Error
        }
        """)

        XCTAssertEqual(components, [
            .token("protocol", .keyword),
            .whitespace(" "),
            .plainText("Task"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("associatedtype", .keyword),
            .whitespace(" "),
            .plainText("Input"),
            .whitespace("\n    "),
            .token("associatedtype", .keyword),
            .whitespace(" "),
            .plainText("Error:"),
            .whitespace(" "),
            .token("Swift", .type),
            .plainText("."),
            .token("Error", .type),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testExtensionDeclaration() {
        let components = highlighter.highlight("extension UIViewController { }")

        XCTAssertEqual(components, [
            .token("extension", .keyword),
            .whitespace(" "),
            .token("UIViewController", .type),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testExtensionDeclarationWithConstraint() {
        let components = highlighter.highlight("extension Hello where Foo == String, Bar: Numeric { }")

        XCTAssertEqual(components, [
            .token("extension", .keyword),
            .whitespace(" "),
            .token("Hello", .type),
            .whitespace(" "),
            .token("where", .keyword),
            .whitespace(" "),
            .token("Foo", .type),
            .whitespace(" "),
            .plainText("=="),
            .whitespace(" "),
            .token("String", .type),
            .plainText(","),
            .whitespace(" "),
            .token("Bar", .type),
            .plainText(":"),
            .whitespace(" "),
            .token("Numeric", .type),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testLazyPropertyDeclaration() {
        let components = highlighter.highlight("""
        struct Hello {
            lazy var property = 0
        }
        """)

        XCTAssertEqual(components, [
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("Hello"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("lazy", .keyword),
            .whitespace(" "),
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("property"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("0", .number),
            .whitespace("\n"),
            .plainText("}")
        ])
    }
    
    func testDynamicPropertyDeclaration() {
        let components = highlighter.highlight("""
        class Hello {
            @objc dynamic var property = 0
        }
        """)
        
        XCTAssertEqual(components, [
            .token("class", .keyword),
            .whitespace(" "),
            .plainText("Hello"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("@objc", .keyword),
            .whitespace(" "),
            .token("dynamic", .keyword),
            .whitespace(" "),
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("property"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("0", .number),
            .whitespace("\n"),
            .plainText("}")
        ])
    }


    func testGenericPropertyDeclaration() {
        let components = highlighter.highlight("class Hello { var array: Array<String> = [] }")

        XCTAssertEqual(components, [
            .token("class", .keyword),
            .whitespace(" "),
            .plainText("Hello"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("array:"),
            .whitespace(" "),
            .token("Array", .type),
            .plainText("<"),
            .token("String", .type),
            .plainText(">"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .plainText("[]"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testPropertyDeclarationWithWillSet() {
        let components = highlighter.highlight("""
        struct Hello {
            var property: Int { willSet { } }
        }
        """)

        XCTAssertEqual(components, [
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("Hello"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("property:"),
            .whitespace(" "),
            .token("Int", .type),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("willSet", .keyword),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("}"),
            .whitespace(" "),
            .plainText("}"),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testPropertyDeclarationWithDidSet() {
        let components = highlighter.highlight("""
        struct Hello {
            var property: Int { didSet { } }
        }
        """)

        XCTAssertEqual(components, [
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("Hello"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("property:"),
            .whitespace(" "),
            .token("Int", .type),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("didSet", .keyword),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("}"),
            .whitespace(" "),
            .plainText("}"),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testPropertyWithSetterAccessLevel() {
        let components = highlighter.highlight("""
        struct Hello {
            private(set) var property: Int
        }
        """)

        XCTAssertEqual(components, [
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("Hello"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("private(set)", .keyword),
            .whitespace(" "),
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("property:"),
            .whitespace(" "),
            .token("Int", .type),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testSubscriptDeclaration() {
        let components = highlighter.highlight("""
        extension Collection {
            subscript(key: Key) -> Value? { return nil }
        }
        """)

        XCTAssertEqual(components, [
            .token("extension", .keyword),
            .whitespace(" "),
            .token("Collection", .type),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("subscript", .keyword),
            .plainText("(key:"),
            .whitespace(" "),
            .token("Key", .type),
            .plainText(")"),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("Value", .type),
            .plainText("?"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("return", .keyword),
            .whitespace(" "),
            .token("nil", .keyword),
            .whitespace(" "),
            .plainText("}"),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testDeferDeclaration() {
        let components = highlighter.highlight("func hello() { defer {} }")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("hello()"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("defer", .keyword),
            .whitespace(" "),
            .plainText("{}"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testFunctionDeclarationWithInOutParameter() {
        let components = highlighter.highlight("func swapValues(value1: inout Int, value2: inout Int) { }")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("swapValues(value1:"),
            .whitespace(" "),
            .token("inout", .keyword),
            .whitespace(" "),
            .token("Int", .type),
            .plainText(","),
            .whitespace(" "),
            .plainText("value2:"),
            .whitespace(" "),
            .token("inout", .keyword),
            .whitespace(" "),
            .token("Int", .type),
            .plainText(")"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testFunctionDeclarationWithNonEscapedKeywordAsName() {
        let components = highlighter.highlight("func get() -> Int { return 7 }")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("get()"),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("Int", .type),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("return", .keyword),
            .whitespace(" "),
            .token("7", .number),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testFunctionDeclarationWithEscapedKeywordAsName() {
        let components = highlighter.highlight("func `public`() -> Int { return 7 }")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("`public`()"),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("Int", .type),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("return", .keyword),
            .whitespace(" "),
            .token("7", .number),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testFunctionDeclarationWithPreProcessors() {
        let components = highlighter.highlight("""
        func log(_ file: StaticString = #file, _ function: StaticString = #function) {}
        """)

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("log("),
            .token("_", .keyword),
            .whitespace(" "),
            .plainText("file:"),
            .whitespace(" "),
            .token("StaticString", .type),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("#file", .keyword),
            .plainText(","),
            .whitespace(" "),
            .token("_", .keyword),
            .whitespace(" "),
            .plainText("function:"),
            .whitespace(" "),
            .token("StaticString", .type),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("#function", .keyword),
            .plainText(")"),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testNonMutatingFunction() {
        let components = highlighter.highlight("""
        struct MyStruct {
            nonmutating func doNotChangeState() { }
        }
        """)

        XCTAssertEqual(components, [
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("MyStruct"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("nonmutating", .keyword),
            .whitespace(" "),
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("doNotChangeState()"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("}"),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testRethrowingFunctionDeclaration() {
        let components = highlighter.highlight("""
        func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
        """)

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("map<T>("),
            .token("_", .keyword),
            .whitespace(" "),
            .plainText("transform:"),
            .whitespace(" "),
            .plainText("("),
            .token("Element", .type),
            .plainText(")"),
            .whitespace(" "),
            .token("throws", .keyword),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("T", .type),
            .plainText(")"),
            .whitespace(" "),
            .token("rethrows", .keyword),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .plainText("["),
            .token("T", .type),
            .plainText("]")
        ])
    }

    func testFunctionDeclarationWithOpaqueReturnType() {
        let components = highlighter.highlight(#"func make() -> some View { Text("!") }"#)

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("make()"),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("some", .keyword),
            .whitespace(" "),
            .token("View", .type),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("Text", .type),
            .plainText("("),
            .token(#""!""#, .string),
            .plainText(")"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testIndirectEnumDeclaration() {
        let components = highlighter.highlight("""
        indirect enum Content {
            case single(String)
            case collection([Content])
        }
        """)

        XCTAssertEqual(components, [
            .token("indirect", .keyword),
            .whitespace(" "),
            .token("enum", .keyword),
            .whitespace(" "),
            .plainText("Content"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("case", .keyword),
            .whitespace(" "),
            .plainText("single("),
            .token("String", .type),
            .plainText(")"),
            .whitespace("\n    "),
            .token("case", .keyword),
            .whitespace(" "),
            .plainText("collection(["),
            .token("Content", .type),
            .plainText("])"),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testWrappedPropertyDeclarations() {
        let components = highlighter.highlight("""
        struct User {
            @Persisted(key: "name") var name: String
        }
        """)

        XCTAssertEqual(components, [
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("User"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("@Persisted", .keyword),
            .plainText("(key:"),
            .whitespace(" "),
            .token(#""name""#, .string),
            .plainText(")"),
            .whitespace(" "),
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("name:"),
            .whitespace(" "),
            .token("String", .type),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension DeclarationTests {
    static var allTests: [(String, TestClosure<DeclarationTests>)] {
        return [
            ("testFunctionDeclaration", testFunctionDeclaration),
            ("testRequiredFunctionDeclaration", testRequiredFunctionDeclaration),
            ("testPublicFunctionDeclarationWithDocumentationEndingWithDot", testPublicFunctionDeclarationWithDocumentationEndingWithDot),
            ("testFunctionDeclarationWithEmptyExternalLabel", testFunctionDeclarationWithEmptyExternalLabel),
            ("testFunctionDeclarationWithKeywordArgumentLabel", testFunctionDeclarationWithKeywordArgumentLabel),
            ("testGenericFunctionDeclarationWithKeywordArgumentLabel", testGenericFunctionDeclarationWithKeywordArgumentLabel),
            ("testGenericFunctionDeclarationWithoutConstraints", testGenericFunctionDeclarationWithoutConstraints),
            ("testGenericFunctionDeclarationWithSingleConstraint", testGenericFunctionDeclarationWithSingleConstraint),
            ("testGenericFunctionDeclarationWithMultipleConstraints", testGenericFunctionDeclarationWithMultipleConstraints),
            ("testGenericFunctionDeclarationWithGenericParameter", testGenericFunctionDeclarationWithGenericParameter),
            ("testFunctionDeclarationWithGenericReturnType", testFunctionDeclarationWithGenericReturnType),
            ("testGenericStructDeclaration", testGenericStructDeclaration),
            ("testClassDeclaration", testClassDeclaration),
            ("testCompactClassDeclarationWithInitializer", testCompactClassDeclarationWithInitializer),
            ("testClassDeclarationWithDeinit", testClassDeclarationWithDeinit),
            ("testClassDeclarationWithMultipleProtocolConformances", testClassDeclarationWithMultipleProtocolConformances),
            ("testSubclassDeclaration", testSubclassDeclaration),
            ("testProtocolDeclaration", testProtocolDeclaration),
            ("testProtocolDeclarationWithAssociatedTypes", testProtocolDeclarationWithAssociatedTypes),
            ("testExtensionDeclaration", testExtensionDeclaration),
            ("testExtensionDeclarationWithConstraint", testExtensionDeclarationWithConstraint),
            ("testLazyPropertyDeclaration", testLazyPropertyDeclaration),
            ("testDynamicPropertyDeclaration", testDynamicPropertyDeclaration),
            ("testGenericPropertyDeclaration", testGenericPropertyDeclaration),
            ("testPropertyDeclarationWithWillSet", testPropertyDeclarationWithWillSet),
            ("testPropertyDeclarationWithDidSet", testPropertyDeclarationWithDidSet),
            ("testPropertyWithSetterAccessLevel", testPropertyWithSetterAccessLevel),
            ("testSubscriptDeclaration", testSubscriptDeclaration),
            ("testDeferDeclaration", testDeferDeclaration),
            ("testFunctionDeclarationWithInOutParameter", testFunctionDeclarationWithInOutParameter),
            ("testFunctionDeclarationWithNonEscapedKeywordAsName", testFunctionDeclarationWithNonEscapedKeywordAsName),
            ("testFunctionDeclarationWithEscapedKeywordAsName", testFunctionDeclarationWithEscapedKeywordAsName),
            ("testFunctionDeclarationWithPreProcessors", testFunctionDeclarationWithPreProcessors),
            ("testNonMutatingFunction", testNonMutatingFunction),
            ("testRethrowingFunctionDeclaration", testRethrowingFunctionDeclaration),
            ("testFunctionDeclarationWithOpaqueReturnType", testFunctionDeclarationWithOpaqueReturnType),
            ("testIndirectEnumDeclaration", testIndirectEnumDeclaration),
            ("testWrappedPropertyDeclarations", testWrappedPropertyDeclarations)
        ]
    }
}
