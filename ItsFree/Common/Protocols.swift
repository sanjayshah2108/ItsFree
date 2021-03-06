//
//  Protocols.swift
//  ItsFree
//
//  Created by Sanjay Shah on 2018-08-05.
//  Copyright © 2018 Sanjay Shah. All rights reserved.
//

import Foundation
import UIKit


protocol HomeMarkerSelectionDelegate {
    func selectMarker(item: Item)
}

protocol LoggedOutDelegate {
    func goToLoginVC()
}

protocol AlertDelegate {
    func presentAlert(alert: UIAlertController)
}


protocol ItemActionDelegate {
    func sendPosterMessage(inpVC: UIViewController, currentItem: Item, destinationUser: User)
    func fullscreenImage(imagePath: String, imageView: UIImageView, inpVC: UIViewController)
    func dismissFullscreenImage(sender: UITapGestureRecognizer)
}

protocol FilterNotificationDelegate {
    
    func setNotificationsFromDelegator(category: ItemCategory?)
    func filterApplied()
    
}
