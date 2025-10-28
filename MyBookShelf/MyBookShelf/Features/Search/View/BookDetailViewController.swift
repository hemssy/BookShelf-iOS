import UIKit
import SnapKit

class BookDetailViewController: UIViewController {

    var book: Book?

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    private let priceLabel = UILabel()
    private let contentsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupLayout()
        updateUI()
    }

    private func setupUI() {
        // 제목
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        // 저자
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textColor = .gray
        authorLabel.textAlignment = .center

        // 썸네일
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true

        // 가격
        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .center
        priceLabel.textColor = .label

        // 내용
        contentsLabel.font = .systemFont(ofSize: 15)
        contentsLabel.textColor = .label
        contentsLabel.numberOfLines = 0
        contentsLabel.textAlignment = .center

        [titleLabel, authorLabel, thumbnailImageView, priceLabel, contentsLabel].forEach {
            view.addSubview($0)
        }
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(220)
            $0.height.equalTo(320)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func updateUI() {
        guard let book = book else { return }

        titleLabel.text = book.title
        authorLabel.text = book.authors?.joined(separator: ", ")

        // 가격 표시 (Optional 풀기 + 천 단위 콤마 찍기)
        if let price = book.price {
            let formatted = NumberFormatter.localizedString(from: NSNumber(value: price), number: .decimal)
            priceLabel.text = "\(formatted)원"
        } else {
            priceLabel.text = "가격 정보 없음"
        }

        if let contents = book.contents {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10  // 줄간격
            paragraphStyle.alignment = .center

            let attributedText = NSAttributedString(
                string: contents,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 15),
                    .foregroundColor: UIColor.label,
                    .paragraphStyle: paragraphStyle
                ]
            )

            contentsLabel.attributedText = attributedText
        }

        if let urlStr = book.thumbnail, let url = URL(string: urlStr) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = image
                    }
                }
            }
        }
    }
}

