#!/bin/bash

# ===========================================================================
# Description  : This test script is for executing smoke test cases after setup
# Prerequisite : 1> All the setup completed
#                2> Modify the SmokeTesting.conf file as per your setup done
#                3> Put the script on any of the host which has connectivity to other hosts required by setup
#                4> Change testuser user password to password from default
#                5> sshpass utility need to be installed on the system
# Usage        : bash SmokeTesting.sh -c SmokeTesting.conf
# Author       : Jayant Parida
# Created On   : 09/02/2016
# Revision     : 1.0
# ===========================================================================

. ../../../Testlib/utilfuncs.sh

APPLICATION_USER=$1
SERVER_HOST=$2
APPLICATION_HOST=$3
MY_HOST1=$4
MY_HOST2=$5
MY_HOST3=$6
USER="root"
PASSWORD="password"
OPT_DIR="/opt/project"

LOGFILE="SmokeTesting.log"
OUTFILE="SmokeTesting.out"

# Test case 1 : Application submission and verify application_submission.log
function execute_tc1(){
    test_log "Updating component config as for testuser or non-testuser user...."
    # If you require some local config to be modified specific to your components you can do here
    test_log "Application submission started...."
    sshpass -p $PASSWORD ssh -o "StrictHostKeyChecking no" $APPLICATION_USER@$1 "python application.py --config $OPT_DIR/project/application.cfg"
    if [ $? -ne 0 ]
    then
        test_out "Application submission failed."
        test_out "TC1-ApplicationSubmission : FAILED"
        exit 1
    else
        test_out "Application submitted on $1."
        sshpass -p $PASSWORD ssh -o "StrictHostKeyChecking no" $USER@$1 "grep -a 'Application submitted successfully' /var/log/application_submission.log"
        if [ $? -ne 0 ]
        then
            test_out "Application submission failed, please check application_submission.log for more information."
            test_out "TC1-ApplicationSubmission : FAILED"
            exit 1
        else
            test_out "Application submitted successfully."
            test_out "TC1-ApplicationSubmission : PASSED"
        fi
    fi
}

# Test case 2 : Verify server.log
function execute_tc2(){
    test_log "Verifying server log...."
    sshpass -p $PASSWORD ssh -o "StrictHostKeyChecking no" $USER@$1 "grep -a 'Verification success' /var/log/server.log"
    if [ $? -eq 0 ]
    then
        test_out "Server verification successful."
        test_out "TC2-ServerVerification : PASSED"
    else
        test_out "Server verification failed, please check /var/log/server.log for more information."
        test_out "TC2-ServerVerification : FAILED"
    fi
}

# Test case 3 : Verify application execution status
function execute_tc3(){
    test_log "Verifying status.txt for first APPLICATION.."
    sshpass -p $PASSWORD ssh -o "StrictHostKeyChecking no" $USER@$1 "grep -qa 'Authentication=PASS' /opt/results/status.txt"
    if [ $? -ne 0 ]
    then
        test_out "Authentication failed, please check server.log for more information."
        test_out "TC3-Authentication : FAILED"
    else
        test_out "Authentication passed."
        test_out "TC3-Authentication : PASSED"
    fi

    sshpass -p $PASSWORD ssh -o "StrictHostKeyChecking no" $USER@$1 "grep -qa 'Measurement=PASS' /opt/results/status.txt"
    if [ $? -ne 0 ]
    then
        test_out "Measurement failed, please check server.log for more information."
        test_out "TC3-Measurement : FAILED"
    else
        test_out "Measurement passed."
        test_out "TC3-Measurement: PASSED"
    fi

    sshpass -p $PASSWORD ssh -o "StrictHostKeyChecking no" $USER@$1 "grep -qa 'status=0' /opt/results/status.txt"
    if [ $? -ne 0 ]
    then
        test_out "Application execution completed with failed status, please check server.log for more information."
        test_out "TC3-Status : FAILED"
    else
        test_out "Application execution completed with status passed."
        test_out "TC3-Status : PASSED"
    fi
    
    # Similarly add code for other application status by verifying their APPLICATIONs.
}

# Test case 4 : Verify myhost1.log
function execute_tc4(){
    test_log "Verifying myhost1.log...."
    sshpass -p $PASSWORD ssh -o "StrictHostKeyChecking no" $USER@$1 "grep -qa 'Successfull connection' /var/log/myhost1.log"
    if [ $? -ne 0 ]
    then
        test_out "Establishing successful connection failed."
        test_out "TC4-Myhost1 : FAILED"
    else
        test_out "Successfully established connection."
        test_out "TC4-Myhost1 : PASSED"
    fi
}

# Test case 5 : Verify myhost2.log
function execute_tc5(){
    test_log "Verifying myhost2.log...."
    sshpass -p $PASSWORD ssh -o "StrictHostKeyChecking no" $USER@$1 "grep -qa 'Successfull connection' /var/log/myhost2.log"
    if [ $? -ne 0 ]
    then
        test_out "Establishing successful connection failed."
        test_out "TC5-Myhost2 : FAILED"
    else
        test_out "Successfully established connection."
        test_out "TC5-Myhost2 : PASSED"
    fi
}

# Test case 6 : Verify myhost3.log
function execute_tc6(){
    test_log "Verifying myhost3.log...."
    sshpass -p $PASSWORD ssh -o "StrictHostKeyChecking no" $USER@$1 "grep -qa 'Successfull connection' /var/log/myhost3.log"
    if [ $? -ne 0 ]
    then
        test_out "Establishing successful connection failed."
        test_out "TC6-Myhost3 : FAILED"
    else
        test_out "Successfully established connection."
        test_out "TC6-Myhost3 : PASSED"
    fi
}

# Test case 7 : Verify application completion from application_submission.log
function execute_tc7(){
    test_log "Verifying application completion...."
    sshpass -p $PASSWORD ssh -o "StrictHostKeyChecking no" $USER@$1 "grep -a \"Application completed\" /var/log/application_submission.log*"
    if [ $? -ne 0 ]
    then
        test_out "Application completion failed, please check /var/log/application_submission.log for more information."
        test_out "TC7-ApplicationCompletion : FAILED"
    else
        test_out "Shutdown call to application done."
        test_out "TC7-ApplicationCompletion : PASSED"
    fi
}

test_log "#######################################################"
test_log "Executed file    : $0"
test_log "Executed command : bash $0 $USER"
test_log "Execution time   : $(date)"
test_log "####################################################### \n"

echo "Execution of $0 for smoke testing started...."

execute_tc1 $APPLICATION_HOST
execute_tc2 $SERVER_HOST
execute_tc3 $APPLICATION_HOST
execute_tc4 $MY_HOST1
execute_tc5 $MY_HOST2
execute_tc6 $MY_HOST3
execute_tc7 $APPLICATION_HOST
