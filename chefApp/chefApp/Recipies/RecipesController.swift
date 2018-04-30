//
//  RecipesController.swift
//  cs329
//
//  Created by Sai Kasam on 4/3/18.
//  Copyright © 2018 Sai Kasam. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "recipeCell"

class RecipesController: UICollectionViewController {
    var recipeArray_list = [Recipes]()
    var recipeArray2d  = [[Recipes]]()

    var API_KEY: String = ""
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        let attributes = [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Light", size: 24)!, NSAttributedStringKey.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = "Recipes"
        self.parent?.title = "Recipes"
        

        
        screenSize = self.view.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        layout.itemSize = CGSize(width: screenWidth/2 - 12, height: 230)
        print(screenWidth,screenHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        
        getData()
    }

    // To get the data from the food2forkapi call using Alamofire framework
    func getData()
    {
        Alamofire.request("https://food2fork.com/api/search?key=571b59e87af50037585a26ff3ad761eb&q=pizza").responseJSON {response in
            self.toObjects(data: response.data!)
        }
    }

    //converting the response data to recipe model object
    func toObjects(data: Data)
    {
        let recipeResult: [String:AnyObject]!
        do {
            recipeResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            let recipeArray =  recipeResult["recipes"] as! [AnyObject]
            
            //Obtaining arraylist of Recipes from the given dictionaryu array of recipes
            recipeArray_list = Recipes.modelsFromDictionaryArray(array: recipeArray as NSArray)
            recipeArray2d = convertTo2D(recipeArray_list)
            collectionView?.reloadData()
            
        } catch {
            print("Could not parse the data as JSON: '\(data)'")
            return
        }
        
    }

    func convertTo2D(_ recipeArray_list : [Recipes]) -> [[Recipes]] {
        //convert List into two d list
        var recipeArray2d = [[Recipes]]()
        var recipeIndex = 0
        print(recipeArray_list.count)
        
        for _ in 0..<(recipeArray_list.count)/2{
            var smallList = [Recipes]()

            smallList.append(recipeArray_list[recipeIndex])
            recipeIndex += 1
            smallList.append(recipeArray_list[recipeIndex])
            recipeIndex += 1
        
            recipeArray2d.append(smallList)
        }
        
        return recipeArray2d
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return   recipeArray_list.count / 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipesCollectionViewCell
    
        
        

        // Configure the cell
        let dish = recipeArray2d[indexPath.section][indexPath.row]
        cell.title.text = dish.title
        
        //Load Image icon
        let imageURL = URL(string: dish.image_url!)
        print(imageURL)
        Alamofire.request(imageURL!).responseJSON {response in
            let imageData = response.data!
            let downloadImage = UIImage(data: imageData)
            DispatchQueue.main.async {
                cell.image.image = downloadImage
            }
        }
        
    
        return cell
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


