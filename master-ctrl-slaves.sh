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
        scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} slave-cmds.sh cpuinfo sample-benchmark.R R-benchmark-25.R revolution-benchmark.R root@${host}:/root
        ret=$?
        if [ $ret -ne 0 ] ; then
            echo "error $ret"; continue
        fi
        
        echo "config-run "
        { ssh ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host} 'bash slave-cmds.sh mro_install netlib_install atlas_st_install openblas_install atlas_mt_install gotoblas2_install mkl_install blis_install cublas_install > install.log 2>&1' ;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/install.log install-${host}.log;
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

function benchmark {

    echo "* Benchmark: ${BENCHMARK_TEST}"

    for host in `cat hosts-list.txt`
    do
        echo -n "${host} ... "
        
        echo "benchmark-run "
        { ssh ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host} "bash slave-cmds.sh test_${BENCHMARK_TEST} netlib_check atlas_st_check openblas_check atlas_mt_check gotoblas2_check mkl_check blis_check cublas_check > test-${BENCHMARK_TEST}.log 2>&1" ;
          scp ${SSH_OPTIONS} -i ssh/${SSH_KEY_PRIV} root@${host}:/root/test-${BENCHMARK_TEST}.log test-${BENCHMARK_TEST}-${host}.log;
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
            *)
                echo "unknown command"
        esac
    done
fi
