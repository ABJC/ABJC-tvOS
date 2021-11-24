/*
 ABJC - tvOS
 SearchView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 24.11.21
 */

import SwiftUI

struct SearchView: View {
    @StateObject var store: SearchViewDelegate = .init()

    var body: some View {
        Group {
            if store.searchResults.count > 0 {
                MediaCardRow(
                    store: .init(),
                    label: "Found \(store.searchResults.count) Results for '\(store.searchTerm)'",
                    items: store.searchResults
                )
                .id(store.searchResults.hashValue)
            } else {
                Text("No Results")
            }
        }
        .searchable(text: $store.searchTerm, prompt: "Search", suggestions: suggestionsView)
        .onChange(of: store.searchTerm, perform: store.retrieveSearchHints)
        .onSubmit(of: .search, store.performSearch)
    }

    func suggestionsView() -> some View {
        VStack {
            ForEach(store.searchHints, id: \.id) { hint in
                Text(hint.name ?? "")
                Text(hint.matchedTerm ?? "")
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
