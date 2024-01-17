//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Adrien CHENU on 1/17/24.
//

import UIKit
import QuickLook

extension Int{
    func formattedSize() -> String{
        return ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: ByteCountFormatter.CountStyle.decimal)
    }
}

struct DocumentFile{
    var title: String
    var size: Int
    var imageName: String? = nil
    var url: URL
    var type: String
}

enum Sections: CaseIterable{
    case Importés;
    case Bundle;
    
    func getValue()->String {
        switch self {
        case .Importés: return "Importés"
        case .Bundle: return "Bundle"
        }
    }
}


class DocumentTableViewController: UITableViewController {
    let quickLookController = QLPreviewController()
    let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image])
    let fm = FileManager.default

    
    func getAllSections() -> [String] {
        return Sections.allCases.map({$0.getValue()})
    }
    
    func listAllFiles() -> [[DocumentFile]] {
        
        let fm = FileManager.default // Initailisation de la gestion des fichiers
        let path = Bundle.main.resourcePath! // Indication du chemin vers DocumentApp
        let items = try! fm.contentsOfDirectory(atPath: path) // Récupération de toutes les images
        
       
         var documentListBundle = [DocumentFile]()

         // Parcourir les fichiers dans le répertoire des documents
         if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
             let items = try! fm.contentsOfDirectory(atPath: documentsDirectory.path)
             
             for item in items {
                 if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") {
                     let currentUrl = documentsDirectory.appendingPathComponent(item)
                     let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                     
                     documentListBundle.append(DocumentFile(
                         title: resourcesValues.name!,
                         size: resourcesValues.fileSize ?? 0,
                         imageName: item,
                         url: currentUrl,
                         type: resourcesValues.contentType!.description)
                     )
                 }
             }
         }
        
        var documentListImportes = [DocumentFile]()

        for item in items { // Boucle sur chaque image
            if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") { // On filtre les images
                let currentUrl = URL(fileURLWithPath: path + "/" + item) // On récupére les propriétés de l'image
                let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                documentListImportes.append(DocumentFile(
                    title: resourcesValues.name!,
                    size: resourcesValues.fileSize ?? 0,
                    imageName: item,
                    url: currentUrl,
                    type: resourcesValues.contentType!.description) // On crée un objet DocumentFile avec les données que nous avons
                                          // récupéré
                )
            }
        }
        return [documentListBundle, documentListImportes]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quickLookController.dataSource = self;
        documentPicker.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importDoc))
    }
    
    @objc func importDoc() {
        present(documentPicker, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAllFiles()[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.getAllSections()[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAllFiles().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        let document = listAllFiles()[0][indexPath.row]
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = document.size.formattedSize()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previewController = QLPreviewController()
                previewController.dataSource = self
                previewController.currentPreviewItemIndex = indexPath.row
                navigationController?.pushViewController(previewController, animated: true)
    }
    
    func instantiateQLPreviewController(withUrl url: URL, indexpath indexPath: IndexPath) {
        quickLookController.currentPreviewItemIndex = indexPath.row
        present(quickLookController, animated: true, completion: nil)
    }
}

extension DocumentTableViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return listAllFiles().count
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let file = listAllFiles()[0][index]
        return file.url as QLPreviewItem
    }
}

extension DocumentTableViewController: UIDocumentPickerDelegate {
    
    func copyFileToDocumentsDirectory(fromUrl url: URL) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
            do {
                try FileManager.default.copyItem(at: url, to: destinationUrl)
            } catch {
                print(error)
            }
        }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            for url in urls {
                copyFileToDocumentsDirectory(fromUrl: url)
                self.tableView.reloadData()
            }
        }
        
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
}
