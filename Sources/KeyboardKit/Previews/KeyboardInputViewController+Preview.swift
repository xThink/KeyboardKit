//
//  KeyboardInputViewController+Preview.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import Foundation

public extension KeyboardInputViewController {
    
    /**
     This preview controller can be used in SwiftUI previews.
     */
    static var preview: KeyboardInputViewController {
        KeyboardInputViewController()
    }
}
#endif
