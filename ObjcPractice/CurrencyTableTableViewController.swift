//
//  CurrencyTableTableViewController.swift
//  ObjcPractice
//
//  Created by Luis Santiago on 22/02/21.
//

import UIKit

class CurrencyTableTableViewController: UITableViewController {
    
    let countryCellID = "CountryCellID"
    
    @objc
    public var listener : CurrencyListener?
    
    let countries = [
        Country(currency: "AFN", name: "AFGHANISTAN"),
        Country(currency: "ALL", name: "ALBANIA"),
        Country(currency: "DZD", name: "ALGERIA"),
        Country(currency: "USD", name: "AMERICAN SAMOA"),
        Country(currency: "EUR", name: "ANDORRA"),
        Country(currency: "MXN", name: "MEXICO"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: countryCellID)
        self.navigationItem.title = "Select Currency"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.onCurrencySelected(country: countries[indexPath.item])
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: countryCellID, for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        return cell
    }
    
    
}
