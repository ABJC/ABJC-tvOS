//
//  Shelf.swift
//  Shelf
//
//  Created by Noah Kamara on 09.09.21.
//

import SwiftUI
import JellyfinAPI
import SwiftUICollection

extension Hashable {
    func combineHash<T: Hashable>(with hashableOther: T) -> Int {
        let ownHash = self.hashValue
        let otherHash = hashableOther.hashValue
        return (ownHash << 5) &+ ownHash &+ otherHash
    }
}

struct CollectionCell<Content: Hashable>: Hashable {
    var id: UUID
    var content: Content
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(content.combineHash(with: id))
    }
    
    init (_ content: Content) {
        self.id = UUID()
        self.content = content
    }
}

struct Shelf: View {
    @ObservedObject var store: MediaViewDelegate = .init()

    typealias Row = CollectionRow<String, CollectionCell<BaseItemDto>>
    
    
    @State var rows: [Row]

    // , _ grouping: Grouping
    init(_ items: [BaseItemDto], grouped grouping: CollectionGrouping) {
        func filterItem(_ grouping: CollectionGrouping, _ category: String, _ item: BaseItemDto) -> Bool {
            switch grouping {
                case .title: return category == String((item.name?.first ?? "#").isNumber ? "#" : String(item.name?.first ?? "#"))
                case .genre: return item.genreItems?.map(\.name).contains(category) ?? false
                case .releaseYear: return category == (item.productionYear != nil ? "\(item.productionYear ?? 0)" : "#")
                case .releaseDecade: return category == (item.productionYear != nil ? "\((item.productionYear ?? 0) / 10)0s" : "#")
            }
        }

        var categories = Set<String>()

        switch grouping {
            case .title:
                categories = items.reduce(into: categories) { set, item in
                    set.insert(String((item.name?.first ?? "#").isNumber ? "#" : String(item.name?.first ?? "#")))
                }
            case .genre:
                categories = items.reduce(into: categories) { set, item in
                    set.formUnion(item.genreItems?.compactMap(\.name) ?? [])
                }
            case .releaseYear:
                categories = items.reduce(into: categories) { set, item in
                    _ = set.insert((item.productionYear != nil ? "\(item.productionYear!)" : "#"))
                }
            case .releaseDecade:
                categories = items.reduce(into: categories) { set, item in
                    _ = set.insert((item.productionYear != nil ? "\(item.productionYear! / 10)0s" : "#"))
                }
        }

        self.rows = categories
            .sorted(by: { $0 < $1 })
            .map({ category in
                Row(section: category,
                    items: items.compactMap({ item in
                    if filterItem(grouping, category, item) {
                        return CollectionCell(item)
                    }
                    return nil
                }))
            })
    }

    var body: some View {
        CollectionView(rows: rows) { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(store.cardSize.width),
                                                   heightDimension: .absolute(store.rowHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])

            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )

            let section = NSCollectionLayoutSection(group: group)

            section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 80, trailing: 80)
            section.interGroupSpacing = 48
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = [header]
            return section
        } cell: { indexPath, cell in
            GeometryReader { geometry in
                NavigationLink(destination: DetailView(item: cell.content)) {
                    MediaCard(store: store, item: cell.content)
                }
                .buttonStyle(PlainButtonStyle())
            }
        } supplementaryView: { kind, indexPath in
            HStack {
                Text(rows[indexPath.section].section)
                    .font(.title3)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .id(store.preferences.collectionGrouping.rawValue+store.preferences.posterType.rawValue+store.preferences.showsTitles.description)
    }
        
}

struct Shelf_Previews: PreviewProvider {
    static var previews: some View {
        Shelf([], grouped: .title)
    }
}
