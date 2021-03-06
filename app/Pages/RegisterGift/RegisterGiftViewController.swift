//
//  RegisterGiftViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/12/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import CropViewController

class RegisterGiftViewController: UIViewController {

    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var contentStackView: UIStackView! {
        didSet {
            let tapGesture=UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
            contentStackView.addGestureRecognizer(tapGesture)
        }
    }

    @IBOutlet weak var categoryBtn: UIButton!

    @IBOutlet weak var dateStatusBtn: UIButton!

    @IBOutlet weak var priceTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!

    @IBOutlet weak var uploadedImageStack: UIStackView!

    var uploadedImageViews=[UploadImageView]()

    @IBOutlet weak var placesStackView: UIStackView!
    var placesLabels=[UILabel]()

    @IBOutlet weak var placeBtn: UIButton!

    @IBOutlet var uploadBtn: UIButton!

    var vm = RegisterGiftViewModel()

    let imagePicker = UIImagePickerController()
    var isEditMode=false

    @IBOutlet weak var editedGiftOriginalAddress: UILabel!

    var editHandler:(() -> Void)?

    var barClearBtn: UIBarButtonItem?
    var barSaveBtn: UIBarButtonItem?
    var barCloseBtn: UIBarButtonItem?

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var newOrSecondhandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    deinit {
        print("RegisterGiftViewController Deinit")
        removeKeyboardObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.vm.delegate = self

        self.configNavBar()

        self.configSendButtons()

        if isEditMode {
            self.vm.readFromEditedGift()
            self.vm.giftHasNewAddress=false
        } else {
            self.vm.readFromDraft()
            self.vm.giftHasNewAddress=true
        }

        self.configAddressViews()

        addKeyboardObserver()
    }

    func configSendButtons() {
        if isEditMode {
            self.registerBtn.hide()
            self.editBtn.show()
        } else {
            self.registerBtn.show()
            self.editBtn.hide()
        }
    }

    func configAddressViews() {
        if self.vm.giftHasNewAddress {
            self.editedGiftOriginalAddress.hide()
        } else {
            self.editedGiftOriginalAddress.show()
        }
    }

    func configNavBar() {

        if !isEditMode {
            self.barClearBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.clearAllInput), text: LanguageKeys.clearPage.localizedString)
            self.navigationItem.rightBarButtonItems=[self.barClearBtn!]
            self.barSaveBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.saveBarBtnAction), text: LanguageKeys.saveDraft.localizedString)
            self.navigationItem.leftBarButtonItems=[self.barSaveBtn!]

        } else {
            self.barCloseBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.closeBarBtnAction), text: LanguageKeys.cancel.localizedString)

            self.navigationItem.rightBarButtonItems=[self.barCloseBtn!]
        }

    }

    @objc func clearAllInput() {

        self.clearUploadedImages()
        self.clearGiftPlaces()

        self.categoryBtn.setTitle(LanguageKeys.select.localizedString, for: .normal)
        self.vm.category=nil

        self.dateStatusBtn.setTitle(LanguageKeys.select.localizedString, for: .normal)
        self.vm.dateStatus=nil

        self.titleTextView.text=""
        self.descriptionTextView.text=""
        self.priceTextView.text=""

        UserDefaultService().delete(.registerGiftDraft)
    }

    @objc func saveBarBtnAction() {
        self.vm.saveDraft()
    }

    @objc func closeBarBtnAction() {
        self.dismiss(animated: true, completion: nil)
    }

    func addGiftPlace(place: Place) {

        let label=UILabel()
        label.text=place.name
        label.backgroundColor=AppColor.GreyBg
        label.textColor=UIColor.black
        label.font=AppFont.get(.iranSansRegular, size: 17)
        label.textAlignment = .center
        placesLabels.append(label)

        let width=label.intrinsicContentSize.width + 20
        label.widthAnchor.constraint(equalToConstant: width).isActive=true

        placesStackView.addArrangedSubview(label)
    }

    func clearGiftPlaces() {
        for placeLabel in placesLabels {
            placeLabel.removeFromSuperview()
        }
        placesLabels=[]
        self.vm.places=[]
    }

    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
//        setAllTextsInView()
    }

    func setAllTextsInView() {
        if isEditMode {
            self.navigationItem.title=LanguageKeys.EditGiftViewControllerTitle.localizedString
        } else {
            self.navigationItem.title=LanguageKeys.RegisterGiftViewControllerTitle.localizedString
        }

        self.barClearBtn?.title=LanguageKeys.clearPage.localizedString
        self.barSaveBtn?.title=LanguageKeys.saveDraft.localizedString
        self.barCloseBtn?.title=LanguageKeys.cancel.localizedString

        self.categoryLabel.text=LanguageKeys.giftCategory.localizedString
        self.titleLabel.text=LanguageKeys.title.localizedString
        self.descriptionLabel.text=LanguageKeys.description.localizedString
        self.placeLabel.text=LanguageKeys.placeOfTheGift.localizedString
        self.newOrSecondhandLabel.text=LanguageKeys.newOrUsed.localizedString
        self.priceLabel.text=LanguageKeys.approximatePrice.localizedString + LanguageKeys.gettingPriceReason.localizedString

        self.registerBtn.setTitle(  LanguageKeys.RegisterGiftViewControllerTitle.localizedString, for: .normal)

        self.editBtn.setTitle(
              LanguageKeys.EditGiftViewControllerTitle.localizedString, for: .normal)

        self.uploadBtn.setTitle(  LanguageKeys.addImage.localizedString, for: .normal)
        self.placeBtn.setTitle(  LanguageKeys.select.localizedString, for: .normal)
        if self.vm.category == nil {
            self.categoryBtn.setTitle(  LanguageKeys.select.localizedString, for: .normal)
        }
        if self.vm.dateStatus == nil {
            self.dateStatusBtn.setTitle(  LanguageKeys.select.localizedString, for: .normal)
        }
    }

    func reloadOtherPages() {
        AppDelegate.me().appCoordinator.reloadTabBarPages(currentPage: nil)
    }

}
