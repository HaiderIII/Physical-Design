# Quiz - SYN_002 The Corner Chaos

Répondez à ces questions **AVANT** de consulter la solution.

---

## Question 1

Pourquoi l'analyse timing initiale donnait-elle des résultats trop optimistes ?

- [ ] A) Le fichier SDC avait des contraintes trop relaxées
- [ ] B) Le design avait trop peu de cellules
- [X] C) Seul le corner typical était chargé, pas le corner slow
- [ ] D) La fréquence cible était trop basse

---

## Question 2

Pour une analyse **setup**, quel corner doit être utilisé ?

- [ ] A) Fast (ff) - car les données doivent arriver vite
- [ ] B) Typical (tt) - c'est le cas moyen
- [X] C) Slow (ss) - car c'est le pire cas pour l'arrivée tardive
- [ ] D) N'importe lequel, ça ne change rien

---

## Question 3

Pour une analyse **hold**, quel corner doit être utilisé ?

- [ ] A) Slow (ss) - pour être conservateur
- [X] B) Fast (ff) - car c'est le pire cas pour l'arrivée précoce
- [ ] C) Typical (tt) - c'est suffisant pour hold
- [ ] D) On utilise le même corner que pour setup

---

## Question 4

Que signifie "PVT" dans "corners PVT" ?

- [ ] A) Power, Voltage, Timing
- [X] B) Process, Voltage, Temperature
- [ ] C) Path, Variation, Threshold
- [ ] D) Physical, Virtual, Temporal

---

## Question 5

Dans le fichier `sky130_fd_sc_hd__ss_n40C_1v40.lib`, que signifient les différentes parties du nom ?

- [ ] A) ss = super speed, n40C = node 40nm, 1v40 = 140 cellules
- [X] B) ss = slow-slow process, n40C = -40°C, 1v40 = 1.40V
- [ ] C) ss = standard speed, n40C = normal 40°C, 1v40 = 1.40mA
- [ ] D) ss = sky standard, n40C = 40 corners, 1v40 = version 1.40

---

## Question 6

Pourquoi charger plusieurs fichiers Liberty au lieu d'un seul ?

- [ ] A) Pour avoir plus de cellules disponibles
- [X] B) Pour que l'outil choisisse automatiquement le bon corner selon l'analyse
- [ ] C) C'est obligatoire sinon OpenROAD refuse de fonctionner
- [ ] D) Pour réduire le temps d'analyse

---

## Question 7

Un design passe le timing en corner typical mais échoue en corner slow. Que cela indique-t-il ?

- [ ] A) Le design est correct, slow est trop pessimiste
- [X] B) Le design a des marges insuffisantes et risque de ne pas fonctionner en production
- [ ] C) Il faut ignorer le corner slow
- [ ] D) Le fichier Liberty slow est incorrect

---

## Vérification

Comptez vos réponses et notez votre score :
- 7/7 : Excellent ! Vous maîtrisez les corners PVT
- 5-6/7 : Bon niveau, quelques concepts à revoir
- 3-4/7 : Relisez les hints et la théorie
- <3/7 : Recommencez le puzzle avec plus d'attention

---

Une fois terminé, consultez `.solution/quiz_answers.md` pour vérifier vos réponses.
