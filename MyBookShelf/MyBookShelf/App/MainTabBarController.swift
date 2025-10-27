import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        // 첫 번째 탭 - 검색 탭
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )

        // 두 번째 탭 - 내 책장 탭
        let savedVC = UINavigationController(rootViewController: SavedBooksViewController())
        savedVC.tabBarItem = UITabBarItem(
            title: "내 책장",
            image: UIImage(systemName: "books.vertical"),
            selectedImage: UIImage(systemName: "books.vertical.fill")
        )

        // 탭 순서 지정
        viewControllers = [searchVC, savedVC]
    }

    private func setupAppearance() {
        tabBar.tintColor = .systemBlue     // 선택된 탭 색상
        tabBar.unselectedItemTintColor = .gray // 선택안 된 탭 색상
        tabBar.backgroundColor = .systemBackground
    }
}

