testRecommendedMode tester at favoritt viewet starter med � vise alle movies.
Deretter endres modus til recommended mode og det sjekkes at recommended mode har blitt satt.
Her burde jeg ogs� teste at calculateAverage metoden blir kalt.

S� startet jeg p� 3 test metoder for � teste at isRecommended metoden p� movie fungerer.
En for � sjekke at en film med last seen 3 �r tilbake og rating st�rr enn 7.1 er recommended.
En annen for � sjekke at en film med n�v�rende last seen dato og rating 7.1 ikke er recommended.
Og en for � sjekke at en film med last seen 3 �r tilbake og rating 7.0 ikke er recommended.

Her er det n�dvendig med mocking av NSManagedObject Movie.
Dessverre rakk jeg ikke gj�re ferdig testing.

Flere ting som burde testes er blant annet:
* Legge til og endring av last seen dato lagrer dato
* Sletting av film sletter film fra database
* Lagring av film lagrer film i databasen
* S�keresultatet viser resultatene riktig fra s�k
* Checkmark vises i s�keresultater n�r film er i favoritter.
* Recommended movies vises med * f�rst
* Recommended filteret returnerer kun recommended movies.
* UI tester av at det som skal oppdateres i Ui gj�r det.