## Usage

### Generate must-gather

Note that the default must-gather image may not collect all the resources required for the comparison, so a custom 
image can/shall be used in this repo. 

Update the [resources.cfg](collection-scripts/resources.cfg) based on your needs to if you need to compare additional resources. Build the 
image and publish it to your registry so that you can fetch the cluster data accordingly. 

In this repo, we built and published the image to quay.io/bzhai/caas-vdu-must-gather:4.18

To generate a custom must-gather, run command below towards the clusters you want to compare:

```shell
# cluster 1
oc adm must-gather --image=quay.io/bzhai/vdu-caas-must-gather:4.18 --dest-dir cluster1-must-gather
# cluster 2
oc adm must-gather --image=quay.io/bzhai/vdu-caas-must-gather:4.18 --dest-dir cluster2-must-gather
```

### Compare

Then compare the collected resources:

```shell
diff.sh cluster1-must-gather cluster2-must-gather
```

### Demo

![demo](diff.jpg "cluster diff")
