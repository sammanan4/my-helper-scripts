#!/usr/bin/bash

echo "Getting Configurations..."

BASE_LOG_FOLDER="/opt/cloudtdms/logs"
MAX_LOG_AGE_IN_DAYS="6"

if [ "${MAX_LOG_AGE_IN_DAYS}" == "" ]; then
    MAX_LOG_AGE_IN_DAYS="7"
fi
ENABLE_DELETE="true"

echo "Configurations:"
echo "BASE_LOG_FOLDER:      '${BASE_LOG_FOLDER}'"
echo "MAX_LOG_AGE_IN_DAYS:  '${MAX_LOG_AGE_IN_DAYS}'"
echo "ENABLE_DELETE:        '${ENABLE_DELETE}'"

cleanup() {
    echo "Executing Find Statement: $1"
    FILES_MARKED_FOR_DELETE=`eval $1`
    echo "Process will be Deleting the following File(s)/Directory(s):"
    echo "${FILES_MARKED_FOR_DELETE}"
    echo "Process will be Deleting `echo "${FILES_MARKED_FOR_DELETE}" | \
    grep -v '^$' | wc -l` File(s)/Directory(s)"     \
    # "grep -v '^$'" - removes empty lines.
    # "wc -l" - Counts the number of lines
    echo ""
    if [ "${ENABLE_DELETE}" == "true" ];
    then
        if [ "${FILES_MARKED_FOR_DELETE}" != "" ];
        then
            echo "Executing Delete Statement: $2"
            eval $2
            DELETE_STMT_EXIT_CODE=$?
            if [ "${DELETE_STMT_EXIT_CODE}" != "0" ]; then
                echo "Delete process failed with exit code \
                    '${DELETE_STMT_EXIT_CODE}'"

                exit ${DELETE_STMT_EXIT_CODE}
            fi
        else
            echo "WARN: No File(s)/Directory(s) to Delete"
        fi
    else
        echo "WARN: You're opted to skip deleting the File(s)/Directory(s)!!!"
    fi
}



    
echo ""
echo "Running Cleanup Process..."

FIND_STATEMENT="find ${BASE_LOG_FOLDER}/*/* -type f -mtime \
    +${MAX_LOG_AGE_IN_DAYS}"
DELETE_STMT="${FIND_STATEMENT} -exec rm -f {} \;"

cleanup "${FIND_STATEMENT}" "${DELETE_STMT}"
CLEANUP_EXIT_CODE=$?

FIND_STATEMENT="find ${BASE_LOG_FOLDER}/*/* -type d -empty"
DELETE_STMT="${FIND_STATEMENT} -prune -exec rm -rf {} \;"

cleanup "${FIND_STATEMENT}" "${DELETE_STMT}"
CLEANUP_EXIT_CODE=$?

FIND_STATEMENT="find ${BASE_LOG_FOLDER}/* -type d -empty"
DELETE_STMT="${FIND_STATEMENT} -prune -exec rm -rf {} \;"

cleanup "${FIND_STATEMENT}" "${DELETE_STMT}"
CLEANUP_EXIT_CODE=$?

FIND_STATEMENT="find ${BASE_LOG_FOLDER}/*/* -type d -mtime +${MAX_LOG_AGE_IN_DAYS}"
DELETE_STMT="${FIND_STATEMENT} -prune -exec rm -rf {} \;"

cleanup "${FIND_STATEMENT}" "${DELETE_STMT}"
CLEANUP_EXIT_CODE=$?




echo "Finished Running Cleanup Process"
