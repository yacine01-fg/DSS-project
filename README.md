# 🚉 RailwayDSS: Système de Gestion de Voyages

![RailwayDSS](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)
![Flask](https://img.shields.io/badge/Flask-3.0-black?style=for-the-badge&logo=flask)
![XML](https://img.shields.io/badge/Data-XML-orange?style=for-the-badge)

Une application web moderne pour la gestion et la visualisation des voyages ferroviaires en Algérie. Ce projet utilise une architecture basée sur Flask et exploite des fichiers XML pour le stockage et l'analyse des données (via **DOM** et **ElementTree**).

## ✨ Fonctionnalités

- 🔎 **Recherche Avancée** : Filtrez les voyages par code, ville de départ/arrivée, type de train et prix maximum.
- 📊 **Statistiques Dynamiques** : Analyse en temps réel de la flotte et des tarifs (moins cher / plus cher) par ligne.
- 🎫 **Détails Haute Fidélité** : Consultation approfondie des classes (VIP, Première, Éco) et des services.
- 🎨 **Interface Premium** : Design moderne avec Glassmorphism, typographie Outfit et animations fluides.
- 🛠️ **Parsing Hybride** : Utilisation combinée de `xml.dom.minidom` (affichage) et `xml.etree.ElementTree` (calculs).

## 🚀 Installation & Lancement

### 1. Cloner le dépôt
```bash
git clone https://github.com/votre-username/RailwayDSS.git
cd RailwayDSS
```

### 2. Créer un environnement virtuel
```bash
python -m venv venv
# Sur Windows
venv\Scripts\activate
# Sur macOS/Linux
source venv/bin/activate
```

### 3. Installer les dépendances
```bash
pip install -r requirements.txt
```

### 4. Lancer l'application
```bash
python app.py
```
L'application sera accessible sur `http://127.0.0.1:5000`.

## 📂 Structure du Projet

- `app.py` : Serveur Flask et logique de parsing XML.
- `transport.xml` : Base de données XML contenant les voyages.
- `Templates/` : Fichiers HTML (Jinja2) avec design system intégré.
- `static/` : Assets statiques (le cas échéant).

## 🛠️ Technologies

- **Backend** : Python 3.x, Flask
- **Frontend** : HTML5, CSS3 (Vanilla + Glassmorphism), Jinja2
- **Data** : XML (Parsing via DOM & ElementTree)

---
*Projet réalisé dans le cadre du module DSS (Decision Support Systems).*
