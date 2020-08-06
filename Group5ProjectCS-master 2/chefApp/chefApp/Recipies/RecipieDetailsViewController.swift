//
//  RecipeDetailViewController.swift
//  chefApp
//
//  Created by Sai Kasam on 4/29/18.
//  Copyright © 2018 cs329e. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var image2: UIImageView!
    var titleVar = ""
    var imageVar: UIImage = #imageLiteral(resourceName: "image1")
    var imageUrl = ""
    var ingredientsUrl = ""
    var directionsUrl = ""
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBAction func directions(_ sender: Any) {
        UIApplication.shared.open(URL(string : directionsUrl)!, options: [:], completionHandler: { (status) in
            
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //        ingredientsLabel.sizeToFit()
        titleLbl.text = titleVar

        titleVar = titleVar.components(separatedBy: " ")[0]
        if (titleVar.last! == ","){
            titleVar = titleVar.substring(to: titleVar.index(before: titleVar.endIndex))
        }
        self.title = titleVar
        
        image2.setRounded2()
        image.setRounded()
        //titleLbl.text = titleVar
        Alamofire.request(imageUrl).responseJSON {response in
            let imageData = response.data!
            let downloadImage = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.image.image = downloadImage!
            }
        }
        
        Alamofire.request( ingredientsUrl, method: .get)
            .responseString { response in
                let responseHtml: String = response.result.value!
                //                print("Response String: \(String(describing: response.result.value))")
                
                
                
                
                do {
                    let html: String = responseHtml
                    let doc: Document = try! SwiftSoup.parse(html)
                    
                    let link: Element = try! doc.select("a").first()!
                    
                    let text: String = try! doc.body()!.text(); // "An example link"
                    let linkHref: String = try! link.attr("href"); // "http://example.com/"
                    let linkText: String = try! link.text(); // "example""
                    
                    let linkOuterH: String = try! link.outerHtml(); // "<a href="http://example.com"><b>example</b></a>"
                    let linkInnerH: String = try! link.html(); // "<b>example</b>"
                    
                    let elements = try doc.select("[itemprop=\"ingredients\"]")
                    print(elements)
                    
                    var allIng = ""
                    var elementsCount = 3
                    for x in elements{
                        var text = try x.text()
                        print(text)
                        allIng += text + "\n"
                        elementsCount += 1
                    }
                    print(elementsCount)
                    self.ingredientsLabel.numberOfLines = elementsCount
                    self.ingredientsLabel.text = allIng
                } catch Exception.Error(let type, let message) {
                    print(message)
                } catch {
                    print("error")
                }
                
                
                
        }
        
        
    }
    
    
    
    
    
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
extension UIImageView {
    
    func setRounded() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = true
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 3).cgPath
    }
    func setRounded2() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 3
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        //        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 3).cgPath
    }
}

