//
//  ViewController.swift
//  SearchController
//
//  Created by Kiattisak Anoochitarom on 2/24/2558 BE.
//  Copyright (c) 2558 Kiattisak Anoochitarom. All rights reserved.
//

import UIKit

enum CountrySortingSearchScope: Int {
    case AlphabetAscending, AlphabetDecending
}

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private var searchController: UISearchController!
    private let CellIdentidfier = "CountryCell"
    private var countries: [String] = []
    private var filteredCountries: [String] = []
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCountries()
        initializeSearchController()
    }
    
    private func initializeCountries() {
        countries = allCountries()
    }
    
    private func initializeSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["A-Z", "Z-A"]
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    private func allCountries() -> [String] {
        var unsortedCountries: [String] = []
        for countryCode in NSLocale.ISOCountryCodes() as [String] {
            let countryName = NSLocale(localeIdentifier: "en_US").displayNameForKey(NSLocaleCountryCode, value: countryCode) ?? "Country not found for code: \(countryCode)"
            unsortedCountries.append(countryName)
        }
        return sorted(unsortedCountries, <)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(countriesForShowing())
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentidfier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = countriesForShowing()[indexPath.row]
        
        return cell;
    }
}

extension ViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if !searchString.isEmpty {
            let scopeIndex = CountrySortingSearchScope(rawValue: searchController.searchBar.selectedScopeButtonIndex)!
            searchForText(searchString, scope: scopeIndex)
            tableView.reloadData()
        }
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(searchController)
    }
    
    private func searchForText(text: String, scope: CountrySortingSearchScope) {
        filteredCountries = countries.filter {
            countryName in
            countryName.lowercaseString.hasPrefix(text)
        }
        
        switch scope {
        case .AlphabetAscending:
            filteredCountries = sorted(filteredCountries, <)
        case .AlphabetDecending:
            filteredCountries = sorted(filteredCountries, >)
        default:
            println("Can't sorting")
        }
    }
    
    private func countriesForShowing() -> [String] {
        if searchController.active {
            return filteredCountries
        } else {
            return countries
        }
    }
}

extension String {
    func contains(substring: String) -> Bool {
        return self.rangeOfString(substring) != nil
    }
}


