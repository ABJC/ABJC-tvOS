//
//  ShelfView.swift
//  ABJC
//
//  Created by Noah Kamara on 12.07.21.
//

import SwiftUI
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
    typealias Row = CollectionRow<String, CollectionCell<APIModels.MediaItem>>
    
    @State var rows: [Row]
    
    /// SessionStore EnvironmentObject
    @EnvironmentObject var session: SessionStore
        
    // , _ grouping: Grouping
    init(_ items: [APIModels.MediaItem], grouped grouping: Grouping) {
        func filterItem(_ grouping: Grouping, _ category: String, _ item: APIModels.MediaItem) -> Bool {
            switch grouping {
                case .title: return category == "\(item.name.first ?? "#")"
                case .genre: return item.genres.map({ $0.name }).contains(category)
                case .releaseYear: return category == (item.year != nil ? "\(item.year!)" : "#")
                case .releaseDecade: return category == (item.year != nil ? "\(item.year! / 10)0s" : "#")
            }
        }
        
        var categories = Set<String>()
        
        switch grouping {
            case .title:
                categories = items.reduce(into: categories) { set, item in
                    set.insert(String(item.name.first ?? "#"))
                }
            case .genre:
                categories = items.reduce(into: categories) { set, item in
                    set.formUnion(item.genres.map(\.name))
                }
            case .releaseYear:
                categories = items.reduce(into: categories) { set, item in
                    _ = set.insert((item.year != nil ? "\(item.year!)" : "#"))
                }
            case .releaseDecade:
                categories = items.reduce(into: categories) { set, item in
                    _ = set.insert((item.year != nil ? "\(item.year! / 10)0s" : "#"))
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
    
    
    private var cardSize: CGSize {
        return session.preferences.posterType == .poster
            ? CGSize(width: 225, height: 337.5)
            : CGSize(width: 548, height: 308.25)
    }

    
    private var groupHeight: CGFloat {
        var _height = session.preferences.posterType == .poster ? 340 : 300
        
        if session.preferences.showsTitles
        {
            _height += 100
        }
        return CGFloat(_height)
    }
    
    var body: some View {
        CollectionView(rows: rows) { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
                        
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(cardSize.width),
                                                   heightDimension: .absolute(groupHeight))
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
                Button(action: {
                    session.setFocus(cell.content)
                }) {
                    LibraryView.MediaCardView(cell.content)
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
        .id(session.preferences.posterType.rawValue)
    }
}

struct Shelf_Previews: PreviewProvider {
    static var previews: some View {
        Shelf([], grouped: .title)
    }
}
