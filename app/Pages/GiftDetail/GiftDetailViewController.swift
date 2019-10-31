//
//  GiftDetailViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/1/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import ImageSlideshow
import KeychainSwift
import Kingfisher
//import ImageSlideshow;/Kingfisher

class GiftDetailViewController: UIViewController {

    var gift:Gift?
//    var sdWebImageSource:[SDWebImageSource] = []
    var profileImages:[String] = []
//    var loadingIndicator:LoadingIndicator?
    var editBtn:UIBarButtonItem?
    
    var editHandler:(()->Void)?
    
    var vm = GiftDetailVM()
    
    @IBOutlet weak var oldOrNewLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var giftNamelbl: UILabel!
    
    @IBOutlet var giftDatelbl: UILabel!
    
    @IBOutlet var giftCategory: UILabel!
    
    @IBOutlet var giftAddress: UILabel!
    
    @IBOutlet var oldOrNew: UILabel!
    
    @IBOutlet var giftDescription: UILabel!
    
    @IBOutlet var requestBtn: UIButton!
    @IBOutlet weak var requestBtnActivity: UIActivityIndicatorView!
    @IBOutlet weak var requestBtnPlaceholder: UIView!
    var requestBtnState: RequestBtnState = .isNotRequested
    
    enum RequestBtnState {
        case hide
        case loading
        case isRequested(chat: Chat)
        case isNotRequested
    }
    
    func setRequestBtnState(state: RequestBtnState) {
        
        self.requestBtnState = state
        
        switch state {
        case .loading, .hide:
            self.requestBtn.setTitle("", for: .normal)
        case .isNotRequested:
            self.requestBtn.setTitle(LanguageKeys.request.localizedString,for: .normal)
        case .isRequested(_):
            self.requestBtn.setTitle(LanguageKeys.sendMessage.localizedString,for: .normal)
        }
        
        switch state {
        case .loading:
            self.requestBtn.isEnabled = false
            self.requestBtnActivity.startAnimating()
        default:
            self.requestBtn.isEnabled = true
            self.requestBtnActivity.stopAnimating()
        }
        
        switch state {
        case .hide:
            self.requestBtnPlaceholder.hide()
        default:
            self.requestBtnPlaceholder.show()
        }
    }
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    deinit {
        print("GiftDetailViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSlideShow()
        fillUIWithGift()
                
        if let myIdString=KeychainSwift().get(AppConst.KeyChain.USER_ID), let myId=Int(myIdString), let userId=gift?.userId, myId==userId {
            self.addEditBtn()
            self.setRequestBtnState(state: .hide)
            self.removeBtn.show()
        } else {
            self.checkRequestStatus()
            self.removeBtn.hide()
        }
    }
    
    func checkRequestStatus(){
        guard AppDelegate.me().appCoordinator.checkForLogin()
        ,let giftId = gift?.id else {
            self.setRequestBtnState(state: .isNotRequested)
            return
        }
        
        self.setRequestBtnState(state: .loading)
        
        vm.checkRequestStatus(id: giftId, completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.handleCheckRequestStatus(result: result)
            }
        })
        
    }
    
    func handleCheckRequestStatus(result: Result<GiftRequestStatus>) {
        switch result {
        case .failure(_):
            self.setRequestBtnState(state: .isNotRequested)
        case .success(let status):
            if status.isRequested, let chat = status.chat {
                self.setRequestBtnState(state: .isRequested(chat: chat))
            } else {
                self.setRequestBtnState(state: .isNotRequested)
            }
        }
    }
    
    func fillUIWithGift(){
        
        giftNamelbl.text = gift?.title
        giftDatelbl.text = AppLanguage.getNumberString(number: gift?.createdAt?.convertToDate()?.getPersianDate() ?? "")
        
        giftCategory.text = gift?.categoryTitle
        giftAddress.text = gift?.address
        if let isNew = gift?.isNew, isNew {
            oldOrNew.text = LanguageKeys.new.localizedString
        }else{
            oldOrNew.text = LanguageKeys.used.localizedString
        }
        giftDescription.text = gift?.description
        
        addImagesToSlideShows()
    }
    
    func addEditBtn(){
        editBtn = NavigationBarStyle.getNavigationItem(
            target: self,
            action: #selector(self.editBtnClicked),
            text: LanguageKeys.edit.localizedString,
            font:AppConst.Resource.Font.getRegularFont(size: 16)
        )
        
        self.navigationItem.rightBarButtonItems=[editBtn!]
    }
    
    @IBAction func requestBtnClicked(_ sender: Any) {
        guard AppDelegate.me().appCoordinator.checkForLogin() else {
            return
        }
        
        switch requestBtnState {
        case .isNotRequested:
            self.requestGiftPrompt()
        case .isRequested(let chat):
            startChat(chat: chat, sendRequestMessage: false)
        default:
            break
        }
        
    }
    
    @objc func editBtnClicked(){
        
        let controller=RegisterGiftViewController()
        
        controller.isEditMode=true
        controller.vm.editedGift=self.gift
        controller.editHandler={ [weak self] in
            self?.fillUIWithGift()
            self?.editHandler?()
        }
        
        let nc=UINavigationController(rootViewController: controller)
        
        self.present(nc, animated: true, completion: nil)
        
    }
    
    @IBAction func removeBtnClicked(_ sender: Any) {
        
        PopUpMessage.showPopUp(nibClass: PromptUser.self, data:  LanguageKeys.giftRemovingPrompt.localizedString,animation:.none,declineHandler: nil) { (ـ) in
            self.removeGift()
        }
    }
    
    func requestGiftPrompt() {
        
        PopUpMessage.showPopUp(nibClass: PromptUser.self, data:  LanguageKeys.giftRequestPrompt.localizedString,animation:.none,declineHandler: nil) { (ـ) in
            self.requestGift()
        }
    }
    
    func requestGift(){
        guard let giftId = gift?.id else {
            return
        }
        self.setRequestBtnState(state: .loading)

        vm.requestGift(id: giftId) { [weak self](result) in
            DispatchQueue.main.async {
                self?.handleRequestGift(result: result)
            }
        }

    }
    
    func handleRequestGift(result:Result<Chat>) {
        
        switch result {
        case .failure(let error):
            print(error)
            FlashMessage.showMessage(body:  LanguageKeys.operationFailed.localizedString,theme: .error)
            self.setRequestBtnState(state: .isNotRequested)
        case .success(let chat):
            self.startChat(chat: chat, sendRequestMessage: true)
            self.setRequestBtnState(state: .isRequested(chat: chat))
        }
    }
    
    func removeGift(){
        
        guard let giftId=gift?.id else {
            return
        }
        self.removeBtn.isEnabled=false
        
        vm.removeGift(id: giftId) { [weak self](result) in
            DispatchQueue.main.async {
                self?.handleRemoveGift(result)
            }
        }
    }
    
    func handleRemoveGift(_ result:Result<Void>) {
        self.removeBtn.isEnabled=true
        
        switch result {
        case .failure(_):
            FlashMessage.showMessage(body:  LanguageKeys.operationFailed.localizedString,theme: .error)
        case .success(_):
            self.editHandler?()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func startChat(chat:Chat, sendRequestMessage: Bool){
        
        guard let chatId = chat.id else {
            return
        }
        
        let giftRequestMessage = "\(LanguageKeys.giftRequestChatMessage.localizedString) '\(self.gift?.title ?? "")'"
        
        guard let startNewChatProtocol = AppDelegate.me().appCoordinator.tabBarCoordinator?.chatCoordinator.startNewChatProtocol else {
            return
        }
        let messagesViewModel = startNewChatProtocol.writeMessage(text: sendRequestMessage ? giftRequestMessage : nil, chatId: chatId)

        let messagesViewControllerDelegate = startNewChatProtocol.getMessagesViewControllerDelegate()
        
        self.pushMessagesViewController(messagesViewModel: messagesViewModel, messagesViewControllerDelegate: messagesViewControllerDelegate)
    }
    
    func pushMessagesViewController(messagesViewModel: MessagesViewModel,
                                    messagesViewControllerDelegate:MessagesViewControllerDelegate){
        
        let controller = MessagesViewController()
        controller.viewModel = messagesViewModel
        controller.delegate = messagesViewControllerDelegate
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.setAllTextsInView()
    }
    
    func setAllTextsInView(){
        self.editBtn?.title=LanguageKeys.edit.localizedString
        self.removeBtn.setTitle(LanguageKeys.remove.localizedString, for: .normal)
        self.setRequestBtnState(state: self.requestBtnState)
        self.categoryLabel.text=LanguageKeys.category.localizedString
        self.oldOrNewLabel.text=LanguageKeys.status.localizedString
        self.addressLabel.text=LanguageKeys.address.localizedString
        self.descriptionLabel.text=LanguageKeys.description.localizedString
    }
    
    func createSlideShow() {
        
        // Do any additional setup after loading the view.
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFit
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(GiftDetailViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    func addImagesToSlideShows(){
        
        guard let images = gift?.giftImages
            else {
                return
        }
        
        var sdWebImageSource:[KingfisherSource] = []
        for img in images {
            if let source = KingfisherSource(urlString: img) {
                sdWebImageSource.append(source)
            }
        }
        
        self.slideshow.setImageInputs(sdWebImageSource)
    }
}
