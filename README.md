## Usage

```shell
# ./diff.sh -h
Usage: ./diff.sh -f kube1 -t kube2 -h
This will compare pre-defined custom resources on 2 clusters specified by kubeconfig files with -f and -t
Example: ./diff.sh -f sno1.yaml -t sno2.yaml
Can set the diff compare mode to adjust the output of the comparison result:
    export DIFF_OPTS=-y
    export DIFF_OPTS=--suppress-common-lines -W 270 --color -y
    export DIFF_OPTS=--color
The default DIFF_OPTS is: -W 270 --color -y

Make sure the server you run the script has the access with oc commands to the 2 clusters.
```

## Example 1

```shell
# ./diff.sh -f /root/workload-enablement/kubeconfigs/kubeconfig-sno131.yaml -t /root/workload-enablement/kubeconfigs/kubeconfig-sno132.yaml
Compare cluster source: /root/workload-enablement/kubeconfigs/kubeconfig-sno131.yaml
Compare cluster target: /root/workload-enablement/kubeconfigs/kubeconfig-sno132.yaml
Compare cluster-scoped resources:

Diff clusterversion:version: diff -W 270 --color -y   source-clusterversion-version.yaml target-clusterversion-version.yaml
------------------------------------------------------------------------------------------------
apiVersion: config.openshift.io/v1													apiVersion: config.openshift.io/v1
kind: ClusterVersion															kind: ClusterVersion
metadata:																metadata:
  name: version																  name: version
spec:																	spec:
  capabilities:																  capabilities:
    additionalEnabledCapabilities:													    additionalEnabledCapabilities:
      - NodeTuning															      - NodeTuning
      - marketplace														      |	      - OperatorLifecycleManager
																      >	      - Ingress
    baselineCapabilitySet: None														    baselineCapabilitySet: None
  channel: stable-4.14														      |	  channel: candidate-4.16
  clusterID: 043e9e47-e79d-4cbc-9538-5714d2ef9296										      |	  clusterID: ec56c67d-c783-4908-a528-60e06c564b76
  desiredUpdate:															  desiredUpdate:
    version: 4.14.25														      |	    version: 4.16.4
  upstream: https://api.openshift.com/api/upgrades_info/v1/graph									  upstream: https://api.openshift.com/api/upgrades_info/v1/graph
------------------------------------------------------------------------------------------------

Diff nodes.config.openshift.io:cluster: diff -W 270 --color -y   source-nodes.config.openshift.io-cluster.yaml target-nodes.config.openshift.io-cluster.yaml
------------------------------------------------------------------------------------------------
apiVersion: config.openshift.io/v1													apiVersion: config.openshift.io/v1
kind: Node																kind: Node
metadata:																metadata:
  name: cluster																  name: cluster
spec:																      |	spec: {}
  cgroupMode: v1														      <
------------------------------------------------------------------------------------------------

Diff containerruntimeconfigs:: diff -W 270 --color -y   source-containerruntimeconfigs.yaml target-containerruntimeconfigs.yaml
------------------------------------------------------------------------------------------------
apiVersion: machineconfiguration.openshift.io/v1											apiVersion: machineconfiguration.openshift.io/v1
kind: ContainerRuntimeConfig														kind: ContainerRuntimeConfig
metadata:																metadata:
  name: enable-crun-master														  name: enable-crun-master
spec:																	spec:
  containerRuntimeConfig:														  containerRuntimeConfig:
    defaultRuntime: crun														    defaultRuntime: crun
  machineConfigPoolSelector:														  machineConfigPoolSelector:
    matchLabels:															    matchLabels:
      pools.operator.machineconfiguration.openshift.io/master: ""									      pools.operator.machineconfiguration.openshift.io/master: ""
------------------------------------------------------------------------------------------------

Diff performanceprofiles:: diff -W 270 --color -y   source-performanceprofiles.yaml target-performanceprofiles.yaml
------------------------------------------------------------------------------------------------
apiVersion: performance.openshift.io/v2													apiVersion: performance.openshift.io/v2
kind: PerformanceProfile														kind: PerformanceProfile
metadata:																metadata:
  name: openshift-node-performance-profile												  name: openshift-node-performance-profile
spec:																	spec:
  additionalKernelArgs:															  additionalKernelArgs:
    - rcupdate.rcu_normal_after_boot=0													    - rcupdate.rcu_normal_after_boot=0
    - efi=runtime															    - efi=runtime
    - vfio_pci.enable_sriov=1														    - vfio_pci.enable_sriov=1
    - vfio_pci.disable_idle_d3=1													    - vfio_pci.disable_idle_d3=1
    - module_blacklist=irdma														    - module_blacklist=irdma
  cpu:																	  cpu:
    isolated: 2-31,34-63														    isolated: 2-31,34-63
    reserved: 0-1,32-33															    reserved: 0-1,32-33
  hugepages:																  hugepages:
    defaultHugepagesSize: 1G														    defaultHugepagesSize: 1G
    pages:																    pages:
      - count: 32															      - count: 32
        size: 1G															        size: 1G
  machineConfigPoolSelector:														  machineConfigPoolSelector:
    pools.operator.machineconfiguration.openshift.io/master: ""										    pools.operator.machineconfiguration.openshift.io/master: ""
  nodeSelector:																  nodeSelector:
    node-role.kubernetes.io/master: ""													    node-role.kubernetes.io/master: ""
  numa:																	  numa:
    topologyPolicy: restricted														    topologyPolicy: restricted
  realTimeKernel:															  realTimeKernel:
    enabled: true															    enabled: true
  workloadHints:															  workloadHints:
    highPowerConsumption: false														    highPowerConsumption: false
    perPodPowerManagement: false													    perPodPowerManagement: false
    realTime: true															    realTime: true
------------------------------------------------------------------------------------------------

Diff networks.operator.openshift.io:cluster: diff -W 270 --color -y   source-networks.operator.openshift.io-cluster.yaml target-networks.operator.openshift.io-cluster.yaml
------------------------------------------------------------------------------------------------
true																	true
------------------------------------------------------------------------------------------------

Diff mc:container-mount-namespace-and-kubelet-conf-master: diff -W 270 --color -y   source-mc-container-mount-namespace-and-kubelet-conf-master.yaml target-mc-container-mount-namespace-and-kubelet-conf-master.yaml
------------------------------------------------------------------------------------------------
apiVersion: machineconfiguration.openshift.io/v1											apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig															kind: MachineConfig
metadata:																metadata:
  name: container-mount-namespace-and-kubelet-conf-master										  name: container-mount-namespace-and-kubelet-conf-master
spec:																	spec:
  config:																  config:
    ignition:																    ignition:
      version: 3.2.0															      version: 3.2.0
    storage:																    storage:
      files:																      files:
        - contents:															        - contents:
            source: data:text/plain;charset=utf-8;base64,IyEvYmluL2Jhc2gKCmRlYnVnKCkgewogIGVjaG8gJEAgPiYyCn0KCnVzYWdlKCkgewogIGVjaG8g	            source: data:text/plain;charset=utf-8;base64,IyEvYmluL2Jhc2gKCmRlYnVnKCkgewogIGVjaG8gJEAgPiYyCn0KCnVzYWdlKCkgewogIGVjaG8g
          mode: 493															          mode: 493
          path: /usr/local/bin/extractExecStart												          path: /usr/local/bin/extractExecStart
        - contents:															        - contents:
            source: data:text/plain;charset=utf-8;base64,IyEvYmluL2Jhc2gKbnNlbnRlciAtLW1vdW50PS9ydW4vY29udGFpbmVyLW1vdW50LW5hbWVzcGFj	            source: data:text/plain;charset=utf-8;base64,IyEvYmluL2Jhc2gKbnNlbnRlciAtLW1vdW50PS9ydW4vY29udGFpbmVyLW1vdW50LW5hbWVzcGFj
          mode: 493															          mode: 493
          path: /usr/local/bin/nsenterCmns												          path: /usr/local/bin/nsenterCmns
    systemd:																    systemd:
      units:																      units:
        - contents: |															        - contents: |
            [Unit]															            [Unit]
            Description=Manages a mount namespace that both kubelet and crio can use to share their container-specific mounts		            Description=Manages a mount namespace that both kubelet and crio can use to share their container-specific mounts

            [Service]															            [Service]
            Type=oneshot														            Type=oneshot
            RemainAfterExit=yes														            RemainAfterExit=yes
            RuntimeDirectory=container-mount-namespace											            RuntimeDirectory=container-mount-namespace
            Environment=RUNTIME_DIRECTORY=%t/container-mount-namespace									            Environment=RUNTIME_DIRECTORY=%t/container-mount-namespace
            Environment=BIND_POINT=%t/container-mount-namespace/mnt									            Environment=BIND_POINT=%t/container-mount-namespace/mnt
            ExecStartPre=bash -c "findmnt ${RUNTIME_DIRECTORY} || mount --make-unbindable --bind ${RUNTIME_DIRECTORY} ${RUNTIME_DIREC	            ExecStartPre=bash -c "findmnt ${RUNTIME_DIRECTORY} || mount --make-unbindable --bind ${RUNTIME_DIRECTORY} ${RUNTIME_DIREC
            ExecStartPre=touch ${BIND_POINT}												            ExecStartPre=touch ${BIND_POINT}
            ExecStart=unshare --mount=${BIND_POINT} --propagation slave mount --make-rshared /						            ExecStart=unshare --mount=${BIND_POINT} --propagation slave mount --make-rshared /
            ExecStop=umount -R ${RUNTIME_DIRECTORY}											            ExecStop=umount -R ${RUNTIME_DIRECTORY}
          name: container-mount-namespace.service											          name: container-mount-namespace.service
        - dropins:															        - dropins:
            - contents: |														            - contents: |
                [Unit]															                [Unit]
                Wants=container-mount-namespace.service											                Wants=container-mount-namespace.service
                After=container-mount-namespace.service											                After=container-mount-namespace.service

                [Service]														                [Service]
                ExecStartPre=/usr/local/bin/extractExecStart %n /%t/%N-execstart.env ORIG_EXECSTART					                ExecStartPre=/usr/local/bin/extractExecStart %n /%t/%N-execstart.env ORIG_EXECSTART
                EnvironmentFile=-/%t/%N-execstart.env											                EnvironmentFile=-/%t/%N-execstart.env
                ExecStart=														                ExecStart=
                ExecStart=bash -c "nsenter --mount=%t/container-mount-namespace/mnt \							                ExecStart=bash -c "nsenter --mount=%t/container-mount-namespace/mnt \
                    ${ORIG_EXECSTART}"													                    ${ORIG_EXECSTART}"
              name: 90-container-mount-namespace.conf											              name: 90-container-mount-namespace.conf
          name: crio.service														          name: crio.service
        - dropins:															        - dropins:
            - contents: |														            - contents: |
                [Unit]															                [Unit]
                Wants=container-mount-namespace.service											                Wants=container-mount-namespace.service
                After=container-mount-namespace.service											                After=container-mount-namespace.service

                [Service]														                [Service]
                ExecStartPre=/usr/local/bin/extractExecStart %n /%t/%N-execstart.env ORIG_EXECSTART					                ExecStartPre=/usr/local/bin/extractExecStart %n /%t/%N-execstart.env ORIG_EXECSTART
                EnvironmentFile=-/%t/%N-execstart.env											                EnvironmentFile=-/%t/%N-execstart.env
                ExecStart=														                ExecStart=
                ExecStart=bash -c "nsenter --mount=%t/container-mount-namespace/mnt \							                ExecStart=bash -c "nsenter --mount=%t/container-mount-namespace/mnt \
                    ${ORIG_EXECSTART} --housekeeping-interval=30s"									                    ${ORIG_EXECSTART} --housekeeping-interval=30s"
              name: 90-container-mount-namespace.conf											              name: 90-container-mount-namespace.conf
            - contents: |														            - contents: |
                [Service]														                [Service]
                Environment="OPENSHIFT_MAX_HOUSEKEEPING_INTERVAL_DURATION=60s"								                Environment="OPENSHIFT_MAX_HOUSEKEEPING_INTERVAL_DURATION=60s"
                Environment="OPENSHIFT_EVICTION_MONITORING_PERIOD_DURATION=30s"								                Environment="OPENSHIFT_EVICTION_MONITORING_PERIOD_DURATION=30s"
              name: 30-kubelet-interval-tuning.conf											              name: 30-kubelet-interval-tuning.conf
          name: kubelet.service														          name: kubelet.service
------------------------------------------------------------------------------------------------

Diff mc:07-sriov-related-kernel-args-master: diff -W 270 --color -y   source-mc-07-sriov-related-kernel-args-master.yaml target-mc-07-sriov-related-kernel-args-master.yaml
------------------------------------------------------------------------------------------------
apiVersion: machineconfiguration.openshift.io/v1											apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig															kind: MachineConfig
metadata:																metadata:
  name: 07-sriov-related-kernel-args-master												  name: 07-sriov-related-kernel-args-master
spec:																	spec:
  config:																  config:
    ignition:																    ignition:
      version: 3.2.0															      version: 3.2.0
  kernelArguments:															  kernelArguments:
    - intel_iommu=on															    - intel_iommu=on
    - iommu=pt																    - iommu=pt
------------------------------------------------------------------------------------------------

Diff mc:08-set-rcu-normal-master: diff -W 270 --color -y   source-mc-08-set-rcu-normal-master.yaml target-mc-08-set-rcu-normal-master.yaml
------------------------------------------------------------------------------------------------
apiVersion: machineconfiguration.openshift.io/v1											apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig															kind: MachineConfig
metadata:																metadata:
  name: 08-set-rcu-normal-master													  name: 08-set-rcu-normal-master
spec:																	spec:
  config:																  config:
    ignition:																    ignition:
      version: 3.2.0															      version: 3.2.0
    storage:																    storage:
      files:																      files:
        - contents:															        - contents:
            source: data:text/plain;charset=utf-8;base64,IyEvYmluL2Jhc2gKIwojIERpc2FibGUgcmN1X2V4cGVkaXRlZCBhZnRlciBub2RlIGhhcyBmaW5p	            source: data:text/plain;charset=utf-8;base64,IyEvYmluL2Jhc2gKIwojIERpc2FibGUgcmN1X2V4cGVkaXRlZCBhZnRlciBub2RlIGhhcyBmaW5p
          mode: 493															          mode: 493
          path: /usr/local/bin/set-rcu-normal.sh											          path: /usr/local/bin/set-rcu-normal.sh
    systemd:																    systemd:
      units:																      units:
        - contents: |															        - contents: |
            [Unit]															            [Unit]
            Description=Disable rcu_expedited after node has finished booting by setting rcu_normal to 1				            Description=Disable rcu_expedited after node has finished booting by setting rcu_normal to 1

            [Service]															            [Service]
            Type=simple															            Type=simple
            ExecStart=/usr/local/bin/set-rcu-normal.sh											            ExecStart=/usr/local/bin/set-rcu-normal.sh

            # Maximum wait time is 600s = 10m:												            # Maximum wait time is 600s = 10m:
            Environment=MAXIMUM_WAIT_TIME=600												            Environment=MAXIMUM_WAIT_TIME=600

            # Steady-state threshold = 2%												            # Steady-state threshold = 2%
            # Allowed values:														            # Allowed values:
            #  4  - absolute pod count (+/-)												            #  4  - absolute pod count (+/-)
            #  4% - percent change (+/-)												            #  4% - percent change (+/-)
            #  -1 - disable the steady-state check											            #  -1 - disable the steady-state check
            # Note: '%' must be escaped as '%%' in systemd unit files									            # Note: '%' must be escaped as '%%' in systemd unit files
            Environment=STEADY_STATE_THRESHOLD=2%%											            Environment=STEADY_STATE_THRESHOLD=2%%

            # Steady-state window = 120s												            # Steady-state window = 120s
            # If the running pod count stays within the given threshold for this time							            # If the running pod count stays within the given threshold for this time
            # period, return CPU utilization to normal before the maximum wait time has							            # period, return CPU utilization to normal before the maximum wait time has
            # expires															            # expires
            Environment=STEADY_STATE_WINDOW=120												            Environment=STEADY_STATE_WINDOW=120

            # Steady-state minimum = 40													            # Steady-state minimum = 40
            # Increasing this will skip any steady-state checks until the count rises above						            # Increasing this will skip any steady-state checks until the count rises above
            # this number to avoid false positives if there are some periods where the							            # this number to avoid false positives if there are some periods where the
            # count doesn't increase but we know we can't be at steady-state yet.							            # count doesn't increase but we know we can't be at steady-state yet.
            Environment=STEADY_STATE_MINIMUM=40												            Environment=STEADY_STATE_MINIMUM=40

            [Install]															            [Install]
            WantedBy=multi-user.target													            WantedBy=multi-user.target
          enabled: true															          enabled: true
          name: set-rcu-normal.service													          name: set-rcu-normal.service
------------------------------------------------------------------------------------------------

Diff mc:99-crio-disable-wipe-master: diff -W 270 --color -y   source-mc-99-crio-disable-wipe-master.yaml target-mc-99-crio-disable-wipe-master.yaml
------------------------------------------------------------------------------------------------
apiVersion: machineconfiguration.openshift.io/v1											apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig															kind: MachineConfig
metadata:																metadata:
  name: 99-crio-disable-wipe-master													  name: 99-crio-disable-wipe-master
spec:																	spec:
  config:																  config:
    ignition:																    ignition:
      version: 3.2.0															      version: 3.2.0
    storage:																    storage:
      files:																      files:
        - contents:															        - contents:
            source: data:text/plain;charset=utf-8;base64,W2NyaW9dCmNsZWFuX3NodXRkb3duX2ZpbGUgPSAiIgo=					            source: data:text/plain;charset=utf-8;base64,W2NyaW9dCmNsZWFuX3NodXRkb3duX2ZpbGUgPSAiIgo=
          mode: 420															          mode: 420
          path: /etc/crio/crio.conf.d/99-crio-disable-wipe.toml										          path: /etc/crio/crio.conf.d/99-crio-disable-wipe.toml
------------------------------------------------------------------------------------------------

Diff mc:99-sync-time-once-master: diff -W 270 --color -y   source-mc-99-sync-time-once-master.yaml target-mc-99-sync-time-once-master.yaml
------------------------------------------------------------------------------------------------
apiVersion: machineconfiguration.openshift.io/v1											apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig															kind: MachineConfig
metadata:																metadata:
  name: 99-sync-time-once-master													  name: 99-sync-time-once-master
spec:																	spec:
  config:																  config:
    ignition:																    ignition:
      version: 3.2.0															      version: 3.2.0
    systemd:																    systemd:
      units:																      units:
        - contents: |															        - contents: |
            [Unit]															            [Unit]
            Description=Sync time once													            Description=Sync time once
            After=network.service												      |	            After=network-online.target
																      >	            Wants=network-online.target
            [Service]															            [Service]
            Type=oneshot														            Type=oneshot
            TimeoutStartSec=300														            TimeoutStartSec=300
																      >	            ExecCondition=/bin/bash -c 'systemctl is-enabled chronyd.service --quiet && exit 1 || exit 0'
            ExecStart=/usr/sbin/chronyd -n -f /etc/chrony.conf -q									            ExecStart=/usr/sbin/chronyd -n -f /etc/chrony.conf -q
            RemainAfterExit=yes														            RemainAfterExit=yes
            [Install]															            [Install]
            WantedBy=multi-user.target													            WantedBy=multi-user.target
          enabled: true															          enabled: true
          name: sync-time-once.service													          name: sync-time-once.service
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-cluster-node-tuning-operator/tuned:performance-patch: diff -W 270 --color -y   source-openshift-cluster-node-tuning-operator-tuned-performance-patch.yaml target-openshift-cluster-node-tuning-operator-tuned-performance-patch.yaml
------------------------------------------------------------------------------------------------
apiVersion: tuned.openshift.io/v1													apiVersion: tuned.openshift.io/v1
kind: Tuned																kind: Tuned
metadata:																metadata:
  name: performance-patch														  name: performance-patch
  namespace: openshift-cluster-node-tuning-operator											  namespace: openshift-cluster-node-tuning-operator
spec:																	spec:
  profile:																  profile:
    - data: |																    - data: |
        [main]																        [main]
        summary=Configuration changes profile inherited from performance created tuned							        summary=Configuration changes profile inherited from performance created tuned
        include=openshift-node-performance-openshift-node-performance-profile								        include=openshift-node-performance-openshift-node-performance-profile
        [bootloader]															        [bootloader]
        cmdline_pstate=intel_pstate=active												        cmdline_pstate=intel_pstate=active
        [sysctl]														      <
        kernel.timer_migration=1												      <
        [scheduler]															        [scheduler]
        group.ice-ptp=0:f:10:*:ice-ptp.*												        group.ice-ptp=0:f:10:*:ice-ptp.*
        group.ice-gnss=0:f:10:*:ice-gnss.*												        group.ice-gnss=0:f:10:*:ice-gnss.*
        [service]															        [service]
        service.stalld=start,enable													        service.stalld=start,enable
        service.chronyd=stop,disable													        service.chronyd=stop,disable
      name: performance-patch														      name: performance-patch
  recommend:																  recommend:
    - machineConfigLabels:														    - machineConfigLabels:
        machineconfiguration.openshift.io/role: master											        machineconfiguration.openshift.io/role: master
      priority: 19															      priority: 19
      profile: performance-patch													      profile: performance-patch
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-monitoring/cm:cluster-monitoring-config: diff -W 270 --color -y   source-openshift-monitoring-cm-cluster-monitoring-config.yaml target-openshift-monitoring-cm-cluster-monitoring-config.yaml
------------------------------------------------------------------------------------------------
apiVersion: v1																apiVersion: v1
data:																	data:
  config.yaml: |															  config.yaml: |
    alertmanagerMain:															    alertmanagerMain:
      enabled: false															      enabled: false
    telemeterClient:															    telemeterClient:
      enabled: false															      enabled: false
    prometheusK8s:															    prometheusK8s:
       retention: 24h															       retention: 24h
kind: ConfigMap																kind: ConfigMap
metadata:																metadata:
  name: cluster-monitoring-config													  name: cluster-monitoring-config
  namespace: openshift-monitoring													  namespace: openshift-monitoring
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-operator-lifecycle-manager/cm:collect-profiles-config: diff -W 270 --color -y   source-openshift-operator-lifecycle-manager-cm-collect-profiles-config.yaml target-openshift-operator-lifecycle-manager-cm-collect-profiles-config.yaml
------------------------------------------------------------------------------------------------
apiVersion: v1																apiVersion: v1
data:																	data:
  pprof-config.yaml: |															  pprof-config.yaml: |
    disabled: True															    disabled: True
kind: ConfigMap																kind: ConfigMap
metadata:																metadata:
  name: collect-profiles-config														  name: collect-profiles-config
  namespace: openshift-operator-lifecycle-manager											  namespace: openshift-operator-lifecycle-manager
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-marketplace/catalogsource:redhat-operators: diff -W 270 --color -y   source-openshift-marketplace-catalogsource-redhat-operators.yaml target-openshift-marketplace-catalogsource-redhat-operators.yaml
------------------------------------------------------------------------------------------------
apiVersion: operators.coreos.com/v1alpha1												apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource															kind: CatalogSource
metadata:																metadata:
  name: redhat-operators														  name: redhat-operators
  namespace: openshift-marketplace													  namespace: openshift-marketplace
spec:																	spec:
  displayName: Red Hat Operators													  displayName: Red Hat Operators
  image: registry.redhat.io/redhat/redhat-operator-index:v4.14									      |	  image: registry.redhat.io/redhat/redhat-operator-index:v4.16
  publisher: Red Hat															  publisher: Red Hat
  sourceType: grpc															  sourceType: grpc
  updateStrategy:															  updateStrategy:
    registryPoll:															    registryPoll:
      interval: 24h															      interval: 24h
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-marketplace/catalogsource:certified-operators: diff -W 270 --color -y   source-openshift-marketplace-catalogsource-certified-operators.yaml target-openshift-marketplace-catalogsource-certified-operators.yaml
------------------------------------------------------------------------------------------------
apiVersion: operators.coreos.com/v1alpha1												apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource															kind: CatalogSource
metadata:																metadata:
  name: certified-operators														  name: certified-operators
  namespace: openshift-marketplace													  namespace: openshift-marketplace
spec:																	spec:
  displayName: Certified Operators													  displayName: Certified Operators
  image: registry.redhat.io/redhat/certified-operator-index:v4.14								      |	  image: registry.redhat.io/redhat/certified-operator-index:v4.16
  publisher: Red Hat															  publisher: Red Hat
  sourceType: grpc															  sourceType: grpc
  updateStrategy:															  updateStrategy:
    registryPoll:															    registryPoll:
      interval: 24h															      interval: 24h
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-ptp/ptpconfig:: diff -W 270 --color -y   source-openshift-ptp-ptpconfig.yaml target-openshift-ptp-ptpconfig.yaml
------------------------------------------------------------------------------------------------
apiVersion: ptp.openshift.io/v1														apiVersion: ptp.openshift.io/v1
kind: PtpConfig																kind: PtpConfig
metadata:																metadata:
  name: slave															      |	  name: du-ptp-slave
  namespace: openshift-ptp														  namespace: openshift-ptp
spec:																	spec:
  profile:																  profile:
    - interface: ens1f2															    - interface: ens1f2
      name: slave															      name: slave
      phc2sysOpts: -a -r -n 24														      phc2sysOpts: -a -r -n 24
      ptp4lConf: |															      ptp4lConf: |
        [global]															        [global]
        #																        #
        # Default Data Set														        # Default Data Set
        #																        #
        twoStepFlag 1															        twoStepFlag 1
        slaveOnly 1															        slaveOnly 1
        priority1 128															        priority1 128
        priority2 128															        priority2 128
        domainNumber 24															        domainNumber 24
        clockClass 255															        clockClass 255
        clockAccuracy 0xFE														        clockAccuracy 0xFE
        offsetScaledLogVariance 0xFFFF													        offsetScaledLogVariance 0xFFFF
        free_running 0															        free_running 0
        freq_est_interval 1														        freq_est_interval 1
        dscp_event 0															        dscp_event 0
        dscp_general 0															        dscp_general 0
        dataset_comparison G.8275.x													        dataset_comparison G.8275.x
        G.8275.defaultDS.localPriority 128												        G.8275.defaultDS.localPriority 128
        #																        #
        # Port Data Set															        # Port Data Set
        #																        #
        logAnnounceInterval -3														        logAnnounceInterval -3
        logSyncInterval -4														        logSyncInterval -4
        logMinDelayReqInterval -4													        logMinDelayReqInterval -4
        logMinPdelayReqInterval -4													        logMinPdelayReqInterval -4
        announceReceiptTimeout 3													        announceReceiptTimeout 3
        syncReceiptTimeout 0														        syncReceiptTimeout 0
        delayAsymmetry 0														        delayAsymmetry 0
        fault_reset_interval -4														        fault_reset_interval -4
        neighborPropDelayThresh 20000000												        neighborPropDelayThresh 20000000
        masterOnly 0															        masterOnly 0
        G.8275.portDS.localPriority 128													        G.8275.portDS.localPriority 128
        #																        #
        # Run time options														        # Run time options
        #																        #
        assume_two_step 0														        assume_two_step 0
        logging_level 6															        logging_level 6
        path_trace_enabled 0														        path_trace_enabled 0
        follow_up_info 0														        follow_up_info 0
        hybrid_e2e 0															        hybrid_e2e 0
        inhibit_multicast_service 0													        inhibit_multicast_service 0
        net_sync_monitor 0														        net_sync_monitor 0
        tc_spanning_tree 0														        tc_spanning_tree 0
        tx_timestamp_timeout 50														        tx_timestamp_timeout 50
        unicast_listen 0														        unicast_listen 0
        unicast_master_table 0														        unicast_master_table 0
        unicast_req_duration 3600													        unicast_req_duration 3600
        use_syslog 1															        use_syslog 1
        verbose 0															        verbose 0
        summary_interval -4														        summary_interval -4
        kernel_leap 1															        kernel_leap 1
        check_fup_sync 0														        check_fup_sync 0
        clock_class_threshold 7														        clock_class_threshold 7
        #																        #
        # Servo Options															        # Servo Options
        #																        #
        pi_proportional_const 0.0													        pi_proportional_const 0.0
        pi_integral_const 0.0														        pi_integral_const 0.0
        pi_proportional_scale 0.0													        pi_proportional_scale 0.0
        pi_proportional_exponent -0.3													        pi_proportional_exponent -0.3
        pi_proportional_norm_max 0.7													        pi_proportional_norm_max 0.7
        pi_integral_scale 0.0														        pi_integral_scale 0.0
        pi_integral_exponent 0.4													        pi_integral_exponent 0.4
        pi_integral_norm_max 0.3													        pi_integral_norm_max 0.3
        step_threshold 2.0														        step_threshold 2.0
        first_step_threshold 0.00002													        first_step_threshold 0.00002
        max_frequency 900000000														        max_frequency 900000000
        clock_servo pi															        clock_servo pi
        sanity_freq_limit 200000000													        sanity_freq_limit 200000000
        ntpshm_segment 0														        ntpshm_segment 0
        #																        #
        # Transport options														        # Transport options
        #																        #
        transportSpecific 0x0														        transportSpecific 0x0
        ptp_dst_mac 01:1B:19:00:00:00													        ptp_dst_mac 01:1B:19:00:00:00
        p2p_dst_mac 01:80:C2:00:00:0E													        p2p_dst_mac 01:80:C2:00:00:0E
        udp_ttl 1															        udp_ttl 1
        udp6_scope 0x0E															        udp6_scope 0x0E
        uds_address /var/run/ptp4l													        uds_address /var/run/ptp4l
        #																        #
        # Default interface options													        # Default interface options
        #																        #
        clock_type OC															        clock_type OC
        network_transport L2														        network_transport L2
        delay_mechanism E2E														        delay_mechanism E2E
        time_stamping hardware														        time_stamping hardware
        tsproc_mode filter														        tsproc_mode filter
        delay_filter moving_median													        delay_filter moving_median
        delay_filter_length 10														        delay_filter_length 10
        egressLatency 0															        egressLatency 0
        ingressLatency 0														        ingressLatency 0
        boundary_clock_jbod 0														        boundary_clock_jbod 0
        #																        #
        # Clock description														        # Clock description
        #																        #
        productDescription ;;														        productDescription ;;
        revisionData ;;															        revisionData ;;
        manufacturerIdentity 00:00:00													        manufacturerIdentity 00:00:00
        userDescription ;														        userDescription ;
        timeSource 0xA0															        timeSource 0xA0
      ptp4lOpts: -2 -s															      ptp4lOpts: -2 -s
      ptpSchedulingPolicy: SCHED_FIFO													      ptpSchedulingPolicy: SCHED_FIFO
      ptpSchedulingPriority: 10														      ptpSchedulingPriority: 10
      ptpSettings:															      ptpSettings:
        logReduce: "true"														        logReduce: "true"
  recommend:																  recommend:
    - match:																    - match:
        - nodeLabel: node-role.kubernetes.io/master											        - nodeLabel: node-role.kubernetes.io/master
      priority: 4															      priority: 4
      profile: slave															      profile: slave
------------------------------------------------------------------------------------------------
```

## Example 2

```shell
# export DIFF_OPTS="--suppress-common-lines -W $(( $(tput cols) - 2 )) --color -y"
# ./diff.sh -f /root/workload-enablement/kubeconfigs/kubeconfig-sno131.yaml -t /root/workload-enablement/kubeconfigs/kubeconfig-sno132.yaml
Compare cluster source: /root/workload-enablement/kubeconfigs/kubeconfig-sno131.yaml
Compare cluster target: /root/workload-enablement/kubeconfigs/kubeconfig-sno132.yaml
Compare cluster-scoped resources:

Diff clusterversion:version: diff --suppress-common-lines -W 155 --color -y source-clusterversion-version.yaml target-clusterversion-version.yaml
------------------------------------------------------------------------------------------------
      - marketplace							     |	      - OperatorLifecycleManager
									     >	      - Ingress
  channel: stable-4.14							     |	  channel: candidate-4.16
  clusterID: 043e9e47-e79d-4cbc-9538-5714d2ef9296			     |	  clusterID: ec56c67d-c783-4908-a528-60e06c564b76
    version: 4.14.25							     |	    version: 4.16.4
------------------------------------------------------------------------------------------------

Diff nodes.config.openshift.io:cluster: diff --suppress-common-lines -W 155 --color -y source-nodes.config.openshift.io-cluster.yaml target-nodes.config.openshift.io-cluster.yaml
------------------------------------------------------------------------------------------------
spec:									     |	spec: {}
  cgroupMode: v1							     <
------------------------------------------------------------------------------------------------

Diff containerruntimeconfigs:: diff --suppress-common-lines -W 155 --color -y source-containerruntimeconfigs.yaml target-containerruntimeconfigs.yaml
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Diff performanceprofiles:: diff --suppress-common-lines -W 155 --color -y source-performanceprofiles.yaml target-performanceprofiles.yaml
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Diff networks.operator.openshift.io:cluster: diff --suppress-common-lines -W 155 --color -y source-networks.operator.openshift.io-cluster.yaml target-networks.operator.openshift.io-cluster.yaml
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Diff mc:container-mount-namespace-and-kubelet-conf-master: diff --suppress-common-lines -W 155 --color -y source-mc-container-mount-namespace-and-kubelet-conf-master.yaml target-mc-container-mount-namespace-and-kubelet-conf-master.yaml
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Diff mc:07-sriov-related-kernel-args-master: diff --suppress-common-lines -W 155 --color -y source-mc-07-sriov-related-kernel-args-master.yaml target-mc-07-sriov-related-kernel-args-master.yaml
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Diff mc:08-set-rcu-normal-master: diff --suppress-common-lines -W 155 --color -y source-mc-08-set-rcu-normal-master.yaml target-mc-08-set-rcu-normal-master.yaml
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Diff mc:99-crio-disable-wipe-master: diff --suppress-common-lines -W 155 --color -y source-mc-99-crio-disable-wipe-master.yaml target-mc-99-crio-disable-wipe-master.yaml
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Diff mc:99-sync-time-once-master: diff --suppress-common-lines -W 155 --color -y source-mc-99-sync-time-once-master.yaml target-mc-99-sync-time-once-master.yaml
------------------------------------------------------------------------------------------------
            After=network.service					     |	            After=network-online.target
									     >	            Wants=network-online.target
									     >	            ExecCondition=/bin/bash -c 'systemctl is-enabled chronyd.servic
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-cluster-node-tuning-operator/tuned:performance-patch: diff --suppress-common-lines -W 155 --color -y source-openshift-cluster-node-tuning-operator-tuned-performance-patch.yaml target-openshift-cluster-node-tuning-operator-tuned-performance-patch.yaml
------------------------------------------------------------------------------------------------
        [sysctl]							     <
        kernel.timer_migration=1					     <
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-monitoring/cm:cluster-monitoring-config: diff --suppress-common-lines -W 155 --color -y source-openshift-monitoring-cm-cluster-monitoring-config.yaml target-openshift-monitoring-cm-cluster-monitoring-config.yaml
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-operator-lifecycle-manager/cm:collect-profiles-config: diff --suppress-common-lines -W 155 --color -y source-openshift-operator-lifecycle-manager-cm-collect-profiles-config.yaml target-openshift-operator-lifecycle-manager-cm-collect-profiles-config.yaml
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-marketplace/catalogsource:redhat-operators: diff --suppress-common-lines -W 155 --color -y source-openshift-marketplace-catalogsource-redhat-operators.yaml target-openshift-marketplace-catalogsource-redhat-operators.yaml
------------------------------------------------------------------------------------------------
  image: registry.redhat.io/redhat/redhat-operator-index:v4.14		     |	  image: registry.redhat.io/redhat/redhat-operator-index:v4.16
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-marketplace/catalogsource:certified-operators: diff --suppress-common-lines -W 155 --color -y source-openshift-marketplace-catalogsource-certified-operators.yaml target-openshift-marketplace-catalogsource-certified-operators.yaml
------------------------------------------------------------------------------------------------
  image: registry.redhat.io/redhat/certified-operator-index:v4.14	     |	  image: registry.redhat.io/redhat/certified-operator-index:v4.16
------------------------------------------------------------------------------------------------

Compare namespace-scoped resources
Diff openshift-ptp/ptpconfig:: diff --suppress-common-lines -W 155 --color -y source-openshift-ptp-ptpconfig.yaml target-openshift-ptp-ptpconfig.yaml
------------------------------------------------------------------------------------------------
  name: slave								     |	  name: du-ptp-slave
------------------------------------------------------------------------------------------------
```