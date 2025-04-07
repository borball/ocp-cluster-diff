## Usage

### Generate must-gather

Note that the default must-gather image does not collect all the resources required for the comparison, so a custom 
image can/shall be used in this script. 

Update the [resources.cfg](collection-scripts/resources.cfg) based on your needs to compare moe resources. Build the 
image and publish to your registry so that you can fetch cluster data accordingly.

In this repo, we built and published the image here quay.io/bzhai/caas-vdu-must-gather:4.18

```shell
# cluster 1
oc adm must-gather --image=quay.io/bzhai/vdu-caas-must-gather:4.18 --dest-dir cluster1-must-gather
# cluster 2
oc adm must-gather --image=quay.io/bzhai/vdu-caas-must-gather:4.18 --dest-dir cluster2-must-gather
```

### Compare

```shell
diff.sh cluster1-must-gather cluster2-must-gather
```

### Demo

[diff](diff.jpg)