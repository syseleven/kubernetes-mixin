{
  _config +:: {
    // SysEleven specifics
    diskDeviceSelector: 'device=~"vd[a-z]"',
    cadvisorSelector: 'job="cadvisor"',
    kubeletSelector: 'job="kubelet"',
    kubeStateMetricsSelector: 'job="kube-state-metrics",cluster=""',
    nodeExporterSelector: 'app="node-exporter"',
    notKubeDnsSelector: 'job!="dns"',
    kubeSchedulerSelector: 'job="scheduler"',
    kubeControllerManagerSelector: 'job="controller-manager"',
    kubeApiserverSelector: 'job="apiserver"',
    machineControllerSelector: 'job="machine-controller"',
  },
}
