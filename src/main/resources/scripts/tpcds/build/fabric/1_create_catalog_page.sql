CREATE TABLE catalog_page
(
    CP_CATALOG_PAGE_SK        int,
    CP_CATALOG_PAGE_ID        char(16),
    CP_START_DATE_SK          int,
    CP_END_DATE_SK            int,
    CP_DEPARTMENT             varchar(50),
    CP_CATALOG_NUMBER         int,
    CP_CATALOG_PAGE_NUMBER    int,
    CP_DESCRIPTION            varchar(100),
    CP_TYPE                   varchar(100)
);