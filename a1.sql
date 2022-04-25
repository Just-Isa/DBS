# F¨ugen Sie zur Relation Auftragsposten das Attribut Einzelpreis hinzu. F¨ullen
# Sie dieses Attribut mit Daten auf, ermittelt aus den Attributen Anzahl und Gesamtpreis.
ALTER TABLE auftragsposten ADD Einzelpreis FLOAT;
UPDATE auftragsposten SET Einzelpreis = Gesamtpreis / Anzahl;
SELECT * FROM auftragsposten;


# Erzeugen Sie in der Beispieldatenbank Bike eine Sicht VPers, die der Relation Personal ohne die Attribute Gehalt und Beurteilung entspricht. Weiter sind in
# dieser Sicht nur die Personen aufzunehmen, denen ein Vorgesetzter zugeordnet ist. Liegt
# eine ¨anderbare Sicht vor? Begr¨unden Sie ihre Antwort.
CREATE VIEW VPers (Persnr, NAME, Strasse, PLZ, Ort, GebDatum, Stand, Vorgesetzt, Aufgabe) AS
(SELECT Persnr, NAME, Strasse, PLZ, Ort, GebDatum, Stand, Vorgesetzt, Aufgabe from personal WHERE Vorgesetzt IS NOT NULL);
SELECT * FROM Vpers;
# Ist editierbar. Gründe: Primary Key aus der Tabelle, mit welcher die View erstellt wurde existiert noch. Es gibt keine Felder die aus Aggregatsfunktionen
# bestehen. Es gibt keine Distinct Klauseln, Subqueries, GROUP BY oder HAVING. Basiert auf keiner anderen View. Es gibt keine Konstanten.



# Die Relation Auftragsposten enth¨alt aus Redundanzgr¨unden nur den Gesamtpreis jedes einzelnen Auftragspostens. Schreiben Sie daher eine Sicht VAuftragsposten,
# die alle Daten der Relation Auftragsposten enth¨alt und zus¨atzlich ein Attribut Einzelpreis. Ist diese Sicht ¨anderbar? Begr¨unden Sie ihre Antwort.
CREATE VIEW VAutragsposten(PosNr, AuftrNr, Artnr, Anzahl, Gesamtpreis, Einzelpreis) AS
(SELECT PosNr, AuftrNr, Artnr, Anzahl, Gesamtpreis, Gesamtpreis / Anzahl FROM auftragsposten);
# NICHT EDITIERBAR WEIL - muss noch schreiben lmeo


# Beim Einf¨ugen und Andern von Artikeln soll automatisch aus dem Netto- ¨
# preis die Mehrwertsteuer (19%) und der Gesamtpreis ermittelt werden. Schreiben Sie
# einen geeigneten Trigger. Testen Sie den Trigger.
CREATE OR REPLACE TRIGGER GesamtPreisErmittlungInsert 
BEFORE INSERT ON artikel
FOR EACH ROW 
SET NEW.Steuer = (NEW.Netto * 0.19), NEW.Preis = (NEW.Netto + (NEW.NETTO *0.19));

CREATE OR REPLACE TRIGGER GesamtPreisErmittlungUpdate
BEFORE UPDATE ON artikel
FOR EACH ROW 
SET NEW.Steuer = (NEW.Netto * 0.19), NEW.Preis = (NEW.Netto + (NEW.NETTO *0.19));


# Alle neuen Kunden sollen automatisch mit einer Kundennummer versehen
# werden. Diese Nummern beginnen bei 21. Es sollen nur ungeradzahlige Kundennummern vergeben werden. 
# Schreiben Sie eine geeignete Sequenz. Probieren Sie diese Sequenz durch Hinzuf¨ugen von neuen Kunden aus.
CREATE OR REPLACE SEQUENCE KnSq START WITH 21 INCREMENT BY 2;
INSERT INTO kunde(Nr, NAME, Strasse, PLZ, Ort, Sperre) VALUES (NEXT VALUE FOR KnSq, "heheheha", "lmaostraße 3", 92321, "Grrrbach", 0);

# In MySQL gibt es die Spaltenbedingung AutoIncrement. Damit erh¨alt dieses
# Attribut immer eine eindeutige automatische Nummer. Bilden Sie diese Funktion mittels
# Sequenzen und Trigger f¨ur das Attribut Persnr der Relation Personal nach.
CREATE OR REPLACE SEQUENCE AIRepl START WITH 10;

CREATE OR REPLACE TRIGGER AIReplTrig
BEFORE INSERT ON personal
FOR EACH ROW
SET NEW.PersNr = NEXT VALUE FOR AIRepl;

INSERT INTO personal	(NAME, Strasse, PLZ, Ort, GebDatum, Stand, Vorgesetzt, Gehalt, Beurteilung, Aufgabe) 
				VALUES 	("grrr", "heheheha", 92831, "hohohoi", "1979-07-05", "verh", 3, 2300, 3, "lmaolord");
				
# Schreiben Sie einen Befehl, der dem Benutzer Gast Anderungsrechte auf die ¨
# Attribute Bestand, Reserviert und Bestellt der Relation Lager und Leserechte auf die
# gesamte Relation einr¨aumt
GRANT UPDATE (Bestand, Reserviert, Bestellt) 
ON lager
TO 'Gast'@'localhost';

# Entziehen Sie dem Benutzer Gast die in der vorherigen Aufgabe gew¨ahrten Rechte wieder
REVOKE UPDATE (Bestand, Reserviert, Bestellt)
ON lager
FROM 'Gast'@'localhost';

# Im Attribut Aufgabe der Relation Personal gibt es nur eine beschr¨ankte
# Anzahl von m¨oglichen Aufgaben. Definieren Sie ein Gebiet Berufsbezeichnung, das eine
# Ansammlung von m¨oglichen Berufen enth¨alt.
ENUM('Manager', 'Vertreter', 'Facharbeiterin', 'Sekretr', 'Meister', 'Arbeiter', 'Sachabearbeiterin', 'Azubi');





