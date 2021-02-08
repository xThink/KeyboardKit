//
//  BaseKeyboardLayoutProviderTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-08.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
import KeyboardKit

class BaseKeyboardLayoutProviderTests: QuickSpec {
    
    override func spec() {
        
        var provider: BaseKeyboardLayoutProvider!
        var inputProvider: MockKeyboardInputSetProvider!
        var context: MockKeyboardContext!
        
        beforeEach {
            context = MockKeyboardContext()
            inputProvider = MockKeyboardInputSetProvider()
            inputProvider.alphabeticInputSetValue = AlphabeticKeyboardInputSet(rows: [["a", "b", "c"]])
            inputProvider.numericInputSetValue = NumericKeyboardInputSet(rows: [["1", "2", "3"]])
            inputProvider.symbolicInputSetValue = SymbolicKeyboardInputSet(rows: [[",", ".", "-"]])
            provider = BaseKeyboardLayoutProvider(
                inputSetProvider: inputProvider,
                dictationReplacement: .go)
        }
        
        
        describe("layout for context") {
            
            it("is items derived from action for the input items") {
                let inputs = provider.inputs(for: context)
                let actions = provider.actions(for: context, inputs: inputs)
                let items = provider.items(for: context, actions: actions)
                let layout = provider.keyboardLayout(for: context)
                let expected = KeyboardLayout(items: items)
                expect(layout.items.count).to(equal(expected.items.count))
            }
        }
        
        
        describe("actions for context and inputs") {
            
            it("is character actions for the provided inputs") {
                let inputs = [["a", "b", "c"], ["d", "e", "f"]]
                let actions = provider.actions(for: context, inputs: inputs)
                let expected = KeyboardActionRows(characters: inputs)
                expect(actions).to(equal(expected))
            }
        }
        
        describe("inputs for context") {
            
            it("can resolve lowercased alphabetic input set") {
                context.keyboardType = .alphabetic(.lowercased)
                let rows = provider.inputs(for: context)
                expect(rows).to(equal([["a", "b", "c"]]))
            }
            
            it("can resolve uppercased alphabetic input set") {
                context.keyboardType = .alphabetic(.uppercased)
                let rows = provider.inputs(for: context)
                expect(rows).to(equal([["A", "B", "C"]]))
            }
            
            it("can resolve numeric input set") {
                context.keyboardType = .numeric
                let rows = provider.inputs(for: context)
                expect(rows).to(equal([["1", "2", "3"]]))
            }
            
            it("can resolve symbolic input set") {
                context.keyboardType = .symbolic
                let rows = provider.inputs(for: context)
                expect(rows).to(equal([[",", ".", "-"]]))
            }
            
            it("returns empty rows for unsupported keybard type") {
                context.keyboardType = .emojis
                let rows = provider.inputs(for: context)
                expect(rows).to(equal([]))
            }
        }
        
        describe("items for context and actions") {
            
            it("is character actions for the provided inputs") {
                let actions: KeyboardActionRows = [[.character("")], [.backspace]]
                let result = provider.items(for: context, actions: actions)
                expect(result.count).to(equal(2))
                expect(result[0][0].action).to(equal(.character("")))
                expect(result[0][0].insets).to(equal(.standardKeyboardButtonInsets(for: context.device)))
                expect(result[0][0].size.height).to(equal(.standardKeyboardRowHeight(for: context.device)))
                expect(result[0][0].size.width).to(equal(.input))
                expect(result[1][0].action).to(equal(.backspace))
                expect(result[1][0].insets).to(equal(.standardKeyboardButtonInsets(for: context.device)))
                expect(result[1][0].size.height).to(equal(.standardKeyboardRowHeight(for: context.device)))
                expect(result[1][0].size.width).to(equal(.available))
            }
        }
        
        describe("keyboard switcher action for bottom input row") {
            
            it("is shift for lowercased alphabetic input set") {
                context.keyboardType = .alphabetic(.lowercased)
                let result = provider.keyboardSwitchActionForBottomInputRow(for: context)
                expect(result).to(equal(KeyboardAction.shift(currentState: .lowercased)))
            }
            
            it("is shift for uppercased alphabetic input set") {
                context.keyboardType = .alphabetic(.uppercased)
                let result = provider.keyboardSwitchActionForBottomInputRow(for: context)
                expect(result).to(equal(KeyboardAction.shift(currentState: .uppercased)))
            }
            
            it("is shift for numeric input set") {
                context.keyboardType = .numeric
                let result = provider.keyboardSwitchActionForBottomInputRow(for: context)
                expect(result).to(equal(.keyboardType(.symbolic)))
            }
            
            it("is shift for symbolic input set") {
                context.keyboardType = .symbolic
                let result = provider.keyboardSwitchActionForBottomInputRow(for: context)
                expect(result).to(equal(.keyboardType(.numeric)))
            }
            
            it("is nil for unsupported keybard type") {
                context.keyboardType = .emojis
                let rows = provider.inputs(for: context)
                expect(rows).to(equal([]))
            }
        }
        
        describe("keyboard switcher action for bottom row") {
            
            it("is shift for lowercased alphabetic input set") {
                context.keyboardType = .alphabetic(.lowercased)
                let result = provider.keyboardSwitchActionForBottomRow(for: context)
                expect(result).to(equal(.keyboardType(.numeric)))
            }
            
            it("is shift for uppercased alphabetic input set") {
                context.keyboardType = .alphabetic(.uppercased)
                let result = provider.keyboardSwitchActionForBottomRow(for: context)
                expect(result).to(equal(.keyboardType(.numeric)))
            }
            
            it("is shift for numeric input set") {
                context.keyboardType = .numeric
                let result = provider.keyboardSwitchActionForBottomRow(for: context)
                expect(result).to(equal(.keyboardType(.alphabetic(.lowercased))))
            }
            
            it("is shift for symbolic input set") {
                context.keyboardType = .symbolic
                let result = provider.keyboardSwitchActionForBottomRow(for: context)
                expect(result).to(equal(.keyboardType(.alphabetic(.lowercased))))
            }
            
            it("is nil for unsupported keybard type") {
                context.keyboardType = .emojis
                let rows = provider.inputs(for: context)
                expect(rows).to(equal([]))
            }
        }
    }
}
