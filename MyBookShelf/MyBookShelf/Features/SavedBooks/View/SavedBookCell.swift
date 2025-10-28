import UIKit
import SnapKit

class SavedBookCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        selectionStyle = .none
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textColor = .secondaryLabel
        
        priceLabel.font = .systemFont(ofSize: 15)
        priceLabel.textColor = .label
        priceLabel.textAlignment = .right
        
        [titleLabel, authorLabel, priceLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-8)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.bottom.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with book: SavedBookEntity) {
        titleLabel.text = book.title ?? "제목 없음"
        authorLabel.text = book.author ?? "저자 미상"
        priceLabel.text = (book.price ?? "-").appending("원")
    }
}

