//
//  ViewController.swift
//  bazTest
//
//  Created by Julian Garcia  on 15/06/23.
//

import UIKit

class ListViewController: UITableViewController {
    var allShows = [Show]() {
        didSet {
            tableView.reloadSections([0], with: .automatic)
        }
    }
    
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TV Shows"
        
        navigationController?.customBarColors(
            tint: .white,
            background: UIColor(red: 0.4, green: 0.1, blue: 0.99, alpha: 1)
        )
        
        tableView.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.reuseIdentifier)
        
        NetworkManager.shared.loadShowsBy(page: currentPage) { [weak self] shows in
            guard let shows = shows else {
                self?.present(UIAlertController.errorAlert(), animated: true)
                return
            }
            
            self?.allShows.append(contentsOf: shows)
        }
    }
}

// MARK: - Table View Data Source and Delegate Methods
extension ListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        precondition(indexPath.section == 0)
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShowTableViewCell.reuseIdentifier,
            for: indexPath) as! ShowTableViewCell
        
        cell.updateWith(show: allShows[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        precondition(section == 0)
        
        return allShows.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = DetailViewController()
        detailVC.show = allShows[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let action: UIContextualAction
        
        if !(DatabaseManager.shared.isFav(id: allShows[indexPath.row].id)) {
            // set to favs
            action = UIContextualAction(style: .normal, title: "Favorite") { [weak self] action, Sourceview, completionHandler in

                DatabaseManager.shared.addFav(show: self!.allShows[indexPath.row]) { err in
                    self?.showErrorAlert(err: err)
                }
                completionHandler(true)
                
            }
            action.backgroundColor = .green
            
        } else {
            // delete from favs
            action = UIContextualAction(style: .destructive, title: "Delete") {[weak self] action, SourceView, completionHandler in
                
                let ac = UIAlertController.deleteAlert(title: "Are you sure?!") { _ in
                    DatabaseManager.shared.deleteFav(id: self!.allShows[indexPath.row].id) { err in
                        self?.showErrorAlert(err: err)
                    }
                }
                
                self?.present(ac, animated: true)
                
                completionHandler(true)
            }
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [action])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}
