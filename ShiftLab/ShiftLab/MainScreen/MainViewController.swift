import UIKit

final class MainViewController: UIViewController {
    private var products: [Product] = []
    private lazy var greetingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Приветствие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(greetingButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
        table.dataSource = self
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchProducts()
    }
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(greetingButton)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            greetingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            greetingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            greetingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            greetingButton.heightAnchor.constraint(equalToConstant: 50),
            tableView.topAnchor.constraint(equalTo: greetingButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    @objc private func greetingButtonTapped() {
        let name = UserDefaults.standard.string(forKey: "savedUserName") ?? "Незнакомец"
        let alert = UIAlertController(
            title: "Привет!",
            message: "Рады видеть тебя, \(name)!",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Спасибо", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    private func fetchProducts() {
        NetworkService.shared.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ProductCell")
        let product = products[indexPath.row]
        cell.textLabel?.text = product.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "Цена: $\(product.price)"
        cell.detailTextLabel?.textColor = .systemGreen
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return cell
    }
}
