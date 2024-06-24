//
//  ViewController.swift
//  GameTest
//
//  Created by Charlie Gottlieb on 6/6/24.
//


//NEXT TODO: make card selection. Can do so in some makeshift manner before moving on to any display

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var turnImage: UIImageView!
    
    var p0Score = 0
    var p1Score = 0
    
    var selectedItem: BoardItem = BoardItem(indexPath: IndexPath.init(item: 5, section: 5), tile: Tile.Empty, sensei: false)
    var selectedItemRow = -1
    var selectedItemCol = -1
    var (selectedCard, cardList) = makeCardList()
    var selectedCardNum = 0
    
    @IBOutlet weak var card0: UIButton!
    @IBOutlet weak var card1: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetBoard()
        setCellWidthHeight()
        
        card0.setImage(UIImage(named: "\(cardList[0])"), for: .normal)
        card1.setImage(UIImage(named: "\(cardList[1])"), for: .normal)
    }
    
    func setCellWidthHeight() {
        let width = collectionView.frame.size.width / 6
        let height = collectionView.frame.size.height / 5
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func numberOfSections(in cv: UICollectionView) -> Int {
        return board.count
    }
    
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return board[section].count
    }
    
    // ---- COLLECTION VIEW ----

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! BoardCell
        
        let boardItem = getBoardItem(indexPath)
        cell.image.tintColor = boardItem.tileColor()
        cell.image.image = boardItem.sensei ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle.fill")
        
        return cell
    }
    
    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.section
        let col = indexPath.item
        let boardItem = board[row][col]
        
        if (boardItem.tile == currentTurnTile()) {
            print("Piece at r\(row) c\(col)")
            selectedItem = boardItem
            selectedItemRow = row
            selectedItemCol = col
            
        } else {
            if let cell = collectionView.cellForItem(at: boardItem.indexPath) as? BoardCell { // selected spot
                if selectedCard.getLegalTiles(board, pieceRow: selectedItemRow, pieceCol: selectedItemCol).contains(where: { $0 == (row, col) }) {
                    //--move is legal
                    print("Place: r\(row) c\(col)")
                    
                    placePiece(cell: cell, piece: selectedItem, origRow: selectedItemRow, origCol: selectedItemCol, newRow: row, newCol: col)
    
                    let oldCell = collectionView.cellForItem(at: selectedItem.indexPath) as! BoardCell
                    
                    oldCell.image.tintColor = UIColor.white
                    oldCell.image.image = UIImage(systemName: "circle.fill")
                    
                    if victoryAchieved() {
                        if p0Turn() {
                            p0Score += 1
                        } else {
                            p1Score += 1
                        }
                        
                        resultAlert(currentTurnVictoryMessage())
                    }
                    
                    swapCards(cardList: &cardList, selection: p0Turn() ? selectedCardNum : 4)
                    toggleTurn(turnImage)
                    
                    selectedCard = cardList[p0Turn() ? 0 : 4]
                }
            }
        }
        collectionView.reloadData()
        refreshImages()
    }
    
    func drawCell(cell: BoardCell, boardItem: BoardItem) {
        cell.image.tintColor = boardItem.tileColor()
        cell.image.image = boardItem.sensei ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle.fill")
    }
    
    // ---- CARD BUTTONS -----
    
    @IBAction func card0Tapped(_ sender: UIButton) {
        if p0Turn() {
            selectedCard = cardList[0]
            selectedCardNum = 0
            print("card0: \(selectedCard)")
        }
        
    }

    @IBAction func card1Tapped(_ sender: UIButton) {
        if p0Turn() {
            selectedCard = cardList[1]
            selectedCardNum = 1
            print("card1: \(selectedCard)")
        }
    }
    
    
    func resultAlert(_ title: String) {
        let message = "\nPlayer 0: \(p0Score)\n\nPlayer1: \(p1Score)"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: {
            [self] (_) in
            resetBoard()
            self.resetCells()
        }))
        self.present(ac, animated: true)
       
    }
    
    func resetCells() {
        for row in 0...4 {
            for col in 0...4 {
                let boardItem = board[row][col]
                if let cell = collectionView.cellForItem(at: boardItem.indexPath) as? BoardCell {
                    drawCell(cell: cell, boardItem: boardItem)
                }
            }
        }
            
            
//        for cell in collectionView.visibleCells as! [BoardCell] {
//            drawCell(cell: cell, indexPath: )
//        }
    }
    
    
    func refreshImages() {
        card0.setImage(UIImage(named: "\(cardList[0])"), for: .normal)
        card1.setImage(UIImage(named: "\(cardList[1])"), for: .normal)
    }

}





/*

if boardItem.emptyTile() {
    if let cell = collectionView.cellForItem(at: boardItem.indexPath) as? BoardCell {
        cell.image.tintColor = currentTurnColor()
        boardItem.tile = currentTurnTile()
        updateBoardWithBoardItem(boardItem)
        
        if victoryAchieved() {
            if yellowTurn() {
                yellowScore += 1
            } else {
                redScore += 1
            }
            
            resultAlert(currentTurnVictoryMessage())
        }
        
        if boardIsFull() {
            resultAlert("Draw")
        }
        
        toggleTurn(turnImage)
        
    }
}
 */
