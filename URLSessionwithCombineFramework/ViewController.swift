//
//  ViewController.swift
//  URLSessionwithCombineFramework
//
//  Created by shiga on 03/03/20.
//  Copyright © 2020 shiga. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private var url = URL(string: "https://jsonplaceholder.typicode.com/comments")!
    private var cancellable: AnyCancellable?
    @IBOutlet weak var tableView: UITableView!
    
    var comments: [Comment] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        request()
    }

    //MARK:-  network request with swift combine
    
    private func request() {
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data})
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .assign(to: \.comments, on: self)
    }

}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
        let comment = comments[indexPath.row]
        
        cell.textLabel?.text = comment.name
        
        return cell
    }
    
    
}
