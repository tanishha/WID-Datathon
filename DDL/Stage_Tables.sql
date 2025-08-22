IF OBJECT_ID('DWH_STG.satellite_catalog_recent','U') IS NOT NULL
    DROP TABLE DWH_STG.satellite_catalog_recent;

CREATE TABLE DWH_STG.satellite_catalog_recent (
    INTLDES          varchar(20)   NULL,
    NORAD_CAT_ID     varchar(20)   NULL,
    OBJECT_TYPE      varchar(20)   NULL,
    SATNAME          varchar(100)  NULL,
    COUNTRY          varchar(20)   NULL,
    LAUNCH           varchar(50)   NULL,   
    SITE             varchar(20)   NULL,
    DECAY            varchar(50)   NULL,   
    PERIOD           varchar(50)   NULL,  
    INCLINATION      varchar(50)   NULL,
    APOGEE           varchar(50)   NULL,
    PERIGEE          varchar(50)   NULL,
    COMMENT          varchar(200)  NULL,
    COMMENTCODE      varchar(50)   NULL,
    RCSVALUE         varchar(50)   NULL,   
    RCS_SIZE         varchar(20)   NULL,
    [FILE]          bigint        NULL,   
    LAUNCH_YEAR      varchar(10)   NULL,
    LAUNCH_NUM       varchar(10)   NULL,
    LAUNCH_PIECE     varchar(10)   NULL,
    [CURRENT]    varchar(5)    NULL,
    OBJECT_NAME      varchar(200)  NULL,
    OBJECT_ID        varchar(50)   NULL,
    OBJECT_NUMBER    varchar(20)   NULL
);

IF OBJECT_ID('DWH_STG.predicted_decay','U') IS NOT NULL
    DROP TABLE DWH_STG.predicted_decay;

CREATE TABLE DWH_STG.predicted_decay (
    NORAD_CAT_ID   varchar(50)   NULL,
    OBJECT_NUMBER  varchar(50)   NULL,
    OBJECT_NAME    varchar(200)  NULL,
    INTLDES        varchar(20)   NULL,
    OBJECT_ID      varchar(50)   NULL,
    RCS            varchar(50)   NULL,
    RCS_SIZE       varchar(20)   NULL,
    COUNTRY        varchar(20)   NULL,
    MSG_EPOCH      varchar(50)   NULL,
    DECAY_EPOCH    varchar(50)   NULL,
    SOURCE         varchar(100)  NULL,
    MSG_TYPE       varchar(50)   NULL,
    PRECEDENCE     varchar(50)   NULL
);


IF OBJECT_ID('DWH_STG.latest_orbits','U') IS NOT NULL
    DROP TABLE DWH_STG.latest_orbits;

CREATE TABLE DWH_STG.latest_orbits (
    CCSDS_OMM_VERS        varchar(50)     NULL,
    COMMENT               varchar(200)    NULL,
    CREATION_DATE         varchar(50)     NULL,  
    ORIGINATOR            varchar(100)    NULL,
    OBJECT_NAME           varchar(200)    NULL,
    OBJECT_ID             varchar(50)     NULL,
    CENTER_NAME           varchar(50)     NULL,
    REF_FRAME             varchar(50)     NULL,
    TIME_SYSTEM           varchar(50)     NULL,
    MEAN_ELEMENT_THEORY   varchar(50)     NULL,
    EPOCH                 varchar(50)     NULL,  
    MEAN_MOTION           varchar(50)     NULL,  
    ECCENTRICITY          varchar(50)     NULL,
    INCLINATION           varchar(50)     NULL,
    RA_OF_ASC_NODE        varchar(50)     NULL,
    ARG_OF_PERICENTER     varchar(50)     NULL,
    MEAN_ANOMALY          varchar(50)     NULL,
    EPHEMERIS_TYPE        varchar(50)     NULL,
    CLASSIFICATION_TYPE   varchar(10)     NULL,
    NORAD_CAT_ID          varchar(50)     NULL,   
    ELEMENT_SET_NO        varchar(50)     NULL,
    REV_AT_EPOCH          varchar(50)     NULL,
    BSTAR                 varchar(50)     NULL,
    MEAN_MOTION_DOT       varchar(50)     NULL,
    MEAN_MOTION_DDOT      varchar(50)     NULL,
    SEMIMAJOR_AXIS        varchar(50)     NULL,
    PERIOD                varchar(50)     NULL,
    APOAPSIS              varchar(50)     NULL,
    PERIAPSIS             varchar(50)     NULL,
    OBJECT_TYPE           varchar(100)    NULL,
    RCS_SIZE              varchar(20)     NULL,
    COUNTRY_CODE          varchar(20)     NULL,
    LAUNCH_DATE           varchar(50)     NULL,
    SITE                  varchar(50)     NULL,
    DECAY_DATE            varchar(50)     NULL,
    [FILE]                varchar(50)     NULL,
    GP_ID                 varchar(50)     NOT NULL,
    TLE_LINE0             varchar(200)    NULL,
    TLE_LINE1             varchar(500)    NULL,
    TLE_LINE2             varchar(500)    NULL);


IF OBJECT_ID('DWH_STG.recent_conjunctions','U') IS NOT NULL
    DROP TABLE DWH_STG.recent_conjunctions;

CREATE TABLE DWH_STG.recent_conjunctions (
    CDM_ID             varchar(50)   NULL,
    CREATED            varchar(50)   NULL,  
    EMERGENCY_REPORTABLE varchar(10) NULL,  
    TCA                varchar(50)   NULL,  
    MIN_RNG            varchar(50)   NULL,  
    PC                 varchar(50)   NULL,  
    SAT_1_ID           varchar(50)   NULL,
    SAT_1_NAME         varchar(200)  NULL,  
    SAT1_OBJECT_TYPE   varchar(50)   NULL,
    SAT1_RCS           varchar(20)   NULL,
    SAT_1_EXCL_VOL     varchar(200)  NULL,
    SAT_2_ID           varchar(50)   NULL,
    SAT_2_NAME         varchar(200)  NULL,
    SAT2_OBJECT_TYPE   varchar(50)   NULL,
    SAT2_RCS           varchar(20)   NULL,
    SAT_2_EXCL_VOL     varchar(200)  NULL
);




