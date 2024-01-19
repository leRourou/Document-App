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

class DocumentTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let quickLookController = QLPreviewController()
    let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image])
    let fm = FileManager.default
    
    // MARK: Importation functionsÒ
    
    func getBundleFiles() -> [DocumentFile] {
        var bundleFiles = [DocumentFile]()
        
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") {
                let currentUrl = URL(fileURLWithPath: path + "/" + item)
                let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                
                bundleFiles.append(DocumentFile(
                    title: resourcesValues.name!,
                    size: resourcesValues.fileSize ?? 0,
                    imageName: item,
                    url: currentUrl,
                    type: resourcesValues.contentType!.description)
                )
            }
        }
        
        return bundleFiles
    }


    func getImportedFiles() -> [DocumentFile] {
        var importedFiles = [DocumentFile]()
                
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let items = try! fm.contentsOfDirectory(atPath: documentsDirectory.path)
            
            for item in items {
                if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") {
                    let currentUrl = documentsDirectory.appendingPathComponent(item)
                    let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                    
                    importedFiles.append(DocumentFile(
                        title: resourcesValues.name!,
                        size: resourcesValues.fileSize ?? 0,
                        imageName: item,
                        url: currentUrl,
                        type: resourcesValues.contentType!.description)
                    )
                }
            }
        }
        return importedFiles
    }
    
    // Get all files from every source
    
    func getAllFiles() -> [DocumentFile]{
        var allFiles = [DocumentFile]()
        for bunFile in getBundleFiles() {
            allFiles.append(bunFile)
        }
        for impFile in getImportedFiles() {
            allFiles.append(impFile)
        }
        return allFiles
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
    
    // MARK: TableView logic

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch section {
            case 0:
                return getBundleFiles().count
            case 1:
                return getImportedFiles().count
            default:
                return 0
            }
        }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

            var document: DocumentFile

            switch indexPath.section {
            case 0:
                document = getBundleFiles()[indexPath.row]
            case 1:
                document = getImportedFiles()[indexPath.row]
            default:
                fatalError("Invalid section")
            }

            cell.textLabel?.text = document.title;
            cell.detailTextLabel?.text = document.size.formattedSize()
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

            return cell
        }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
          let sectionName: String
          switch section {
              case 0:
                  sectionName = NSLocalizedString("Bundles", comment: "Bundles")
              case 1:
                  sectionName = NSLocalizedString("Importations", comment: "Importations")
              default:
                  sectionName = ""
          }
          return sectionName
      }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        
        var fileIndex = indexPath.row
        
        switch indexPath.section {
        case 1:
            fileIndex += getBundleFiles().count
        default:
            break
        }
        
        previewController.currentPreviewItemIndex = fileIndex
        navigationController?.pushViewController(previewController, animated: true)
    }
    
    func instantiateQLPreviewController(withUrl url: URL, indexpath indexPath: IndexPath) {
        quickLookController.currentPreviewItemIndex = indexPath.row
        present(quickLookController, animated: true, completion: nil)
    }
}

// MARK: Query Look

extension DocumentTableViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return getAllFiles().count
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let file = getAllFiles()[index]
        return file.url as QLPreviewItem
    }
}

// MARK: Document Picker

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
