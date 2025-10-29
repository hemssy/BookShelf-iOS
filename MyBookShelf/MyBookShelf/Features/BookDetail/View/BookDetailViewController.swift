import UIKit
import SnapKit
import CoreData

// BookDetailViewControllerDelegate 정의
protocol BookDetailViewControllerDelegate: AnyObject {
    func didAddBook(_ book: Book)
}

class BookDetailViewController: UIViewController {

    var book: Book?
    weak var delegate: BookDetailViewControllerDelegate?

    private var viewModel: BookDetailViewModel?
    
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
        setupViewModel()
        updateUI()
    }
    
    private func setupViewModel() {
        guard let book = book else { return }
        viewModel = BookDetailViewModel(book: book)
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
        
        // 담기 버튼 액션 연결
        addButton.addTarget(self, action: #selector(addBookTapped), for: .touchUpInside)


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



    func updateUI() {
        guard let vm = viewModel else { return }
        titleLabel.text = vm.title
        authorLabel.text = vm.author
        priceLabel.text = vm.priceText
        contentsLabel.attributedText = vm.contents
        
        if let url = vm.thumbnailURL {
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


    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addBookTapped() {
        guard let book = book else { return }

        // 코어데이터 저장
        let savedBooksViewModel = SavedBooksViewModel()
        savedBooksViewModel.addBook(
            title: book.title,
            author: book.authors?.first ?? "저자 미상",
            price: book.price.map { "\($0)" } ?? "-",
            thumbnailURL: book.thumbnail
        )

        // 알림 전송 (SavedBooksViewController 업데이트용으로)
        NotificationCenter.default.post(name: NSNotification.Name("BookAdded"), object: nil)

        // 책 담기 완료 알럿 표시
        let alert = UIAlertController(title: "책이 담겼습니다!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }




    
}

