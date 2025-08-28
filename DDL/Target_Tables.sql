-- IF OBJECT_ID('DWH_TGT.latest_orbits','U') IS NOT NULL
--     DROP TABLE DWH_TGT.latest_orbits;

CREATE TABLE DWH_TGT.latest_orbits (
    CCSDS_OMM_VERS      VARCHAR(3)      NULL,
    COMMENT             VARCHAR(33)     NULL,
    CREATION_DATE       DATETIME2(6)    NULL,
    ORIGINATOR          VARCHAR(7)      NULL,
    OBJECT_NAME         VARCHAR(25)     NULL,
    OBJECT_ID           VARCHAR(12)     NULL,
    CENTER_NAME         VARCHAR(5)      NULL,
    REF_FRAME           VARCHAR(4)      NULL,
    TIME_SYSTEM         VARCHAR(3)      NULL,
    MEAN_ELEMENT_THEORY VARCHAR(4)      NULL,
    EPOCH               DATETIME2(6)    NULL,
    MEAN_MOTION         DECIMAL(13,8)   NULL,
    ECCENTRICITY        DECIMAL(13,8)   NULL,
    INCLINATION         DECIMAL(7,4)    NULL,
    RA_OF_ASC_NODE      DECIMAL(7,4)    NULL,
    ARG_OF_PERICENTER      DECIMAL(7,4)    NULL,
    MEAN_ANOMALY        DECIMAL(7,4)    NULL,
    EPHEMERIS_TYPE      SMALLINT         NULL,
    CLASSIFICATION_TYPE CHAR(1)         NULL,
    NORAD_CAT_ID        INT             NOT NULL,
    ELEMENT_SET_NO      SMALLINT        NULL,
    REV_AT_EPOCH        INT             NULL,
    BSTAR               DECIMAL(19,14)  NULL,
    MEAN_MOTION_DOT     DECIMAL(9,8)    NULL,
    MEAN_MOTION_DDOT    DECIMAL(22,13)  NULL,
    SEMIMAJOR_AXIS      FLOAT(53)       NULL,
    PERIOD              FLOAT(53)       NULL,
    APOAPSIS            FLOAT(53)       NULL,
    PERIAPSIS           FLOAT(53)       NULL,
    OBJECT_TYPE         VARCHAR(12)     NULL,
    RCS_SIZE            CHAR(6)         NULL,
    COUNTRY_CODE        CHAR(6)         NULL,
    LAUNCH_DATE         DATE            NULL,
    SITE                CHAR(5)         NULL,
    DECAY_DATE          DATE            NULL,
    [FILE]              BIGINT          NULL,
    GP_ID               INT             NOT NULL,
    TLE_LINE0           VARCHAR(MAX)     NULL,
    TLE_LINE1           VARCHAR(MAX)     NULL,
    TLE_LINE2           VARCHAR(MAX)     NULL,
    CONSTRAINT PK_latest_orbits PRIMARY KEY (NORAD_CAT_ID)
);

-- IF OBJECT_ID('DWH_TGT.satellite_catalog_recent','U') IS NOT NULL
--     DROP TABLE DWH_TGT.satellite_catalog_recent;

CREATE TABLE DWH_TGT.satellite_catalog_recent (
    INTLDES        CHAR(12)        NULL,
    NORAD_CAT_ID   INT             NOT NULL,
    OBJECT_TYPE    VARCHAR(12)     NULL,
    SATNAME        CHAR(25)        NULL,
    COUNTRY        CHAR(6)         NULL,
    LAUNCH         DATE            NULL,
    SITE           CHAR(5)         NULL,
    DECAY          DATE            NULL,
    PERIOD         DECIMAL(12,2)   NULL,
    INCLINATION    DECIMAL(12,2)   NULL,
    APOGEE         BIGINT          NULL,
    PERIGEE        BIGINT          NULL,
    COMMENT        CHAR(32)        NULL,
    COMMENTCODE    TINYINT         NULL,
    RCSVALUE       INT             NULL,
    RCS_SIZE       VARCHAR(6)      NULL,
    [FILE]         SMALLINT        NULL,
    LAUNCH_YEAR    SMALLINT        NULL,
    LAUNCH_NUM     SMALLINT        NULL,
    LAUNCH_PIECE   VARCHAR(3)      NULL,
    [CURRENT]      CHAR(1)         NULL,
    OBJECT_NAME    CHAR(25)        NULL,
    OBJECT_ID      CHAR(12)        NULL,
    OBJECT_NUMBER  INT             NULL,
    CONSTRAINT PK_satellite_catalog_recent PRIMARY KEY (NORAD_CAT_ID)
);


-- IF OBJECT_ID('DWH_TGT.recent_conjunctions','U') IS NOT NULL
--     DROP TABLE DWH_TGT.recent_conjunctions;

CREATE TABLE DWH_TGT.recent_conjunctions (
    CDM_ID             INT            NOT NULL,
    CREATED            DATETIME2(6)   NULL,
    EMERGENCY_REPORTABLE CHAR(1)      NULL,
    TCA                DATETIME2(6)   NULL,
    MIN_RNG            FLOAT(53)      NULL,
    PC                 FLOAT(53)      NULL,
    SAT_1_ID           INT            NULL,
    SAT_1_NAME         VARCHAR(25)    NULL,
    SAT1_OBJECT_TYPE   VARCHAR(25)    NULL,
    SAT1_RCS           VARCHAR(6)     NULL,
    SAT_1_EXCL_VOL     VARCHAR(62)    NULL,
    SAT_2_ID           INT            NULL,
    SAT_2_NAME         VARCHAR(25)    NULL,
    SAT2_OBJECT_TYPE   VARCHAR(25)    NULL,
    SAT2_RCS           VARCHAR(6)     NULL,
    SAT_2_EXCL_VOL     VARCHAR(62)    NULL,
    CONSTRAINT PK_recent_conjunctions PRIMARY KEY (CDM_ID)
);


-- IF OBJECT_ID('DWH_TGT.predicted_decay','U') IS NOT NULL
--     DROP TABLE DWH_TGT.predicted_decay;

CREATE TABLE DWH_TGT.predicted_decay (
    NORAD_CAT_ID   INT            NOT NULL,
    OBJECT_NUMBER  INT            NULL,
    OBJECT_NAME    CHAR(25)       NULL,
    INTLDES        CHAR(12)       NULL,
    OBJECT_ID      CHAR(12)       NULL,
    RCS            INT            NULL,
    RCS_SIZE       VARCHAR(6)     NULL,
    COUNTRY        CHAR(6)        NULL,
    MSG_EPOCH      DATETIME2(6)   NULL,
    DECAY_EPOCH    VARCHAR(24)    NOT NULL,
    SOURCE         VARCHAR(9)     NULL,
    MSG_TYPE       VARCHAR(10)    NOT NULL,
    PRECEDENCE     BIGINT         NULL,
    CONSTRAINT PK_predicted_decay PRIMARY KEY (NORAD_CAT_ID, DECAY_EPOCH, MSG_TYPE)
);

