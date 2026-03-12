# 🚀 Space Shooter – Projet Godot 4

## Structure du projet

```
shooter_godot/
├── project.godot          # Fichier de configuration Godot
├── scenes/
│   ├── Main.tscn          # Scène principale (point d'entrée)
│   ├── Player.tscn        # Vaisseau du joueur
│   ├── Bullet.tscn        # Projectile (joueur & ennemis)
│   ├── EnemyBasic.tscn    # Ennemi de base (descend tout droit)
│   ├── EnemyZigzag.tscn   # Ennemi rapide (trajectoire sinusoïdale)
│   └── EnemyShooter.tscn  # Ennemi tireur (lent mais tire)
└── scripts/
    ├── Main.gd            # Logique principale + spawn des vagues
    ├── Player.gd          # Mouvement, tir, HP, score
    ├── Enemy.gd           # Comportement des 3 types d'ennemis
    ├── Bullet.gd          # Projectile (direction auto selon camp)
    └── HUD.gd             # Affichage score, HP, vague
```

## Comment ouvrir dans Godot

1. Télécharge **Godot 4.2+** sur https://godotengine.org
2. Lance Godot → **"Importer"** → sélectionne le dossier `shooter_godot/`
3. Lance le projet avec **F5** (ou le bouton Play ▶)

## Contrôles

| Touche | Action |
|--------|--------|
| `ZQSD` / Flèches | Déplacer le vaisseau |
| `Espace` / Clic gauche | Tirer |

## Gameplay

- **5 points de vie** → les ennemis touchent = -1 HP → invulnérabilité 1.5s
- **3 types d'ennemis** qui apparaissent au fur et à mesure des vagues :
  - 🔴 **Basic** (dès vague 1) : descend en ligne droite, 100 pts
  - 🟣 **Zigzag** (dès vague 2) : trajectoire sinusoïdale, 150 pts
  - 🟢 **Shooter** (dès vague 3) : tire vers le joueur, 200 pts
- **Vagues infinies** : chaque vague a +2 ennemis et un spawn plus rapide
- **Game Over** → score final + vague atteinte + bouton Recommencer

## Comment étendre le projet

### Ajouter des sprites
Remplace les `ColorRect` et `Polygon2D` dans les scènes par des `Sprite2D` pointant vers tes images PNG.

### Ajouter des effets de mort
Dans `Enemy.gd` → `_die()`, instancie une scène de particules avant `queue_free()`.

### Ajouter de la musique
Dans `Main.tscn`, ajoute un nœud `AudioStreamPlayer` avec `autoplay = true`.

### Ajouter un boss
Crée une nouvelle scène `Boss.tscn` avec `Enemy.gd` et augmente ses stats. Spawne-le toutes les 5 vagues dans `Main.gd`.
