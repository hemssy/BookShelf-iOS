import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    // UI 컴포넌트
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
}

// Setup UI
extension SearchViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "책 검색"
        
        // 검색바 설정
        searchBar.placeholder = "책 제목을 입력하세요"
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
        
        // 테이블뷰 설정
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 90
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        // 검색 결과 없을 때 라벨
        emptyLabel.text = "검색 결과가 없습니다."
        emptyLabel.textColor = .gray
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
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
}

