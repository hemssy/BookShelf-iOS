import UIKit
import SnapKit

final class BookDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        // 임시 내용.. 라벨 하나 넣어봄
        let label = UILabel()
        label.text = "책 상세정보가 여기 표시될 예정입니다."
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 18, weight: .medium)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

