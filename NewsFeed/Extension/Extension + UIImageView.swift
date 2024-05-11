//
//  Extension + UIImageView.swift
//  NewsFeed
//
//  Created by paytalab on 5/9/24.
//

import UIKit
import CoreData

extension UIImageView {
    @MainActor
    func setImage(imageURLSring: String) {
        Task { [weak self] in
            if let fetchedImage = await self?.getImage(imageURLSring: imageURLSring) {
                self?.image = fetchedImage
            }
        }
    }
    
    private func getImage(imageURLSring: String) async -> UIImage? {
        let convertedURLString = imageURLSring.replacingOccurrences(of: "http://", with: "https://")
        if let image = getImageCoreData(imageURLSring: imageURLSring) {
            return image
        }
        do {
            guard let url = URL(string: convertedURLString) else { return nil }
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                saveImageCoreData(imageURLSring: imageURLSring, image: image)
                return image
            } else {
                return nil
            }
            
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
   
    private func saveImageCoreData(imageURLSring: String, image: UIImage) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let viewContext = appDelegate?.persistentContainer.viewContext,
              let entity = NSEntityDescription.entity(forEntityName: "Image", in: viewContext) else { return }
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        let imageObject = NSManagedObject(entity: entity, insertInto: viewContext)
        imageObject.setValue(imageData, forKey: "imageData")
        imageObject.setValue(imageURLSring, forKey: "imageURL")
        do {
            try viewContext.save()
        } catch let error {
            print("saveImageCoreData Error - \(error)")
        }
        
    }
    
    private func getImageCoreData(imageURLSring: String) -> UIImage? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let viewContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageURL == %@", imageURLSring)
        do {
            let photos = try viewContext.fetch(fetchRequest)
            if let imageData = photos.first?.imageData {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        } catch let error {
            print("getImageCoreData Error - \(error)")
            return nil
        }
    }
}
