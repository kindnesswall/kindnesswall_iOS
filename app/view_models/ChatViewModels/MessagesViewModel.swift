//
//  MessagesViewModel.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/11/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import Foundation


class MessagesViewModel {
    var userId:Int
    var chatId:Int
    var contactInfo:UserProfile?
    var serverNotificationCount: Int?
    private var messages = [TextMessage]()
    var curatedMessages = [[TextMessage]]()
    var sendingQueue = [TextMessage]()
    weak var delegate:MessagesDelegate?
    var noMoreOldMessages = false
    
    init(userId:Int,chatId:Int) {
        self.userId=userId
        self.chatId=chatId
    }
    
    deinit {
        print("MessagesViewModel deinit")
    }
    
    func getContactId()->Int?{
        return contactInfo?.id
    }
    
    var notificationCount: Int {
        if self.messages.count == 0 {
            return serverNotificationCount ?? 0
        } else {
            return localNotificationCount
        }
    }
    
    private var localNotificationCount: Int {
        var number = 0
        for each in self.messages {
            if each.senderId != self.userId, each.ack == false, each.hasSeen ?? false == false {
                number+=1
            }
        }
        return number
    }
    
    func addMessages(messages:[TextMessage],isSending:Bool) {
        
        var uiHasChanged = false
        var scrollToTop = false
        for message in messages {
            if let index = addMessage(message: message, isSending: isSending) {
                if !uiHasChanged {
                    uiHasChanged = true
                }
                if !scrollToTop, index == 0 {
                    scrollToTop = true
                }
            }
            
        }
        
        guard uiHasChanged else {
            return
        }
        
        updateUI(scrollToTop: scrollToTop)
    }
    
    func ackMessageIsReceived(message:TextMessage) {
        self.removeSendingMessageFromMessages(message: message)
        self.removeSendingMessageFromSendingQueue(message: message)
        guard let index = self.addMessage(message: message) else {
            return
        }
        let scrollToTop = index == 0 ? true : false
        
        updateUI(scrollToTop: scrollToTop)
    }
    
    private func addMessage(message:TextMessage,isSending:Bool)->Int? {
        if isSending {
            let index = 0
            self.messages.insert(message, at: index)
            self.sendingQueue.append(message)
            return index
        } else {
            return self.addMessage(message: message)
        }
    }
    
    private func updateUI(scrollToTop:Bool){
        updateCuratedMessages()
        
        if scrollToTop{
            self.delegate?.updateTableViewAndScrollToTop()
        } else {
            self.delegate?.updateTableView()
        }
    }
    
    private func updateCuratedMessages(){
        var curatedMessagesStorage = [[TextMessage]]()
        var lastDate:String? = nil
        var sameDateMessages:[TextMessage] = []
        var newMessage:TextMessage?
        for message in messages {
            
            var sendDate = message.createdAt?.convertToDate()
            if sendDate == nil, message.sendingState == .sending {
                sendDate = Date()
            }
            
            guard let date = sendDate?.getPersianDate() else {
                continue
            }
            
            //For the first item
            if lastDate == nil {
                lastDate = date
            }
            
            if lastDate != date {
                curatedMessagesStorage.append(sameDateMessages)
                sameDateMessages = []
                lastDate = date
            }
            
            sameDateMessages.append(message)
            
            message.isNewMessage = false
             if isNewMessage(message: message){
                newMessage = message
            }
            
        }
        
        curatedMessagesStorage.append(sameDateMessages)
        
        newMessage?.isNewMessage = true
        
        self.curatedMessages = curatedMessagesStorage
    }
    
    private func isNewMessage(message:TextMessage)->Bool {
        if message.receiverId == userId, !(message.ack ?? false), !(message.hasSeen ?? false) {
            return true
        }
        return false
    }
    
    
    private func removeSendingMessageFromMessages(message:TextMessage){
        
        if let index = self.messages.firstIndex(where: {each in findSameText(message: message, each: each)}) {
            self.messages.remove(at: index)
        }
    }
    
    private func removeSendingMessageFromSendingQueue(message:TextMessage){
        
        if let index = self.sendingQueue.firstIndex (where: {each in findSameText(message: message, each: each)}) {
            self.sendingQueue.remove(at: index)
        }
    }
    
    private func findSameText(message:TextMessage,each:TextMessage)->Bool {
        //#Caution: it only considers text of message for compare! (because sending message has no id)
        if each.sendingState == .sending, each.text == message.text {
            return true
        }
        return false
    }
    
    private func addMessage(message:TextMessage)->Int?{
        guard let messageId = message.id else {
            return nil
        }
        guard !messages.contains(where: { each -> Bool in
            return messageId == each.id
        }) else {
            return nil
        }
        
        for i in 0..<messages.count {
            guard let eachId = messages[i].id else {
                continue
            }
            if messageId > eachId {
                self.messages.insert(message, at: i)
                return i
            }
        }
        
        messages.append(message)
        let index = messages.count - 1
        return index
        
    }
}

extension MessagesViewModel {
    static func find(chatId:Int,list:[MessagesViewModel])->MessagesViewModel? {
        return list.first(where: { (each) -> Bool in
            if each.chatId == chatId {
                return true
            } else {
                return false
            }
        })
    }
}


protocol MessagesDelegate : class {
    func updateTableViewAndScrollToTop()
    func updateTableView()
}
