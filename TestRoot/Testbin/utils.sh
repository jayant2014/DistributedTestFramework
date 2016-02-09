#!/bin/sh

function parse_config() {
    TEST_CONF=$1
    echo "TEST_CONF=$TEST_CONF"
    cat $TEST_CONF | cut -d"=" -s -f1,2 > /tmp/temp.cfg
    source /tmp/temp.cfg
}

function print_test_parameters(){
    echo "Executing the following test cases...."
    echo "++++++++++++++++++++++++++++++++++++++++++++++++"
    cat $TEST_FILE
    echo -e "++++++++++++++++++++++++++++++++++++++++++++++++\n"
    echo "Executing the test with following parameters...."
    echo "++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "TEST_HOME=$TEST_HOME"
    echo "TEST_ROOT_DIR=$TEST_ROOT_DIR"
    echo "SUITE_NAME=$SUITE_NAME"
    echo "TEST_DIR=$TEST_DIR"
    echo "TEST_FILE=$TEST_FILE"
    echo "TEST_CONF=$TEST_CONF"
    echo "OUTPUT_DIR=$OUTPUT_DIR"
    echo "EXPECTED_DIR=$EXPECTED_DIR"
    echo "SCRIPTS_DIR=$SCRIPTS_DIR"
}

function log_success() {
    echo -e "\e[0;32m $1 : PASSED \e[0m"
}

function log_failure() {
    echo -e "\e[0;31m $1 : FAILED \e[0m"
}
function run_test() {
    tc_name=$1
    params=$2
    echo "Test Started : $(date)"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "bash $tc_name.sh $params"
    bash $tc_name.sh $params
    if [ $? -eq 0 ]
    then
        mv $tc_name.log $tc_name.out $OUTPUT_DIR
        diff $OUTPUT_DIR/$tc_name.out $EXPECTED_DIR/$tc_name.exp > $OUTPUT_DIR/$tc_name.diff
        if [ -f $OUTPUT_DIR/$tc_name.diff ]
        then
            if [ -s $OUTPUT_DIR/$tc_name.diff ]
            then
                log_failure $tc_name
            else
                log_success $tc_name
            fi
        else
            log_success $tc_name
        fi
        echo "Test ended : $(date)"
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    else
        echo -e "\e[0;32m $tc_name execution failed \e[0m"
    fi
}
