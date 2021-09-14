//
//  MovieDetailView.swift
//  MovieDetailView
//
//  Created by Noah Kamara on 10.09.21.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject
    var store: DetailViewDelegate
    @Namespace
    var namespace

    var body: some View {
        ZStack {
            backdrop.edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: true) {
                headerView
                    .padding(80)
                    .frame(width: 1920, height: 1080 + 50)
                peopleView
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: store.onAppear)
    }

    var headerView: some View {
        ButtonArea(store.play) { _ in
            VStack(alignment: .leading) {
                // Poster Image
                poster
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(store.item.name ?? "No Name")
                            .bold()
                            .font(.title2)
                        HStack {
                            Text(store.item.productionYear != nil ? "\(String(store.item.productionYear!))" : "")
                            Text(store.item.type ?? "")
                        }.foregroundColor(.secondary)
                    }
                    Spacer()
//                    PlayButton(isContinue ? "buttons.play" : "buttons.continue", play)
                    Button(action: {}) {
                        Text("Playbutton")
                    }
                    .padding(.trailing)
                }

                if store.item.overview != nil {
                    Divider()
                    HStack {
                        Text(store.item.overview!)
                    }
                } else {
                    Text("IS NIL")
                }
            }
        }
        .prefersDefaultFocus(in: namespace)
        .padding(.horizontal, 80)
        .padding(.bottom, 80)
    }

    /// People (Actors, etc.)
    var peopleView: some View {
        Group {
            Divider().padding(.horizontal, 80)
            PeopleCardRow("Cast & Crew", store.item.people ?? [])
        }.edgesIgnoringSafeArea(.horizontal)
    }

    /// Recommended Items View
    var recommendedView: some View {
        Group {
            Divider().padding(.horizontal, 80)
            MediaCardRow(store: .init(), label: "Similar Items", items: store.itemSimilars)
        }
    }

    // Poster View
    var poster: some View {
        AsyncImg(url: store.imageUrl) { image in
            image
                .renderingMode(.original)
                .resizable()
        } placeholder: {
            Blur()
        }
        .aspectRatio(2 / 3, contentMode: .fill)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .frame(width: 400, height: 600)
        .shadow(radius: 5)
    }

    /// Backdrop
    var backdrop: some View {
        Blurhash(store.item.blurhash(for: .backdrop))
    }
}

// struct MovieDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieDetailView(store: .init(.preview))
//    }
// }
