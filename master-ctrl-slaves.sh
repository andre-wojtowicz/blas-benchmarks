#!/bin/bash

SSH_OPTIONS="-o ConnectTimeout=5 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -q"
SSH_KEY_PRIV="rsa.key"
BENCHMARK_TEST="sample"

function configure_hosts {

    echo "* Configuring hosts:"

    for host in `cat hosts-list.txt`
    do
        echo -n "${host} ... "
        
        echo -n "config-push "
        scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} slave-cmds.sh cpuinfo benchmark-sample.R benchmark-urbanek.R benchmark-revolution.R benchmark-gcbd.R root@${host}:/root
        ret=$?
        if [ $ret -ne 0 ] ; then
            echo "error $ret"; continue
        fi
        
        echo -n "cpuinfo-chmod "
        ssh ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host} 'chmod +x cpuinfo'
        ret=$?
        if [ $ret -ne 0 ] ; then
            echo "error $ret"; continue
        fi
        
        echo "config-run "
        { ssh ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host} 'bash slave-cmds.sh mro_install netlib_install atlas_st_install openblas_install atlas_mt_install gotoblas2_install mkl_install blis_install cublas_install > install.log 2>&1' ;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/install.log install-${host}.log;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/host-info.log host-info-${host}.log;
          echo "${host} finished" ; } &
        
    done

    while true
    do
        runningjobs=$(jobs -rp | wc -l)
        if [ $runningjobs -eq 0 ] ; then
            break
        fi
        curtim=`date +"%T"`
        echo "* [$curtim] Waiting for $runningjobs hosts..."
        sleep 5
    done

    echo "* All hosts configured"

}

function power_off {

    echo "* Power-off hosts:"

    for host in `cat hosts-list.txt`
    do
        echo -n "${host} ... "
        
        echo "power off "
        ssh ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host} 'poweroff'
        
    done

    echo "* Done"

}

function benchmark {

    echo "* Benchmark: ${BENCHMARK_TEST}"

    for host in `cat hosts-list.txt`
    do
        echo -n "${host} ... "
        
        echo "benchmark-run "
        { ssh ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host} "bash slave-cmds.sh test_${BENCHMARK_TEST} netlib_check atlas_st_check openblas_check atlas_mt_check gotoblas2_check mkl_check blis_check cublas_check > test-${BENCHMARK_TEST}.log 2>&1" ;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/test-${BENCHMARK_TEST}.log test-${BENCHMARK_TEST}-${host}.log;
          
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/test-${BENCHMARK_TEST}-netlib.rds test-${BENCHMARK_TEST}-${host}-netlib.rds;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/test-${BENCHMARK_TEST}-atlas_st.rds test-${BENCHMARK_TEST}-${host}-atlas_st.rds;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/test-${BENCHMARK_TEST}-openblas.rds test-${BENCHMARK_TEST}-${host}-openblas.rds;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/test-${BENCHMARK_TEST}-atlas_mt.rds test-${BENCHMARK_TEST}-${host}-atlas_mt.rds;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/test-${BENCHMARK_TEST}-gotoblas2.rds test-${BENCHMARK_TEST}-${host}-gotoblas2.rds;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/test-${BENCHMARK_TEST}-mkl.rds test-${BENCHMARK_TEST}-${host}-mkl.rds;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/test-${BENCHMARK_TEST}-blis.rds test-${BENCHMARK_TEST}-${host}-blis.rds;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/test-${BENCHMARK_TEST}-cublas.rds test-${BENCHMARK_TEST}-${host}-cublas.rds 2> /dev/null;
          echo "${host} finished" ; } &
    done

    while true
    do
        runningjobs=$(jobs -rp | wc -l)
        if [ $runningjobs -eq 0 ] ; then
            break
        fi
        curtim=`date +"%T"`
        echo "* [$curtim] Waiting for $runningjobs hosts..."
        sleep 5
    done

    echo "* All hosts finished benchmark ${BENCHMARK_TEST}"

}

##############################################################
##############################################################

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
else
    for i in "$@"
    do  
        case "$i" in
            configure_hosts)
                configure_hosts
                ;;
            power_off)
                power_off
                ;;
            test_sample)
                BENCHMARK_TEST="sample"
                benchmark
                ;;
            test_urbanek)
                BENCHMARK_TEST="urbanek"
                benchmark
                ;;
            test_revolution)
                BENCHMARK_TEST="revolution"
                benchmark
                ;;
            test_gcbd)
                BENCHMARK_TEST="gcbd"
                benchmark
                ;;
            *)
                echo "unknown command"
        esac
    done
fi
