SET NOCOUNT ON;
PRINT '--- ROZPOCZÊCIE TESTÓW FUNKCJONALNYCH HURTOWNI DANYCH ---';
PRINT '';

SET NOCOUNT ON;
PRINT '--- ROZPOCZÊCIE TESTÓW INTEGRALNOŒCI: STAGING VS FAKTY ---';
PRINT '';

---------------------------------------------------------
-- 1. BUDOWNICTWO
---------------------------------------------------------
DECLARE @StgBudownictwo INT = (SELECT COUNT(DISTINCT Rok + Kwartal) FROM StagingBudownictwo WHERE Rok >= 2014);
DECLARE @FaktBudownictwo INT = (SELECT COUNT(*) FROM FaktBudownictwo);

IF @StgBudownictwo = @FaktBudownictwo
    PRINT 'TEST 01 PASS: Budownictwo (' + CAST(@FaktBudownictwo AS VARCHAR) + ' wierszy)';
ELSE
    PRINT 'TEST 01 FAIL: Budownictwo | Staging: ' + CAST(@StgBudownictwo AS VARCHAR) + ' vs Fakty: ' + CAST(@FaktBudownictwo AS VARCHAR);


---------------------------------------------------------
-- 2. KREDYTY NA NIERUCHOMOŒCI
---------------------------------------------------------
DECLARE @StgKredyty INT = (SELECT COUNT(*) FROM StagingKredytyNieruchomosci);
DECLARE @FaktKredyty INT = (SELECT COUNT(*) FROM FaktKredytyNieruchomoœci);

IF @StgKredyty = @FaktKredyty
    PRINT 'TEST 02 PASS: Kredyty Nieruchomoœci (' + CAST(@FaktKredyty AS VARCHAR) + ' wierszy)';
ELSE
    PRINT 'TEST 02 FAIL: Kredyty Nieruchomoœci | Staging: ' + CAST(@StgKredyty AS VARCHAR) + ' vs Fakty: ' + CAST(@FaktKredyty AS VARCHAR);


---------------------------------------------------------
-- 3. WYNAGRODZENIA - SEKTOR
---------------------------------------------------------
DECLARE @StgWynSektor INT = (SELECT COUNT(*) FROM StagingWynagrodzenieSektor WHERE Rok >= 2014 AND Sektor LIKE '%wynagrodzeni%');
DECLARE @FaktWynSektor INT = (SELECT COUNT(*) FROM FaktWynagrodzenieSektor);

IF @StgWynSektor = @FaktWynSektor
    PRINT 'TEST 03 PASS: Wynagrodzenia Sektor (' + CAST(@FaktWynSektor AS VARCHAR) + ' wierszy)';
ELSE
    PRINT 'TEST 03 FAIL: Wynagrodzenia Sektor | Staging: ' + CAST(@StgWynSektor AS VARCHAR) + ' vs Fakty: ' + CAST(@FaktWynSektor AS VARCHAR);


---------------------------------------------------------
-- 4. WYNAGRODZENIA - REGION
---------------------------------------------------------
DECLARE @StgWynRegion INT = (SELECT COUNT(*) FROM StagingWynagrodzeniaRegion);
DECLARE @FaktWynRegion INT = (SELECT COUNT(*) FROM FaktWynagrodzenieRegion);

IF @StgWynRegion = @FaktWynRegion
    PRINT 'TEST 04 PASS: Wynagrodzenia Region (' + CAST(@FaktWynRegion AS VARCHAR) + ' wierszy)';
ELSE
    PRINT 'TEST 04 FAIL: Wynagrodzenia Region | Staging: ' + CAST(@StgWynRegion AS VARCHAR) + ' vs Fakty: ' + CAST(@FaktWynRegion AS VARCHAR);


---------------------------------------------------------
-- SEKCJA 5-10. MIESZKANIA
---------------------------------------------------------
DECLARE @FaktMieszkania INT = (SELECT COUNT(*) FROM FaktMieszkania);
PRINT '';
PRINT '--- WERYFIKACJA FAKTU MIESZKANIA (' + CAST(@FaktMieszkania AS VARCHAR) + ' wierszy) ---';

-- 5. MIESZKANIA LICZBA
DECLARE @StgMieszLiczba INT = (SELECT COUNT(*) FROM StagingMieszkaniaLiczba);
IF @StgMieszLiczba = @FaktMieszkania
    PRINT 'TEST 05 PASS: Mieszkania Liczba';
ELSE
    PRINT 'TEST 05 FAIL: Mieszkania Liczba | Staging: ' + CAST(@StgMieszLiczba AS VARCHAR) + ' vs Fakty: ' + CAST(@FaktMieszkania AS VARCHAR);

-- 6. MIESZKANIA MEDIANA
DECLARE @StgMieszMediana INT = (SELECT COUNT(*) FROM StagingMieszkaniaMediana);
IF @StgMieszMediana = @FaktMieszkania
    PRINT 'TEST 06 PASS: Mieszkania Mediana';
ELSE
    PRINT 'TEST 06 FAIL: Mieszkania Mediana | Staging: ' + CAST(@StgMieszMediana AS VARCHAR) + ' vs Fakty: ' + CAST(@FaktMieszkania AS VARCHAR);

-- 7. MIESZKANIA POWIERZCHNIA
DECLARE @StgMieszPowierzchnia INT = (SELECT COUNT(*) FROM StagingMieszkaniaPowierzchnia);
IF @StgMieszPowierzchnia = @FaktMieszkania
    PRINT 'TEST 07 PASS: Mieszkania Powierzchnia';
ELSE
    PRINT 'TEST 07 FAIL: Mieszkania Powierzchnia | Staging: ' + CAST(@StgMieszPowierzchnia AS VARCHAR) + ' vs Fakty: ' + CAST(@FaktMieszkania AS VARCHAR);

-- 8. MIESZKANIA ŒREDNIA CENA
DECLARE @StgMieszSredniaCena INT = (SELECT COUNT(*) FROM StagingMieszkaniaSredniaCena);
IF @StgMieszSredniaCena = @FaktMieszkania
    PRINT 'TEST 08 PASS: Mieszkania Œrednia Cena';
ELSE
    PRINT 'TEST 08 FAIL: Mieszkania Œrednia Cena | Staging: ' + CAST(@StgMieszSredniaCena AS VARCHAR) + ' vs Fakty: ' + CAST(@FaktMieszkania AS VARCHAR);

-- 9. MIESZKANIA ŒREDNIA CENA M2
DECLARE @StgMieszSredniaCenaM2 INT = (SELECT COUNT(*) FROM StagingMieszkaniaSredniaCenaM2);
IF @StgMieszSredniaCenaM2 = @FaktMieszkania
    PRINT 'TEST 09 PASS: Mieszkania Œrednia Cena M2';
ELSE
    PRINT 'TEST 09 FAIL: Mieszkania Œrednia Cena M2 | Staging: ' + CAST(@StgMieszSredniaCenaM2 AS VARCHAR) + ' vs Fakty: ' + CAST(@FaktMieszkania AS VARCHAR);

-- 10. MIESZKANIA WARTOŒÆ
DECLARE @StgMieszWartosc INT = (SELECT COUNT(*) FROM StagingMieszkaniaWartosc);
IF @StgMieszWartosc = @FaktMieszkania
    PRINT 'TEST 10 PASS: Mieszkania Wartoœæ';
ELSE
    PRINT 'TEST 10 FAIL: Mieszkania Wartoœæ | Staging: ' + CAST(@StgMieszWartosc AS VARCHAR) + ' vs Fakty: ' + CAST(@FaktMieszkania AS VARCHAR);

PRINT '';
PRINT '--- ZAKOÑCZENIE TESTÓW INTEGRALNOŒCI ---';
PRINT '';

PRINT '--- ROZPOCZÊCIE TESTÓW JAKOŒCI ---';

---------------------------------------------------------
-- SPRAWDZENIE DUPLIKATÓW
---------------------------------------------------------
PRINT '';
PRINT '--- WERYFIKACJA DUPLIKATÓW ---';

-- 11. WYMIAR SEKTOR
DECLARE @DuplikatySektor INT = (SELECT COUNT(*) FROM (SELECT NazwaOryginalna FROM DimSektor GROUP BY NazwaOryginalna HAVING COUNT(*) > 1) AS Sub);

IF @DuplikatySektor = 0
    PRINT 'TEST 11 PASS: Wymiar DimSektor nie zawiera duplikatów.';
ELSE
    PRINT 'TEST 11 FAIL: Znaleziono duplikaty w DimSektor! Iloœæ: ' + CAST(@DuplikatySektor AS VARCHAR);

-- 12. WYMIAR OKRES
DECLARE @DuplikatyOkres INT = (
    SELECT COUNT(*) FROM (
        SELECT Rok, Kwarta³, Miesi¹cNumer
        FROM DimOkres
        GROUP BY Rok, Kwarta³, Miesi¹cNumer
        HAVING COUNT(*) > 1
    ) AS Sub
);

IF @DuplikatyOkres = 0
    PRINT 'TEST 12 PASS: Wymiar DimOkres jest unikalny. Brak duplikatów czasu.';
ELSE
    PRINT 'TEST 12 FAIL: Krytyczny b³¹d! Wymiar DimOkres zawiera duplikaty. Iloœæ: ' + CAST(@DuplikatyOkres AS VARCHAR);

-- 13. WYMIAR JEDNOSTKA
DECLARE @DuplikatyJednostka INT = (SELECT COUNT(*) FROM (SELECT NazwaJednostki FROM DimJednostka GROUP BY NazwaJednostki HAVING COUNT(*) > 1) AS Sub);

IF @DuplikatyJednostka = 0
    PRINT 'TEST 13 PASS: Wymiar DimJednostka nie zawiera duplikatów.';
ELSE
    PRINT 'TEST 13 FAIL: Znaleziono duplikaty w DimJednostka! Iloœæ: ' + CAST(@DuplikatyJednostka AS VARCHAR);

---------------------------------------------------------
-- TESTY SCD2 W WYMIARZE REGION
---------------------------------------------------------
PRINT '';
PRINT '--- WERYFIKACJA SCD2 (DimRegion) ---';

-- 14. JEDEN AKTYWNY WIERSZ DLA REGIONU

DECLARE @ZdublowaneAktywneRegiony INT = (
    SELECT COUNT(*) FROM (
        SELECT NazwaWojewództwa
        FROM DimRegion
        WHERE ValidFlag = 1
        GROUP BY NazwaWojewództwa
        HAVING COUNT(*) > 1
    ) AS Sub
);

IF @ZdublowaneAktywneRegiony = 0
    PRINT 'TEST 14 PASS: Wymiar SCD2 jest spójny - ka¿dy region ma tylko jeden aktywny wiersz.';
ELSE
    PRINT 'TEST 14 FAIL: B£¥D SCD2! Znaleziono regiony z wieloma aktywnymi wierszami. Iloœæ: ' + CAST(@ZdublowaneAktywneRegiony AS VARCHAR);

-- 15. OTWARTE DATY DLA AKTYWNYCH REKORDÓW
-- Zak³adamy, ¿e aktywny rekord ma ValidTo równe NULL. 

DECLARE @ZleZamknieteAktywne INT = (
    SELECT COUNT(*) 
    FROM DimRegion 
    WHERE ValidFlag = 1 
      AND ValidTo IS NOT NULL 
);

IF @ZleZamknieteAktywne = 0
    PRINT 'TEST 15 PASS: Wymiar SCD2 spójny logicznie - aktywne wiersze maj¹ otwarte daty koñcowe.';
ELSE
    PRINT 'TEST 15 FAIL: B£¥D SCD2! Znaleziono aktywne regiony z zamkniêt¹ dat¹ ValidTo. Iloœæ: ' + CAST(@ZleZamknieteAktywne AS VARCHAR);

-- 16. NAK£ADANIE SIÊ OKRESÓW WA¯NOŒCI

DECLARE @NakladajaceSieOkresy INT = (
    SELECT COUNT(*) FROM (
        SELECT 
            NazwaWojewództwa,
            ValidFrom,
            ValidTo,
            LEAD(ValidFrom) OVER(PARTITION BY NazwaWojewództwa ORDER BY ValidFrom) AS NastepnyValidFrom
        FROM DimRegion
    ) AS Sub
    WHERE ValidTo > NastepnyValidFrom
);

IF @NakladajaceSieOkresy = 0
    PRINT 'TEST 16 PASS: Wymiar SCD2 ma ci¹g³¹ historiê. ¯adne okresy wa¿noœci siê nie nak³adaj¹.';
ELSE
    PRINT 'TEST 16 FAIL: KRYTYCZNY B£¥D SCD2! Znaleziono nak³adaj¹ce siê daty w historii regionów. Iloœæ: ' + CAST(@NakladajaceSieOkresy AS VARCHAR);

------------------------------------------------------------
-- SPRAWDZENIE CZYSTOŒCI DANYCH (CZY NIE MA NP. "-", "b.d")
------------------------------------------------------------
PRINT '';
PRINT '--- WERYFIKACJA CZYSTOŒCI DANYCH ---';

-- 17. WYNAGRODZENIA REGIONALNE
DECLARE @BrudneDaneWynagrodzeniaRegion INT = (SELECT COUNT(*) FROM StagingWynagrodzeniaRegion WHERE Wartosc IN ('.', '-', ' ', 'x', 'X'));

IF @BrudneDaneWynagrodzeniaRegion = 0
    PRINT 'TEST 17 PASS: Czystoœæ danych (StagingWynagrodzeniaRegion). Brak b³êdnych znaków.';
ELSE
    PRINT 'TEST 17 FAIL: Brudne dane w StagingWynagrodzeniaRegion! Iloœæ: ' + CAST(@BrudneDaneWynagrodzeniaRegion AS VARCHAR);

-- 18. WYNAGRODZENIA SEKTOR
DECLARE @BrudneDaneWynagrodzeniaSektor INT = (SELECT COUNT(*) FROM StagingWynagrodzenieSektor WHERE Wartosc IN ('.', '-', ' ', 'x', 'X'));

IF @BrudneDaneWynagrodzeniaSektor = 0
    PRINT 'TEST 18 PASS: Czystoœæ danych (StagingWynagrodzenieSektor). Brak b³êdnych znaków.';
ELSE
    PRINT 'TEST 18 FAIL: Brudne dane w StagingWynagrodzenieSektor! Iloœæ: ' + CAST(@BrudneDaneWynagrodzeniaSektor AS VARCHAR);

-- 19. BUDOWNICTWO
DECLARE @BrudneDaneBudownictwo INT = (SELECT COUNT(*) FROM StagingBudownictwo WHERE Wartosc IN ('.', '-', ' ', 'x', 'X'));

IF @BrudneDaneBudownictwo = 0
    PRINT 'TEST 19 PASS: Czystoœæ danych (StagingBudownictwo). Brak b³êdnych znaków.';
ELSE
    PRINT 'TEST 19 FAIL: Brudne dane w StagingBudownictwo! Iloœæ: ' + CAST(@BrudneDaneBudownictwo AS VARCHAR);

-- 20. KREDYTY
DECLARE @BrudneDaneKredyty INT = (SELECT COUNT(*) FROM StagingKredytyNieruchomosci WHERE Wartosc IN ('np.', 'b.d.', '.', '-', ' ', 'x', 'X'));

IF @BrudneDaneKredyty = 0
    PRINT 'TEST 20 PASS: Czystoœæ danych (StagingKredytyNieruchomosci). Brak b³êdnych znaków.';
ELSE
    PRINT 'TEST 20 FAIL: Brudne dane w StagingKredytyNieruchomosci! Iloœæ: ' + CAST(@BrudneDaneKredyty AS VARCHAR);

-- 21. MIESZKANIA
DECLARE @BrudneDaneMieszkania INT = (
    (SELECT COUNT(*) FROM StagingMieszkaniaLiczba WHERE Wartosc IN ('.', '-', ' ', 'x', 'X')) +
    (SELECT COUNT(*) FROM StagingMieszkaniaMediana WHERE Wartosc IN ('.', '-', ' ', 'x', 'X')) +
    (SELECT COUNT(*) FROM StagingMieszkaniaPowierzchnia WHERE Wartosc IN ('.', '-', ' ', 'x', 'X')) +
    (SELECT COUNT(*) FROM StagingMieszkaniaSredniaCena WHERE Wartosc IN ('.', '-', ' ', 'x', 'X')) +
    (SELECT COUNT(*) FROM StagingMieszkaniaSredniaCenaM2 WHERE Wartosc IN ('.', '-', ' ', 'x', 'X')) +
    (SELECT COUNT(*) FROM StagingMieszkaniaWartosc WHERE Wartosc IN ('.', '-', ' ', 'x', 'X'))
);

IF @BrudneDaneMieszkania = 0
    PRINT 'TEST 21 PASS: Czystoœæ danych (Wszystkie Stagingi Mieszkañ). Brak b³êdnych znaków.';
ELSE
    PRINT 'TEST 21 FAIL: Brudne dane w stagingach dla Mieszkañ! Iloœæ: ' + CAST(@BrudneDaneMieszkania AS VARCHAR);

PRINT '';
PRINT '--- ZAKOÑCZENIE TESTÓW ---';