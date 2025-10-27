import UIKit
import SnapKit

class BookTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatalError 메시지")
    }
    
    private func setupUI() {
        // 제목
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        
        // 저자
        authorLabel.font = .systemFont(ofSize: 16)
        authorLabel.textColor = .label
        
        // 가격
        priceLabel.font = .systemFont(ofSize: 15)
        priceLabel.textColor = .label
        priceLabel.textAlignment = .right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceLabel)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-8)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.bottom.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.authors?.first ?? "저자 미상"

        
        if let price = book.price {
            priceLabel.text = "\(price)원"
        } else {
            priceLabel.text = "-"
        }
    }
}

