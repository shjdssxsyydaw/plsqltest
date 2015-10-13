#!/bin/bash
sqlplus -s gennick/secret << EOF
COLUMN tab_count NEW_VALUE table_count
SELECT COUNT(*) tab_count FROM user_all_tables;
EXIT table_count
EOF

let "tabcount = $?"
echo You have $tabcount tables.

