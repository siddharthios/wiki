//
//  ViewController.swift
//  wiki
//
//  Created by Siddharth Kumar on 24/06/18.
//  Copyright © 2018 Siddharth Kumar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    
    enum SearchError: Error {
        case invalidKeyword
    }
    
    var gridCollectionView: UICollectionView!
    var gridLayout: GridLayout!
    let wikiSearchDataModel = WikiSearchDataModel()
    var searchKeywordTextField = UITextField()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    let apiString = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=Sachin+T&gpslimit=10"
    let apiString2 = "https://en.m.wikipedia.org/w/index.php?curid=18630637"

    var previousApi = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initView()
        
        
    }
    
    
    func initView(){
        
        gridLayout = GridLayout()
        gridCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: gridLayout)
        gridCollectionView.backgroundColor = UIColor.lightGray
        gridCollectionView.showsVerticalScrollIndicator = false
        gridCollectionView.showsHorizontalScrollIndicator = false
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        gridCollectionView!.register(GridCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(gridCollectionView)
        
        var frame = gridCollectionView.frame
        frame.size.height = self.view.frame.size.height*0.66
        frame.size.width = self.view.frame.size.width
        frame.origin.x = 0
        frame.origin.y = self.view.frame.size.height*0.34
        gridCollectionView.frame = frame
        
        loadSearchForm()
        
    }
    
    
    func loadSearchForm(){

        
        
        searchKeywordTextField = UITextField(frame: CGRect(x: view.frame.width*0.1, y: view.frame.height*0.12, width: view.frame.width*0.8, height: view.frame.height*0.08))
        
        let placeholder = NSAttributedString(string: "Search wiki",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 14)])
        
        searchKeywordTextField.attributedPlaceholder = placeholder
        searchKeywordTextField.textColor = UIColor.black
        searchKeywordTextField.font = UIFont.systemFont(ofSize: 14)
        searchKeywordTextField.textAlignment = .left
        searchKeywordTextField.delegate = self
        searchKeywordTextField.returnKeyType = .done
        view.addSubview(searchKeywordTextField)
        
        let searchKeywordBottomline = CALayer()
        searchKeywordBottomline.frame = CGRect(x: 0.0, y: searchKeywordTextField.frame.height*0.82, width: searchKeywordTextField.frame.width, height: 1)
        searchKeywordBottomline.backgroundColor = UIColor(white: 0.9,alpha: 1).cgColor
        searchKeywordTextField.borderStyle = UITextBorderStyle.none
        searchKeywordTextField.layer.addSublayer(searchKeywordBottomline)
        searchKeywordTextField.attributedPlaceholder = placeholder
        
        
        
        let searchButton = UIButton(frame: CGRect(x: view.frame.width*0.1, y: view.frame.height*0.22, width: view.frame.width*0.8, height: view.frame.height*0.08))
        searchButton.backgroundColor = UIColor.darkGray
        searchButton.layer.cornerRadius = 5
        searchButton.setTitle("Search", for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        view.addSubview(searchButton)
        
        
        let separatorView = UIView(frame: CGRect(x: 0, y: view.frame.height*0.32, width: view.frame.width, height: view.frame.height*0.02))
        separatorView.backgroundColor = UIColor.lightGray
        view.addSubview(separatorView)
        
    }
    
    
    @objc func searchButtonAction(){
        dismissKeyboard()
        do {
            try search()
            
        } catch SearchError.invalidKeyword {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter a keyword", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        catch {
            
            let alertController = UIAlertController(title: "Error", message: "Some error occured. Please try again.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)        }
        
    }
    
    
    func search() throws {
        
        let searchKeyword = searchKeywordTextField.text!.lowercased().replacingOccurrences(of: " ", with: "")
        
        
        
        if searchKeyword.count < 1 {
            throw SearchError.invalidKeyword
        }
        
        
        let newApi = apiString.replacingOccurrences(of: "Sachin+T", with: searchKeyword)
        
        fetchData(api: newApi)
        
    }
    
    
    func fetchData(api: String) {
        
        if previousApi == api{
            
        }
        else{
            startActivityIndicator()
            previousApi = api
            Alamofire.request(api, method: .get).responseJSON {
                response in
                if response.result.isSuccess {
                    let WikiSearchsJSON : JSON = JSON(response.result.value!)
                    self.updateWikiSearchDataModel(json: WikiSearchsJSON)
                }
                else {
                    self.stopActivityIndicator()
                    
                    let alertController = UIAlertController(title: "Error", message: String(describing: (response.result.error?.localizedDescription)!), preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
            
        }
    }
    
    
    func updateWikiSearchDataModel(json : JSON) {
        
        wikiSearchDataModel.pageId = [Int]()
        wikiSearchDataModel.title = [String]()
        wikiSearchDataModel.desc = [String]()
        wikiSearchDataModel.thumbnail_url = [String]()
        
        for obj in (json["query"]["pages"].arrayValue) {
            wikiSearchDataModel.pageId.append(obj["pageid"].intValue)
            wikiSearchDataModel.title.append(obj["title"].stringValue)
            wikiSearchDataModel.desc.append(obj["terms"]["description"][0].stringValue)
            wikiSearchDataModel.thumbnail_url.append(obj["thumbnail"]["source"].stringValue)
           
        }
        
        if wikiSearchDataModel.pageId.count < 1{
            let alertController = UIAlertController(title: "Not Found", message: "No results found for the provided keyword", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        updateUIWithWikiSearchData()
    }
    
    
    
    func updateUIWithWikiSearchData() {
        gridCollectionView.reloadData()
        self.stopActivityIndicator()
        
    }
    
    
    func startActivityIndicator()
    {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        self.view.bringSubview(toFront: activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func stopActivityIndicator()
    {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wikiSearchDataModel.title.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GridCell
        cell.backgroundColor = UIColor.white
        cell.titleLabel.text = wikiSearchDataModel.title[indexPath.row]
        cell.descLabel.text = wikiSearchDataModel.desc[indexPath.row]
       
        if let imageUrl:URL = URL(string: wikiSearchDataModel.thumbnail_url[indexPath.row]){
            
            // Start background thread so that image loading does not make app unresponsive
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let imageData:NSData = NSData(contentsOf: imageUrl){
                    
                    // When from background thread, UI needs to be updated on main queue
                    DispatchQueue.main.async {
                        
                        let image = UIImage(data: imageData as Data)
                        cell.imageView.image = image
                        
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       // let cell = collectionView.cellForItem(at: indexPath) as! GridCell
        
        
        let newApi2 = apiString2.replacingOccurrences(of: "18630637" , with: String(wikiSearchDataModel.pageId[indexPath.row]))
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
        vc.apiString = newApi2
        navigationController?.pushViewController(vc,animated: true)
        
//        let webView = UIWebView(frame: UIScreen.main.bounds)
//        webView.delegate = self
//        view.addSubview(webView)
//        if let url = URL(string: newApi2) {
//            let request = URLRequest(url: url)
//            webView.loadRequest(request)
//        }
        
//        if let image = cell.imageView.image {
//            self.showProductFullView(of: image)
//        } else {
//            print("no photo")
//        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {()
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    
}
