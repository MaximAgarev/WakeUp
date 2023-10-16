import UIKit
import AudioToolbox

final class WakeUpViewController: UIViewController {
    
    //MARK: - Private properties
    private let storage = RecordsStorage.shared
        
    //MARK: - Layout elements
    private lazy var recordsButton: UIButton = {
        let recordsButton = UIButton()
        recordsButton.translatesAutoresizingMaskIntoConstraints = false
        recordsButton.backgroundColor = .white
        recordsButton.tintColor = .white
        recordsButton.layer.cornerRadius = 16
        recordsButton.layer.borderWidth = 1
        recordsButton.layer.borderColor = UIColor.blue.cgColor
        recordsButton.setTitle(" Wakeups", for: .normal)
        recordsButton.setTitleColor(.blue, for: .normal)
        recordsButton.titleLabel?.font = .systemFont(ofSize: 16)
        recordsButton.setImage(UIImage(systemName: "list.bullet.rectangle"), for: .normal)
        recordsButton.tintColor = .blue
        recordsButton.addTarget(self, action: #selector(self.didTapRecordButton(sender:)), for: .touchUpInside)
        return recordsButton
    }()
    
    private lazy var wakeUpButton: UIButton = {
        let wakeUpButton = UIButton()
        wakeUpButton.translatesAutoresizingMaskIntoConstraints = false
        wakeUpButton.backgroundColor = .blue.withAlphaComponent(0.3)
        wakeUpButton.tintColor = .white
        wakeUpButton.layer.cornerRadius = 16
        wakeUpButton.layer.borderWidth = 1
        wakeUpButton.layer.borderColor = UIColor.blue.cgColor
        wakeUpButton.titleLabel?.font = .boldSystemFont(ofSize: 96)
        wakeUpButton.setTitle("😴", for: .normal)
        wakeUpButton.addTarget(self, action: #selector(self.didTapWakeUpButton(sender:)), for: .touchDown)
        return wakeUpButton
    }()
    
    private lazy var wakeUpTimeLabel: UILabel = {
        let wakeUpTimeLabel = UILabel()
        wakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeLabel.backgroundColor = .clear
        wakeUpTimeLabel.textColor = .white
        wakeUpTimeLabel.font = .boldSystemFont(ofSize: 64)
        wakeUpTimeLabel.textColor = .blue
        return wakeUpTimeLabel
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addRecordButton()
        addWakeUpButton()
        
        storage.loadRecords()
    }
    
    // MARK: - Private Methods
    @objc
    private func didTapRecordButton(sender: Any) {
        self.present(RecordsViewController(), animated: true)
    }
    
    @objc
    private func didTapWakeUpButton(sender: Any) {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        let date = Date().withoutSeconds()
        let time = df.string(from: date)
        
        storage.saveRecord(date: date)

        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        wakeUpTimeLabel.text = time
        wakeUpButton.setTitle("😳", for: .normal)
        wakeUpButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.wakeUpTimeLabel.text = ""
            self.wakeUpButton.setTitle("😴", for: .normal)
            self.wakeUpButton.isEnabled = true
        })
        
    }
    
    // MARK: - Layout methods
    private func addRecordButton() {
        view.addSubview(recordsButton)
        NSLayoutConstraint.activate([
            recordsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            recordsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            recordsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            recordsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addWakeUpButton() {
        view.addSubview(wakeUpButton)
        wakeUpButton.addSubview(wakeUpTimeLabel)
        NSLayoutConstraint.activate([
            wakeUpButton.topAnchor.constraint(equalTo: recordsButton.bottomAnchor, constant: 16),
            wakeUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            wakeUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            wakeUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            wakeUpTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wakeUpTimeLabel.centerYAnchor.constraint(equalTo: wakeUpButton.topAnchor, constant: 175)
        ])
    }
}

