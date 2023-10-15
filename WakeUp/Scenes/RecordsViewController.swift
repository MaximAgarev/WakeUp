import UIKit

final class RecordsViewController: UIViewController {
    
    //MARK: - Private properties
    private let storage = RecordsStorage.shared
    
    private var dates: Set<String> = []
    
    //MARK: - Layout elements
    private lazy var closeButton: UIButton = {
        var filled = UIButton.Configuration.plain()
        filled.image = UIImage(systemName: "xmark.circle.fill")
        
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.tintColor = .blue
        closeButton.configuration = filled
        closeButton.addTarget(self, action: #selector(self.didTapCloseButton(sender:)), for: .touchUpInside)
        return closeButton
    }()
    
    private lazy var recordsTable: UITableView = {
        let recordsTable = UITableView()
        recordsTable.translatesAutoresizingMaskIntoConstraints = false
        recordsTable.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        recordsTable.register(UITableViewCell.self, forCellReuseIdentifier: "RecordCell")
        recordsTable.sectionHeaderHeight = 50
        recordsTable.allowsSelection = false
        recordsTable.dataSource = self
        recordsTable.delegate = self
        return recordsTable
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addCloseButton()
        addRecordsTable()
        
        storage.loadRecords().forEach { record in
            dates.insert(record.0)
        }
    }
    
    // MARK: - Private Methods
    @objc
    private func didTapCloseButton(sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Layout methods
    private func addCloseButton() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func addRecordsTable() {
        view.addSubview(recordsTable)
        NSLayoutConstraint.activate([
            recordsTable.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            recordsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            recordsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Extensions
extension RecordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath as IndexPath)
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = "Test"
        cell.textLabel?.highlightedTextColor = .white
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dates.count
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
//        headerView.backgroundColor = .red
//        
//        let label = UILabel()
//        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width, height: headerView.frame.height)
//        label.text = Array(dates.sorted {
//            DateFormatter().date(from: $0) ?? Date() > DateFormatter().date(from: $1) ?? Date()
//        })[section]
//        label.font = .boldSystemFont(ofSize: 32)
//        label.textColor = .black
//        
//        headerView.addSubview(label)
//        
//        return headerView
//    }
}

extension RecordsViewController: UITableViewDelegate {}
