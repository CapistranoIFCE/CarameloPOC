//
//  GameScene.swift
//  CarameloPOC
//
//  Created by Davi Capistrano on 23/03/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var level = 1
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?

    override func didMove(to view: SKView) {

        let background = SKSpriteNode(imageNamed: "background")
        //background.scale(to: CGSize(width: 1820, height: 1200))
        background.name = "background"
        background.zPosition = -1
        addChild(background)

        createGrid()
        createLevel()

    }

    //    let array: [CGPoint] = [
    //        CGPoint(x: 0, y: 0),
    //        CGPoint(x: 0, y: 10)
    //    ]

    func createGrid() {

        let minX = -self.size.width/2 + 10
        let maxX = self.size.width/2 - 10

        let minY = -self.size.height/2 + 50
        let maxY = self.size.height/2 - 70

        let item = SKSpriteNode(imageNamed: "caramelo")
        item.size = CGSize(width: 50, height: 25)
        item.position = CGPoint(x: CGFloat.random(in: minX...maxX), y: CGFloat.random(in: minY...maxY))

        //item.position = array.randomElement()!
                addChild(item)


    }
    func createLevel(){

        var itemsToShow = 5 + (level * 4)

        let items = children.filter { $0.name != "background" }

        let shuffled = (items as NSArray).shuffled() as!  [SKSpriteNode]

        for item in shuffled {
            item.alpha = 0
        }

        let animals = ["caramelo"]
        var shuffledAnimals = (animals as NSArray).shuffled() as! [String]

        let correct = shuffledAnimals.removeLast()

        var showAnimals = [String]()
        var placingAnimal = 0
        var numUsed = 0

        for _ in 1 ..< itemsToShow {
            numUsed += 1

            if numUsed == 2 {
                numUsed = 0
                placingAnimal += 1
            }

            if placingAnimal == shuffledAnimals.count {
                placingAnimal = 0
            }
        }

        for (index, animal) in showAnimals.enumerated(){
            let item = shuffled[index]

            item.texture = SKTexture(imageNamed: animal)

            item.alpha = 1

            item.name = "wrong"
        }

        shuffled.last?.texture = SKTexture(imageNamed: correct)
        shuffled.last?.alpha = 1
        shuffled.last?.name = "correct"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return }

        if tapped.name == "correct" {
            correctAnswer(node: tapped)
        } else if tapped.name == "wrong" {
            print("Whrong!")
        }
    }

    func correctAnswer(node: SKNode){

        if let sparks = SKEmitterNode(fileNamed: "Sparks"){

            sparks.position = node.position
            addChild(sparks)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                sparks.removeFromParent()
                self.level += 1
                self.createLevel()
            }

            let scaleUp = SKAction.scale(to: 2, duration: 0.5)
            let scaleDown = SKAction.scale(to: 1, duration: 0.5)
            let sequence = SKAction.sequence([scaleUp, scaleDown])
            node.run(sequence)
        }
    }
}
