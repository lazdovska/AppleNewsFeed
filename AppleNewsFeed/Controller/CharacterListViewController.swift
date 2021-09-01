//
//  NewsFeedViewController.swift
//  AppleNewsFeed
//
//  Created by kristine.lazdovska on 09/08/2021.
//

import UIKit
import CoreLocation
import Gloss

class CharacterListViewController: UIViewController {
    
    var results: [Result]? = []
    var series: [ComicsItem]? = []
    var comics: [ComicsItem]? = []
    var stories: [StoriesItem]? = []
    var thumbnail: [Thumbnail]? = []
    var find = FindCharacterController()
    var jsonUrl = String()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Marvel Characters"
        activityIndicatorView.isHidden = true
        tableView.backgroundView = UIImageView(image: UIImage(named: "BacgroundMarvelLight"))
    }
    
    func activityIndicator(animated: Bool){
        DispatchQueue.main.async {
            if animated{
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            }else{
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    @IBAction func infoBarItem(_ sender: Any) {
        basicAlert(title: "Marvel Character Info!", message: "Press plane to choose Marvel Characters.")
    }
    
    @IBAction func getDataTapped(_ sender: Any) {
        let chooseAlert = UIAlertController(title: "Please Choose Series List!", message: "Choose series to fetch Marvel Characters.", preferredStyle: .alert)
        chooseAlert.view.backgroundColor = UIColor.systemRed
        chooseAlert.view.tintColor = UIColor.systemPurple
        chooseAlert.view.layer.cornerRadius = 40
        let buttonA = UIAlertAction(title: "Avengers", style: .default){ alertAction in
            self.jsonUrl = "https://gateway.marvel.com:443/v1/public/characters?series=Avengers%209085%2C%2022547%2C%2024229&orderBy=name&ts=1&apikey=70ba4f388906d13bd576ffb400428920&hash=98096b3587d12a61474d31b900eb831e"
            self.results?.removeAll()
            self.tableView.reloadData()
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
            self.handleGetData()
            self.activityIndicator(animated: true)
            
        }
        
        let buttonS = UIAlertAction(title: "Spider-Man", style: .default) { alertAction in
            self.jsonUrl = "https://gateway.marvel.com:443/v1/public/characters?series=Spider-Man%2C%202069%2C%2027022%2C%2020508&orderBy=name&ts=1&apikey=70ba4f388906d13bd576ffb400428920&hash=98096b3587d12a61474d31b900eb831e"
            self.results?.removeAll()
            self.tableView.reloadData()
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "SpiderManLight"))
            self.handleGetData()
            self.activityIndicator(animated: true)
            
        }
        let buttonD = UIAlertAction(title: "Doctor Strange", style: .default) { alertAction in
            self.jsonUrl = "https://gateway.marvel.com:443/v1/public/characters?series=Doctor%20Strange%2C%202985%2C%203740%2C%2020457%2C%2024296&orderBy=name&ts=1&apikey=70ba4f388906d13bd576ffb400428920&hash=98096b3587d12a61474d31b900eb831e"
            self.results?.removeAll()
            self.tableView.reloadData()
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "DoctorStrangeLight"))
            self.handleGetData()
            self.activityIndicator(animated: true)
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        chooseAlert.addAction(buttonA)
        chooseAlert.addAction(buttonS)
        chooseAlert.addAction(buttonD)
        chooseAlert.addAction(cancelButton)
        
        present(chooseAlert, animated: true, completion: nil)
        
    }
    
    func handleGetData(){
        let jsonUrlLink = self.jsonUrl
        
        guard let url = URL(string: jsonUrlLink) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { data, response, err in
            
            if let err = err {
                self.basicAlert(title: "Error!", message: "\(err.localizedDescription)")
            }
            guard let data = data else{
                self.basicAlert(title: "Error!", message: "Something went wrong, no data")
                return
            }
            do{
                let jsonData = try JSONDecoder().decode(Marvel.self, from: data)
                
                DispatchQueue.main.async {
                    self.results = jsonData.data?.results
                    print("Marvel JSON self.results: ", self.results as Any)
                    
                    self.tableView.reloadData()
                    self.activityIndicator(animated: false)
                    
                }
                
            }catch{
                print("err:", error)
            }
        }
        task.resume()
    }
    private func loadImage(thumbnail: Thumbnail) -> UIImage? {
        var returnImage: UIImage?
        let imageURL = (thumbnail.path)!.replacingOccurrences(of: "http://", with: "https://") + "/portrait_uncanny." + (thumbnail.thumbnailExtension)!
        print(">>>imageUR: " + imageURL)
        guard let url = URL(string: imageURL) else {
            return returnImage
        }
        
        if let data = try? Data(contentsOf: url){
            if let imageURL = UIImage(data: data){
                returnImage = imageURL
            }
        }
        return returnImage
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return results!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterList", for: indexPath) as? CharacterListTableViewCell else {
            return UITableViewCell()
        }
        
        let result = results?[indexPath.row]
        cell.characterNameLabel.text = result?.name
        cell.characterNameLabel.numberOfLines = 0
        cell.characterImageView?.image = loadImage(thumbnail: (result?.thumbnail)!)!
        cell.backgroundView = UIImageView(image: UIImage(named: "SavedMarcelCellLight.png"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard  let vc = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        else {
            return
        }
        let result = results?[indexPath.row]
        let nameSeries = result?.series?.items?.compactMap({(item: ComicsItem) -> String in return item.name!})
        vc.seriesString = (nameSeries?.joined(separator: "\n"))!
        let nameComics = result?.comics?.items?.compactMap({(item: ComicsItem) -> String in return item.name!})
        vc.comicsString = (nameComics?.joined(separator: "\n"))!
        let nameStories = result?.stories?.items?.compactMap({(item: StoriesItem) -> String in return item.name!})
        vc.storiesString = (nameStories?.joined(separator: "\n"))!
        
        vc.descriptionString = (result?.resultDescription)!
        vc.nameString = (result?.name)!
        vc.images = loadImage(thumbnail: (result?.thumbnail)!)!
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

