import UIKit
import SnapKit

class RecentlyViewedBooksCell: UITableViewCell {
    static let identifier = "RecentlyViewedBooksCell"
    
    private var recentBooks: [[String: String]] = []

    func configure(with books: [[String: String]]) {
        self.recentBooks = books
        collectionView.reloadData()
    }

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 91, height: 130)
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private var placeholderCount = 5
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10)
            $0.height.equalTo(150)
        }
        
        collectionView.dataSource = self
        collectionView.register(RecentBookItemCell.self, forCellWithReuseIdentifier: "RecentBookItemCell")
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configurePlaceholder() {
        placeholderCount = 5
        collectionView.reloadData()
    }
}

extension RecentlyViewedBooksCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentBooks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentBookItemCell", for: indexPath) as! RecentBookItemCell
        let book = recentBooks[indexPath.item]
        cell.configure(with: book["thumbnailURL"] ?? "")
        return cell
    }

}

