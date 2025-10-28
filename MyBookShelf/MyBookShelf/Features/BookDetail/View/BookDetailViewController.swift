import UIKit
import SnapKit

class BookDetailViewController: UIViewController {

    var book: Book?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    private let priceLabel = UILabel()
    private let contentsLabel = UILabel()
    
    private let closeButton = UIButton(type: .system)
    private let addButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupUI()
        setupLayout()
        updateUI()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
    }
    private func setupUI() {

        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textColor = .gray
        authorLabel.textAlignment = .center

        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true

        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .center
        priceLabel.textColor = .label

        contentsLabel.font = .systemFont(ofSize: 15)
        contentsLabel.textColor = .label
        contentsLabel.numberOfLines = 0
        contentsLabel.textAlignment = .center

        closeButton.setTitle("X", for: .normal)
        closeButton.backgroundColor = .systemGray
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        closeButton.layer.cornerRadius = 12
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)

        addButton.setTitle("담기", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        addButton.layer.cornerRadius = 12

        [titleLabel, authorLabel, thumbnailImageView, priceLabel, contentsLabel].forEach {
            contentView.addSubview($0)
        }

        [closeButton, addButton].forEach {
            view.addSubview($0)
        }
    }

    private func setupLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
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
            $0.bottom.equalToSuperview().inset(30) // 스크롤뷰 끝
        }

        closeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.width.equalTo(70)
            $0.height.equalTo(55)
        }

        addButton.snp.makeConstraints {
            $0.leading.equalTo(closeButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(closeButton)
        }
    }



    private func updateUI() {
        guard let book = book else { return }

        titleLabel.text = book.title
        authorLabel.text = book.authors?.joined(separator: ", ")

        if let price = book.price {
            let formatted = NumberFormatter.localizedString(from: NSNumber(value: price), number: .decimal)
            priceLabel.text = "\(formatted)원"
        } else {
            priceLabel.text = "가격 정보 없음"
        }

        if let contents = book.contents {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 13
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

    // 모달 닫기 액션
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
}

