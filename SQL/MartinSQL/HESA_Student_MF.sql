/*
    HESA_Student_MF

    Table: [UoH].[STUDENT_HESA_CoreTable_DATA].
    
    Join all existing HESA Lookup tables.

   

    Martin Fish
    29 May 2018

*/
USE [Dev_Philip_02_DataWarehouse]

SELECT 
     DAT.[OWNSTU]                           --  UoH Student ID                                                            -   https://www.hesa.ac.uk/collection/c17051/a/ownstu
    ,DAT.[INSTANCEKEY]
    ,DAT.[UKPRN]                            --  UK Provider Reference Number                                              -   https://www.hesa.ac.uk/collection/c17051/a/ukprn
    ,DAT.[HUSID]                            --  HESE Unique Student ID                                                    -   https://www.hesa.ac.uk/collection/c17051/a/husid
    ,DAT.[NUMHUS]                           --  POS course code                                                           -   https://www.hesa.ac.uk/collection/c17051/a/numhus
    ,DAT.[INSTCAMP]                         --  Provider's own campus identifier   = OU3 code                             -   https://www.hesa.ac.uk/collection/c17051/a/instcamp
    ,DAT.[COURSEID]                         --  Appears to be POS code with month suffix                                  -   https://www.hesa.ac.uk/collection/c17051/a/course_courseid
    ,DAT.[OWNINST]                          --  Also POS course code - same as NUMHUS                                     -   https://www.hesa.ac.uk/collection/c17051/a/owninst
    ,DAT.[FNAMES]                           --  Student forenames
    ,DAT.[SURNAME]                          --  Student surname
    ,DAT.[BIRTHDTE]                         --  Date of Birth
    ,DAT.[GENDERID]                         --  See Note 01 at foot of script                                             -   https://www.hesa.ac.uk/collection/c17051/a/genderid
    ,GEN.[Label]                            AS  Gender                                                                    --  Lookup
    ,DAT.[DISABLE]                          --  Disability code                                                           -   https://www.hesa.ac.uk/collection/c17051/a/disable
    ,DIS.[Label]                            AS  Disability                                                                --  Lookup
    ,DAT.[ETHNIC]                           --  Ethnicity code                                                            -   https://www.hesa.ac.uk/collection/c17051/a/ethnic
    ,ETH.[Label]                            AS  Ethnicity                                                                 --  Lookup
    ,DAT.[NATION]                           --  Nationality code                                                          -   https://www.hesa.ac.uk/collection/c17051/a/nation
    ,NAT.[Label]                            AS  Nationality                                                               --  Lookup
    ,DAT.[RELBLF]                           --  ReligionBelief code                                                       -   https://www.hesa.ac.uk/collection/c17051/a/relblf
    ,REL.[Label]                            AS  ReligiousBelief                                                           --  Lookup
    ,DAT.[SEXID]                            --  Sex identifier code                                                       -   https://www.hesa.ac.uk/collection/c17051/a/sexid
    ,SEX.[Label]                            AS  Sex                                                                       --  Lookup
    ,DAT.[SEXORT]                           --  Sexual orientation code                                                   -   https://www.hesa.ac.uk/collection/c17051/a/sexort
    ,ORT.[Label]                            AS  SexualOrientation                                                         --  Lookup
    ,DAT.[SCN]                              --  Scottish Candidate Number                                                 -   https://www.hesa.ac.uk/collection/c17051/a/scn
    ,DAT.[TTACCOM]                          --  Term-time accommodation code                                              -   https://www.hesa.ac.uk/collection/c17051/a/ttaccom
    ,TTA.[Label]                            AS  TermTimeAccommodation                                                     --  Lookup
    ,DAT.[TTPCODE]                          --  Term-time postcode                                                        -   https://www.hesa.ac.uk/collection/c17051/a/ttpcode
    ,DAT.[UCASPERID]                        --  UCAS personal identifier                                                  -   https://www.hesa.ac.uk/collection/c17051/a/ucasperid
    ,DAT.[ULN]                              --  Unique Learner Number                                                     -   https://www.hesa.ac.uk/collection/c17051/a/uln
    ,DAT.[CARELEAVER]                       --  Care leaver / Looked after status                                         -   https://www.hesa.ac.uk/collection/c17051/a/careleaver
    ,CRL.[Label]                            AS  CareLeaverDescription                                                     --  Lookup
    ,DAT.[DOMICILE]                         --  Domicile code                                                             -   https://www.hesa.ac.uk/collection/c17051/a/domicile
    ,DOM.[Label]                            AS  CountryOfDomicile                                                         --  Lookup
    ,DAT.[PARED]                            --  Parental Education code                                                   -   https://www.hesa.ac.uk/collection/c17051/a/pared
    ,PED.[Label]                            AS  ParentHigherEdQuals                                                         --Lookup
    ,DAT.[PGCECLSS]                         --  PGCE class of undergraduate degree                                        -   https://www.hesa.ac.uk/collection/c17051/a/pgceclss
    ,DAT.[PGCESBJ1]                         --  PGCE subject of undergraduate degree (1)                                  -   https://www.hesa.ac.uk/collection/c17051/a/pgcesbj
    ,DAT.[PGCESBJ2]                         --  PGCE subject of undergraduate degree (2)                                  -   https://www.hesa.ac.uk/collection/c17051/a/pgcesbj
    ,DAT.[POSTCODE]                         --  Postcode of home address                                                  -   https://www.hesa.ac.uk/collection/c17051/a/postcode
    ,DAT.[PREVINST]                         --  Previous provider attended by the student                                 -   https://www.hesa.ac.uk/collection/c17051/a/previnst
    ,DAT.[QUALENT3]                         --  Highest qualification on entry                                            -   https://www.hesa.ac.uk/collection/c17051/a/qualent3
    ,QAL.[Label]                            AS  HighestQualificationOnEntry                                               --  Lookup
    ,DAT.[SEC]                              --  Socio-economic classification code                                        -   https://www.hesa.ac.uk/collection/c17051/a/sec
    ,DAT.[SOC2000]                          --  Occupation code                                                           -   https://www.hesa.ac.uk/collection/c17051/a/soc2000
    ,DAT.[SOC2010]                          --  Occupation code                                                           -   https://www.hesa.ac.uk/collection/c17051/a/soc2010
    ,DAT.[UCASAPPID]                        --  UCAS Application Number                                                   -   https://www.hesa.ac.uk/collection/c17051/a/ucasappid
    ,DAT.[YRLLINST]                         --  Year left last provider                                                   -   https://www.hesa.ac.uk/collection/c17051/a/yrllinst
    ,DAT.[AIMTYPE]                          --  Type of aim recorded                                                      -   https://www.hesa.ac.uk/collection/c17051/a/aimtype
    ,AIM.[Label]                            AS  TypeOfAim                                                                 --  Lookup
    ,DAT.[CAMPID]                           --  Campus identifier                                                         -   https://www.hesa.ac.uk/collection/c17051/a/campid
    ,DAT.[COMDATE]                          --  Date start                                                                -   https://www.hesa.ac.uk/collection/c17051/a/comdate
    ,DAT.[CSTAT]                            --  Completion status code                                                    -   https://www.hesa.ac.uk/collection/c17051/a/cstat
    ,CST.[Label]                            AS  CompletionStatus                                                          --  Lookup
    ,DAT.[DHFUND]                           --  Department of Health funding body code                                    -   https://www.hesa.ac.uk/collection/c17051/a/dhfund
    ,DAT.[DHREGREF]                         --  Regulatory body reference number                                          -   https://www.hesa.ac.uk/collection/c17051/a/dhregref
    ,DAT.[DISALL]                           --  Disabled Student Allowance code                                           -   https://www.hesa.ac.uk/collection/c17051/a/disall
    ,DAT.[ELQ]                              --  Aiming for an Equivalent or Lower Qualification code                      -   https://www.hesa.ac.uk/collection/c17051/a/elq
    ,DAT.[ENDDATE]                          --  Date student left                                                         -   https://www.hesa.ac.uk/collection/c17051/a/enddate
    ,DAT.[ENTRYRTE]                         --  Route by which the student has accessed ITT provision                     -   https://www.hesa.ac.uk/collection/c17051/a/entryrte
    ,DAT.[EXCHANGE]                         --  Exchange programmes                                                       -   https://www.hesa.ac.uk/collection/c17051/a/exchange
    ,DAT.[FEEELIG]                          --  Fee eligibility code                                                      -   https://www.hesa.ac.uk/collection/c17051/a/feeelig
    ,DAT.[FEEREGIME]                        --  Fee regime indicator                                                      -   https://www.hesa.ac.uk/collection/c17051/a/feeregime
    ,DAT.[FESTUMK]                          --  FE student marker                                                         -   https://www.hesa.ac.uk/collection/c17051/a/festumk
    ,DAT.[FUNDCODE]                         --  Fundability code                                                          -   https://www.hesa.ac.uk/collection/c17051/a/fundcode
    ,DAT.[FUNDCOMP]                         --  Completion status code for the year                                       -   https://www.hesa.ac.uk/collection/c17051/a/fundcomp
    ,DAT.[FUNDLEV]                          --  Level applicable to funding council HESES                                 -   https://www.hesa.ac.uk/collection/c17051/a/fundlev
    ,DAT.[FUNDMODEL]                        --  Funding Model code                                                        -   https://www.hesa.ac.uk/collection/c17051/a/fundmodel
    ,DAT.[GROSSFEE]                         --  Gross Fee                                                                 -   https://www.hesa.ac.uk/collection/c17051/a/grossfee
    ,DAT.[INITIATIVES1]                     --  Initiatives code (1)                                                      -   https://www.hesa.ac.uk/collection/c17051/a/initiatives
    ,DAT.[INITIATIVES2]                     --  Initiatives code (2)                                                      -   https://www.hesa.ac.uk/collection/c17051/a/initiatives
    ,DAT.[ITTAIM]                           --  ITT qualification aim code                                                -   https://www.hesa.ac.uk/collection/c17051/a/ittaim
    ,DAT.[ITTPHSC]                          --  ITT phase/scope code                                                      -   https://www.hesa.ac.uk/collection/c17051/a/ittphsc
    ,DAT.[ITTSCHMS]                         --  ITT Schemes codes                                                         -   https://www.hesa.ac.uk/collection/c17051/a/ittschms
    ,DAT.[LEARNPLANENDDATE]                 --  Learning Planned end date                                                 -   https://www.hesa.ac.uk/collection/c17051/a/learnplanenddate
    ,DAT.[LOCSDY]                           --  Location of study                                                         -   https://www.hesa.ac.uk/collection/c17051/a/locsdy
    ,DAT.[MCDATE]                           --  Change of mode date                                                       -   https://www.hesa.ac.uk/collection/c17051/a/mcdate
    ,DAT.[MODE]                             --  Mode of study                                                             -   https://www.hesa.ac.uk/collection/c17051/a/mode
    ,SMD.[Label]                            AS  StudyMode                                                                 --  Lookup
    ,DAT.[MSTUFEE]                          --  Major source of tuition fees code                                         -   https://www.hesa.ac.uk/collection/c17051/a/mstufee
    ,FEE.[Label]                            AS  TuitionFeeMainSource                                                      --  Lookup
    ,DAT.[NETFEE]                           --  Net fee                                                                   -   https://www.hesa.ac.uk/collection/c17051/a/netfee
    ,DAT.[NOTACT]                           --  Suspension of active studies                                              -   https://www.hesa.ac.uk/collection/c17051/a/notact
    ,DAT.[PARTNERUKPRN]                     --  Subcontracted or partnership UKPRN                                        -   https://www.hesa.ac.uk/collection/c17051/a/partnerukprn
    ,DAT.[PHDSUB]                           --  PhD submission date                                                       -   https://www.hesa.ac.uk/collection/c17051/a/phdsub
    ,DAT.[PROGTYPE]                         --  Programme type                                                            -   https://www.hesa.ac.uk/collection/c17051/a/progtype
    ,DAT.[QTS]                              --  Qualified teacher status code                                             -   https://www.hesa.ac.uk/collection/c17051/a/qts
    ,DAT.[RCSTDNT]                          --  Research council student code                                             -   https://www.hesa.ac.uk/collection/c17051/a/rcstdnt
    ,DAT.[REDUCEDI]                         --  Reduced instance return indicator code                                    -   https://www.hesa.ac.uk/collection/c17051/a/reducedi
    ,DAT.[RSNEND]                           --  Reason for leaving code                                                   -   https://www.hesa.ac.uk/collection/c17051/a/rsnend
    ,RSN.[Label]                            AS  ReasonForLeaving                                                          --  Lookup
    ,DAT.[SPECFEE]                          --  Special fee indicator code                                                -   https://www.hesa.ac.uk/collection/c17051/a/specfee
    ,DAT.[SPLENGTH]                         --  Expected length of study                                                  -   https://www.hesa.ac.uk/collection/c17051/a/splength
    ,DAT.[SSN]                              --  Student Support Number (for Student Loans Company)                        -   https://www.hesa.ac.uk/collection/c17051/a/ssn
    ,DAT.[STULOAD]                          --  Student FTE                                                               -   https://www.hesa.ac.uk/collection/c17051/a/stuload
    ,DAT.[TREFNO]                           --  Teacher Reference Number                                                  -   https://www.hesa.ac.uk/collection/c17051/a/trefno
    ,DAT.[TYPEYR]                           --  Type of instance year                                                     -   https://www.hesa.ac.uk/collection/c17051/a/typeyr
    ,DAT.[UNITLGTH]                         --  Units of length code                                                      -   https://www.hesa.ac.uk/collection/c17051/a/unitlgth
    ,DAT.[YEARPRG]                          --  Year of course                                                            -   https://www.hesa.ac.uk/collection/c17051/a/yearprg
    ,DAT.[YEARSTU]                          --  Year of student on this instance                                          -   https://www.hesa.ac.uk/collection/c17051/a/yearstu
    ,DAT.[COURSEAIM]                        --  General qualification aim of course code                                  -   https://www.hesa.ac.uk/collection/c17051/a/courseaim
    ,CQI.[Label]                            AS  CourseQualificationAim                                                    --  Lookup
    ,DAT.[MSFUND]                           AS  MSFUND  --  Major source of funding code                                  -   https://www.hesa.ac.uk/collection/c17051/a/msfund
    ,MSF.[Label]                            AS  FundingSource                                                             --  Lookup
    ,DAT.[TTCID]                            --  Teacher training course code                                              -   https://www.hesa.ac.uk/collection/c17051/a/ttcid
    ,DAT.[OUTCOME1]                         --  Outcome of ITT (initial teacher training)                                 -   https://www.hesa.ac.uk/collection/c17051/a/outcome
    
    /*  The following 'X' fields are included by HESA when the submission is returned to UoH.    */
    ,DAT.[XAGEA01]                          --  Age at 31 August in reporting year            
    ,AGE.[Label]                            AS  Age31AugustX                                                               --  Lookup
    ,DAT.[XAGEJ01]                          --  Age at 31 July in reporting year
    ,AGJ.[Label]                            AS  Age31JulyX                                                                 --  Lookup
    ,DAT.[XAGRP601]                         --  Age grouping at 31 August
    ,AGR.[Label]                            AS  AgeGroupX                                                                  --  Lookup
    ,DAT.[XAGRPA01]                         --  Age grouping at 31 August - 6 way split
    ,AGA.[Label]                            AS  AgeGroup6WaySplitX                                                         --  Lookup
    ,DAT.[XAGRPJ01]                         --  Age grouping at 31 July in reporting year
    ,AGR.[Label]                            AS  AgeGroup31JulyX                                                            --  Lookup
    ,DAT.[XAPP01]                           --  Apprenticeship identifier
    ,APP.[Label]                            AS  ApprenticeshipIdentifierX                                                  --  Lookup
    ,DAT.[XCLASS01]                         --  Classification of qualification - aggregates [XCLASSF01]                  
    ,CLA.[Label]                            AS  ClassificationOfQualificationX                                             --  Lookup
    ,DAT.[XCLASSF01]                        --  Classification of qualification - highest-ranked qualification            
    ,CLF.[Label]                            AS  HighestRankedQualificationX                                                --  Lookup
    ,DAT.[XDLEV301]                         --  Level of qualification in DLHE - 3 way split
    ,LV3.[Label]                            AS  LevelOfQualification3WaySplitX                                             --  Lookup
    ,DAT.[XDLEV501]                         --  Level of qualification in DLHE - 5 way split
    ,LV5.[Label]                            AS  LevelOfQualification5WaySplitX                                             --  Lookup
    ,DAT.[XDLEV601]                         --  Level of qualification in DLHE - 6 way split
    ,LV6.[Label]                            AS  LevelOfQualification6WaySplitX                                             --  Lookup
    ,DAT.[XDOM01]                           --  Domicile code
    ,DM1.[Label]                            AS  DomicileCountryX                                                           --  Lookup
    ,DAT.[XDOMGR01]                         --  Region of student domicile
    ,DM2.[Label]                            AS  DomicileRegionX                                                            --  Lookup
    ,DAT.[XDOMGR401]                        --  Region of student domicile - 4 way split
    ,DM3.Label                              AS  RegionOfDomicile4WaySplitX                                                 --  Lookup
    ,DAT.[XDOMHM01]                         --  Domicile (participation by nation)
    ,DM4.[Label]                            AS  DomicileNationX                                                            --  Lookup
    ,DAT.[XDOMREG01]                        --  Domicile region
    ,DM5.[Label]                            AS  DomicileRegionInternationalX                                                           --  Lookup
    ,DAT.[XDOMUC01]                         --  Domicile (county/region/unitary authority/local government district level)
    ,DM6.[Label]                            AS  DomicileLocalityX                                                          --  Lookup
    ,DAT.[XELSP01]                          --  Expected length of study programme
    ,ELS.[Label]                            AS  ExpectedLengthOfStudyX                                                     --  Lookup
    ,DAT.[XEPYEAR01]                        --  Last year in which an Entry Profile for a UHN was supplied to HESA
    ,DAT.[XETHNIC01]                        --  Analytical protocol ethnicity
    ,ET2.[Label]                            AS  EthnicityUKDomicileX                                                       --  Lookup
    ,DAT.[XFYEAR01]                         --  First year identifier (to be used with XPDEC01 only)
    ,DAT.[XFYRSR01]                         --  First year identifier (to be used with XPSR01 only)
    ,DAT.[XHOOS01]                          --  Home/overseas student
    ,HOO.[Label]                            AS  HomeOrOverseasX                                                            --  Lookup
    ,DAT.[XINSTC01]                         --  Country of higher education provider
    ,INS.[Label]                            AS  CountryOfHigherEducationProviderX                                          --  Lookup
    ,DAT.[XINSTG01]                         --  Region of higher education provider
    ,IN2.[Label]                            AS  RegionOfHigherEducationProviderX                                           --  Lookup
    ,DAT.[XINSTID01]                        --  HESA higher education provider identifier
    ,IN3.[Label]                            AS  HigherEducationProviderIdentifierX                                         --  Lookup
    ,DAT.[XLEV301]                          --  Level of study - 3 way split
    ,LS3.[Label]                            AS  LevelOfStudy3WaySplitX                                                     --  Lookup
    ,DAT.[XLEV501]                          --  Level of study - 5 way split
    ,LS5.[Label]                            AS  LevelOfStudy5WaySplitX                                                     --  Lookup
    ,DAT.[XLEV601]                          --  Level of study - 6 way split
    ,LS6.[Label]                            AS  LevelOfStudy6WaySplitX                                                     --  Lookup
    ,DAT.[XMODE01]                          --  Mode of study
    ,MOS.[Label]                            AS  ModeOfStudyX                                                               --  Lookup
    ,DAT.[XMODE301]                         --  Mode of study - 3 way split
    ,MS3.[Label]                            AS  ModeOfStudy3WaySplitX                                                      --  Lookup
    ,DAT.[XMSFUND01]                        --  Major source of funding
    ,FND.[Label]                            AS  MajorSourceOfFundingX                                                      --  Lookup
    ,DAT.[XMSTUFEE01]                       --  Major source of tuition fees
    ,TUF.[Label]                            AS  MajorSourceOfTuitionFeesX                                                  --  Lookup
    ,DAT.[XNATGR01]                         --  Geographic region of student nationality
    ,GRN.[Label]                            AS  GeographicRegionOfStudentNationalityX                                      --  Lookup
    ,DAT.[XOBTND01]                         --  DLHE highest qualification obtained
    ,OBT.[Label]                            AS  DLHEHighestQualificationObtainedX                                          --  Lookup
    ,DAT.[XPDEC01]                          --  Population at 1 December
    ,PD1.[Label]                            AS  Population1DecemberX                                                       --  Lookup
    ,DAT.[XPDLHE02]                         --  DLHE population
    ,DLP.[Label]                            AS  DLHEPopulationX                                                            --  Lookup
    ,DAT.[XPQUAL01]                         --  Qualifications obtained population
    ,QOP.[Label]                            AS  QualificationsObtainedPopulationX                                          --  Lookup
    ,DAT.[XPSES01]                          --  Session population
    ,SES.[Label]                            AS  SessionPopulationX                                                         --  Lookup
    ,DAT.[XPSR01]                           --  Standard registration population
    ,SRP.[Label]                            AS  StandardRegistrationPopulationX                                            --  Lookup
    ,DAT.[XQLEV1003]                        --  Level of qualification - 10 way split
    ,L10.[Label]                            AS  Qualification10WaySplitX                                                   --  Lookup
    ,DAT.[XQLEV301]                         --  Level of qualification - 3 way split
    ,LQ3.[Label]                            AS  Qualification3WaySplitX                                                    --  Lookup
    ,DAT.[XQLEV501]                         --  Level of qualification - 5 way split
    ,LQ5.[Label]                            AS  Qualification5WaySplitX                                                    --  Lookup
    ,DAT.[XQLEV601]                         --  Level of qualification - 6 way split
    ,LQ6.[Label]                            AS  Qualification6WaySplitX                                                    --  Lookup
    ,DAT.[XQLEV701]                         --  Level of qualification - 7 way split
    ,LQ7.[Label]                            AS  Qualification7WaySplitX                                                    --  Lookup
    ,DAT.[XQMODE01]                         --  Qualification obtained mode of study
    ,QMS.[Label]                            AS  QualificationObtainedModeOfStudyX                                          --  Lookup
    ,DAT.[XQOBTN01]                         --  Highest qualification obtained
    ,HQO.[Label]                            AS  HighestQualificationObtainedX                                             --  Lookup
    ,DAT.[XQUALENT01]                       --  Highest qualification on entry
    ,HQE.[Label]                            AS  HighestQualificationOnEntryX                                               --  Lookup
    ,DAT.[XSTUDIS01]                        --  Student disability
    ,DSB.[Label]                            AS  StudentDisabilityX                                                         --  Lookup
    ,DAT.[XTARIFF]                          AS  TariffUcasX                                                                --  UCAS Tariff for general purposes
    ,DAT.[XTARIFFGP01]                      --  Tariff analysis groupings
    ,TAG.[Label]                            AS  TariffGroupingsX                                                           --  Lookup
    ,DAT.[XTPOINTS]                         AS  TariffPointsX                                                              --  UCAS tariff point aggregation
    ,DAT.[YEAR]                             --  Year of HESA submission
    ,DAT.[SSR_FTE_Times]                    --  ?

--INTO [Dev_Martin_DataWarehouse].dbo.DimHESA
FROM 
    [UoH].[STUDENT_HESA_CoreTable_DATA]         AS  DAT     --  Main data. This is the driver table, lookup tables below are joined on this tables (DAT) columns
    LEFT OUTER JOIN [UoH].[HESA_GENDER]         AS  GEN     --  Gender
        ON  DAT.[GENDERID] = GEN.[Code]
    LEFT OUTER JOIN [UoH].[HESA_DISABLE]        AS  DIS     --  Disability
        ON  DAT.[DISABLE] = DIS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_ETHNIC]         AS  ETH     --  Ethnicity
        ON  DAT.[ETHNIC] = ETH.Code
    LEFT OUTER JOIN [UoH].[HESA_NATION]         AS  NAT     --  Nationality
        ON  DAT.[NATION] = NAT.[Code]
    LEFT OUTER JOIN [UoH].[HESA_RELBLF]         AS  REL     --  Religious belief
        ON  DAT.[RELBLF] = REL.[Code]
    LEFT OUTER JOIN [UoH].[HESA_SEXID]          AS  SEX     --  Sex
        ON  DAT.[SEXID] = SEX.[Code]
    LEFT OUTER JOIN [UoH].[HESA_SEXORT]         AS  ORT     --  Sexual orientation
        ON  DAT.[SEXORT] = ORT.[Code]
    LEFT OUTER JOIN [UoH].[HESA_CARELEAVER]     AS  CRL     --  Care leaver
        ON  DAT.[CARELEAVER] = CRL.[Code]
    LEFT OUTER JOIN [UoH].[HESA_TTACCOM]        AS  TTA     --  Term-time accommodation
        ON  DAT.[TTACCOM] = TTA.[Code]
    LEFT OUTER JOIN [UoH].[HESA_DOMICILE]       AS  DOM     --  Country of domicile
        ON  DAT.[DOMICILE] = DOM.[Code]
    LEFT OUTER JOIN [UoH].[HESA_PARED]          AS  PED     --  Parental education
        ON  DAT.[PARED] = PED.[Code]
    LEFT OUTER JOIN [UoH].[HESA_QUALENT3]       AS  QAL     --  Highest qualification on entry
        ON  DAT.[QUALENT3] = QAL.[Code]
    LEFT OUTER JOIN [UoH].[HESA_RSNEND]         AS  RSN     --  Reason for leaving
        ON  DAT.[RSNEND] = RSN.[Code]
    LEFT OUTER JOIN [UoH].[HESA_AIMTYPE]        AS  AIM     --  Type of aim recorded
        ON DAT.[AIMTYPE] = AIM.[Code]
    LEFT OUTER JOIN [UoH].[HESA_CSTAT]          AS  CST     --  Completion status
        ON DAT.[CSTAT] = CST.[Code]
    LEFT OUTER JOIN [UoH].[HESA_MODE]           AS  SMD     --  Study mode
        ON DAT.[MODE] = SMD.[Code]
    LEFT OUTER JOIN [UoH].[HESA_MSTUFEE]        AS  FEE     --  Main source of tuition fee
        ON DAT.[MSTUFEE] = FEE.[Code]
    LEFT OUTER JOIN [UoH].[HESA_COURSEAIM]      AS  CQI     --  Course qualification aim
        ON  DAT.[COURSEAIM] = CQI.[Code]
    LEFT OUTER JOIN [UoH].[HESA_MSFUND]         AS  MSF     --  Main source of funding
        ON DAT.[MSFUND] = MSF.[Code]

    /*  The following 'X' tables were developed in-house from HESA data available within PDF documents.   */
    LEFT OUTER JOIN [UoH].[HESA_XAGEA01]        AS  AGE     --
        ON DAT.[XAGEA01] = AGE.[Code]                       
    LEFT OUTER JOIN [UoH].[HESA_XAGEJ01]        AS  AGJ     --
        ON DAT.[XAGEJ01] = AGJ.[Code]                       
    LEFT OUTER JOIN [UoH].[HESA_XAGRP601]       AS  AGR     --
        ON DAT.[XAGRP601] = AGR.[Code]                      
    LEFT OUTER JOIN [UoH].[HESA_XAGRPA01]       AS  AGA     --
        ON DAT.[XAGRPA01] = AGA.[Code]                      
    LEFT OUTER JOIN [UoH].[HESA_XAGRPJ01]       AS  AJR     --
        ON DAT.[XAGRPJ01] = AJR.[Code]                      
    LEFT OUTER JOIN [UoH].[HESA_XAPP01]         AS  APP     --
        ON DAT.[XAPP01] = APP.[Code]                        
    LEFT OUTER JOIN [UoH].[HESA_XCLASS01]       AS  CLA     --
        ON DAT.[XCLASS01] = CLA.[Code]                      
    LEFT OUTER JOIN [UoH].[HESA_XCLASSF01]      AS  CLF     --
        ON DAT.[XCLASSF01] = CLF.[Code]                     
    LEFT OUTER JOIN [UoH].[HESA_XDLEV301]       AS  LV3     --
        ON DAT.[XDLEV301] = LV3.[Code]                      
     LEFT OUTER JOIN [UoH].[HESA_XDLEV501]      AS  LV5     --
        ON DAT.[XDLEV501] = LV5.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDLEV601]       AS  LV6     --
        ON DAT.[XDLEV601] = LV6.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOM01]         AS  DM1     --
        ON DAT.[XDOM01] = DM1.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOMGR01]       AS  DM2     --
        ON DAT.[XDOMGR01] = DM2.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOMGR401]      AS  DM3     --
        ON DAT.[XDOMGR401] = DM3.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOMHM01]       AS  DM4     --
        ON DAT.[XDOMHM01] = DM4.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOMREG01]      AS  DM5     --
        ON DAT.[XDOMREG01] = DM5.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XDOMUC01]       AS  DM6     --
        ON DAT.[XDOMUC01] = DM6.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XELSP01]        AS  ELS     --
        ON DAT.[XELSP01] = ELS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XETHNIC01]      AS  ET2    --
        ON DAT.[XETHNIC01] = ET2.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XHOOS01]        AS  HOO    --
        ON DAT.[XHOOS01] = HOO.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XINSTC01]       AS  INS    --
        ON DAT.[XINSTC01] = INS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XINSTG01]       AS  IN2    --
        ON DAT.[XINSTG01] = IN2.[Code]    
    LEFT OUTER JOIN [UoH].[HESA_XINSTID01]      AS  IN3    --
        ON DAT.[XINSTID01] = IN3.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XLEV301]        AS  LS3    --
        ON DAT.[XLEV301] = LS3.[Code] 
    LEFT OUTER JOIN [UoH].[HESA_XLEV501]        AS  LS5    --
        ON DAT.[XLEV501] = LS5.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XLEV601]        AS  LS6    --
        ON DAT.[XLEV601] = LS6.[Code]   
    LEFT OUTER JOIN [UoH].[HESA_XMODE01]        AS  MOS    --
        ON DAT.[XMODE01] = MOS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XMODE301]       AS  MS3    --
        ON DAT.[XMODE301] = MS3.[Code]    
    LEFT OUTER JOIN [UoH].[HESA_XMSFUND01]      AS  FND    --
        ON DAT.[XMSFUND01] = FND.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XMSTUFEE01]     AS  TUF   --
        ON DAT.[XMSTUFEE01] = TUF.[Code]   
    LEFT OUTER JOIN [UoH].[HESA_XNATGR01]       AS  GRN   --
        ON DAT.[XNATGR01] = GRN.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XOBTND01]       AS  OBT   --
        ON DAT.[XOBTND01] = OBT.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XPDEC01]        AS  PD1   --
        ON DAT.[XPDEC01] = PD1.[Code] 
    LEFT OUTER JOIN [UoH].[HESA_XPDLHE02]       AS  DLP   --
        ON DAT.[XPDLHE02] = DLP.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XPQUAL01]       AS  QOP   --
        ON DAT.[XPQUAL01] = QOP.[Code] 
    LEFT OUTER JOIN [UoH].[HESA_XPSES01]        AS  SES   --
        ON DAT.[XPSES01] = SES.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XPSR01]         AS  SRP   --
        ON DAT.[XPSR01] = SRP.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XQLEV1003]      AS  L10   --
        ON DAT.[XQLEV1003] = L10.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XQLEV301]       AS  LQ3   --
        ON DAT.[XQLEV301] = LQ3.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XQLEV501]       AS  LQ5   --
        ON DAT.[XQLEV501] = LQ5.[Code]   
    LEFT OUTER JOIN [UoH].[HESA_XQLEV601]       AS  LQ6   --
        ON DAT.[XQLEV601] = LQ6.[Code]  
    LEFT OUTER JOIN [UoH].[HESA_XQLEV701]       AS  LQ7   --
        ON DAT.[XQLEV701] = LQ7.[Code]   
    LEFT OUTER JOIN [UoH].[HESA_XQMODE01]       AS  QMS   --
        ON DAT.[XQMODE01] = QMS.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XQOBTN01]       AS  HQO   --
        ON DAT.[XQOBTN01] = HQO.[Code]
    LEFT OUTER JOIN [UoH].[HESA_XQUALENT01]     AS  HQE   --
        ON DAT.[XQUALENT01] = HQE.[Code]   
    LEFT OUTER JOIN [UoH].[HESA_XSTUDIS01]      AS  DSB   --
        ON DAT.[XSTUDIS01] = DSB.[Code]   
    LEFT OUTER JOIN [UoH].[HESA_XTARIFFGP01]    AS  TAG   --
        ON DAT.[XTARIFFGP01] = TAG.[Code]     
 
WHERE                               --  Filtering provided by Tim - consistent with use elswhere
    [YEARSTU] =  1                  --  First year student
    AND    
    [YEAR]    IN(2014,2015,2016)    --  HESA submission for year ending 31 July
    AND    
    [MODE]    =  '01'               --  Full-time study
    AND    
    [XLEV601] in (4,5)              --  4 = First degree  5 = Other undergraduate

 /*

 NOTES

    01  GENDERID
    Records the gender identity of the student. 
    Students should, according to their own self-assessment, 
    indicate if their gender identity is the same as the 
    gender originally assigned to them at birth.
    01 = Yes
    02 = No
    98 = Information refused

 */
