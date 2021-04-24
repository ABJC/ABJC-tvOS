//
//  ReportAProblemView.swift
//  ABJC
//
//  Created by Noah Kamara on 24.04.21.
//

import SwiftUI

struct ReportAProblemView: View {
    private let session: SessionStore
    
    init(_ session: SessionStore) {
        self.session = session
    }
    
    var body: some View {
        ZStack {
            Blur()
                .edgesIgnoringSafeArea(.all)
            NavigationView {
                Text("HELLO")
                    .navigationTitle("Report A Problem")
            }
        }
    }
}

struct ReportAProblemView_Previews: PreviewProvider {
    static var previews: some View {
        ReportAProblemView(SessionStore())
    }
}
