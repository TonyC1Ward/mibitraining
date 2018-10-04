USE Dev_Martin_DataWarehouse;
GO


/*=========================================================================================
    
    Author:		    Philip Dimsdale
    Create date:    15 June 2018
    
    Description:	
 
    From table: [UoH].[STUDENT_HESA_CoreTable_DATA].

    This script has been adapted from a previous script, with all filters but one removed.
    The sole remaining filter in the WHERE statement is to select the three years where
    the HESA submission year is 2014, 2015 or 2016. These are for academic years 2014/15,
    2015/16 and 2016/17.

    There is annotation throughout the script, with additional annotation at the foot of the script.
    
    Amendments to:
    *   HESA01Dec
    *   IsCountHESA
    *   IsNonContinuationHESA
    *   IsWithdrawn

    *   IsRegisteredNextYear
    *   [UoH].[STUDENT_HESA_NonCon_PI_CHECK] added
    *   HESA flags changed

    *   Add field IsP4Q12 for Brian P

    *   IsCountUoH and IsWithdrawnUoH amended.
    *   [YEAR] extended to > 2009 (a lot more NULLs to consider).

    *   Add field DisabledYN        |
    *   Add field BME               |   Requested by Tim
    *   Add field YoungMature       |

    *   DAT.[XLEV601] IN('4') changed from DAT.[XLEV601] IN('4','5')
    *   Four fields renamed

    Philip Dimsdale
    Updated 17 July 2018

     *   Added check table exists
    Philip Dimsdale
    Updated 23 July 2018
   
=========================================================================================*/


--TRUNCATE TABLE  [UoH].[DimHESA_StudentPoSYear]
--INSERT INTO     [UoH].[DimHESA_StudentPoSYear]

SELECT
     DAT.[INSTANCEKEY]                                  AS  PoSInstanceKey          --  Joins DimHESA_StudentModuleYear
    ,DAT.[OWNSTU] 
        +'¬'+ LEFT(DAT.[COURSEID],6)
        +'¬'+ CAST(DAT.[YEAR] AS nvarchar(4))           AS  StudentPoSYear          --  Composite primary key requested by Brian P
    ,ROW_NUMBER()  
        OVER(PARTITION BY [DAT].[OWNSTU], [DAT].[Year] 
        ORDER BY [DAT].[COURSEID])                      AS  StudentCourseYearRowNo  
    ,DAT.[OWNSTU]                                       AS  StudentId               --  UoH Student ID                              -   https://www.hesa.ac.uk/collection/c17051/a/ownstu
    ,CAST(DAT.[YEAR] AS nvarchar(4))
        +'/'+ CAST(RIGHT(DAT.[YEAR],2)+1 AS nvarchar(2))AS  YearAcademic            --  Academic Year of HESA Submission 
    ,DAT.[YEAR]                                         AS  YearHESAReport          --  Year of HESA Submission
    ,CAST(
        CAST(DAT.[YEAR] AS nvarchar(4)) + '0101' 
        AS date)                                        AS  YearHESAReportDate      --  Required by Brian P
    --,CAST(
    --    CAST(DAT.[YEAR] AS nvarchar(4)) + '1201' 
    --    AS date)                                      AS  HESA01Dec               --  Probably not needed - but just in case ....
    /*===================================================================================================================================================================================*/
    ,CASE      
        WHEN HNC.[OWNSTU] IS NULL 
        THEN 0
        ELSE 1 
    END                                                 AS  IsHESAset01     -- renamed as agreed with Brian and Tony
    /*===================================================================================================================================================================================*/
    ,CASE                                                   --                                      |   
        WHEN DAT.[XFYRSR01] = 1                             --  First year student                  |   The HESA definition of a first-year, full-time undergraduate differs from
        AND  DAT.[XMODE01] = '1'                            --  Full-time                           |   UoH requirments.
        AND  DAT.[XLEV601] IN('4')                          --  First degree                        |   Changed from IN('4','5')
        AND  DAT.[YEARPRG] IN('0','1')                      --  Course year - foundation or 1st year|   Required by Brian P - 11 July 2018
        THEN 1                                              --                                      |
        ELSE 0                                              --                                      |
    END                                                 AS  IsUoHset01      -- renamed as agreed with Brian and Tony
    /*===================================================================================================================================================================================*/
    ,CASE
        WHEN DAT.[XFYRSR01] = 1                             --  First year student
        AND  DAT.[XMODE01] = '1'                            --  Full-time 
        AND  DAT.[XLEV601] IN('4')                          --  First degree    -   Changed from IN('4','5')
        AND  DAT.[YEARPRG] IN('0','1')                      --  Course year - foundation or 1st year
        AND  DAT.[RSNEND] IN ('01')                         --  Completed successfully ... BUT ...
        AND  DAT.[YEARPRG] < DAT.[SPLENGTH]                 --  did not complete the expected course length.
        AND  DT2.[IsContinue] = 0                           --  Did not return the following year
        THEN 1
        
        WHEN DAT.[XFYRSR01] = 1                             --  First year student
        AND  DAT.[XMODE01] = '1'                            --  Full-time
        AND  DAT.[XLEV601] IN('4')                          --  First degree    -   Changed from IN('4','5')
        AND  DAT.[YEARPRG] IN('0','1')                      --  Course year - foundation or 1st year
        AND  DAT.[RSNEND] NOT IN ('01','98')                --  Course not completed
        AND  DT2.[IsContinue] = 0                           --  Did not return the following year
        THEN 1
   
        ELSE 0
    END                                                 AS  IsNonConUoHset01     -- renamed as agreed with Brian and Tony
     /* RSNEND Lookup

        Code	Label
         01     Successful completion of course
         02     Academic failure/left in bad standing/not permitted to progress
         03     Transferred to another provider
         04     Health reasons
         05     Death
         06     Financial reasons
         07     Other personal reasons & dropped out
         08     Written off after lapse of time
         09     Exclusion
         10     Gone into employment
         11     Other
         12     Transferred out as part of collaborative supervision arrangements
         98     Completion of course - result unknown
         99     Unknown
    */                    
    /*===================================================================================================================================================================================*/
    ,CASE                                                                               
        WHEN HNC.[HESANonConFlag] = 6                       --  HESA non-continuation
        THEN 1                                                                           
        ELSE 0                                                                                
    END                                                 AS  IsNonConHESAset01
    /*  From HESA web site

      CODE	    DESCRIPTION	                        FINAL CLASSIFICATION
        0	    Qualify First Degree	            Continue or qualify
        1	    Qualify Other Undergraduate	        Continue or qualify
        2	    Full-time First Degree	            Continue or qualify
        3	    Full-time Other Undergraduate	    Continue or qualify
	    3       Part-time First Degree	            Continue or qualify
	    3       Part-time Other Undergraduate	    Continue or qualify
        4	    Transfer	                        Transfer
        6	    Inactive	                        No longer in HE
    */
    /*===================================================================================================================================================================================*/
    ,CASE
        WHEN DT2.[IsContinue] = 1                           --  If student is registered for next year then student did not withdraw this year
        THEN 1
        ELSE 0
     END                                                AS  IsRegisteredNextYear
    /*===================================================================================================================================================================================*/
    ,CASE 
        WHEN DAT.[YEARPRG]  = 1                             --  Year of course
        AND  DAT.[XMODE01]  = '1'                           --  Full-time 
        AND  DAT.[XLEV601]  IN('4')                         --  First degree
        AND  DAT.[SPLENGTH] = 1                             --  Expected length of study 
        THEN 1
        ELSE 0
     END                                                AS  IsPoSTopUp              --  Required by Brian P
    
    ,CASE
        WHEN PC2.[POLAR4_Quintile] IN(1,2)
        THEN 1
        ELSE 0
     END                                                AS  IsP4Q12                 --  Required by Brian P
    
    ,ISNULL(HNC.[IsFoundationYear],0)                   AS  IsFoundationYear        --  Required by Tim D
    ,DAT.[UKPRN]                                        AS  UoHRefNo                --  UK Provider Reference Number                -   https://www.hesa.ac.uk/collection/c17051/a/ukprn
    ,DAT.[HUSID]                                        AS  StudentIdHESA           --  HESA Unique Student ID                      -   https://www.hesa.ac.uk/collection/c17051/a/husid
    ,ISNULL(HIR.[Level2Name],'')                        AS  Faculty                                                                 --  Lookup
    ,ISNULL(HIR.[Level2ShortName],'')                   AS  FacultyShortName                                                        --  Lookup
    ,ISNULL(HIR.[Level3Name],'')                        AS  School                                                                  --  Lookup
    ,ISNULL(HIR.[Level3ShortName],'')                   AS  SchoolShortName                                                         --  Lookup
    ,ISNULL(HIR.[Level4Name],'')                        AS  SubjectGroupArea                                                        --  Lookup
    ,DAT.[INSTCAMP]                                     AS  OU3codeOriginal         --  Original OU3 code                           -   https://www.hesa.ac.uk/collection/c17051/a/instcamp  
    ,ISNULL(MAP.[Current_OU3_Code_Txt],DAT.[INSTCAMP])  AS  OU3CodeMap
    ,ISNULL(DAT.[NUMHUS],'')                            AS  PoSIdRegistration       --  Course code at registration                 -   https://www.hesa.ac.uk/collection/c17051/a/numhus
    ,ISNULL(DAT.[OWNINST],'')                           AS  PoSIdCurrent            --  Also POS course code - same as NUMHUS       -   https://www.hesa.ac.uk/collection/c17051/a/owninst
    ,DAT.[COURSEID]                                     AS  PoSIdHESA               --  Appears to be POS code with month suffix    -   https://www.hesa.ac.uk/collection/c17051/a/course_courseid
    ,ISNULL(CRS.[CTITLE],'')                            AS  PoSTitle                                                                --  Lookup
    ,ISNULL(DAT.[FNAMES],'')                            AS  Forenames               --  Student forenames
    ,ISNULL(DAT.[SURNAME],'')                           AS  Surname                 --  Student surname
    ,CAST(DAT.[BIRTHDTE] AS date)                       AS  DateOfBirth             --  Date of Birth
    ,ISNULL(DAT.[GENDERID],'')                          AS  GenderId                --  See Note 01 at foot of script               -   https://www.hesa.ac.uk/collection/c17051/a/genderid
    ,ISNULL(GEN.[Label],'')                             AS  IsGenderSameAsAtBirth                                                   --  Lookup
    ,ISNULL(DAT.[DISABLE],'')                           AS  DisabilityId            --  Disability code                             -   https://www.hesa.ac.uk/collection/c17051/a/disable
    ,ISNULL(DIS.[Label],'')                             AS  Disability                                                              --  Lookup
    ,ISNULL(DAT.[ETHNIC],'')                            AS  EthnicId                --  Ethnicity code                              -   https://www.hesa.ac.uk/collection/c17051/a/ethnic
    ,ISNULL(ETH.[Label],'')                             AS  Ethnicity                                                               --  Lookup
    ,ISNULL(DAT.[NATION],'')                            AS  NationalityId           --  Nationality code                            -   https://www.hesa.ac.uk/collection/c17051/a/nation
    ,ISNULL(NAT.[Label],'')                             AS  Nationality                                                             --  Lookup
    ,ISNULL(DAT.[RELBLF],'')                            AS  ReligionId              --  ReligionBelief code                         -   https://www.hesa.ac.uk/collection/c17051/a/relblf
    ,ISNULL(REL.[Label],'')                             AS  ReligiousBelief                                                         --  Lookup
    ,ISNULL(DAT.[SEXID],'')                             AS  SexId                   --  Sex identifier code                         -   https://www.hesa.ac.uk/collection/c17051/a/sexid
    ,ISNULL(SEX.[Label],'')                             AS  Sex                                                                     --  Lookup
    ,ISNULL(DAT.[SEXORT],'')                            AS  SexualOrinationId       --  Sexual orientation code                     -   https://www.hesa.ac.uk/collection/c17051/a/sexort
    ,ISNULL(ORT.[Label],'')                             AS  SexualOrientation                                                       --  Lookup
    ,ISNULL(DAT.[SCN],'')                               AS  ScottishCandidateNumber --  Scottish Candidate Number                   -   https://www.hesa.ac.uk/collection/c17051/a/scn
    ,ISNULL(DAT.[TTACCOM],'')                           AS  TermTimeAccommodationId --  Term-time accommodation code                -   https://www.hesa.ac.uk/collection/c17051/a/ttaccom
    ,ISNULL(TTA.[Label],'')                             AS  TermTimeAccommodation                                                   --  Lookup
    ,ISNULL(DAT.[TTPCODE],'')                           AS  TermTimePostcode        --  Term-time postcode                          -   https://www.hesa.ac.uk/collection/c17051/a/ttpcode
    ,ISNULL(PC1.[PostCode_Area],'')                     AS  TermTimePostcodeAreaCode                                                --  Lookup
    ,ISNULL(LEFT(PC1.[PostCode],
        CAST(LEN(PC1.[PostCode]) AS int)-4),'')         AS  TermTimePostcodeDistrictCode                                            --  Lookup
    ,ISNULL(LEFT(PC1.[PostCode],
        CAST(LEN(PC1.[PostCode]) AS int)-2),'')         AS  TermTimePostcodeSectorCode
    ,ISNULL(PC1.[POLAR3_Quintile],'')                   AS  TermTimePolar3                                                          --  Lookup
    ,ISNULL(PC1.[POLAR4_Quintile],'')                   AS  TermTimePolar4                                                          --  Lookup
    ,ISNULL(PC1.[LocalToHull],'')                       AS  TermTimeLocalToHull                                                     --  Lookup
    ,ISNULL(CAST(PC1.[DistanceFromHullUniMiles] 
        AS decimal(6,2)),0)                             AS  TermTimeDistanceMiles                                                   --  Lookup
    ,CASE
        WHEN PC1.[DistanceFromHullUniMiles] > 0 AND
            PC1.[DistanceFromHullUniMiles] <= 1
        THEN '<= 1'
        WHEN PC1.[DistanceFromHullUniMiles] > 1 AND
            PC1.[DistanceFromHullUniMiles] <= 3
        THEN '> 1 and <= 3'
        WHEN PC1.[DistanceFromHullUniMiles] > 3 AND
            PC1.[DistanceFromHullUniMiles] <= 6
        THEN '> 3 and <= 6'
        WHEN PC1.[DistanceFromHullUniMiles] > 6 AND
            PC1.[DistanceFromHullUniMiles] <= 10
        THEN '> 6 and <= 10'
        WHEN PC1.[DistanceFromHullUniMiles] > 10 AND
            PC1.[DistanceFromHullUniMiles] <= 20
        THEN '> 10 and <= 20'
        WHEN PC1.[DistanceFromHullUniMiles] > 20 AND
            PC1.[DistanceFromHullUniMiles] <= 35
        THEN '> 20 and <= 35'
        WHEN PC1.[DistanceFromHullUniMiles] > 35 AND
            PC1.[DistanceFromHullUniMiles] <= 60
        THEN '> 35 and <= 60'
        WHEN PC1.[DistanceFromHullUniMiles] > 60 
        THEN '> 60'
        ELSE 'Unknown'
     END                                                AS  TermTimeDistanceMilesBand
    ,ISNULL(PC1.[PostCode_Electoral_Ward],'')           AS  TermTimePostCodeElectoralWard                                           --  Lookup
    ,ISNULL(PC1.[PostCode_LocalAuthorityDistrict],'')   AS  TermTimePostCodeLocalAuthorityDistrict                                  --  Lookup
    ,ISNULL(PC1.[PostCode_County],'')                   AS  TermTimePostCodeCounty                                                  --  Lookup
    ,ISNULL(PC1.[PostCode_Region],'')                   AS  TermTimePostCodeRegion                                                  --  Lookup
    ,ISNULL(DAT.[UCASPERID],'')                         AS  StudentIdUCAS           --  UCAS personal identifier                    -   https://www.hesa.ac.uk/collection/c17051/a/ucasperid
    ,ISNULL(DAT.[ULN],'')                               AS  UniqueLearnerNumber     --  Unique Learner Number                       -   https://www.hesa.ac.uk/collection/c17051/a/uln
    ,ISNULL(DAT.[CARELEAVER],'')                        AS  CareLeaverId            --  Care leaver / Looked after status           -   https://www.hesa.ac.uk/collection/c17051/a/careleaver
    ,ISNULL(CRL.[Label],'')                             AS  CareLeaverDescription                                                   --  Lookup
    ,ISNULL(DAT.[DOMICILE],'')                          AS  DomicileId              --  Domicile code                               -   https://www.hesa.ac.uk/collection/c17051/a/domicile
    ,ISNULL(DOM.[Label],'')                             AS  CountryOfDomicile                                                       --  Lookup
    ,ISNULL(DAT.[PARED],'')                             AS  ParentalEducationId     --  Parental Education code                     -   https://www.hesa.ac.uk/collection/c17051/a/pared
    ,ISNULL(PED.[Label],'')                             AS  ParentHigherEdQuals                                                     --  Lookup
    ,ISNULL(DAT.[PGCECLSS],'')                          AS  PGCEclassId             --  PGCE class of undergraduate degree          -   https://www.hesa.ac.uk/collection/c17051/a/pgceclss
    ,ISNULL(PGC.[Label],'')                             AS  PGCEclassification                                                      --  Lookup
    ,ISNULL(DAT.[PGCESBJ1],'')                          AS  PGCEsubject1Id          --  PGCE subject of undergraduate degree (1)    -   https://www.hesa.ac.uk/collection/c17051/a/pgcesbj
    ,ISNULL(PG1.[Label],'')                             AS  PGCEsubject1                                                            --  Lookup
    ,ISNULL(DAT.[PGCESBJ2],'')                          AS  PGCEsubject2Id          --  PGCE subject of undergraduate degree (2)    -   https://www.hesa.ac.uk/collection/c17051/a/pgcesbj
    ,ISNULL(PG2.[Label],'')                             AS  PGCEsubject2                                                            --  Lookup
    ,ISNULL(DAT.[POSTCODE],'')                          AS  HomePostcode            --  Postcode of home address                    -   https://www.hesa.ac.uk/collection/c17051/a/postcode
    ,ISNULL(PC2.[PostCode_Area],'')                     AS  HomePostcodeAreaCode                                                    --  Lookup
    ,ISNULL(LEFT(PC2.[PostCode],
        CAST(LEN(PC2.[PostCode]) AS int)-4),'')         AS  HomePostcodeDistrictCode                                                --  Lookup
    ,ISNULL(LEFT(PC2.[PostCode],
        CAST(LEN(PC2.[PostCode]) AS int)-2),'')         AS  HomePostcodeSectorCode                                                  --  Lookup
    ,ISNULL(PC2.[POLAR3_Quintile],'')                   AS  HomePolar3                                                              --  Lookup
    ,ISNULL(PC2.[POLAR4_Quintile],'')                   AS  HomePolar4                                                              --  Lookup

    ,ISNULL(PC2.[LocalToHull],'')                       AS  HomeLocalToHull                                                         --  Lookup
    ,ISNULL(CAST(PC2.[DistanceFromHullUniMiles] 
        AS decimal(8,2)),0)                             AS  HomeDistanceMiles                                                       --  Lookup
    ,CASE
        WHEN PC2.[DistanceFromHullUniMiles] <= 15 
            THEN '<= 15 Miles'
        WHEN PC2.[DistanceFromHullUniMiles] <= 50
            THEN '> 15 and <= 50 miles'
        WHEN PC2.[DistanceFromHullUniMiles] <= 100
            THEN '> 50 and <= 100 Miles'
        WHEN PC2.[DistanceFromHullUniMiles] > 100
            THEN '> 100 Miles'
        ELSE 'Unknown'
     END                                                AS  HomeDistanceMilesBand
    ,CASE
        WHEN PC2.[DistanceFromHullUniMiles] <= 15 
            THEN 'Close'
        WHEN PC2.[DistanceFromHullUniMiles] <= 50
            THEN 'Medium'
        WHEN PC2.[DistanceFromHullUniMiles] <= 100
            THEN 'Long'
        WHEN PC2.[DistanceFromHullUniMiles] > 100
            THEN 'Very long'
        ELSE 'Unknown'
     END                                                AS  HomeDistanceMilesCategory
    ,ISNULL(PC2.[PostCode_Electoral_Ward],'')           AS  HomePostCodeElectoralWard                                               --  Lookup
    ,ISNULL(PC2.[PostCode_LocalAuthorityDistrict],'')   AS  HomePostCodeLocalAuthorityDistrict                                      --  Lookup
    ,ISNULL(PC2.[PostCode_County],'')                   AS  HomePostCodeCounty                                                      --  Lookup
    ,ISNULL(PC2.[PostCode_Region],'')                   AS  HomePostCodeRegion                                                      --  Lookup
    ,ISNULL(DAT.[PREVINST],'')                          AS  PreviousProvider        --  Previous provider attended by the student   -   https://www.hesa.ac.uk/collection/c17051/a/previnst
    ,ISNULL(DAT.[QUALENT3],'')                          AS  HighestEntryQualId      --  Highest qualification on entry              -   https://www.hesa.ac.uk/collection/c17051/a/qualent3
    ,ISNULL(QAL.[Label],'')                             AS  HighestQualificationOnEntry                                             --  Lookup
    ,ISNULL(DAT.[SEC],'')                               AS  SECId                   --  Socio-economic classification code          -   https://www.hesa.ac.uk/collection/c17051/a/sec
    ,ISNULL(SEC.[Label],'')                             AS  SocioEconomicClassification                                             --  Lookup
    ,ISNULL(DAT.[SOC2000],'')                           AS  Occupation1Id           --  Occupation code                             -   https://www.hesa.ac.uk/collection/c17051/a/soc2000
    ,ISNULL(S20.[Label],'')                             AS  Occupation1                                                             --  Lookup
    ,ISNULL(DAT.[SOC2010],'')                           AS  Occupation2Id           --  Occupation code                             -   https://www.hesa.ac.uk/collection/c17051/a/soc2010
    ,ISNULL(S21.[Label],'')                             AS  Occupation2                                                             --  Lookup
    ,ISNULL(DAT.[UCASAPPID],'')                         AS  UCASApplicationNumber   --  UCAS Application Number                     -   https://www.hesa.ac.uk/collection/c17051/a/ucasappid
    ,ISNULL(DAT.[YRLLINST],'')                          AS  YearLeftLastProvider    --  Year left last provider                     -   https://www.hesa.ac.uk/collection/c17051/a/yrllinst
    ,ISNULL(DAT.[AIMTYPE],'')                           AS  TypeOfAimId             --  Type of aim recorded                        -   https://www.hesa.ac.uk/collection/c17051/a/aimtype
    ,ISNULL(AIM.[Label],'')                             AS  TypeOfAim                                                               --  Lookup
    ,ISNULL(DAT.[CAMPID],'')                            AS  CampusId                --  Campus identifier                           -   https://www.hesa.ac.uk/collection/c17051/a/campid
    ,ISNULL(CASE
        WHEN DAT.[CAMPID] = 'B'
        THEN 'Scarborough'
        ELSE 'Hull'
     END,'')                                            AS  Campus
    ,CAST(DAT.[COMDATE] AS date)                        AS  DateStart               --  Date start                                  -   https://www.hesa.ac.uk/collection/c17051/a/comdate
    ,ISNULL(DAT.[CSTAT],'')                             AS  CompletionStatusId      --  Completion status code                      -   https://www.hesa.ac.uk/collection/c17051/a/cstat
    ,ISNULL(CST.[Label],'')                             AS  CompletionStatus                                                        --  Lookup
    ,ISNULL(DAT.[DHFUND],'')                            AS  DeptHealthFundingBodyId --  Department of Health funding body code      -   https://www.hesa.ac.uk/collection/c17051/a/dhfund
    ,ISNULL(DHF.[Label],'')                             AS  DeptHealthFundingBody                                                   --  Lookup             
    ,ISNULL(DAT.[DHREGREF],'')                          AS  RegulatoryBodyRefNo     --  Regulatory body reference number            -   https://www.hesa.ac.uk/collection/c17051/a/dhregref
    ,ISNULL(DAT.[DISALL],'')                            AS  DisabilityAllowanceId   --  Disabled Student Allowance code             -   https://www.hesa.ac.uk/collection/c17051/a/disall
    ,ISNULL(DSL.[Code],'')                              AS  DisabilityAllowance                                                     --  Lookup
    ,ISNULL(DAT.[ELQ],'')                               AS  AimingForELQId          --  Aiming for Equivalent or Lower Qualification-   https://www.hesa.ac.uk/collection/c17051/a/elq
    ,ISNULL(ELQ.[Label],'')                             AS  AimingForELQ                                                            --  Lookup
    ,ISNULL(CAST(DAT.[ENDDATE] AS date),'99991231')     AS  DateLeft                --  Date student left                           -   https://www.hesa.ac.uk/collection/c17051/a/enddate
    ,ISNULL(DAT.[ENTRYRTE],'')                          AS  IITProvisionRouteId     --  Route student has accessed ITT provision    -   https://www.hesa.ac.uk/collection/c17051/a/entryrte
    ,ISNULL(ENT.[Label],'')                             AS  IITProvisionRoute                                                       --  Lookup
    ,ISNULL(DAT.[EXCHANGE],'')                          AS  ExchangeProgrammeId     --  Exchange programmes                         -   https://www.hesa.ac.uk/collection/c17051/a/exchange
    ,ISNULL(XCH.[Label],'')                             AS  ExchangeProgramme                                                       --  Lookup
    ,ISNULL(DAT.[FEEELIG],'')                           AS  FeeEligibilityId        --  Fee eligibility code                        -   https://www.hesa.ac.uk/collection/c17051/a/feeelig
    ,ISNULL(FLG.[Label],'')                             AS  FeeEligibility                                                          --  Lookup
    ,ISNULL(DAT.[FEEREGIME],'')                         AS  FeeRegimeId             --  Fee regime indicator                        -   https://www.hesa.ac.uk/collection/c17051/a/feeregime
    ,ISNULL(FRG.[Label],'')                             AS  FeeRegime                                                               --  Lookup
    ,ISNULL(DAT.[FESTUMK],'')                           AS  FEStudentMarker         --  FE student marker                           -   https://www.hesa.ac.uk/collection/c17051/a/festumk
    ,ISNULL(FST.[Label],'')                             AS  FEStudentMarkerId                                                       --  Lookup
    ,ISNULL(DAT.[FUNDCODE],'')                          AS  FundabilityId           --  Fundability code                            -   https://www.hesa.ac.uk/collection/c17051/a/fundcode
    ,ISNULL(FCD.[Label],'')                             AS  Fundability                                                             --  Lookup
    ,ISNULL(DAT.[FUNDCOMP],'')                          AS  CompletionStatusYrId    --  Completion status code for the year         -   https://www.hesa.ac.uk/collection/c17051/a/fundcomp
    ,ISNULL(FNC.[Label],'')                             AS  CompletionStatusYear                                                    --  Lookup
    ,ISNULL(DAT.[FUNDLEV],'')                           AS  FundingLevelId          --  Level applicable to funding council HESES   -   https://www.hesa.ac.uk/collection/c17051/a/fundlev
    ,ISNULL(FDV.[Label],'')                             AS  FundingLevel                                                            --  Lookup
    ,ISNULL(DAT.[FUNDMODEL],'')                         AS  FundinModelId           --  Funding Model code                          -   https://www.hesa.ac.uk/collection/c17051/a/fundmodel
    ,ISNULL(FML.[Label],'')                             AS  FundinModel                                                             --  Lookup
    ,ISNULL(DAT.[GROSSFEE],'')                          AS  GrossFee                --  Gross Fee                                   -   https://www.hesa.ac.uk/collection/c17051/a/grossfee
    ,ISNULL(DAT.[INITIATIVES1],'')                      AS  InitiativeId1           --  Initiatives code (1)                        -   https://www.hesa.ac.uk/collection/c17051/a/initiatives
    ,ISNULL(IV1.[Label],'')                             AS  Initiative1                                                             --  Lookup
    ,ISNULL(DAT.[INITIATIVES2],'')                      AS  InitiativeId2           --  Initiatives code (2)                        -   https://www.hesa.ac.uk/collection/c17051/a/initiatives
    ,ISNULL(IV2.[Label],'')                             AS  Initiative2                                                             --  Lookup
    ,ISNULL(DAT.[ITTAIM],'')                            AS  ITTaimId                --  ITT qualification aim code                  -   https://www.hesa.ac.uk/collection/c17051/a/ittaim
    ,ISNULL(TTM.[Label],'')                             AS  InitialTeacherTrainingAim                                               --  Lookup
    ,ISNULL(DAT.[ITTPHSC],'')                           AS  ITTphaseId              --  ITT phase/scope code                        -   https://www.hesa.ac.uk/collection/c17051/a/ittphsc
    ,ISNULL(TTP.[Label],'')                             AS  ITTphase                                                                --  Lookup
    ,ISNULL(DAT.[ITTSCHMS],'')                          AS  ITTschemeId             --  ITT Schemes codes                           -   https://www.hesa.ac.uk/collection/c17051/a/ittschms
    ,ISNULL(TTS.[Label],'')                             AS  ITTscheme                                                               --  Lookup
    ,ISNULL(DAT.[LEARNPLANENDDATE],'99991231')          AS  DateLearningPlannedEnd  --  Learning Planned end date                   -   https://www.hesa.ac.uk/collection/c17051/a/learnplanenddate
    ,ISNULL(DAT.[LOCSDY],'')                            AS  StudyLocationId         --  Location of study                           -   https://www.hesa.ac.uk/collection/c17051/a/locsdy
    ,ISNULL(LCS.[Label],'')                             AS  StudyLocation                                                           --  Lookup
    ,ISNULL(DAT.[MCDATE],'99991231')                    AS  DateModeChange          --  Change of mode date                         -   https://www.hesa.ac.uk/collection/c17051/a/mcdate
    ,ISNULL(DAT.[MODE],'')                              AS  StudyModeId             --  Mode of study                               -   https://www.hesa.ac.uk/collection/c17051/a/mode
    ,ISNULL(SMD.[Label],'')                             AS  StudyMode                                                               --  Lookup
    ,RIGHT('000'+ISNULL(DAT.[MSTUFEE],''),2)            AS  TuitionFeesSourceId     --  Major source of tuition fees code           -   https://www.hesa.ac.uk/collection/c17051/a/mstufee
    ,ISNULL(FEE.[Label],'No description for this code') AS  TuitionFeeMainSource                                                    --  Lookup
    ,CASE
        WHEN DAT.[NETFEE] IS NULL THEN 0
        WHEN DAT.[NETFEE] = ''    THEN 0
        ELSE DAT.[NETFEE]
     END                                                AS  NetFee                  --  Net fee                                     -   https://www.hesa.ac.uk/collection/c17051/a/netfee
    ,ISNULL(DAT.[NOTACT],'')                            AS  ActiveStudySuspendedId  --  Suspension of active studies                -   https://www.hesa.ac.uk/collection/c17051/a/notact
    ,ISNULL(NTA.[Label],'')                             AS  ActiveStudySuspended                                                    --  Lookup
    ,ISNULL(DAT.[PARTNERUKPRN],'')                      AS  PartnerId               --  Subcontracted or partnership UKPRN          -   https://www.hesa.ac.uk/collection/c17051/a/partnerukprn
    ,ISNULL(DAT.[PHDSUB],'99991231')                    AS  DatePhDsubmission       --  PhD submission date                         -   https://www.hesa.ac.uk/collection/c17051/a/phdsub
    ,ISNULL(DAT.[PROGTYPE],'')                          AS  ProgrammeTypeId         --  Programme type                              -   https://www.hesa.ac.uk/collection/c17051/a/progtype
    ,ISNULL(PGT.[Label],'')                             AS  ProgrammeType                                                           --  Lookup
    ,ISNULL(DAT.[QTS],'')                               AS  QTSId                   --  Qualified teacher status code               -   https://www.hesa.ac.uk/collection/c17051/a/qts
    ,ISNULL(QTS.[Label],'')                             AS  QualifiedTeacherStatus                                                  --  Lookup
    ,ISNULL(DAT.[RCSTDNT],'')                           AS  ReasearchCouncilStudentId --  Research council student code             -   https://www.hesa.ac.uk/collection/c17051/a/rcstdnt
    ,ISNULL(RCS.[Label],'')                             AS  ReasearchCouncilStudent                                                 --  Lookup
    ,ISNULL(DAT.[REDUCEDI],'')                          AS  ReducedInstanceId       --  Reduced instance return indicator code      -   https://www.hesa.ac.uk/collection/c17051/a/reducedi
    ,ISNULL(RDC.[Label],'')                             AS  ReducedInstanceReturnIndicator                                          --  Lookup
    ,ISNULL(DAT.[RSNEND],'')                            AS  ReasonLeftId            --  Reason for leaving code                     -   https://www.hesa.ac.uk/collection/c17051/a/rsnend
    ,ISNULL(RSN.[Label],'')                             AS  ReasonForLeaving                                                        --  Lookup
    ,ISNULL(DAT.[SPECFEE],'')                           AS  SpecialFeeId            --  Special fee indicator code                  -   https://www.hesa.ac.uk/collection/c17051/a/specfee
    ,ISNULL(SPF.[Label],'')                             AS  SpecialFeeIndicator                                                     --  Lookup
    ,ISNULL(DAT.[SPLENGTH],'')                          AS  ExpectedLengthStudy     --  Expected length of study                    -   https://www.hesa.ac.uk/collection/c17051/a/splength
    ,ISNULL(DAT.[SSN],'')                               AS  StudentSupportNumber    --  Student Support No (Student Loans Company)  -   https://www.hesa.ac.uk/collection/c17051/a/ssn
    ,ISNULL(DAT.[STULOAD],0)                            AS  StudentFTE              --  Student FTE                                 -   https://www.hesa.ac.uk/collection/c17051/a/stuload
    ,ISNULL(DAT.[TREFNO],'')                            AS  TeacherReferenceNumber  --  Teacher Reference Number                    -   https://www.hesa.ac.uk/collection/c17051/a/trefno
    ,ISNULL(DAT.[TYPEYR],'')                            AS  YearTypeId              --  Type of instance year                       -   https://www.hesa.ac.uk/collection/c17051/a/typeyr
    ,ISNULL(TYR.[Label],'')                             AS  YearType                                                                --  Lookup
    ,ISNULL(DAT.[UNITLGTH],'')                          AS  UnitsOfLengthId         --  Units of length code                        -   https://www.hesa.ac.uk/collection/c17051/a/unitlgth
    ,ISNULL(UNL.[Label],'')                             AS  UnitsOfLength                                                           --  Lookup
    ,ISNULL(DAT.[YEARPRG],'')                           AS  CourseYear              --  Year of course                              -   https://www.hesa.ac.uk/collection/c17051/a/yearprg
    ,ISNULL(DAT.[YEARSTU],'')                           AS  StudentYear             --  Year of student on this instance            -   https://www.hesa.ac.uk/collection/c17051/a/yearstu
    ,ISNULL(DAT.[COURSEAIM],'')                         AS  CourseQualificationAimId--  General qualification aim of course code    -   https://www.hesa.ac.uk/collection/c17051/a/courseaim
    ,ISNULL(CQI.[Label],'')                             AS  CourseQualificationAim                                                  --  Lookup
    ,ISNULL(DAT.[MSFUND],'')                            AS  FundingSourceId         --  Major source of funding code                -   https://www.hesa.ac.uk/collection/c17051/a/msfund
    ,ISNULL(MSF.[Label],'')                             AS  FundingSource                                                           --  Lookup
    ,ISNULL(DAT.[TTCID],'')                             AS  TeacherTrainingCourseId --  Teacher training course code                -   https://www.hesa.ac.uk/collection/c17051/a/ttcid
    ,ISNULL(TTC.[Label],'')                             AS  TeacherTrainingCourse                                                   --  Lookup

    /*  The following 'X' fields are included by HESA when the submission is returned to UoH.    
        See folder X:\ICTD - Projects\PhilipD\HESA_X_Fields_Lookup_c16051 for PDF information files.
        
        The 'X' lookup label names include an 'X' suffix to differentiate from the UoH submission
        fields and also to avoid duplicate field names.                                              */

    ,DAT.[XAGEA01]                                  --  Age at 31 August in reporting year            
    ,AGE.[Label]                                    AS  Age31AugustX
    ,CASE 
        WHEN [XAGEA01] < 21 
        THEN 'Young' 
        ELSE 'Mature' 
     END                                            AS  YoungMature
    ,DAT.[XAGEJ01]                                  --  Age at 31 July in reporting year
    ,AGJ.[Code]                                     AS  Age31JulyX                                                                  
    ,DAT.[XAGRP601]                                 --  Age grouping at 31 August
    ,AGR.[Label]                                    AS  AgeGroupX                                                                   
    ,ISNULL(DAT.[XAGRPA01],'')                      AS  XAGRPA01    --  Age grouping at 31 August - 6 way split
    ,ISNULL(AGA.[Label],'')                         AS  AgeGroup6WaySplitX                                                          
    ,DAT.[XAGRPJ01]                                 --  Age grouping at 31 July in reporting year
    ,AGR.[Label]                                    AS  AgeGroup31JulyX                                                             
    ,ISNULL(DAT.[XAPP01],'')                        AS  [XAPP01]    --  Apprenticeship identifier
    ,ISNULL(APP.[Label],'')                         AS  ApprenticeshipIdentifierX                                                   
    ,DAT.[XCLASS01]                                 --  Classification of qualification - aggregates [XCLASSF01]                    
    ,CLA.[Label]                                    AS  ClassificationOfQualificationX                                              
    ,CASE 
        WHEN DAT.[XCLASSF01] IS NULL
            THEN ''
        WHEN DAT.[XCLASSF01] = '0A'                 --  The lookup is 'A' but the table incorrectly contains '0A'
            THEN 'A' 
        ELSE DAT.[XCLASSF01]
     END                                            AS  [XCLASSF01] --  Classification of qualification - highest-ranked qualificatio
    ,ISNULL(CLF.[Label],'')                         AS  HighestRankedQualificationX
    ,ISNULL(DAT.[XDLEV301],'')                      AS  XDLEV301    --  Level of qualification in DLHE - 3 way split
    ,ISNULL(LV3.[Label],'')                         AS  LevelOfQualification3WaySplitX
    ,ISNULL(DAT.[XDLEV501],'')                      AS  XDLEV501    --  Level of qualification in DLHE - 5 way split
    ,ISNULL(LV5.[Label],'')                         AS  LevelOfQualification5WaySplitX
    ,ISNULL(DAT.[XDLEV601],'')                      AS  XDLEV601    --  Level of qualification in DLHE - 6 way split
    ,ISNULL(LV6.[Label],'')                         AS  LevelOfQualification6WaySplitX
    ,DAT.[XDOM01]                                   --  Domicile code
    ,DM1.[Label]                                    AS  DomicileCountryX
    ,DAT.[XDOMGR01]                                 --  Region of student domicile
    ,DM2.[Label]                                    AS  DomicileRegionX
    ,ISNULL(DAT.[XDOMGR401],'')                     AS  XDOMGR401    --  Region of student domicile - 4 way split
    ,ISNULL(DM3.[Label],'')                         AS  DomicileRegion4WaySplitX
    ,DAT.[XDOMHM01]                                 --  Domicile (participation by nation)
    ,DM4.[Label]                                    AS  DomicileNationX
    ,DAT.[XDOMREG01]                                --  Domicile region
    ,DM5.[Label]                                    AS  DomicileRegionInternationalX
    ,DAT.[XDOMUC01]                                 --  Domicile (county/region/unitary authority/local government district level)
    ,DM6.[Label]                                    AS  DomicileLocalLevelX
    ,DAT.[XELSP01]                                  --  Expected length of study programme
    ,ELS.[Label]                                    AS  ExpectedLengthOfStudyX
    ,DAT.[XEPYEAR01]                                --  Last year in which an Entry Profile for a UHN was supplied to HESA
    ,ISNULL(DAT.[XETHNIC01],'')                     AS  [XETHNIC01] --  Analytical protocol ethnicity
    ,ISNULL(ET2.[Label],'')                         AS  EthnicityUKdomicileX
    ,CASE 
        WHEN DAT.[XETHNIC01] = '10' 
            THEN 'White'
        WHEN [XETHNIC01] IN ('99') 
            THEN 'Unknown'
        WHEN [XETHNIC01] IN ('NA','UN') 
            THEN 'Non/Domicile Unknown'
        ELSE 'BME' 
     END                                            AS  BME --  Requested by Tim
    ,DAT.[XFYEAR01]                                 --  First year identifier (to be used with XPDEC01 only)
    ,DAT.[XFYRSR01]                                 --  First year identifier (to be used with XPSR01 only)
    ,DAT.[XHOOS01]                                  --  Home/overseas student
    ,HOS.[Label]                                    AS  HomeOverseasX
    ,DAT.[XINSTC01]                                 --  Country of higher education provider
    ,IN1.[Label]                                    AS  HigherEducationProviderCountryX
    ,DAT.[XINSTG01]                                 --  Region of higher education provider
    ,IN2.[Label]                                    AS  HigherEducationProviderRegionX
    ,CASE 
        WHEN DAT.[XINSTID01] = '120'
        THEN '0120'
        ELSE DAT.[XINSTID01]
     END                                            AS  [XINSTID01] --  HESA higher education provider identifier
    ,IN3.[Label]                                    AS  HigherEducationProviderX
    ,DAT.[XLEV301]                                  --  Level of study - 3 way split
    ,LE3.[Label]                                    AS  LevelOfStudy3WaySplitX
    ,DAT.[XLEV501]                                  --  Level of study - 5 way split
    ,LE5.[Label]                                    AS  LevelOfStudy5WaySplitX
    ,DAT.[XLEV601]                                  --  Level of study - 6 way split
    ,LE6.[Label]                                    AS  LevelOfStudy6WaySplitX
    ,DAT.[XMODE01]                                  --  Mode of study
    ,MD1.[Label]                                    AS  ModeOfStudyX
    ,ISNULL(DAT.[XMODE301],'')                      AS  XMODE301    --  Mode of study - 3 way split
    ,ISNULL(MD3.[Label],'')                         AS  StudyMode3WaySplitX
    ,CASE
        WHEN DAT.[XMSFUND01] 
            IN('1','2','3','4','5','6','7','8','9')
        THEN '0'+ DAT.[XMSFUND01]
        ELSE DAT.[XMSFUND01]                        
     END                                            AS [XMSFUND01]  --  Major source of funding
    ,FND.[Label]                                    AS  MajorSourceOfFundingX
    ,DAT.[XMSTUFEE01]                               --  Major source of tuition fees
    ,FN2.[Label]                                    AS  MajorSourceOfTuitionFeesX
    ,DAT.[XNATGR01]                                 --  Geographic region of student nationality
    ,NT1.[Label]                                    AS  NationalityRegionX
    ,DAT.[XOBTND01]                                 --  DLHE highest qualification obtained
    ,BTN.[Label]                                    AS  HighestDLHEQualificationObtainedX
    ,DAT.[XPDEC01]                                  --  Population at 1 December
    ,PDE.[Label]                                    AS  Population1DecemberX
    ,DAT.[XPDLHE02]                                 --  DLHE population
    ,PDL.[Label]                                    AS  DLHEpopulationX
    ,DAT.[XPQUAL01]                                 --  Qualifications obtained population
    ,PQL.[Label]                                    AS  QualificationsObtainedPopulationX
    ,DAT.[XPSES01]                                  --  Session population
    ,PSE.[Label]                                    AS  SessionPopulationX
    ,DAT.[XPSR01]                                   --  Standard registration population
    ,PSR.[Label]                                    AS  StandardRegistrationPopulationX
    ,CASE
        WHEN DAT.XQLEV1003 = '__' 
            THEN DAT.XQLEV1003
        WHEN LEFT(DAT.XQLEV1003,1) <> '0' 
            THEN '0'+DAT.XQLEV1003
        ELSE DAT.XQLEV1003
     END                                            AS  XQLEV1003   --  Level of qualification - 10 way split
    ,QL1.[Label]                                    AS  Qualification10WaySplitX
    ,DAT.[XQLEV301]                                 --  Level of qualification - 3 way split
    ,QL3.[Label]                                    AS  Qualification3WaySplitX
    ,DAT.[XQLEV501]                                 --  Level of qualification - 5 way split
    ,QL5.[Label]                                    AS  Qualification5WaySplitX
    ,DAT.[XQLEV601]                                 --  Level of qualification - 6 way split
    ,QL6.[Label]                                    AS  Qualification6WaySplitX
    ,ISNULL(DAT.[XQLEV701],'')                      AS  XQLEV701    --  Level of qualification - 7 way split
    ,ISNULL(QL7.[Label],'')                         AS  Qualification7WaySplitX
    ,DAT.[XQMODE01]                                 --  Qualification obtained mode of study
    ,QMD.[Label]                                    AS  QualificationObtainedModeOfStudyX
    ,DAT.[XQOBTN01]                                 --  Highest qualification obtained
    ,QBT.[Label]                                    AS  HighestQualificationObtainedX
    ,DAT.[XQUALENT01]                               --  Highest qualification on entry
    ,QLT.[Label]                                    AS  HighestQualificationOnEntryX
    ,DAT.[XSTUDIS01]                                --  Student disability
    ,STD.[Label]                                    AS  StudentDisabilityX
    ,CASE 
        WHEN DAT.[XSTUDIS01] = 'A' THEN 'N'
        WHEN DAT.[XSTUDIS01] = 'X' THEN 'NA'
        ELSE 'Y' 
     END                                            AS  DisabledYN      --  Requested by Tim
    ,DAT.[XTARIFF]                                  AS  TariffUCASX     --  UCAS Tariff for general purposes
    ,CASE
        WHEN DAT.[XTARIFF] IN('____','$$$$')         
        THEN 0
        ELSE CAST(DAT.[XTARIFF] AS int)
     END                                            AS  TariffX         --  Tariff analysis groupings
    ,ISNULL(DAT.[XTARIFFGP01],'')                   AS  TariffGroupX
    ,ISNULL(DAT.[XTPOINTS],0)                       AS  TariffPointsX   --  UCAS tariff point aggregation

--INTO UoH.DimHESA_StudentPoSYear
/*
DROP TABLE UoH.DimHESA_StudentPoSYear
*/
FROM 
    [UoH].[STUDENT_HESA_CoreTable_DATA]                         AS  DAT     --  Main data
 
    LEFT OUTER JOIN
        (
        SELECT
             COR.[OWNSTU]
            ,COR.[YEAR]
            ,MAX(DATEPART(YEAR,CEN.[analysis_date]))         AS  YearCensus
            ,CASE
                WHEN MAX(DATEPART(YEAR,CEN.[analysis_date])) > COR.[YEAR]
                THEN 1
                ELSE 0
            END AS IsContinue
        FROM
            [UoH].[STUDENT_HESA_CoreTable_DATA]         AS  COR
            LEFT OUTER JOIN [UoH].[Dec1st_Census]   AS  CEN
                ON COR.[OWNSTU] = CEN.[stdnt_nbr]
        WHERE
            COR.[YEAR] > 2009
            AND  [XFYRSR01] = 1       
            AND  [XMODE01] = '1'      
            AND  [XLEV601] IN('4','5')          
        GROUP BY
            COR.[OWNSTU]
            ,COR.[YEAR]
        )                                                       AS  DT2      --  Most recent report year for each distinct student
        ON DAT.[OWNSTU] = DT2.[OWNSTU]
        AND DAT.[YEAR] = DT2.[YEAR]
    
    LEFT OUTER JOIN [UoH].[STUDENT_HESA_NonCon_PI_CHECK]        AS  HNC     --  HESA category flags 0 to 6. 6 = non-continuation.
        ON DAT.[INSTANCEKEY] = HNC.[INSTANCEKEY]
        --AND DAT.[YEAR] = HNC.[YEAR]

    LEFT OUTER JOIN [UoH].[STUDENT_HESA_CourseTable_DATA]       AS  CRS     --  HESA course table
        ON DAT.[COURSEID] = CRS.[COURSEID]
        AND DAT.[YEAR] = CRS.[YEAR]
    LEFT OUTER JOIN [UoH].[Subject_Mapper_OU3]                  AS  MAP     --  Maps previous codes to existing codes
        ON DAT.[INSTCAMP] = MAP.Original_OU3_Code_Txt
    LEFT OUTER JOIN [UoH].[Subject_Master]                      AS  HIR     --  Academic model (hierarchy)
        ON ISNULL(MAP.[Current_OU3_Code_Txt],
            DAT.[INSTCAMP]) = HIR.[OU3_Code_Txt]
    LEFT OUTER JOIN [UoH].[Postcode_Table]                      AS  PC1     --  Term time postcode
        ON DAT.[TTPCODE] = PC1.[PostCode]
    LEFT OUTER JOIN [UoH].[Postcode_Table]                      AS  PC2     --  Home postcode
        ON DAT.[POSTCODE] = PC2.[PostCode]
    LEFT OUTER JOIN [UoH].[HESA_GENDER]                         AS  GEN     --  Gender
        ON  DAT.[GENDERID] = GEN.[Code]
    LEFT OUTER JOIN [UoH].[HESA_DISABLE]                        AS  DIS     --  Disability
        ON  DAT.[DISABLE] = DIS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_ETHNIC]                         AS  ETH     --  Ethnicity
        ON  DAT.[ETHNIC] = ETH.Code
    LEFT OUTER JOIN [UoH].[HESA_NATION]                         AS  NAT     --  Nationality
        ON  DAT.[NATION] = NAT.[Code]
    LEFT OUTER JOIN [UoH].[HESA_RELBLF]                         AS  REL     --  Religious belief
        ON  DAT.[RELBLF] = REL.[Code]
    LEFT OUTER JOIN [UoH].[HESA_SEXID]                          AS  SEX     --  Sex
        ON  DAT.[SEXID] = SEX.[Code]
    LEFT OUTER JOIN [UoH].[HESA_SEXORT]                         AS  ORT     --  Sexual orientation
        ON  DAT.[SEXORT] = ORT.[Code]
    LEFT OUTER JOIN [UoH].[HESA_CARELEAVER]                     AS  CRL     --  Care leaver
        ON  DAT.[CARELEAVER] = CRL.[Code]
    LEFT OUTER JOIN [UoH].[HESA_TTACCOM]                        AS  TTA     --  Term-time accommodation
        ON  DAT.[TTACCOM] = TTA.[Code]
    LEFT OUTER JOIN [UoH].[HESA_DOMICILE]                       AS  DOM     --  Country of domicile
        ON  DAT.[DOMICILE] = DOM.[Code]
    LEFT OUTER JOIN [UoH].[HESA_PARED]                          AS  PED     --  Parental education
        ON  DAT.[PARED] = PED.[Code]  
    LEFT OUTER JOIN [UoH].[HESA_PGCECLSS]                       AS  PGC     --  PGCE class of undergraduate degree
        ON  DAT.[PGCECLSS] = PGC.[Code]
    LEFT OUTER JOIN [UoH].[HESA_PGCESBJ]                        AS  PG1     --  PGCE subject of undergraduate degree (1)
        ON  DAT.[PGCESBJ1] = PG1.[Code]
    LEFT OUTER JOIN [UoH].[HESA_PGCESBJ]                        AS  PG2     --  PGCE subject of undergraduate degree (2)
        ON  DAT.[PGCESBJ2] = PG2.[Code]  
    LEFT OUTER JOIN [UoH].[HESA_QUALENT3]                       AS  QAL     --  Highest qualification on entry
        ON  DAT.[QUALENT3] = QAL.[Code]   
    LEFT OUTER JOIN [UoH].[HESA_SEC]                            AS  SEC     --  Socio-economic classification
        ON  DAT.[SEC] = SEC.[Code]
    LEFT OUTER JOIN [UoH].[HESA_SOC2000]                        AS  S20     --  Occupation code 1
        ON  DAT.[SOC2000] = S20.[Code]
    LEFT OUTER JOIN [UoH].[HESA_SOC2010]                        AS  S21     --  Occupation code 2
        ON  DAT.[SOC2010] = S21.[Code]
    LEFT OUTER JOIN [UoH].[HESA_RSNEND]                         AS  RSN     --  Reason for leaving
        ON  DAT.[RSNEND] = RSN.[Code]
    LEFT OUTER JOIN [UoH].[HESA_AIMTYPE]                        AS  AIM     --  Type of aim recorded
        ON DAT.[AIMTYPE] = AIM.[Code]
    LEFT OUTER JOIN [UoH].[HESA_CSTAT]                          AS  CST     --  Completion status
        ON DAT.[CSTAT] = CST.[Code]
    LEFT OUTER JOIN [UoH].[HESA_DHFUND]                         AS  DHF     --  Dept of Health funding body
        ON DAT.[DHFUND] = DHF.[Code]
    LEFT OUTER JOIN [UoH].[HESA_DISALL]                         AS  DSL     --  Disabled student allowance
        ON DAT.[DISALL] = DSL.[Code]   
    LEFT OUTER JOIN [UoH].[HESA_ELQ]                            AS  ELQ     --  Aiming for equivalent or lower qualification
        ON DAT.[ELQ] = ELQ.[Code]
    LEFT OUTER JOIN [UoH].[HESA_ENTRYRTE]                       AS  ENT     --  Route student has accessed ITT provision
        ON DAT.[ENTRYRTE] = ENT.[Code]
    LEFT OUTER JOIN [UoH].[HESA_EXCHANGE]                       AS  XCH     --  Exchange programme
        ON DAT.[EXCHANGE] = XCH.[Code]
    LEFT OUTER JOIN [UoH].[HESA_FEEELIG]                        AS  FLG     --  Fee eligibility
        ON DAT.[FEEELIG] = FLG.[Code]
    LEFT OUTER JOIN [UoH].[HESA_FEEREGIME]                      AS  FRG     --  Fee regime
        ON DAT.[FEEREGIME] = FRG.[Label]
    LEFT OUTER JOIN [UoH].[HESA_FESTUMK]                        AS  FST     --  FE student marker
        ON DAT.[FESTUMK] = FST.[Code]
    LEFT OUTER JOIN [UoH].[HESA_FUNDCODE]                       AS  FCD     --  Fundability
        ON DAT.[FUNDCODE] = FCD.[Code]
    LEFT OUTER JOIN [UoH].[HESA_FUNDCOMP]                       AS  FNC     --  Completion status for the year
        ON DAT.[FUNDCOMP] = FNC.[Code]
    LEFT OUTER JOIN [UoH].[HESA_FUNDLEV]                        AS  FDV     --  Level applicable to funding council HESES
        ON DAT.[FUNDLEV] = FDV.[Code]
    LEFT OUTER JOIN [UoH].[HESA_FUNDMODEL]                      AS  FML     --  Funding model
        ON DAT.[FUNDMODEL] = FML.[Code]
    LEFT OUTER JOIN [UoH].[HESA_INITIATIVES]                    AS  IV1     --  Initiatives1
        ON DAT.[INITIATIVES1] = IV1.[Code]
    LEFT OUTER JOIN [UoH].[HESA_INITIATIVES]                    AS  IV2     --  Initiatives2
        ON DAT.[INITIATIVES2] = IV2.[Code]
    LEFT OUTER JOIN [UoH].[HESA_ITTAIM]                         AS  TTM     --  Initial teacher qualifiaction aim
        ON DAT.[ITTAIM] = TTM.[Code]
    LEFT OUTER JOIN [UoH].[HESA_ITTPHSC]                        AS  TTP     --  Initial teacher training phase/scope
        ON DAT.[ITTPHSC] = TTP.[Code]
    LEFT OUTER JOIN [UoH].[HESA_ITTSCHMS]                       AS  TTS     --  Initial teacher training schemes
        ON DAT.[ITTSCHMS] = TTS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_LOCSDY]                         AS  LCS
        ON DAT.[LOCSDY] = LCS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_MODE]                           AS  SMD     --  Study mode
        ON DAT.[MODE] = SMD.[Code]   
    LEFT OUTER JOIN [UoH].[HESA_MSTUFEE]                        AS  FEE     --  Main source of tuition fee
        ON 
        (
        RIGHT('000'+ISNULL(DAT.[MSTUFEE],''),2)
        ) = FEE.[Code]   
    LEFT OUTER JOIN [UoH].[HESA_NOTACT]                         AS  NTA
        ON DAT.[NOTACT] = NTA.[Code]
    LEFT OUTER JOIN [UoH].[HESA_PROGTYPE]                       AS  PGT
        ON DAT.[PROGTYPE] = PGT.[Code]
    LEFT OUTER JOIN [UoH].[HESA_QTS]                            AS  QTS
        ON DAT.[QTS] = QTS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_RCSTDNT]                        AS  RCS
        ON DAT.[RCSTDNT] = RCS.[Code] 
    LEFT OUTER JOIN [UoH].[HESA_REDUCEDI]                       AS  RDC
        ON DAT.[REDUCEDI] = RDC.[Code]
    LEFT OUTER JOIN [UoH].[HESA_COURSEAIM]                      AS  CQI     --  Course qualification aim
        ON  DAT.[COURSEAIM] = CQI.[Code]
    LEFT OUTER JOIN [UoH].[HESA_MSFUND]                         AS  MSF     --  Main source of funding
        ON DAT.[MSFUND] = MSF.[Code]
    LEFT OUTER JOIN [UoH].[HESA_SPECFEE]                        AS  SPF     --  Special fee indicator
        ON DAT.[SPECFEE] = SPF.[Code]
    LEFT OUTER JOIN [UoH].[HESA_TYPEYR]                         AS  TYR     --  Year type
        ON DAT.[TYPEYR] = TYR.[Code]
    LEFT OUTER JOIN [UoH].[HESA_UNITLGTH]                       AS  UNL     --  Unit length
        ON DAT.[UNITLGTH] = UNL.[Code]
    LEFT OUTER JOIN [UoH].[HESA_TTCID]                          AS  TTC     --  Teacher training code
        ON DAT.[TTCID] = TTC.[Code]
   
    /*  The following 'X' tables were developed in-house from HESA data available within PDF documents.   
        See X:\ICTD - Projects\PhilipD\HESA_X_Fields_Lookup_c16051                                      */

    LEFT OUTER JOIN [UoH].[HESA_XAGEA01]                        AS  AGE 
        ON DAT.[XAGEA01] = AGE.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XAGEJ01]                        AS  AGJ
        ON DAT.[XAGEJ01] = AGJ.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XAGRP601]                       AS  AGR     
        ON DAT.[XAGRP601] = AGR.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XAGRPA01]                       AS  AGA
        ON DAT.[XAGRPA01] = AGA.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XAGRPJ01]                       AS  AJR
        ON DAT.[XAGRPJ01] = AJR.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XAPP01]                         AS  APP
        ON DAT.[XAPP01] = APP.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XCLASS01]                       AS  CLA
        ON DAT.[XCLASS01] = CLA.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XCLASSF01]                      AS  CLF
        ON 
        (
        CASE 
            WHEN DAT.[XCLASSF01] = '0A'
            THEN 'A'
            ELSE DAT.[XCLASSF01]
        END 
        ) = CLF.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDLEV301]                       AS  LV3
        ON DAT.[XDLEV301] = LV3.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDLEV501]                       AS  LV5
        ON DAT.[XDLEV501] = LV5.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDLEV601]                       AS  LV6
        ON DAT.XDLEV601 = LV6.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOM01]                         AS  DM1 
        ON DAT.XDOM01 = DM1.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOMGR01]                       AS  DM2
        ON DAT.XDOMGR01 = DM2.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOMGR401]                      AS  DM3 
        ON DAT.XDOMGR401 = DM3.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOMHM01]                       AS  DM4
        ON DAT.XDOMHM01 = DM4.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOMREG01]                      AS  DM5  
        ON DAT.XDOMREG01 = DM5.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOMUC01]                       AS  DM6
        ON DAT.XDOMUC01 = DM6.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XELSP01]                        AS  ELS
        ON DAT.XELSP01 = ELS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XETHNIC01]                      AS  ET2
        ON DAT.XETHNIC01 = ET2.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XHOOS01]                        AS  HOS
        ON DAT.XHOOS01 = HOS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XINSTC01]                       AS  IN1
        ON DAT.XINSTC01 = IN1.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XINSTG01]                       AS  IN2
        ON DAT.XINSTG01 = IN2.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XINSTID01]                      AS  IN3
        ON 
        (
        CASE 
            WHEN DAT.[XINSTID01] = '120'
            THEN '0120'
            ELSE DAT.[XINSTID01]
        END
        ) = IN3.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XLEV301]                        AS  LE3
        ON DAT.XLEV301 = LE3.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XLEV501]                        AS  LE5
        ON DAT.XLEV501 = LE5.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XLEV601]                        AS  LE6
        ON DAT.XLEV601 = LE6.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XMODE01]                        AS  MD1  
        ON DAT.XMODE01 = MD1.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XMODE301]                       AS  MD3  
        ON DAT.XMODE301 = MD3.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XMSFUND01]                      AS  FND
        ON 
        (
        CASE
            WHEN DAT.[XMSFUND01] 
                IN('1','2','3','4','5','6','7','8','9')
            THEN '0'+ DAT.[XMSFUND01]
            ELSE DAT.[XMSFUND01]                        
        END
        ) = FND.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XMSTUFEE01]                     AS  FN2
        ON DAT.[XMSTUFEE01] = FN2.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XNATGR01]                       AS  NT1
        ON DAT.XNATGR01 = NT1.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XOBTND01]                       AS  BTN
        ON DAT.XOBTND01 = BTN.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XPDEC01]                        AS  PDE
        ON DAT.XPDEC01 = PDE.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XPDLHE02]                       AS  PDL
        ON DAT.XPDLHE02 = PDL.[Code]
    LEFT OUTER JOIN  [UoH].[HESA_XPQUAL01]                      AS  PQL
        ON DAT.XPQUAL01 = PQL.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XPSES01]                        AS  PSE
        ON DAT.XPSES01 = PSE.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XPSR01]                         AS  PSR
        ON DAT.XPSR01 = PSR.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XQLEV1003]                      AS  QL1
        ON
        ( 
        CASE
            WHEN DAT.XQLEV1003 = '__' THEN DAT.XQLEV1003
            WHEN LEFT(DAT.XQLEV1003,1) <> '0' THEN '0'+DAT.XQLEV1003
            ELSE DAT.XQLEV1003
        END
        )             = QL1.[Code]                           
    LEFT OUTER JOIN [UoH].[HESA_XQLEV301]                       AS  QL3
        ON DAT.XQLEV301 = QL3.[Code]                            
    LEFT OUTER JOIN [UoH].[HESA_XQLEV501]                       AS  QL5
        ON DAT.XQLEV501 = QL5.[Code]                            
    LEFT OUTER JOIN [UoH].[HESA_XQLEV601]                       AS  QL6
        ON DAT.XQLEV601 = QL6.[Code]                            
    LEFT OUTER JOIN [UoH].[HESA_XQLEV701]                       AS  QL7
        ON DAT.XQLEV701 = QL7.[Code]                            
    LEFT OUTER JOIN [UoH].[HESA_XQMODE01]                       AS  QMD
        ON DAT.XQMODE01 = QMD.[Code]                            
    LEFT OUTER JOIN [UoH].[HESA_XQOBTN01]                       AS  QBT
        ON DAT.XQOBTN01 = QBT.[Code]                            
    LEFT OUTER JOIN [UoH].[HESA_XQUALENT01]                     AS  QLT
        ON DAT.XQUALENT01 = QLT.[Code]                          
    LEFT OUTER JOIN [UoH].[HESA_XSTUDIS01]                      AS  STD
        ON DAT.XSTUDIS01 = STD.[Code]

WHERE
    DAT.[YEAR] > 2009        --  HESA submission for year ending 31 July
  
 /*

 NOTES

    [GENDERID]
    Records the gender identity of the student. 
    Students should, according to their own self-assessment, 
    indicate if their gender identity is the same as the 
    gender originally assigned to them at birth.
    01 = Yes
    02 = No
    98 = Information refused


    [XFYEAR01] - First year identifier (to be used with XPDEC01 only)
    VALID ENTRIES
    1 = Student was in their first year of instance on 1 December
    2 = Student was not identified as being in their first year of instance on 1 December

    [XFYRSR01] - First year identifier (to be used with XPSR01 only)
    VALID ENTRIES
    1 = Student was in their first year of instance in the reporting period
    2 = Student was not identified as being in their first year of instance in the reporting period
 */


