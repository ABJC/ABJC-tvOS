//
//  ViewExtensions.swift
//  ABJC
//
//  Created by Stephen Byatt on 28/5/21.
//

import SwiftUI

extension View {
    // Modifier allows the view to be hidden but still retains the frame within the layout
    @ViewBuilder func hidden(_ hide: Bool) -> some View {
        if hide { hidden() }
        else { self }
    }
}
