import UIKit
import SnapKit

class RecentBookItemCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with urlString: String) {
        if let url = URL(string: urlString),
           let data = try? Data(contentsOf: url) {
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = UIImage(systemName: "book")
            imageView.tintColor = .systemGray3
        }
    }
}


