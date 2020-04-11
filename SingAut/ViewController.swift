//
//  ViewController.swift
//  SingAut
//
//  Created by Faizyy on 11/04/20.
//  Copyright © 2020 faiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    var loadingLabel = UILabel()
    let appdel = UIApplication.shared.delegate as! AppDelegate
    var selectedRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.largeTitleDisplayMode = .always

        NotificationCenter.default.addObserver(forName: Notification.Name("reload"), object: nil, queue: OperationQueue.main, using: didDownloadData(notif:))

        setupIndicatorandLabel()
        configureInitialScreen()
        
        tableView.rowHeight = 50
        
    }
    
    func setupIndicatorandLabel() {
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.view.addSubview(loadingLabel)
        loadingLabel.text = "Loading..."
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 25)
        loadingLabel.alpha = 0.5
        loadingLabel.layer.borderColor = UIColor.gray.cgColor
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
    }
    
    func configureInitialScreen() {
        // If data is not downloaded, show activity indicator with loading...
        if appdel.listOfRooms.count == 0 {
            self.tableView.isHidden = true
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.startAnimating()
        }
        else {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.loadingLabel.isHidden = true
        }
    }

    @objc func didDownloadData(notif: Notification) {
        if (notif.userInfo!["hasData"] as! Bool) == false {
            let alert = UIAlertController(title: "No Internet", message: "Try after switching the data ON.", preferredStyle: .alert)
            let button = UIAlertAction(title: "Retry", style: .default, handler: { (_) in
                self.appdel.downloadInitialData()
            })
            alert.addAction(button)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            self.activityIndicator.removeFromSuperview()
            self.loadingLabel.isHidden = true
            self.tableView.isHidden = false
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Removing observer.")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "reload"), object: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appdel.listOfRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let roomData = appdel.listOfRooms[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = .clear
        cell.textLabel?.text = "\(roomData.org.name) - \(roomData.property.name) - \(roomData.room.name)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailsVC") as? DetailsViewController else {
            print("Cannot get details VC from storyboard!!")
            return
        }
        let roomDetails = appdel.listOfRooms[indexPath.row]
        let service = Services()
        service.downloadData(forType: .lockDetails, withRoom: roomDetails.room.id) { (details) in
            detailsController.lockDetails = details as? LockDetails
            NotificationCenter.default.post(name: Notification.Name("reloadDetails"), object: nil, userInfo: nil)
        }
        navigationController?.pushViewController(detailsController, animated: true)
        
    }
}
