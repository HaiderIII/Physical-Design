# Hierarchical Physical Design — Review Notes

Notes de revision pre-emploi couvrant le flow PD complet avec focus sur le design hierarchique.

---

## 1. Synthese logique

**Formule cle :**
> Synthese = RTL (.v) + Liberty (.lib) + Contraintes (SDC) → Gate-level netlist

| Input | Description |
|-------|-------------|
| RTL (Verilog) | Description comportementale du design |
| Liberty (.lib) | Bibliotheque de cellules standard (timing, area, power) |
| SDC | Contraintes : frequence cible, I/O delays, fanout max |

| Output | Description |
|--------|-------------|
| Gate-level netlist (.v) | Design mappe sur les cellules standard du fondeur |
| Rapports | Area, nombre de cellules, timing estime |

**Outil open-source :** Yosys
**Outil industrie :** Synopsys Design Compiler / Cadence Genus

---

## 2. LEF vs Liberty (.lib)

| Fichier | Contenu | Utilise par |
|---------|---------|-------------|
| **LEF** | Geometrie : dimensions, position des pins, obstructions | Placeur, Routeur |
| **Liberty (.lib)** | Timing : delays, setup/hold, power, capacite des pins | STA (timing analysis) |

> LEF = la **forme** des cellules → pour placer et router
> Liberty = le **comportement** des cellules → pour le timing et la puissance

---

## 3. Floorplanning & Core Utilization

**Core utilization** = surface std cells / surface core area

| Utilization | Usage typique |
|-------------|---------------|
| 70-80% | Design dense en production |
| 40-60% | Design avec macros (SRAM, IP) |
| < 40% | Grosses macros ou frequence aggressive |

Pourquoi pas 100% : il faut de la place pour les buffers CTS, les buffers de repair, les wire tracks, les filler cells.

---

## 4. Timing : Setup & Hold

**Setup time** : donnee stable **AVANT** le front d'horloge (registre de capture)
**Hold time** : donnee stable **APRES** le front d'horloge (registre de capture)

**Equations :**
```
Setup slack = T_clock - T_arrival - T_setup - T_uncertainty
Hold slack  = T_arrival - T_hold - T_uncertainty
```

**Slack** = marge entre quand la donnee arrive et quand elle doit arriver
- Positif → OK
- Negatif → violation

**Ne pas confondre :**
- **Slack** = marge de timing sur un chemin
- **Skew** = difference de temps d'arrivee de l'horloge entre deux registres

**WNS** (Worst Negative Slack) = slack du pire chemin
**TNS** (Total Negative Slack) = somme de tous les slacks negatifs

**Reparer les violations :**
- Setup : upsizing cellules, rebuffering, optimiser placement, baisser frequence
- Hold : ajouter des buffers/delais (independant de la frequence)

---

## 5. Clock Tree Synthesis (CTS)

**Probleme sans CTS :** un seul driver pour des milliers de flip-flops → fanout enorme, slew degrade, skew incontrolable.

**CTS insere un arbre de buffers pour :**
- Distribuer le fanout
- Equilibrer le skew
- Maintenir un bon slew

**Impact de la frequence :**

| | Sky130 (130nm) | ASAP7 (7nm) |
|--|----------------|-------------|
| Frequence | 100 MHz | 500 MHz |
| Periode | 10 ns | 2 ns |
| Buffers CTS | 3 niveaux | 8 niveaux, 6303 buffers |
| Skew | 0.48 ns | 35 ps |

Plus la frequence est haute → plus le skew doit etre faible → plus le CTS est complexe.

---

## 6. Routing

**Global routing :** decoupe le die en grille, decide par quelles regions chaque fil passe. Planification de haut niveau.

**Detailed routing :** trace les fils exacts sur les pistes metalliques, respecte les regles DRC.

**Pourquoi 2 passes :** detailed routing direct serait trop couteux en calcul. Le global routing reduit le probleme region par region.

> Analogie : global routing = GPS choisit les autoroutes, detailed routing = choisit chaque rue.

---

## 7. Puissance CMOS

**3 composantes :**

1. **Dynamic power (switching)** — principale
   ```
   P_dynamic = alpha * C * V^2 * f
   ```
   alpha = taux d'activite, C = capacite, V = tension, f = frequence

2. **Short-circuit power** (~10-15% du dynamic)
   PMOS et NMOS brievement passants en meme temps pendant la transition.

3. **Leakage power (statique)**
   Courant de fuite meme sans switching. Dominant en noeuds avances (7nm).

**V^2 dans la formule :** Sky130 (1.8V) consomme bien plus que ASAP7 (0.7V) a activite egale.

---

## 8. SDC — Points cles

```tcl
create_clock -name clk -period 10.0 [get_ports clk]     # Define clock
set_clock_uncertainty 0.3 [get_clocks clk]                # Skew + jitter margin
set_input_delay -clock clk -max 2.0 [get_ports data_in]   # Timing budget entree
set_output_delay -clock clk -max 2.0 [get_ports data_out] # Timing budget sortie
set_false_path -from [get_ports rst_n]                     # Ignorer chemin async
```

**False path sur rst_n :** le reset est asynchrone, pas synchronise avec clk → pas de sens de verifier setup/hold. L'input_delay reste pour dimensionner les buffers d'entree.

---

## 9. PDKs utilises

| PDK | Noeud | Tension | Couches metal |
|-----|-------|---------|---------------|
| Sky130 | 130 nm | 1.8V | 5 (li1 → met5) |
| ASAP7 | 7 nm | 0.7V | 9 (M1 → M9) |
| Nangate45 | 45 nm | 1.1V | ~10 |

---

## 10. Flow hierarchique vs Flat

**Flat :** tout le design traite d'un seul bloc. Simple mais explose en runtime/memoire pour les gros designs.

**Hierarchique :** chaque bloc (CPU, UART, SPI...) fait son propre PnR separement, puis assemble au top-level via des abstracts (LEF).

### Organisation en industrie

```
Chip Lead / PD Manager
├── Block Owner CPU      → PnR du CPU
├── Block Owner UART     → PnR de l'UART
├── ...
└── Top-level Owner      → assemble, ferme le timing global
```

### Livrables entre niveaux

| Du bloc vers le top | Du top vers le bloc |
|---------------------|---------------------|
| Abstract LEF (forme + pins) | Timing budget (SDC) |
| Timing model (.lib) | Pin placement constraints |
| Power intent (UPF) | Halo / keepout requirements |

### Abstracts LEF

**Garde :** contour du bloc, pins (position + couche), obstructions routing/placement
**Cache :** cellules internes, routage interne, netlist, clock tree

But : le top-level voit chaque bloc comme une boite noire → runtime et memoire reduits.

### Budget timing

Le top-level decoupe la periode entre les blocs :
```
[FF_cpu] → logique CPU → pin OUT → fil top → pin IN → logique UART → [FF_uart]
|←── budget CPU ──→|←── top-level ──→|←──── budget UART ────→|
|←──────────────────── 10 ns total ──────────────────────────→|
```

Se traduit en `set_output_delay` / `set_input_delay` dans les SDC des blocs.

### Pin placement

- Dicte par le **top-level owner** (top-down)
- Pins mal places → fils longs → timing violations + congestion
- Processus iteratif entre block owners et top-level

### Power grid (PDN) hierarchique

- **Top-level :** gros rails VDD/VSS sur couches hautes (met4, met5)
- **Blocs :** rails fins sur couches basses (met1, met2)
- Connexion par vias/stripes verticales
- Verifier IR drop : tension ne doit pas trop chuter loin des pads

### Ordre d'implementation des blocs

1. **Timer/GPIO** — petits, valident le flow
2. **SPI/UART** — complexite moyenne
3. **Bus** — connecte tout, besoin des timings des peripheriques
4. **CPU** — le plus gros et critique, flow deja rode

> Regle : low-risk d'abord pour valider le flow, blocs critiques en dernier.

---

## 11. Signoff — Verifications avant tapeout

| Check | Verifie |
|-------|---------|
| **STA multi-corner** | Setup/hold sur tous les corners PVT (SS, TT, FF) |
| **DRC** | Regles geometriques du fondeur (espacement, largeur min) |
| **LVS** | Layout correspond a la netlist (pas d'erreur de connexion) |
| **Extraction parasite (RCX)** | R et C reelles des fils → timing realiste |
| **IR Drop** | Tension suffisante partout sur le die |
| **EM (Electromigration)** | Courant dans les fils ne depasse pas les limites |
| **Antenna** | Charges accumulees pendant fabrication ne grillent pas les gates |

**Ordre :** Extraction → STA → DRC → LVS → IR Drop → Antenna → GDSII

Tout doit etre **clean**. Un seul echec = pas de tapeout.

---

## 12. Outils : Open-source vs Industrie

| Open-source | Industrie | Fonction |
|-------------|-----------|----------|
| Yosys | Design Compiler / Genus | Synthese |
| OpenROAD | Innovus / ICC2 | Floorplan, placement, CTS, routing |
| OpenSTA | PrimeTime | STA |
| KLayout | Virtuoso / Calibre | GDSII, DRC, LVS |

Les concepts sont les memes. Les commandes changent, pas la logique.

---

## 13. Pipeline RISC-V 5 etages

| Etage | Nom | Role |
|-------|-----|------|
| IF | Instruction Fetch | Cherche l'instruction en IMEM |
| ID | Instruction Decode | Decode + lecture registres |
| EX | Execute | ALU, evaluation branches |
| MEM | Memory Access | Load/Store (DMEM) |
| WB | Write Back | Ecrit resultat dans register file |

**Pourquoi pipeline :** decouper en etages courts → frequence plus elevee + 5 instructions en vol simultanement → debit x5.
**Prix :** hazards (data, control) → hazard unit + forwarding + branch penalty.

---

## Points faibles identifies (a travailler)

1. **Vocabulaire precis** : ne pas confondre slack/skew, routing/placement
2. **Equations par coeur** : setup slack, P = alphaCV^2f
3. **Toujours justifier** chaque choix technique (pas juste l'ordre, le pourquoi)
4. **Ne jamais dire "je sais pas"** sans tenter une reponse
5. **Les 3 PDKs** : tensions et couches metal par coeur
