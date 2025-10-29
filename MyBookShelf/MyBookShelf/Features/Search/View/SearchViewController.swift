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
        // 최근 본 책 셀 등록 추가
        tableView.register(RecentlyViewedBooksCell.self, forCellReuseIdentifier: RecentlyViewedBooksCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 섹션 0: 최근 본 책, 섹션 1: 검색 결과
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // 최근 본 책 섹션 (지금은 임시 UI만 있음)
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentlyViewedBooksCell.identifier, for: indexPath) as! RecentlyViewedBooksCell
            cell.configurePlaceholder()
            return cell
        } else {
            // 기존 검색 결과 섹션
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookTableViewCell else {
                return UITableViewCell()
            }
            let book = viewModel.books[indexPath.row]
            cell.configure(with: book)
            return cell
        }
    }
    
    // 섹션 헤더 타이틀
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "최근 본 책" : "검색 결과"
    }
}

// UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground // 배경 통일!!
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemGray
        label.text = section == 0 ? "최근 본 책 " : "검색 결과 🔍"
        
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(5)
        }
        
        // 아래 구분선 추가
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        headerView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let selectedBook = viewModel.books[indexPath.row]
        let detailVC = BookDetailViewController()
        detailVC.book = selectedBook
        detailVC.delegate = self
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

// BookDetailViewControllerDelegate
extension SearchViewController: BookDetailViewControllerDelegate {
    func didAddBook(_ book: Book) {
    }
}

