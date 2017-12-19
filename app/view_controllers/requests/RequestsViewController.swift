//
//  RequestsViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController {

    let userDefault = UserDefaults.standard
    var gifts:[Gift] = []
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var requestView: UIView!
    @IBOutlet var loginView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        // Do any additional setup after loading the view.
        let bundle = Bundle(for: GiftTableViewCell.self)
        let nib = UINib(nibName: "RequestsTableViewCell", bundle: bundle)
        self.tableview.register(nib, forCellReuseIdentifier: "RequestsTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let _ = UserDefaults.standard.string(forKey: AppConstants.Authorization) else{
            loginView.isHidden = false
            requestView.isHidden = true
            return
        }

        ApiMethods.getRequestsMyGifts(startIndex: 0) { (data, response, error) in
            
            APIRequest.logReply(data: data)
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 && response.statusCode >= 300 {
                    return
                }
            }
            guard error == nil else {
                print("Get error register")
                return
            }
            
            if let reply=APIRequest.readJsonData(data: data, outpuType: [Gift].self) {
                
                self.gifts.append(contentsOf: reply)
                self.tableview.reloadData()
                
                print("count:")
                print(reply.count)
                
            }
            
        }
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        let controller=ActivationEnterPhoneViewController(nibName: "ActivationEnterPhoneViewController", bundle: Bundle(for: ActivationEnterPhoneViewController.self))
        //            controller.backgroundImage = image
        
        controller.setCloseComplition {
            
        }
        controller.setSubmitComplition { (str) in
            self.loginView.isHidden = true
            self.requestView.isHidden = false
        }
        
        let nc = UINavigationController.init(rootViewController: controller)
        self.tabBarController?.present(nc, animated: true, completion: nil)
        
    }
    
    
}

extension RequestsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "RequestsTableViewCell") as! RequestsTableViewCell
        
        //        let gift:Gift = Gift()
        //        gift.title = "هدیه"
        //        gift.createDateTime = "تاریخ"
        //        gift.description = "توضیحات بسیار کامل و جامع"
        //        gift.giftImages = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Meso2mil-English.JPG/220px-Meso2mil-English.JPG"]
        //
        
        cell.fillUI(gift: gifts[indexPath.row])
        
        return cell
    }
}

extension RequestsViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = RequestToAGiftViewController(nibName: "RequestToAGiftViewController", bundle: Bundle(for: RequestToAGiftViewController.self))
        
        controller.giftId = gifts[indexPath.row].id!
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(122)
    }
    
}

