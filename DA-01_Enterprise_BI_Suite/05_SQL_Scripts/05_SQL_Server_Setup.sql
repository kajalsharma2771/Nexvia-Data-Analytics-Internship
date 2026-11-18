SELECT
    SERVERPROPERTY('Edition') AS SQLServerEdition,
    SERVERPROPERTY('ProductVersion') AS SQLServerVersion;

    USE master;
GO

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'Agent XPs', 1;
RECONFIGURE;
GO