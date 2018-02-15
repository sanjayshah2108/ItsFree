//
//  FilterTableViewController.swift
//  ItsFree
//
//  Created by Sanjay Shah on 2017-11-29.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select A Category"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIProperties.sharedUIProperties.lightGreenColour]
        
        categoryTableView =  UITableView()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ItemCategory.count+1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filterCategoryCellID")
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCategoryCellID")!
        
        if(indexPath.row == 0){
            cell.textLabel?.text = "All"
        }
        else {
            cell.textLabel?.text = ItemCategory.stringValue(index: indexPath.row-1)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch availableBool {
        case true :
            if(indexPath.row == 0){
                ReadFirebaseData.readOffers(category:nil)
            }
            else {
                ReadFirebaseData.readOffers(category: ItemCategory.enumName(index:indexPath.row-1))
            }
            
        case false :
            if(indexPath.row == 0){
                ReadFirebaseData.readRequests(category: nil)
            }
            else {
                ReadFirebaseData.readRequests(category: ItemCategory.enumName(index:indexPath.row-1))
            }
            
        case .none:
            break
            
        case .some(_):
            break
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentNonRequestedAlert), name: NSNotification.Name(rawValue: "noRequestedItemsInCategoryKey"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentNonAvailableAlert), name: NSNotification.Name(rawValue: "noOfferedItemsInCategoryKey"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func presentNonAvailableAlert(){

        let noValuesAlert = UIAlertController(title: "No items!", message: "Nothing is available in this category", preferredStyle: UIAlertControllerStyle.alert)

        let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil)

        noValuesAlert.addAction(okayAction)
        present(noValuesAlert, animated: true, completion: nil)

    }

    @objc func presentNonRequestedAlert(){

        let noValuesAlert = UIAlertController(title: "No items!", message: "Nothing is requested for in this category", preferredStyle: UIAlertControllerStyle.alert)

        let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil)

        noValuesAlert.addAction(okayAction)
        present(noValuesAlert, animated: true, completion: nil)

    }

}
