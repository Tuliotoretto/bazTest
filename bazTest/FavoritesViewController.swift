//
//  FavoritesViewController.swift
//  bazTest
//
//  Created by Julian Garcia  on 16/06/23.
//

import UIKit

class FavoritesViewController: UITableViewController {
    var favShows = [Show]() {
        didSet {
            if oldValue != favShows {
                tableView.reloadSections([0], with: .automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        
        navigationController?.customBarColors(
            tint: .white,
            background: UIColor(red: 0.4, green: 0.1, blue: 0.99, alpha: 1)
        )
        
        tableView.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavs()
    }
    
    func updateFavs() {
        if let favs: [Show] = DatabaseManager.shared.retriveShows() {
            favShows = favs
        }
    }
}

// MARK: - Table View Data Source and Delegate Methods
extension FavoritesViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        precondition(indexPath.section == 0)
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShowTableViewCell.reuseIdentifier,
            for: indexPath) as! ShowTableViewCell
        
        cell.updateWith(show: favShows[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        precondition(section == 0)
        
        return favShows.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension FavoritesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = DetailViewController()
        detailVC.show = favShows[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let action: UIContextualAction
        
        action = UIContextualAction(style: .destructive, title: "Delete") {[weak self] action, SourceView, completionHandler in
            
            let ac = UIAlertController.deleteAlert(title: "Are you sure?!") { _ in
                DatabaseManager.shared.deleteFav(id: self!.favShows[indexPath.row].id) { err in
                    self?.showErrorAlert(err: err)
                }
                
                self?.updateFavs()
            }
            
            self?.present(ac, animated: true)
            
            completionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [action])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}
