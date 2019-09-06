//
//  ViewController.swift
//  DragNDrop
//
//  Created by hongjuyeon_dev on 29/08/2019.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var items: [String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.dragInteractionEnabled = true
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width-8)/3), height: ((collectionView.frame.width-8)/3))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imgString = items[indexPath.row]
        return cell
    }
}


extension ViewController: UICollectionViewDragDelegate{
    // create one or more UIDragItem objects for the item at the specified indexPath
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("item draging...")
        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension ViewController: UICollectionViewDropDelegate{
    // drag한 item을 새로운 위치에 놓았을 때 UICollectionViewDragDelegate에 알려주는 역할
    // dropSession: drag한 item의 정보를 가지고 있음
    // UICollectionViewDropProposal: collection view know how you intend to handle a drop at the currently specified location
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag{
            print("item will drop")
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    // drop이 끝나고 실행할 코드를 작성. cell이 경계에 있을지 없을지를 계산함.
    // Tells your delegate to incorporate the drop data into the collection view.
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(row: -1, section: 0)
        }
        
        if coordinator.proposal.operation == .move{
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView){
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {
            
            collectionView.performBatchUpdates({
                print("reordering..")
                items.remove(at: sourceIndexPath.item)
                items.insert(item.dragItem.localObject as! String, at: destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            print("reordering.. and drop")
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }

}

