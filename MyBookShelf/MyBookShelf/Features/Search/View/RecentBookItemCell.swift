import UIKit
import SnapKit

class RecentBookItemCell: UICollectionViewCell {
    private let thumbnailView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(thumbnailView)
        thumbnailView.snp.makeConstraints { $0.edges.equalToSuperview() }
        thumbnailView.backgroundColor = .systemGray5
        thumbnailView.layer.cornerRadius = 8
        thumbnailView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configurePlaceholder() {
        // 나중에 이미지뷰로 바꿀 예정
    }
}

