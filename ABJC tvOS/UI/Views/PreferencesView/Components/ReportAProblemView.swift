/*
 ABJC - tvOS
 ReportAProblemView.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 07.10.21
 */

import CoreImage.CIFilterBuiltins
import SwiftUI

class ReportAProblemViewDelegate: ViewDelegate {
    var qrCode: Image {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        let analyticId = session.app.analytics.id
        let message =
            "MATMSG:TO:\nfeedback@abjc.tech;\nSUB:\n[ISSUE] [\(analyticId)];\nBODY:\n[Insert feedback / comments here]\n\nThanks [Your Name];;"
        let data = Data(message.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return Image(uiImage: UIImage(cgImage: cgimg))
            }
        }

        return Image(systemName: "xmark.circle")
    }
}

struct ReportAProblemView: View {
    @Environment(\.presentationMode)
    var presentationMode

    @StateObject
    var store: ReportAProblemViewDelegate = .init()

    var body: some View {
        ZStack {
            Blur()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Report A Problem")
                    .font(.title)

                Spacer()
                store.qrCode
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400, alignment: .center)

                Spacer()
            }
        }.onLongPressGesture(minimumDuration: 0.01, perform: { presentationMode.wrappedValue.dismiss() })
    }
}

struct ReportAProblemView_Previews: PreviewProvider {
    static var previews: some View {
        ReportAProblemView()
    }
}
