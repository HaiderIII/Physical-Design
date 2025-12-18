# Quiz Answers - SYN_002 The Corner Chaos

---

## Question 1 : C
**Seul le corner typical était chargé, pas le corner slow**

Le script original ne chargeait que `sky130_fd_sc_hd__tt_025C_1v80.lib` (typical). Le corner typical représente des conditions nominales - il n'est pas représentatif des pires cas rencontrés en production.

---

## Question 2 : C
**Slow (ss) - car c'est le pire cas pour l'arrivée tardive**

Pour le setup, on vérifie que les données arrivent AVANT le front d'horloge. Le pire cas est quand les données arrivent le plus TARD possible → corner SLOW.

```
        Tclk
    ───┬─────────┬───
       │         │
       │  DATA   │
       │  ════►  │
       │ (slow)  │
    ───┴─────────┴───
                 ▲
                 Setup check ici
```

---

## Question 3 : B
**Fast (ff) - car c'est le pire cas pour l'arrivée précoce**

Pour le hold, on vérifie que les données ne changent PAS trop tôt après le front d'horloge. Le pire cas est quand les nouvelles données arrivent le plus TÔT possible → corner FAST.

```
        Tclk
    ───┬─────────┬───
       │         │
       │  NEW    │
       │  DATA   │
       │  ◄════  │
       │ (fast)  │
    ───┴─────────┴───
       ▲
       Hold check ici
```

---

## Question 4 : B
**Process, Voltage, Temperature**

Les variations PVT sont les trois sources principales de variation dans les circuits :
- **Process** : Variations de fabrication (slow, typical, fast)
- **Voltage** : Variations d'alimentation (1.40V, 1.80V, 1.95V)
- **Temperature** : Variations thermiques (-40°C, 25°C, 100°C)

---

## Question 5 : B
**ss = slow-slow process, n40C = -40°C, 1v40 = 1.40V**

Décomposition du nom :
- `sky130` : Technologie SkyWater 130nm
- `fd_sc_hd` : Foundry-provided Standard Cells High Density
- `ss` : Slow-Slow (NMOS slow, PMOS slow)
- `n40C` : Negative 40°C (-40°C)
- `1v40` : 1.40 Volts

---

## Question 6 : B
**Pour que l'outil choisisse automatiquement le bon corner selon l'analyse**

OpenROAD (et la plupart des outils STA) utilisent intelligemment les corners :
- `report_checks -path_delay max` → utilise le corner le plus lent
- `report_checks -path_delay min` → utilise le corner le plus rapide

Cela permet une analyse multi-corner en une seule session.

---

## Question 7 : B
**Le design a des marges insuffisantes et risque de ne pas fonctionner en production**

Un design qui passe en typical mais échoue en slow a des marges timing trop faibles. En production :
- Certains chips seront "slow" (variations de fabrication)
- La température peut atteindre des extrêmes
- L'alimentation peut fluctuer

**Un design signoff-clean doit passer dans TOUS les corners PVT.**

---

## Score

| Score | Niveau |
|-------|--------|
| 7/7 | Expert en timing multi-corner |
| 5-6/7 | Bonne compréhension, quelques détails à affiner |
| 3-4/7 | Concepts de base acquis, théorie à approfondir |
| <3/7 | Retravaillez les fondamentaux PVT |

---

## Pour aller plus loin

1. **MMMC (Multi-Mode Multi-Corner)** : En vrai signoff, on analyse plusieurs modes fonctionnels × plusieurs corners
2. **OCV (On-Chip Variation)** : Variations supplémentaires au sein d'un même chip
3. **AOCV/POCV** : Méthodes statistiques pour des marges plus réalistes
