//
//  KeyboardSpaceLongPressBehavior.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2023-02-21.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This enum describes the behavior of a keyboard space button
 when it's long pressed.
 */
public enum KeyboardSpaceLongPressBehavior: Codable {

    /// The space key will start moving the input cursor.
    case enableInputCursorMovement

    /// The space key will open a locale context menu.
    case openLocaleContextMenu(in: Locale)
}

public extension KeyboardSpaceLongPressBehavior {

    /// The space key will open a locale context menu.
    static func openLocaleContextMenu(in locale: KeyboardLocale) -> KeyboardSpaceLongPressBehavior {
        .openLocaleContextMenu(in: locale.locale)
    }
}
