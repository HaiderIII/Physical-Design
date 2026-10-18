# Questions d'Interview - Physical Design

## Guide de Préparation

Ce document compile les questions les plus fréquentes en interview pour les postes de Physical Design Engineer. Les questions sont organisées par niveau de difficulté et par thème.

---

## Table des Matières

1. [Questions Fondamentales](#1-questions-fondamentales)
2. [Synthèse](#2-synthèse)
3. [Floorplanning](#3-floorplanning)
4. [Placement](#4-placement)
5. [Clock Tree Synthesis](#5-clock-tree-synthesis)
6. [Routing](#6-routing)
7. [Static Timing Analysis](#7-static-timing-analysis)
8. [Power Analysis](#8-power-analysis)
9. [Signal Integrity](#9-signal-integrity)
10. [Physical Verification](#10-physical-verification)
11. [Questions Avancées](#11-questions-avancées)
12. [Questions Comportementales](#12-questions-comportementales)

---

## 1. Questions Fondamentales

### Q1.1: Décrivez le flow RTL-to-GDSII
**R:** Le flow RTL-to-GDSII comprend:

1. **Synthesis**: RTL → Gate-level netlist
2. **Floorplanning**: Définition du die/core, placement I/O et macros
3. **Placement**: Positionnement des cellules standard
4. **CTS**: Construction de l'arbre d'horloge
5. **Routing**: Interconnexions métalliques
6. **Signoff**: STA, DRC, LVS, power analysis
7. **GDSII**: Export du layout final

### Q1.2: Qu'est-ce qu'une cellule standard?
**R:** Une **cellule standard** est un bloc logique pré-conçu et pré-caractérisé:
- Hauteur fixe (pour s'aligner sur les rows)
- Largeur variable (multiples du site width)
- Fonctions: portes logiques, flip-flops, buffers
- Caractérisé en timing, power, area dans les fichiers Liberty (.lib)

### Q1.3: Expliquez les fichiers d'entrée/sortie du PD
**R:**

| Fichier | Type | Contenu |
|---------|------|---------|
| **.v** | Verilog | Netlist (entrée/sortie) |
| **.lib** | Liberty | Timing, power des cellules |
| **.lef** | LEF | Géométrie des cellules et tech |
| **.def** | DEF | Placement et routage |
| **.sdc** | SDC | Contraintes de timing |
| **.spef** | SPEF | Parasitics extraits |
| **.gds** | GDSII | Layout final |

### Q1.4: Qu'est-ce que le PVT?
**R:** **PVT** = Process, Voltage, Temperature - les trois sources de variation:

- **Process**: Variations de fabrication (fast/typical/slow)
- **Voltage**: Fluctuations d'alimentation (±10%)
- **Temperature**: Plage d'opération (-40°C à 125°C)

Le design doit fonctionner dans tous les **corners PVT**.

### Q1.5: Différence entre front-end et back-end design?
**R:**
- **Front-end**: Design logique (RTL, vérification fonctionnelle, synthèse)
- **Back-end**: Design physique (floorplan → GDSII)

Le Physical Design fait partie du **back-end**.

---

## 2. Synthèse

### Q2.1: Qu'est-ce que le technology mapping?
**R:** Le **technology mapping** convertit la représentation logique abstraite (AND, OR, NOT) en cellules physiques de la librairie standard (NAND2_X1, NOR3_X2), en optimisant selon les contraintes d'area, timing ou power.

### Q2.2: Comment fonctionne la synthèse multi-Vt?
**R:** Les PDKs offrent plusieurs types de transistors:
- **HVT**: High-Vt, faible leakage, plus lent
- **RVT**: Regular-Vt, balance
- **LVT**: Low-Vt, rapide, high leakage

La synthèse choisit:
- **HVT** sur chemins non-critiques (70%)
- **LVT** sur chemins critiques (10-20%)

### Q2.3: Qu'est-ce que le clock gating?
**R:** Le **clock gating** désactive le clock des registres inactifs:

```
            ICG Cell
    clk ───→│ Latch+AND │──→ gated_clk ──→ FF
    enable ─┘
```

**Avantages**: Réduction de 30-50% de la power dynamique du clock.

### Q2.4: Expliquez la différence entre scan insertion et ATPG
**R:**
- **Scan insertion**: Connecte les flip-flops en chaîne pour la testabilité
- **ATPG** (Automatic Test Pattern Generation): Génère les vecteurs de test

Scan permet d'observer et contrôler tous les registres.

---

## 3. Floorplanning

### Q3.1: Comment calculer l'utilization?
**R:**
```
Utilization = (Cell Area + Macro Area) / Core Area × 100%

Target:
- 50-60%: Facile à router
- 60-70%: Standard
- >75%: Risque de congestion
```

### Q3.2: Comment placer les macros optimalement?
**R:**
1. **Périphérie**: Macros sur les bords du core
2. **Pins vers l'intérieur**: Facilite le routage
3. **Grouping**: Macros connectées ensemble
4. **Channels**: Espace entre macros pour le routage
5. **Flylines**: Visualiser les connexions avant placement

### Q3.3: Qu'est-ce que le halo/blockage?
**R:**
- **Halo**: Zone d'exclusion autour d'une macro (pas de cellules standard)
- **Placement blockage**: Zone interdite pour les cellules
- **Routing blockage**: Zone interdite pour le routage (certaines couches)

### Q3.4: Expliquez la structure du PDN
**R:** Le **Power Distribution Network**:

```
Rails (M1) → Straps (M3-M5) → Rings → Pads
```

- **Rails**: Alimentent les cellules (VDD/VSS)
- **Straps**: Distribution verticale/horizontale
- **Rings**: Encadrent le core
- **Vias**: Connexions entre couches

### Q3.5: Pourquoi utiliser des tap cells?
**R:** Les **tap cells** connectent les wells (N-well, P-well) aux rails d'alimentation pour éviter le **latch-up** (court-circuit parasite PNPN). Spacing typique: 20-30 µm.

---

## 4. Placement

### Q4.1: Différence entre global et detailed placement?
**R:**
- **Global**: Placement approximatif, optimise le wirelength total, permet les overlaps
- **Detailed**: Légalisation sur les rows/sites, élimine les overlaps, affine le placement

### Q4.2: Qu'est-ce que le HPWL?
**R:** **Half-Perimeter Wire Length** = demi-périmètre du bounding box des pins d'un net.

```
HPWL = Width + Height du bounding box
```

Approximation rapide du wirelength réel, utilisée pour l'optimisation.

### Q4.3: Comment fonctionne le timing-driven placement?
**R:**
1. Identifie les **chemins critiques** via STA
2. Assigne des **poids** aux nets critiques
3. **Minimise le wirelength** sur ces nets en priorité
4. Place les cellules critiques **proches**

### Q4.4: Qu'est-ce que repair_design?
**R:** `repair_design` corrige après placement:
- **Long wires**: Buffer insertion
- **High fanout**: Buffer trees
- **Slew violations**: Drivers plus forts
- **Max capacitance**: Réduction de load

### Q4.5: Comment gérer la congestion au placement?
**R:**
1. Réduire l'utilization (70% → 60%)
2. Augmenter le cell padding
3. Bloquer les zones critiques
4. Répartir les high-fanout nets avec buffers
5. Repositionner les macros

---

## 5. Clock Tree Synthesis

### Q5.1: Qu'est-ce que le clock skew?
**R:** **Skew** = différence de latency du clock entre deux sinks.

```
Skew = |Latency(FF1) - Latency(FF2)|
```

Skew idéal: 0 (tous les FFs reçoivent le clock au même instant)

### Q5.2: Impact du skew sur setup et hold?
**R:**

| Skew | Setup | Hold |
|------|-------|------|
| Positif (capture tard) | Aide | Nuit |
| Négatif (capture tôt) | Nuit | Aide |

**Formules:**
```
Setup: T_clk + skew ≥ T_cq + T_data + T_setup
Hold:  T_cq + T_data ≥ T_hold + skew
```

### Q5.3: Qu'est-ce que le useful skew?
**R:** **Useful skew** = introduction intentionnelle de skew pour améliorer le timing:
- Retarder le capture clock sur les chemins setup-critiques
- Permet de récupérer du slack négatif

### Q5.4: Différence entre skew et jitter?
**R:**
- **Skew**: Différence **spatiale** (entre sinks), déterministe
- **Jitter**: Variation **temporelle** (cycle à cycle), stochastique

Le jitter est causé par le bruit, les variations PVT locales.

### Q5.5: Topologies de clock tree?
**R:**
- **H-Tree**: Symétrique, skew minimal par construction
- **Balanced Tree**: Adaptatif au placement
- **Mesh/Grid**: Très faible skew, haute power

---

## 6. Routing

### Q6.1: Différence entre global et detailed routing?
**R:**
- **Global routing**: Planification grossière, chemins approximatifs par GCells
- **Detailed routing**: Géométrie exacte sur les tracks, respect DRC

### Q6.2: Qu'est-ce que la congestion?
**R:**
```
Congestion = Demand / Capacity × 100%
```
- **Demand**: Routes nécessaires
- **Capacity**: Tracks disponibles
- **>100%**: Overflow, impossible à router

### Q6.3: Comment éviter la congestion?
**R:**
1. Utilization modérée (60-70%)
2. Placement uniforme
3. Channels entre macros
4. Buffers sur high-fanout nets
5. Layer assignment optimisé

### Q6.4: Qu'est-ce que le NDR?
**R:** **Non-Default Rules** = règles spéciales pour certains nets:
- **Clock NDR**: Largeur et spacing doublés
- **Critical NDR**: Espacement augmenté
- **Power NDR**: Wires plus larges

### Q6.5: Expliquez l'effet antenna
**R:** **Antenna effect** = charge accumulée sur le métal pendant la fabrication, peut endommager les gates.

**Solutions:**
1. Antenna diodes
2. Jumper vers couche supérieure
3. Metal splitting

---

## 7. Static Timing Analysis

### Q7.1: Formule du setup time check?
**R:**
```
T_clk ≥ T_cq + T_comb + T_setup - T_skew

Slack_setup = T_required - T_arrival
            = (T_clk - T_setup + T_skew) - (T_cq + T_comb)
```

### Q7.2: Formule du hold time check?
**R:**
```
T_cq + T_comb ≥ T_hold + T_skew

Slack_hold = T_arrival - T_required
           = (T_cq + T_comb) - (T_hold + T_skew)
```

### Q7.3: Comment fixer une violation setup?
**R:**
1. **Réduire le data path delay**:
   - Upsize les cellules
   - Buffer insertion
   - Logic restructuring
2. **Useful skew**: Retarder le capture clock
3. **Réduire la fréquence** (dernier recours)

### Q7.4: Comment fixer une violation hold?
**R:**
1. **Augmenter le data path delay**:
   - Delay buffers
   - Cellules plus lentes
2. **Note**: Hold indépendant de la fréquence!

### Q7.5: Qu'est-ce que l'OCV?
**R:** **On-Chip Variation** = variations locales sur le même die:
- Même technologie, différents delays
- **Derates**: ±5-10% sur les delays
- Rend l'analyse plus pessimiste mais réaliste

### Q7.6: Qu'est-ce que le CRPR?
**R:** **Clock Reconvergence Pessimism Removal**:
- Supprime le double derate sur le chemin clock partagé
- Entre launch et capture paths
- Analyse plus réaliste

### Q7.7: Expliquez le multi-corner analysis
**R:** Analyse sur plusieurs corners PVT:
- **Slow corner** (SS, hot, low V): Pire setup
- **Fast corner** (FF, cold, high V): Pire hold
- Le design doit passer **tous** les corners

---

## 8. Power Analysis

### Q8.1: Composantes de la power?
**R:**
```
Total = Dynamic + Static

Dynamic = Switching + Internal
        = α×C×V²×f + P_internal

Static = Leakage
       = I_leak × V
```

### Q8.2: Comment réduire la power dynamique?
**R:**
1. **Clock gating**: Désactiver les blocs inactifs
2. **Réduire la tension**: V² effect
3. **Réduire la fréquence**: Où possible
4. **Réduire la capacitance**: Optimiser routage

### Q8.3: Comment réduire le leakage?
**R:**
1. **Multi-Vt**: HVT sur chemins non-critiques
2. **Power gating**: Couper l'alimentation
3. **Body biasing**: Reverse body bias
4. **Réduire la température**

### Q8.4: Qu'est-ce que l'IR drop?
**R:** **IR drop** = chute de tension dans le PDN:
```
V_local = V_supply - I × R_pdn
```

**Limite**: <5% de VDD pour éviter la dégradation timing.

### Q8.5: Comment réduire l'IR drop?
**R:**
1. PDN plus robuste (straps plus larges)
2. Plus de vias
3. Decaps près des cellules high-power
4. Clock gating pour réduire les pics

---

## 9. Signal Integrity

### Q9.1: Qu'est-ce que le crosstalk?
**R:** **Crosstalk** = couplage capacitif entre wires adjacents:
- **Aggressor**: Wire qui switch
- **Victim**: Wire affecté

**Effets:**
- Glitch (spike sur victim)
- Delay variation

### Q9.2: Comment minimiser le crosstalk?
**R:**
1. **Spacing augmenté**: NDR
2. **Shielding**: VDD/VSS entre wires sensibles
3. **Couches différentes**: Éviter le parallélisme
4. **Wire spreading**: Dans les zones peu denses

### Q9.3: Qu'est-ce que l'électromigration (EM)?
**R:** **Électromigration** = mouvement des atomes de métal sous fort courant:
- Cause des opens ou shorts
- Limite de courant par largeur de wire
- Plus critique sur les couches fines (M1, M2)

### Q9.4: Comment éviter l'EM?
**R:**
1. Wires plus larges pour les nets high-current
2. Multiple vias (réduire la densité de courant)
3. Power grid robuste
4. Respecter les règles de current density

---

## 10. Physical Verification

### Q10.1: Différence entre DRC et LVS?
**R:**
- **DRC** (Design Rule Check): Règles de fabrication (spacing, width)
- **LVS** (Layout vs Schematic): Layout = Netlist?

Les deux sont obligatoires pour le tapeout.

### Q10.2: Erreurs DRC courantes?
**R:**
- **Spacing**: Wires trop proches
- **Width**: Wire trop fin
- **Enclosure**: Metal insuffisant autour du via
- **Density**: Trop ou pas assez de métal

### Q10.3: Erreurs LVS courantes?
**R:**
- **Open**: Connection manquante
- **Short**: Connection non voulue
- **Device mismatch**: Paramètres différents
- **Net mismatch**: Noms différents

### Q10.4: Qu'est-ce que l'ERC?
**R:** **Electrical Rule Check**:
- Floating gates
- Missing well taps
- ESD violations
- Antenna violations

---

## 11. Questions Avancées

### Q11.1: Expliquez le flow hierarchical vs flat
**R:**
- **Flat**: Tout le design dans un seul niveau
  - Simple mais lent pour gros designs
- **Hierarchical**: Blocs séparés, assemblés
  - Parallélisation, réutilisation
  - Complexité des interfaces

### Q11.2: Qu'est-ce que l'ECO?
**R:** **Engineering Change Order** = modifications tardives:
- **Functional ECO**: Fix bugs logiques
- **Timing ECO**: Fix timing violations
- Utilise les spare cells ou metal-only changes

### Q11.3: Expliquez le concept de Multi-Mode
**R:** Différents **modes d'opération**:
- **Functional mode**: Opération normale
- **Test mode**: Scan, BIST
- **Low-power mode**: Blocs éteints

Chaque mode a ses contraintes timing.

### Q11.4: Comment gérer un design très congestionné?
**R:**
1. Identifier les hotspots
2. Restructurer le placement
3. Ajouter des couches de routage
4. Réduire l'utilization localement
5. Hierarchical approach
6. Placement blockages stratégiques

### Q11.5: Qu'est-ce que le clock domain crossing (CDC)?
**R:** **CDC** = données traversant entre domaines d'horloge différents:
- Risque de métastabilité
- Solutions: Synchronizers (2-FF), FIFO, handshake
- Vérification: CDC tools (Spyglass, etc.)

---

## 12. Questions Comportementales

### Q12.1: Décrivez un challenge technique que vous avez résolu
**Préparation:**
- Situation: Violation timing/congestion
- Action: Debug, analyse, solution
- Résultat: Design clean, leçons apprises

### Q12.2: Comment priorisez-vous les tâches avec des deadlines serrées?
**Points à mentionner:**
- Identifier le chemin critique du projet
- Communication avec l'équipe
- Focus sur les bloqueurs
- Escalade si nécessaire

### Q12.3: Comment travaillez-vous avec les équipes front-end/design?
**Points à mentionner:**
- Feedback sur les contraintes physiques
- Early engagement
- DFM/DFT guidelines
- Reviews conjointes

---

## Conseils pour l'Interview

### Préparation Technique
1. **Revoir les fondamentaux**: Timing, power, routage
2. **Pratiquer les calculs**: Slack, utilization, skew
3. **Connaître les outils**: OpenROAD, Innovus, ICC2
4. **Exemples concrets**: Projets personnels, challenges résolus

### Pendant l'Interview
1. **Clarifier la question** avant de répondre
2. **Structurer la réponse**: Définition → Explication → Exemple
3. **Utiliser des diagrammes** si possible
4. **Admettre** si vous ne savez pas, puis proposer une approche

### Questions à Poser
1. Quels outils/technologies utilisez-vous?
2. Quelle est la taille typique des designs?
3. Comment est structurée l'équipe PD?
4. Quels sont les défis actuels du projet?

---

## Ressources Complémentaires

- [VLSI System Design](https://www.vlsisystemdesign.com/)
- [Chip Design Made Easy](https://www.chipdesignmadeeasy.com/)
- [OpenROAD Documentation](https://openroad.readthedocs.io/)
- [Digital VLSI Design with Cadence](https://www.cadence.com/)
