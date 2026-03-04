# Phase 0 — Concepts de la Conception Hiérarchique

## Pourquoi la conception hiérarchique ?

### Le problème du flat design

Dans un design **flat** (non hiérarchique), tout le design est traité comme un seul
bloc monolithique. Cela pose des problèmes :

1. **Scalabilité** : Les outils P&R ont une complexité O(n log n) à O(n²).
   Un SoC avec des millions de cellules devient impraticable en flat.
2. **Temps de run** : Chaque itération (placement, CTS, routage) prend des heures.
3. **Collaboration** : Impossible pour plusieurs ingénieurs de travailler en parallèle.
4. **Convergence** : Les optimisations globales sont plus difficiles à contrôler.

### La solution hiérarchique

On divise le design en **blocs** indépendants :

```
     Flat Design                    Hierarchical Design
  ┌──────────────────┐           ┌──────────────────────┐
  │ ○ ○ ○ ○ ○ ○ ○ ○ │           │ ┌────┐ ┌────┐ ┌───┐ │
  │ ○ ○ ○ ○ ○ ○ ○ ○ │           │ │ CPU│ │SRAM│ │   │ │
  │ ○ ○ ○ ○ ○ ○ ○ ○ │    →      │ └────┘ └────┘ │BUS│ │
  │ ○ ○ ○ ○ ○ ○ ○ ○ │           │ ┌────┐ ┌────┐ │   │ │
  │ ○ ○ ○ ○ ○ ○ ○ ○ │           │ │UART│ │GPIO│ └───┘ │
  └──────────────────┘           │ └────┘ └────┘       │
   Toutes les cellules            └──────────────────────┘
   traitées ensemble               Blocs indépendants
```

### Avantages

| Aspect        | Flat         | Hiérarchique          |
|---------------|-------------|------------------------|
| Temps P&R     | Long        | Court (par bloc)       |
| Parallélisme  | Non         | Oui (blocs en //)      |
| Itérations    | Tout refaire| Refaire 1 bloc         |
| Complexité    | O(N²)       | O(n²) × k blocs       |
| ECO           | Difficile   | Localisé               |

## Le flow hiérarchique en 2 niveaux

### Niveau 1 : Block-level implementation

Chaque bloc est implémenté **indépendamment** :

```
RTL du bloc → Synthesis → Floorplan → Placement → CTS → Routing → Signoff
                                                                    │
                                                                    ▼
                                                            Abstract (LEF)
                                                            Timing model (.lib)
```

**Ce qu'on produit pour chaque bloc :**
- **LEF abstract** : Vue « boîte noire » physique (outline, pins, obstructions)
- **Timing model** : Délais entrée→sortie pour l'analyse de timing top-level
- **GDS** : Layout complet du bloc (pour le merge final)

### Niveau 2 : Top-level integration

Les blocs sont assemblés au top-level comme des **macros** :

```
Block LEFs + SRAM LEFs + Top-level netlist
    │
    ▼
Top Floorplan (placer les blocs + SRAM + I/O)
    │
    ▼
Top Power Planning (PDN: rings + stripes)
    │
    ▼
Top Placement (glue logic restante)
    │
    ▼
Top CTS (arbre d'horloge global)
    │
    ▼
Top Routing (connexions inter-blocs)
    │
    ▼
Top Signoff (DRC, LVS, STA)
    │
    ▼
GDSII (merge blocs + top)
```

## Concepts clés

### 1. Abstract LEF

Le LEF (Library Exchange Format) abstract est la vue que le top-level voit
de chaque bloc. Il contient :

```
MACRO cpu_wb_wrapper
  CLASS BLOCK ;
  SIZE 400 BY 400 ;              ← Dimensions physiques
  PIN clk
    DIRECTION INPUT ;
    PORT
      LAYER met3 ;
      RECT 0.0 200.0 0.5 200.5 ; ← Position physique du pin
    END
  END clk
  PIN wb_adr_o[0]
    DIRECTION OUTPUT ;
    ...
  END wb_adr_o[0]
  OBS                             ← Obstructions (couches utilisées à l'intérieur)
    LAYER met1 ;
      RECT 0.0 0.0 400.0 400.0 ;
    LAYER met2 ;
      RECT 0.0 0.0 400.0 400.0 ;
  END
END cpu_wb_wrapper
```

**Ce que le top-level NE voit PAS** : les cellules internes, le routage interne,
l'arbre d'horloge interne.

### 2. Timing Budget

Le timing budget répartit le temps disponible entre les blocs :

```
Période = 10 ns (100 MHz)

CPU output → Bus → Périphérique input
   3 ns        1 ns      3 ns       = 7 ns utilisés
                                      3 ns de marge (clock uncertainty + setup)

Contraintes SDC par bloc :
  CPU:   set_output_delay -clock clk 3.0 [get_ports wb_*]
  UART:  set_input_delay  -clock clk 3.0 [get_ports wb_*]
```

Le timing budget est **critique** : si un bloc utilise plus que son budget,
le timing au top-level ne fermera pas.

### 3. Partitionnement

Critères pour définir les frontières de blocs :

1. **Fonctionnel** : chaque bloc a une fonction claire (CPU, UART, Timer...)
2. **Interface standard** : bus Wishbone = interface bien définie entre blocs
3. **Taille raisonnable** : ni trop petit (overhead), ni trop gros (perd l'intérêt)
4. **Registres aux frontières** : les signaux inter-blocs passent par des registres
   → facilite le timing budgeting

### 4. Channel Routing

Les canaux entre les blocs doivent être dimensionnés pour passer les fils :

```
  ┌────────┐    channel    ┌────────┐
  │        │◄─── 50 µm ──►│        │
  │  CPU   │               │  SRAM  │
  │        │  fils inter-  │        │
  └────────┘  blocs ici    └────────┘
```

Un canal trop étroit → congestion → violations DRC.
Un canal trop large → gaspillage de surface.

### 5. Power Planning

Le PDN (Power Distribution Network) doit alimenter tous les blocs :

```
  ┌─────────────────────────────────────────┐
  │ ═══════ VDD ring ═══════════════════   │
  │ ║                                   ║   │
  │ ║  ┌────┐  ┌────┐  ┌────┐         ║   │
  │ ║  │ CPU│  │SRAM│  │UART│  stripes ║   │
  │ ║  └────┘  └────┘  └────┘  ║║║║║  ║   │
  │ ║                           ║║║║║  ║   │
  │ ═══════ VSS ring ═══════════════════   │
  └─────────────────────────────────────────┘
```

## Application à notre SoC

### Blocs identifiés

| Bloc  | ~Cellules estimées | SRAM | Complexité |
|-------|-------------------|------|------------|
| CPU   | ~5000             | Non  | Haute      |
| DMEM  | ~50 + macro       | Oui  | Basse      |
| UART  | ~300              | Non  | Moyenne    |
| SPI   | ~250              | Non  | Moyenne    |
| Timer | ~200              | Non  | Basse      |
| GPIO  | ~150              | Non  | Basse      |

### Timing budget de notre SoC

```
Chemin critique : CPU → Wishbone bus → DMEM SRAM → bus → CPU

    CPU internal    Bus decode    DMEM access    Bus mux    CPU input
    ├── 3 ns ──┤├── 1 ns ──┤├── 3 ns ──┤├── 1 ns ──┤├── 2 ns ──┤
    └───────────────────── 10 ns ──────────────────────────────────┘
```

## Exercice de compréhension

1. Pourquoi l'IMEM n'est-elle PAS sur le bus Wishbone ?
   → Réponse : Le CPU a besoin de lire une instruction **chaque cycle**. Passer
   par le bus ajouterait de la latence et de la contention avec les accès data.
   Architecture Harvard = 2 ports mémoire indépendants.

2. Pourquoi mettre des registres aux frontières des blocs ?
   → Réponse : Les registres « cassent » les chemins combinatoires longs.
   Le timing d'un bloc n'impacte pas directement le timing interne de l'autre.
   Chaque bloc peut être optimisé indépendamment.

3. Que contient un abstract LEF qui n'est PAS dans une netlist ?
   → Réponse : Les **positions physiques des pins** et les **obstructions** par
   couche de métal. La netlist ne contient que la connectivité logique.
