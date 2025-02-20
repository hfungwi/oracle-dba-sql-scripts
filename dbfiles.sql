set linesize 300
set pagesize 250
COL file_name FOR A26
COL tablespace_name FOR A23
COL PCTFREE FOR A10
COL PCTUSED FOR A10

SELECT    df.tablespace_name,
          substr(df.file_name,(instr(df.file_name, '/', '1', '4') +1)) file_name,
          round(df.bytes/1024/1024)                                    totalSizeMB,
          nvl(round(usedBytes/1024/1024), 0)                           usedMB,
          nvl(round(freeBytes/1024/1024), 0)                           freeMB,
          nvl(round(df.MaxBytes/1024/1024), 0)                         MaxMB,
          nvl(round(freeBytes/df.bytes * 100), 0) ||'%' AS            "PCTFREE",
          nvl(round(usedBytes/df.bytes * 100), 0) ||'%' AS            "PCTUSED",
          df.autoextensible                                            autoextend
FROM      dba_data_files df
   LEFT JOIN (
               SELECT file_id, sum(bytes) usedBytes
               FROM dba_extents
               GROUP BY file_id
              ) ext
   ON df.file_id = ext.file_id
   LEFT JOIN (
                SELECT file_id, sum(bytes) freeBytes
                FROM dba_free_space
                GROUP BY file_id
              ) free
   ON df.file_id = free.file_id
ORDER BY df.tablespace_name, df.file_name
/
