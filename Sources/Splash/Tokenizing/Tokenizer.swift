/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

internal struct Tokenizer {
    func segmentsByTokenizing(_ code: String, delimiters: CharacterSet) -> AnySequence<Segment> {
        return AnySequence<Segment> {
            return Buffer(iterator: Iterator(code: code, delimiters: delimiters))
        }
    }
}

private extension Tokenizer {
    struct Buffer: IteratorProtocol {
        private var iterator: Iterator
        private var nextSegment: Segment?

        init(iterator: Iterator) {
            self.iterator = iterator
        }

        mutating func next() -> Segment? {
            var segment = nextSegment ?? iterator.next()
            nextSegment = iterator.next()
            segment?.tokens.next = nextSegment?.tokens.current
            return segment
        }
    }

    struct Iterator: IteratorProtocol {
        enum Component {
            case token(String)
            case delimiter(String)
            case whitespace(String)
            case newline(String)
        }

        private let code: String
        private let delimiters: CharacterSet
        private var index: String.Index?
        private var tokenCounts = [String: Int]()
        private var allTokens = [String]()
        private var lineTokens = [String]()
        private var segments: (current: Segment?, previous: Segment?)

        init(code: String, delimiters: CharacterSet) {
            self.code = code
            self.delimiters = delimiters
            segments = (nil, nil)
        }

        mutating func next() -> Segment? {
            let nextIndex = makeNextIndex()

            guard nextIndex != code.endIndex else {
                let segment = segments.current
                segments.current = nil
                return segment
            }

            index = nextIndex
            let component = makeComponent(at: nextIndex)

            switch component {
            case .token(let token), .delimiter(let token):
                guard var segment = segments.current else {
                    segments.current = makeSegment(with: component, at: nextIndex)
                    return next()
                }

                guard segment.trailingWhitespace == nil,
                      component.isDelimiter == segment.currentTokenIsDelimiter else {
                    return finish(segment, with: component, at: nextIndex)
                }

                segment.tokens.current.append(token)
                segments.current = segment
                return next()
            case .whitespace(let whitespace), .newline(let whitespace):
                guard var segment = segments.current else {
                    var segment = makeSegment(with: component, at: nextIndex)
                    segment.trailingWhitespace = whitespace
                    segment.isLastOnLine = component.isNewline
                    segments.current = segment
                    return next()
                }

                if let existingWhitespace = segment.trailingWhitespace {
                    segment.trailingWhitespace = existingWhitespace.appending(whitespace)
                } else {
                    segment.trailingWhitespace = whitespace
                }

                if component.isNewline {
                    segment.isLastOnLine = true
                }

                segments.current = segment
                return next()
            }
        }

        private func makeNextIndex() -> String.Index {
            guard let index = index else {
                return code.startIndex
            }

            return code.index(after: index)
        }

        private func makeComponent(at index: String.Index) -> Component {
            let character = code[index]
            let substring = String(character)

            if character.isWhitespace {
                return .whitespace(substring)
            }

            if character.isNewline {
                return .newline(substring)
            }

            if delimiters.contains(character) {
                return .delimiter(substring)
            }

            return .token(substring)
        }

        private func makeSegment(with component: Component, at index: String.Index) -> Segment {
            let tokens = Segment.Tokens(
                all: allTokens,
                counts: tokenCounts,
                onSameLine: lineTokens,
                previous: segments.current?.tokens.current,
                current: component.token,
                next: nil
            )

            return Segment(
                prefix: code[..<index],
                tokens: tokens,
                trailingWhitespace: nil,
                currentTokenIsDelimiter: component.isDelimiter,
                isLastOnLine: false
            )
        }

        private mutating func finish(_ segment: Segment,
                                     with component: Component,
                                     at index: String.Index) -> Segment {
            var count = tokenCounts[segment.tokens.current] ?? 0
            count += 1
            tokenCounts[segment.tokens.current] = count

            allTokens.append(segment.tokens.current)

            if segment.isLastOnLine {
                lineTokens = []
            } else {
                lineTokens.append(segment.tokens.current)
            }

            segments.previous = segment
            segments.current = makeSegment(with: component, at: index)

            return segment
        }
    }
}

extension Tokenizer.Iterator.Component {
    var token: String {
        switch self {
        case .token(let token),
             .delimiter(let token):
            return token
        case .whitespace, .newline:
            return ""
        }
    }

    var isDelimiter: Bool {
        switch self {
        case .token, .whitespace, .newline:
            return false
        case .delimiter:
            return true
        }
    }

    var isNewline: Bool {
        switch self {
        case .token, .whitespace, .delimiter:
            return false
        case .newline:
            return true
        }
    }
}

private extension Character {
    var isWhitespace: Bool {
        return CharacterSet.whitespaces.contains(self)
    }

    var isNewline: Bool {
        return CharacterSet.newlines.contains(self)
    }
}
