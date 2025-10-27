import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    // UI 컴포넌트들
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    
    // 프로퍼티들
    private var searchResults: [String] = [] {
        didSet { updateUIState() }
    }
    
    // 라이프싸이클
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        updateUIState()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 90
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
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
    
    // UI 상태 업데이트
    private func updateUIState() {
        if searchResults.isEmpty {
            // 검색 전 또는 결과 없음
            if searchBar.text?.isEmpty == true {
                // 검색 전
                tableView.isHidden = true
                emptyLabel.isHidden = true
            } else {
                // 검색 결과 없음
                tableView.isHidden = true
                emptyLabel.isHidden = false
            }
        } else {
            // 검색 결과 있음
            tableView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
}

// UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
}

// UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        
        // 네트워크 호출
        BookService.shared.searchBooks(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    // 검색 결과를 문자열로 변환 (임시)
                    self?.searchResults = books.map { $0.title }
                case .failure(let error):
                    print("검색 실패:", error.localizedDescription)
                    self?.searchResults = []
                }
            }
        }
    }
}


