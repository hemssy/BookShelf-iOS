import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    // UI 컴포넌트들
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    
    // 뷰모델
    private let viewModel = SearchViewModel()
    
    // 라이프싸이클
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        updateUIState()
        tableView.delegate = self
        
        bindViewModel()
    }
    
    // 뷰모델 바인딩
    private func bindViewModel() {
        viewModel.whenUpdated = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.updateUIState()
        }
        
        viewModel.whenError = { errorMessage in
            print("검색 실패:", errorMessage)
        }
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
        if viewModel.books.isEmpty {
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

// UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        let book = viewModel.books[indexPath.row]
        cell.configure(with: book)
        return cell
    }
}

// UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = viewModel.books[indexPath.row]
        let detailVC = BookDetailViewController()
        detailVC.book = selectedBook
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }

}

// UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        viewModel.searchBooks(query: query)
    }
}

