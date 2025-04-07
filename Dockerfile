FROM registry.ci.openshift.org/ocp/builder:rhel-9-golang-1.22-openshift-4.18 AS builder
WORKDIR /go/src/github.com/borball/ocp-cluster-diff
COPY . .
ENV GO_PACKAGE github.com/openshift/must-gather

FROM registry.ci.openshift.org/ocp/4.18:cli

LABEL io.k8s.display-name="vdu-caas-must-gather" \
      io.k8s.description="This is a must-gather image that collects important vDU required & tuned resources."
COPY --from=builder /go/src/github.com/borball/ocp-cluster-diff/collection-scripts/* /usr/bin/
RUN chmod +x /usr/bin/gather
