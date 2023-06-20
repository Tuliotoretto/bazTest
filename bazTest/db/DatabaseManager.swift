//
//  DatabaseManager.swift
//  bazTest
//
//  Created by Julian Garcia  on 17/06/23.
//

import CoreData
import UIKit

class DatabaseManager: NSObject {
    static public let shared = DatabaseManager()
    
    private var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    private override init() {
        super.init()
    }
        
    public func retriveShows() -> [FavoriteShows]? {
        do {
            let items = try context!.fetch(FavoriteShows.fetchRequest())
            return items
        } catch {
            fatalError("Failed to retrive shows")
        }
    }
    
    public func retriveShows() -> [Show]? {
        do {
            let items = try context!.fetch(FavoriteShows.fetchRequest())
            return items.map { Show(favShow: $0) }
        } catch {
            fatalError("Failed to retrive shows")
        }
    }
    
    public func addFav(show: Show, handler: ((Error?) -> Void)? = nil) {
        let newItem = FavoriteShows(context: context!)
        newItem.id = Int32(show.id)
        newItem.name = show.name
        newItem.summary = show.summary
        newItem.imageMedium = show.image.medium
        newItem.imageOriginal = show.image.original
        newItem.externals = show.externals.imdb ?? ""
        
        if let _ = handler {
            handler?(save())
        } else {
            save()
        }
    }
    
    public func deleteFav(id: Int, handler: ((Error?) -> Void)? = nil) {
        guard let favShows: [FavoriteShows] = retriveShows() else { return }
        guard let toDelete = favShows.first(where: { favShows in
            favShows.id == id
        }) else { return }
        
        context?.delete(toDelete)
        
        if let _ = handler {
            handler?(save())
        } else {
            save()
        }
    }
    
    public func isFav(id: Int) -> Bool {
        guard let shows: [FavoriteShows] = retriveShows() else { return false }
        
        return shows.contains { favShows in
            favShows.id == id
        }
    }
    
    @discardableResult
    private func save() -> Error? {
        do {
            try context!.save()
            return nil
        } catch {
            return error
        }
    }
}
