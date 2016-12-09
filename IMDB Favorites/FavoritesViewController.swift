//
//  FirstViewController.swift
//  IMDB Favorites
//
//  Created by Olav on 03/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import UIKit
import CoreData
import SugarRecord

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [Movie]()
    
    lazy var db: CoreDataDefaultStorage = {
        let store = CoreDataStore.named("movie_favorites")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "\(movie.title) (\(movie.year))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowMovieSegue", sender: movies[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! MovieDetailViewController
        guest.mTitle = (sender as! String)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movies = try! db.fetch(FetchRequest<Movie>())
        tableView.reloadData()
    }

}

