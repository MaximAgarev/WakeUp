import UIKit

final class RecordsViewController: UIViewController {
    
    //MARK: - Private properties
    private let storage = RecordsStorage.shared
    
//    private var dates: Set<String> = []
    
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
        recordsTable.sectionHeaderTopPadding = 0
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
        if storage.getDates().isEmpty { return 0 }
        let dateInSection = storage.getDates()[section]
        return storage.getTimes(for: dateInSection).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath as IndexPath)
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        
        let date = storage.getDates()[indexPath.section]
        let time = storage.getTimeStrings(for: date)[indexPath.row]
        cell.textLabel?.text = time
        cell.textLabel?.highlightedTextColor = .white
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if storage.getDates().isEmpty {
            return 1
        } else {
            return storage.getDates().count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .blue
        
        if storage.getDateString().isEmpty {
            label.text = "No records yet"
        } else {
            label.text = String(storage.getDateString()[section])
        }
        
        headerView.addSubview(label)
        
        return headerView
    }
}

extension RecordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let date = self.storage.getDates()[indexPath.section]
            let time = self.storage.getTimes(for: date)[indexPath.row]
            self.storage.deleteRecord(time: time)
            self.recordsTable.reloadData()
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
    
}
