import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    
    // 검색 결과를 Book 배열로 받음
    private var searchResults: [Book] = [] {
        didSet {
            tableView.reloadData()
            updateUIState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        updateUIState()
        tableView.delegate = self

    }
}

// UI 셋업
extension SearchViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "책 검색"
        
        // 검색바
        searchBar.placeholder = "책 제목을 입력하세요"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        // 테이블뷰
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.rowHeight = 70
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // 결과 없음 라벨
        emptyLabel.text = "검색 결과가 없습니다."
        emptyLabel.textColor = .gray
        emptyLabel.textAlignment = .center
        view.addSubview(emptyLabel)
    }
    
    private func setupLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func updateUIState() {
        if searchResults.isEmpty {
            if searchBar.text?.isEmpty == true {
                tableView.isHidden = true
                emptyLabel.isHidden = true
            } else {
                tableView.isHidden = true
                emptyLabel.isHidden = false
            }
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
}

// 테이블뷰
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        let book = searchResults[indexPath.row]
        cell.configure(with: book)
        return cell
    }
}

// 서치바
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        
        BookService.shared.searchBooks(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self?.searchResults = books
                case .failure(let error):
                    print("검색 실패:", error.localizedDescription)
                    self?.searchResults = []
                }
            }
        }
    }
}

// 책 상세화면 모달
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = BookDetailViewController()
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }
}

