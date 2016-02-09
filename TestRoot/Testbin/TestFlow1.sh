#!/bin/bash

export TEST_HOME="/opt"
TEST_ROOT_DIR="$TEST_HOME/TestRoot"
TEST_BIN_DIR="$TEST_ROOT_DIR/Testbin"
SUITE_NAME="MyProject/TestFlow1"
TEST_DIR="$TEST_ROOT_DIR/$SUITE_NAME"
TEST_FILE="$TEST_DIR/testfile"
TEST_CONF="$TEST_DIR/TestFlow1.conf"
OUTPUT_DIR="$TEST_DIR/TestResults"
EXPECTED_DIR="$TEST_DIR/Expected"
SCRIPTS_DIR="$TEST_DIR/TestScripts"

. $TEST_BIN_DIR/utils.sh

if [ ! -d $TEST_DIR ];
then
    echo -e "\n$TEST_DIR not found. Please check out the appropriate directory before test execution.\n"
    exit
else
    echo -e "\n$TEST_DIR found. Starting test execution....\n"
    if [ -f $TEST_FILE ];
    then
        echo "$TEST_FILE found."
        print_test_parameters
        # Read the contents of the conf file like server names and parameters
        parse_config $TEST_CONF
        env
    else
        echo -e "$TEST_FILE not found. Please check out the appropriate directory before test execution.\n"
        exit
    fi
fi

cd $SCRIPTS_DIR
if [ $? == 0 ];
then
    if [ ! -d $OUTPUT_DIR ];
    then
        mkdir $OUTPUT_DIR
    fi
    # Execute test through root user or normal user
    run_test TestFlow1 "root $SERVER_HOST $APPLICATION_HOST $MY_HOST1 $MY_HOST2 $MY_HOST3"
    run_test TestFlow1 "testuser $SERVER_HOST $APPLICATION_HOST $MY_HOST1 $MY_HOST2 $MY_HOST3"
else
    echo "TestScripts directory not found, please verify the directory structure again and start tests...."
    exit $?
fi
