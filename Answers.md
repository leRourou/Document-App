# Answers
> CHENU Adrien & ROUQUETTE Axel
## Partie 1 - Environnement de développement

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

