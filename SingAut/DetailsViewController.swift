//
//  DetailsViewController.swift
//  SingAut
//
//  Created by Faizyy on 11/04/20.
//  Copyright © 2020 faiz. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var lockName: UILabel!
    @IBOutlet weak var lockMac: UILabel!
    @IBOutlet weak var fetchingLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    var lockDetails: LockDetails?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingIndicator.startAnimating()
        self.loadingIndicator.hidesWhenStopped = true
        
        self.lockName.isHidden = true
        self.lockMac.isHidden = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: Notification.Name("reloadDetails"), object: nil, queue: OperationQueue.main, using: refreshView(notif:))

    }
    
    @objc func refreshView(notif: Notification) {
        
        self.fetchingLabel.isHidden = true
        self.loadingIndicator.stopAnimating()
        
        self.lockName.isHidden = false
        self.lockMac.isHidden = false
        self.lockName.text = lockDetails?.name
        self.lockMac.text = lockDetails?.MAC
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
