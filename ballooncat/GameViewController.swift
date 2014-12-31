//
//  GameViewController.swift
//  ballooncat
//
//  Created by Alfred on 14-8-28.
//  Copyright (c) 2014年 HackSpace. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController{
    @IBOutlet weak var gameOverView: UIView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    var userDefault = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameOverView.hidden = true

        /* Pick a size for the scene */

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gameOver", name: "gameOverNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pause", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resume", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        //        let scene = GameScene(fileNamed:"GameScene")
        let scene = GameScene(size: CGSizeMake(320,568))
        // Configure the view.
        let skView = self.view as SKView
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func pause(){
        var skView = self.view as SKView
        skView.paused = true
    }
    
    func resume(){
        var skView = self.view as SKView
        skView.paused = false
    }
    
    func gameOver(){
        gameOverView.hidden = false
        totalScoreLabel.text = String(userDefault.integerForKey("total"))
        bestScoreLabel.text = String(userDefault.integerForKey("best"))

    }
    
    @IBAction func restartGame(sender: UIButton) {
        sender.superview?.hidden = true
        //        let scene = GameScene(fileNamed:"GameScene")
        let scene = GameScene(size: CGSizeMake(320,568))
        // Configure the view.
        let skView = self.view as SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        skView.paused = false
    }
    
    @IBAction func share(sender: UIButton) {
        //share game
    }
}
