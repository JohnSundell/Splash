/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest
import Splash

final class FunctionCallTests: SyntaxHighlighterTestCase {
    func testFunctionCallWithIntegers() {
        let components = highlighter.highlight("add(1, 2)")

        XCTAssertEqual(components, [
            .token("add", .call),
            .plainText("("),
            .token("1", .number),
            .plainText(","),
            .whitespace(" "),
            .token("2", .number),
            .plainText(")")
        ])
    }

    func testImplicitInitializerCall() {
        let components = highlighter.highlight("let string = String()")

        XCTAssertEqual(components, [
            .token("let", .keyword),
            .whitespace(" "),
            .plainText("string"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("String", .type),
            .plainText("()")
        ])
    }

    func testExplicitInitializerCall() {
        let components = highlighter.highlight("let string = String.init()")

        XCTAssertEqual(components, [
            .token("let", .keyword),
            .whitespace(" "),
            .plainText("string"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("String", .type),
            .plainText("."),
            .token("init", .call),
            .plainText("()")
        ])
    }

    func testDotSyntaxInitializerCall() {
        let components = highlighter.highlight("let string: String = .init()")

        XCTAssertEqual(components, [
            .token("let", .keyword),
            .whitespace(" "),
            .plainText("string:"),
            .whitespace(" "),
            .token("String", .type),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .plainText("."),
            .token("init", .keyword),
            .plainText("()")
        ])
    }

    func testAccessingPropertyAfterFunctionCallWithoutArguments() {
        let components = highlighter.highlight("call().property")

        XCTAssertEqual(components, [
            .token("call", .call),
            .plainText("()."),
            .token("property", .property)
        ])
    }

    func testAccessingPropertyAfterFunctionCallWithArguments() {
        let components = highlighter.highlight("call(argument).property")

        XCTAssertEqual(components, [
            .token("call", .call),
            .plainText("(argument)."),
            .token("property", .property)
        ])
    }

    func testCallingStaticMethodOnGenericType() {
        let components = highlighter.highlight("Array<String>.call()")

        XCTAssertEqual(components, [
            .token("Array", .type),
            .plainText("<"),
            .token("String", .type),
            .plainText(">."),
            .token("call", .call),
            .plainText("()")
        ])
    }

    func testPassingTypeToFunction() {
        let components = highlighter.highlight("call(String.self)")

        XCTAssertEqual(components, [
            .token("call", .call),
            .plainText("("),
            .token("String", .type),
            .plainText("."),
            .token("self", .keyword),
            .plainText(")")
        ])
    }

    func testPassingBoolToUnnamedArgument() {
        let components = highlighter.highlight("setCachingEnabled(true)")

        XCTAssertEqual(components, [
            .token("setCachingEnabled", .call),
            .plainText("("),
            .token("true", .keyword),
            .plainText(")")
        ])
    }

    func testXCTAssertCalls() {
        let components = highlighter.highlight("XCTAssertTrue(variable)")

        XCTAssertEqual(components, [
            .token("XCTAssertTrue", .call),
            .plainText("(variable)")
        ])
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension FunctionCallTests {
    static var allTests: [(String, TestClosure<FunctionCallTests>)] {
        return [
            ("testFunctionCallWithIntegers", testFunctionCallWithIntegers),
            ("testImplicitInitializerCall", testImplicitInitializerCall),
            ("testExplicitInitializerCall", testExplicitInitializerCall),
            ("testDotSyntaxInitializerCall", testDotSyntaxInitializerCall),
            ("testAccessingPropertyAfterFunctionCallWithoutArguments", testAccessingPropertyAfterFunctionCallWithoutArguments),
            ("testAccessingPropertyAfterFunctionCallWithArguments", testAccessingPropertyAfterFunctionCallWithArguments),
            ("testCallingStaticMethodOnGenericType", testCallingStaticMethodOnGenericType),
            ("testPassingTypeToFunction", testPassingTypeToFunction),
            ("testPassingBoolToUnnamedArgument", testPassingBoolToUnnamedArgument),
            ("testXCTAssertCalls", testXCTAssertCalls)
        ]
    }
}
