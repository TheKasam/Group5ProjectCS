//
//  RecipesController.swift
//  cs329
//
//  Created by Sai Kasam on 4/3/18.
//  Copyright © 2018 Sai Kasam. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import HCSStarRatingView

private let reuseIdentifier = "recipeCell"

class RecipesController: UICollectionViewController {
    var recipeArray_list = [Recipes]()
    var recipeArray2d  = [[Recipes]]()
    var alertController:UIAlertController? = nil
    var loginTextField: UITextField? = nil
    var fridge: [String] = []
    
    var API_KEY: String = ""
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let uid = Auth.auth().currentUser?.uid
        let databaseRef = Database.database().reference().child("users").child(uid!).child("fridge")
        databaseRef.observe(.value, with: {snapshot in
            var newItems:[String] = []
            var newRefs:[String] = []
            let groceries = snapshot.value as? [String : AnyObject] ?? [:]
            for i in groceries {
                newRefs.append(i.key)
                newItems.append(i.value as! String)
            }
            self.fridge = newItems
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.getData()
                
            })

        })
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.42, blue:0.42, alpha:0.58)



        // Register cell classes
        
        let attributes = [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Medium", size: 24)!, NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = "Recipes"
        self.parent?.title = "Recipes"
        
        
        
        screenSize = self.view.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        layout.itemSize = CGSize(width: screenWidth/2 - 12, height: 230)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            
        })
        
    }
    
    @IBOutlet weak var reload: UIBarButtonItem!
    
    @IBAction func reload(_ sender: Any) {
        
        
        
        self.getData()
        
        
    }
    
    
    @IBAction func search(_ sender: Any) {
        self.alertController = UIAlertController(title: "Search All Recipes", message: "Enter text to search all recipes:", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            var ing = self.loginTextField?.text?.components(separatedBy: " ")
            var q = ""
            for x in ing!{
                q += x + ","
            }
            
            
            Alamofire.request("https://food2fork.com/api/search?key=571b59e87af50037585a26ff3ad761eb&q="+q).responseJSON {response in
                self.toObjects(data: response.data!)
            }
            
            print("Ok Button Pressed 2")
            print("You entered \(self.loginTextField!.text!)")
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
            print("Cancel Button Pressed 2")
        }
        
        self.alertController!.addAction(ok)
        self.alertController!.addAction(cancel)
        
        self.alertController!.addTextField { (textField) -> Void in
            // Enter the textfield customization code here.
            self.loginTextField = textField
            self.loginTextField?.placeholder = "Enter ingredients"
        }
        
        present(self.alertController!, animated: true, completion: nil)
    }
    
    // To get the data from the food2forkapi call using Alamofire framework
    func getData()
    {
        var q = ""
        for x in fridge{
            q += x + ","
            print(x)
        }
        print(q)
        print(self.fridge)
        Alamofire.request("https://food2fork.com/api/search?key=571b59e87af50037585a26ff3ad761eb&q="+q).responseJSON {response in
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipesCollectionViewCell
        
        
        
        
        // Configure the cell
        let dish = recipeArray2d[indexPath.section][indexPath.row]
        let imageURL = URL(string: dish.image_url!)
        cell.title.text = dish.title
        print(dish.social_rank)
        cell.stars.value = CGFloat(randomNumber(MIN: 3,MAX: 6))
        //        cell.stars.value = CGFloat(dish.social_rank! / 20)
        
        //Load Image icon

        Alamofire.request(imageURL!).responseJSON {response in
            let imageData = response.data!
            let downloadImage = UIImage(data: imageData)
            DispatchQueue.main.async {
                cell.image.image = downloadImage
            }
        }
        
        
        return cell
    }
    
    func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX-MIN)) + UInt32(MIN));
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("attempted")
        if let destinationVC = segue.destination as? RecipeDetailViewController{
            
            
            guard let indexPath = collectionView?.indexPath(for: sender as! UICollectionViewCell)! else {
                print("count get index path")
                return
            }
            
            destinationVC.titleVar =  recipeArray2d[indexPath.section][indexPath.row].title!
            destinationVC.imageUrl = recipeArray2d[indexPath.section][indexPath.row].image_url!
            destinationVC.ingredientsUrl = recipeArray2d[indexPath.section][indexPath.row].f2f_url!
            destinationVC.directionsUrl = recipeArray2d[indexPath.section][indexPath.row].source_url!
            
        } else {
            print("failed")
        }
        
        
    }
    
    var indexPathVar = 0
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        self.performSegue(withIdentifier: "id", sender: self)
        indexPathVar = indexPath.row
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



