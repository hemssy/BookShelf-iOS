import UIKit
import SnapKit

class SavedBooksViewController: UIViewController {
    
    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    private let viewModel = SavedBooksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "내 책장"
        
        setupUI()
        setupLayout()
        bindViewModel()
        viewModel.fetchBooks()
    }
    
    private func setupUI() {
        tableView.register(SavedBookCell.self, forCellReuseIdentifier: "SavedBookCell")
        tableView.dataSource = self
        tableView.rowHeight = 90
        view.addSubview(tableView)
        
        emptyLabel.text = "아직 담은 책이 없습니다 📚"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        view.addSubview(emptyLabel)
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.updateEmptyState()
        }
    }
    
    private func updateEmptyState() {
        let hasBooks = !viewModel.savedBooks.isEmpty
        tableView.isHidden = !hasBooks
        emptyLabel.isHidden = hasBooks
    }
}

// MARK: - UITableViewDataSource
extension SavedBooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.savedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedBookCell", for: indexPath) as? SavedBookCell else {
            return UITableViewCell()
        }
        let book = viewModel.savedBooks[indexPath.row]
        cell.configure(with: book)
        return cell
    }
}

