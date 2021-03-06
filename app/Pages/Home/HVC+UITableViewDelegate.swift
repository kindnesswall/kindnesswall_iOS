//
//  HVC+UITableViewDelegate.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard vm.isReview else {return UISwipeActionsConfiguration(actions: [])}
        let approveAction = approveGift(at: indexPath)
        return UISwipeActionsConfiguration(actions: [approveAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard vm.isReview else {return UISwipeActionsConfiguration(actions: [])}
        let rejectAction = rejectGift(at: indexPath)
        return UISwipeActionsConfiguration(actions: [rejectAction])
    }

    func approveGift(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Approve") { (_, _, completion) in
            self.approveAction(rowIndex: indexPath, handler: completion)
        }
        action.image = UIImage(named: AppImages.Approve)
        action.backgroundColor = .green
        return action
    }

    func approveAction(rowIndex: IndexPath, handler: @escaping (Bool) -> Void) {
        self.vm.giftApprovedAfterReview(rowNumber: rowIndex.row, completion: { [weak self] (result) in
            switch result {
            case .failure:
                self?.homeCoordiantor?.showDialogFailed(closeType: .dismissAlert) {
                    self?.approveAction(rowIndex: rowIndex, handler: handler)
                }
            case .success:
                DispatchQueue.main.async {
                    self?.tableview.deleteRows(at: [rowIndex], with: .automatic)
                }
                handler(true)
            }
        })
    }

    func rejectGift(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Reject") { [weak self](_, _, completion) in
            self?.homeCoordiantor?.showConfirmationDialog {
                self?.rejectAction(rowIndex: indexPath, handler: completion)
            }
        }
        action.image = UIImage(named: AppImages.Reject)
        //        action.backgroundColor = .red
        return action
    }

    func rejectAction(rowIndex: IndexPath, handler: @escaping (Bool) -> Void) {
        self.vm.giftRejectedAfterReview(rowNumber: rowIndex.row, completion: { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.homeCoordiantor?.showDialogFailed(closeType: .dismissAlert) {
                        self?.rejectAction(rowIndex: rowIndex, handler: handler)
                    }
                }
            case .success:
                DispatchQueue.main.async {

                    self?.tableview.deleteRows(at: [rowIndex], with: .automatic)
                }
                handler(true)
            }
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeCoordiantor?.showDetail(gift: vm.gifts[indexPath.row], editHandler: self.editHandler)
    }

    func editHandler() {
        self.reloadPage()
        homeCoordiantor?.reloadOtherVCs()
    }

}
