import UIKit
import SnapKit

class BookTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("에러메세지") }
    
    private func setupUI() {
           selectionStyle = .none
           backgroundColor = .clear
           
           contentView.addSubview(containerView)
           containerView.backgroundColor = .systemBackground
           containerView.layer.cornerRadius = 10
           containerView.layer.borderWidth = 0.6
           containerView.layer.borderColor = UIColor.systemGray4.cgColor
           
           containerView.layer.shadowColor = UIColor.black.cgColor
           containerView.layer.shadowOpacity = 0.08
           containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
           containerView.layer.shadowRadius = 4
           containerView.layer.masksToBounds = false
           
           titleLabel.font = .boldSystemFont(ofSize: 16)
           titleLabel.textColor = .label
           titleLabel.numberOfLines = 2
           
           authorLabel.font = .systemFont(ofSize: 14)
           authorLabel.textColor = .secondaryLabel
           
           priceLabel.font = .systemFont(ofSize: 15)
           priceLabel.textColor = .label
           priceLabel.textAlignment = .right
           
           [titleLabel, authorLabel, priceLabel].forEach { containerView.addSubview($0) }
       }
       
    
    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }
        
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
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.authors?.first ?? "저자 미상"
        priceLabel.text = book.price.map { "\($0)원" } ?? "-"
    }
}

