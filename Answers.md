# Answers
> CHENU Adrien & ROUQUETTE Axel

## Partie 1 - Environnement de développement


### Exercice 1
#### Les targets
Les targets sont les cibles de l'application, c'est à dire un ensemble de paramètres de configuration définissant ce que le proje doit construire. Par exemple si il s'agit d'une bibliothèque, d'un framework, ou encore la destination: si il s'agit d'une application MacOS, WatchOS ou mobile, mais aussi la version de l'application (iOS 16, 17, etc.), sa catégorie, etc.
Il est important de noter qu'un projet peut contenir un ou plusieurs targets.
Les targets et leur configuration peuvent défini en ouvrant le fichier <nomduprojet>.xcodeproj dans XCode.
#### Les fichiers
**AppDelegate** : Il s'agit du point d'entrée de l'application, il est responsable de l'état global de l'application et de son cycle de vie. Il a également pour but l'initialisation de l'application et la mise en place des *ViewController* initiaux.
**SceneDelegate** : Le SceneDelegate est responsable de la mise en place des interfaces utilisateurs initiales pour chaque scène et de réagir aux changements dans les scènes.
**ViewController** : Chaque écran est un ViewController, responsable de la gestion de l'interface de l'application. Celui-ci est le ViewController initial.
#### Les assets
Les assets est le nom donné à toutes les ressources de l'application : images, icônes, couleurs, etc. Ils sont accessibles en cliquant sur "assets" dans le gestionnaire de fichiers de XCode
#### Ouvrir le storyboard
Les fichiers de type "Storyboard" permettent de définir la navigation de l'application : comment les vues sont connectées entre elles.
On peut créer un fichier "StoryBoard" en effectuant un clic-droit puis dans le gestionnaire de fichier d'XCode, puis "New" et enfin de choisir le type de fichier "Storyboard".
#### Ouvrir un simulateur
Les simulateurs sont des émulateurs d'appareils faisant tourner notre application développée sur XCode.
On peut configurer un nouveau simulateur en choisissant Window > Devices and simulators puis en sélectionnant l'onglet "Simulators". Nous est alors affiché une liste de modèles d'appareils développés par Apple (tablettes, téléphones, montres), ainsi que différentes versions d'OS.
On peut ensuite choisir le simulateur sur lequel on souhaites faire tourner notre application pour le débug et la prévue.
#### Lancer une application sur le simulateur
On appuie sur le bouton "Run"

### Exercice 2
#### A quoi sert le raccourci `CMD + R`
Cela permet de construire (build) le projet.
#### A quoi sert le raccourci `CMD + SHIFT + 0`
Cela permet d'ouvrir la document d'XCode.
#### Trouver le raccourci pour indenter le code automatiquement
Il s'agit du raccourci `CMD + I`
#### Et celui poru commenter la sélection
Il s'agit du raccourci `CMD + /`

### Exercice 3
/


## Partie 3 - Délégation
### Exercice 1
L'intérêt d'utiliser une propriété statique, est que l'on a pas besoin de créer une instance de la classe pour accèder à la propriété.

### Exercice 2
```swift
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DocumentFile.documentList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = DocumentFile.documentList[indexPath.row].title
        content.secondaryText = String(DocumentFile.documentList[indexPath.row].size)
        cell.contentConfiguration = content
        
        return cell
    }
```

Si `dequeueReusableCell` est aussi important pour les performances de l'application, c'est parce qu'au lieu de créer chaque cellule et de les afficher de manière sélective, il ne créé qu'une poignée de cellules, suffisamment pour remplir l'écran et un peu plus. Au fur et à mesure du défilement, nous réutilisons les cellules en dehors de l'écran, ce qui permet d'économiser de la mémoire.
### Exercice 3
On va créer une extension de type `Int64` car c'est le type du paramètre `fromByteCount` accepté par la méthode `string` de la classe `ByteCountFormatter` que nous allons utiliser.
Le type `Int64` contenant toutes les valeurs du type `Int`, cela ne pose pas de problème.
```swift
extension Int64{
    func formattedSize() -> String{
        return ByteCountFormatter.string(fromByteCount: self, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
}
```
On applique alors la modification dans la méthode `tableView`
```swift
content.secondaryText = DocumentFile.documentList[indexPath.row].size.formattedSize()
```


## Partie 4 - Navigation
### Exercice 1
TODO!!!!!!


## Partie 5 - Bundle
### Exercice 1
```swift
 func listFileInBundle() -> [DocumentFile] {
        // On instancie un objet de type FileManager permettant d'effectuer des actions sur le sytème de fichier
        let fm = FileManager.default
        // On obtient le path des "resources"
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // On Initialise la liste de documents
        var documentListBundle = [DocumentFile]()
    
        // Pour chaque fichier trouvé dans "items"
        for item in items {
            // On prends les fichers qui n'ont pas le suffixe DS_Store et on le suffixe .jpg
            if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") {
                // On instancie un objet de type URL qui sera le path de notre fichier (son dossier parent / son nom)
                let currentUrl = URL(fileURLWithPath: path + "/" + item)
                // On récupère des informations importantes sur le fichier avec la méthode "resourceValues" de la classe URL
                let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                   
                // On ajoute à la liste initialement créé un objet de type DocumentFile avec comme propriétés les informations récupérés précedemment.
                documentListBundle.append(DocumentFile(
                    title: resourcesValues.name!,
                    size: resourcesValues.fileSize ?? 0,
                    imageName: item,
                    url: currentUrl,
                    type: resourcesValues.contentType!.description)
                )
            }
        }
        return documentListBundle
    }
```


## Partie 6 - Créer l’écran de détail
### Exercice 1
Un `Segue` permet de définir une transition entre deux `ViewController`.

### Exercice 2
Une `constraint` est une distance permettant de définir le placement d'un élément de l'UI. Quand à l'`AutoLayout `, il permet de créer des contraintes qui définissent des relations entre deux vues; on précise à l'`AutoLayout` des informations pour qu'il puisse modifier la position et la taille de nos vues en fonction de la taille de l'écran: ces informations sont les contraintes.


## Partie 9 - QLPrview
### Exercice 1
#### Questions
Il serait pertinent d'utiliser un `disclosureIndicator` pour indiquer qu'une cellule est cliquable et qu'elle mènera à une autre vue de l'application. Cela offre une indication visuelle aux utilisateurs que la cellule est interactive. De plus, cela permet de suivre les conventions de conception d'Apple pour les applications iOS. Les utilisateurs d'iOS s'attendent à voir cette flèche pour indiquer la navigation ou l'accès à plus d'informations.
