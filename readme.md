testRecommendedMode tester at favoritt viewet starter med å vise alle movies.
Deretter endres modus til recommended mode og det sjekkes at recommended mode har blitt satt.
Her burde jeg også teste at calculateAverage metoden blir kalt.

Så startet jeg på 3 test metoder for å teste at isRecommended metoden på movie fungerer.
En for å sjekke at en film med last seen 3 år tilbake og rating størr enn 7.1 er recommended.
En annen for å sjekke at en film med nåværende last seen dato og rating 7.1 ikke er recommended.
Og en for å sjekke at en film med last seen 3 år tilbake og rating 7.0 ikke er recommended.

Her er det nødvendig med mocking av NSManagedObject Movie.
Dessverre rakk jeg ikke gjøre ferdig testing.

Flere ting som burde testes er blant annet:
* Legge til og endring av last seen dato lagrer dato
* Sletting av film sletter film fra database
* Lagring av film lagrer film i databasen
* Søkeresultatet viser resultatene riktig fra søk
* Checkmark vises i søkeresultater når film er i favoritter.
* Recommended movies vises med * først
* Recommended filteret returnerer kun recommended movies.
* UI tester av at det som skal oppdateres i Ui gjør det.