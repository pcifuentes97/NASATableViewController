//
//  ViewController.swift
//  TableViewImplementaion2
//
//  Created by Paolo Cifuentes on 11/19/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var roverTableView: UITableView! {
        didSet {
            self.roverTableView.tableFooterView = UIView()
            self.roverTableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetch()
    }
    var roverDataSource: Photos? {
        didSet {
            DispatchQueue.main.async {
                self.roverTableView.reloadData()
            }
        }
    }
    var currentIndex = 0
    
    func fetch() {
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=DEMO_KEY&sol=2000&page=1") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return
            }
            guard let unwrappedData = data else {
                return
            }
            switch response.statusCode {
            case 200...299:
                do {
                    self.roverDataSource = try JSONDecoder().decode(Photos.self, from: unwrappedData)
                } catch {
                    print(error.localizedDescription)
                }
            default:
                break
            }

        }.resume()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roverDataSource?.photos.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")
        
        if reusableCell == nil {
            cell = reusableCell ?? UITableViewCell()
        } else {
            cell = UITableViewCell(style: .value2, reuseIdentifier: "defaultCell")
        }
        cell.textLabel?.text = String(roverDataSource?.photos[indexPath.row].id ?? 0)
        
        let favorite = (roverDataSource?.photos[indexPath.row].favorite ?? false)
        if favorite {
            cell.imageView?.image = UIImage(systemName: "heart.fill")
        } else {
            cell.imageView?.image = UIImage(systemName: "heart")
        }
        cell.imageView?.tintColor = .red
        cell.backgroundColor = .gray
        cell.textLabel?.textColor = .white
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentIndex = indexPath.row
        let sb = storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        sb.delegate = self
        sb.rover = roverDataSource?.photos[indexPath.row]
        self.navigationController?.pushViewController(sb, animated: true)
    }
}

extension ViewController: ImageDelegate {
    func updateInformation(isFavorite: Bool) {
        roverDataSource?.photos[currentIndex].favorite = isFavorite
        roverTableView.reloadData()
    }
}

