/*
 ABJC - tvOS
 ItemType.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

import Foundation

enum ItemType: String, Encodable {
    case movie = "Movie"
    case series = "Series"
    case episode = "Episode"
}
