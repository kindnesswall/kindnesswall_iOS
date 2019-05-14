//
//  GiftsToDonateViewController.swift
//  app
//
//  Created by Amir Hossein on 5/11/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class GiftsToDonateViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel:GiftsToDonateViewModel?
    var toUserId:Int?
    
    var donateGiftHandler:((Gift)->Void)?
    
    var initialLoadingIndicator:LoadingIndicator?
    var lazyLoadingIndicator:LoadingIndicator?
    var tableViewCellHeight:CGFloat=122
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalizationSystem.getStr(forKey: LanguageKeys.DonateGift)
        
        if let toUserId = toUserId {
            self.viewModel = GiftsToDonateViewModel(toUserId: toUserId)
            self.viewModel?.delegate = self
        }
        tableView.register(type: GiftTableViewCell.self)
        tableView.dataSource = self.viewModel
        
        self.initialLoadingIndicator=LoadingIndicator(view: self.view)
        self.lazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.view, cellHeight: tableViewCellHeight/2)
        tableView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight/2, right: 0)
        
        self.viewModel?.getGifts(beforeId: nil)
        
        

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setDefaultStyle()
    }
    
    func donateGift(gift:Gift){
        guard let giftId = gift.id
        ,let toUserId = self.toUserId
            else { return }
        
        let input = Donate(giftId: giftId, donatedToUserId: toUserId)
        APICall.request(url: URIs().donate, httpMethod: .POST, input: input) { [weak self] (data, response, error) in
            guard let _ = APICall.readJsonData(data: data, outputType: Gift.self) else {
                return
            }
            
            self?.donateGiftHandler?(gift)
            self?.navigationController?.popViewController(animated: true)
        }
        
    }

}

extension GiftsToDonateViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let gift = self.viewModel?.gifts[indexPath.row]
            else { return }
        
        PopUpMessage.showPopUp(nibClass: PromptUser.self, data: LocalizationSystem.getStr(forKey: LanguageKeys.giftDonationPrompt),animation:.none,declineHandler: nil) { [weak self] (ـ) in
            self?.donateGift(gift: gift)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewCellHeight
    }
}

extension GiftsToDonateViewController : GiftViewModelDelegate {
    func pageLoadingAnimation(viewModel: GiftViewModel, isLoading: Bool) {
        if isLoading {
            self.initialLoadingIndicator?.startLoading()
        } else {
            self.initialLoadingIndicator?.stopLoading()
        }
    }
    
    func lazyLoadingAnimation(viewModel: GiftViewModel, isLoading: Bool) {
        if isLoading {
            self.lazyLoadingIndicator?.startLoading()
        } else {
            self.lazyLoadingIndicator?.stopLoading()
        }
    }
    
    func refreshControlAnimation(viewModel: GiftViewModel, isLoading: Bool) {
    }
    
    func showTableView(viewModel: GiftViewModel, show: Bool) {
        if show {
            self.tableView.show()
        } else {
            self.tableView.hide()
        }
    }
    
    func reloadTableView(viewModel: GiftViewModel) {
        self.tableView.reloadData()
    }
    
    func insertNewItemsToTableView(viewModel: GiftViewModel, insertedIndexes: [IndexPath]) {
        UIView.performWithoutAnimation {
            self.tableView.insertRows(at: insertedIndexes, with: .bottom)
        }
    }
    
    func presentfailedAlert(viewModel: GiftViewModel, alert: UIAlertController) {
    }
    
    
}
