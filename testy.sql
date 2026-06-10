SET NOCOUNT ON;
PRINT '--- ROZPOCZÊCIE TESTÓW FUNKCJONALNYCH HURTOWNI DANYCH ---';
PRINT '';

SET NOCOUNT ON;
PRINT '--- ROZPOCZÊCIE TESTÓW INTEGRALNOŒCI: STAGING VS FAKTY ---';
PRINT '';

---------------------------------------------------------
-- 1. BUDOWNICTWO (Grupowane po kwarta³ach)
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


-- TEST 11: Duplikaty w wymiarze Sektor
DECLARE @DuplikatySektor INT = (SELECT COUNT(*) FROM (SELECT NazwaOryginalna FROM DimSektor GROUP BY NazwaOryginalna HAVING COUNT(*) > 1) AS Sub);

IF @DuplikatySektor = 0
    PRINT 'TEST 11 PASS: Wymiar DimSektor nie zawiera duplikatów.';
ELSE
    PRINT 'TEST 11 FAIL: Znaleziono duplikaty w DimSektor! Iloœæ: ' + CAST(@DuplikatySektor AS VARCHAR);

-- TEST 12: Sprawdzenie czystoœci danych w Kredytach (czy przesz³o "np." lub "b.d.")
DECLARE @BrudneDaneKredyty INT = (SELECT COUNT(*) FROM StagingKredytyNieruchomosci WHERE Wartosc IN ('np.', 'b.d.', '-'));

IF @BrudneDaneKredyty = 0
    PRINT 'TEST 12 PASS: Filtracja zanieczyszczeñ C# zadzia³a³a. Brak "np.", "b.d.", "-" w danych.';
ELSE
    PRINT 'TEST 12 FAIL: Skrypt C# przepuœci³ brudne dane! Iloœæ: ' + CAST(@BrudneDaneKredyty AS VARCHAR);

-- TEST 13: Sprawdzenie matematyki (Test mno¿nika x1000)
-- Za³o¿enie: sprawdzamy czy istnieje wartoœæ z mno¿nikiem (np. > 1000) ¿eby udowodniæ ¿e transformacja zasz³a
DECLARE @PozwoleniaMax DECIMAL(18,2) = (SELECT MAX(LiczbaPozwoleñ) FROM FaktBudownictwo);

IF @PozwoleniaMax >= 1000
    PRINT 'TEST 13 PASS: Transformacja x1000 udana (Znaleziono wartoœci rzêdu tysiêcy: ' + CAST(@PozwoleniaMax AS VARCHAR) + ').';
ELSE
    PRINT 'TEST 13 FAIL: Wartoœci w LiczbaPozwoleñ s¹ za ma³e. Prawdopodobnie brak mno¿nika.';

PRINT '';
PRINT '--- ZAKOÑCZENIE TESTÓW ---';