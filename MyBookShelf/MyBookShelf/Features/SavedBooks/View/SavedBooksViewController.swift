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
        
        // 전체삭제 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "전체삭제",
            style: .plain,
            target: self,
            action: #selector(deleteAllBooks)
        )
        
        setupUI()
        setupLayout()
        bindViewModel()
        viewModel.fetchBooks()
        
        tableView.delegate = self

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshBooks),
            name: NSNotification.Name("BookAdded"),
            object: nil
        )
        
    }
    
    private func setupUI() {
        tableView.register(SavedBookCell.self, forCellReuseIdentifier: "SavedBookCell")
        tableView.dataSource = self
        tableView.rowHeight = 90
        view.addSubview(tableView)
        
        emptyLabel.text = "아직 담은 책이 없습니다."
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
    
    @objc private func refreshBooks() {
        viewModel.fetchBooks()
    }
    
    @objc private func deleteAllBooks() {
        let alert = UIAlertController(
            title: "전체 삭제",
            message: "담은 책을 모두 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteAllBooks()
        }))
        present(alert, animated: true)
    }


}

// UITableViewDataSource
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

// UITableViewDelegate
extension SavedBooksViewController: UITableViewDelegate {
    // 스와이프 삭제 액션 추가
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
            guard let self = self else { return }

            let bookToDelete = self.viewModel.savedBooks[indexPath.row]
            self.viewModel.deleteBook(bookToDelete)   
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


