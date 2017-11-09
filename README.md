# minecraft-server
Minecraft server on Google Container Engine

### Create disk for persistent data
```bash
gcloud compute disks create --size 200GB mc-world-disk

```

New disks are unformatted. You must format and mount a disk before it<br>
can be used. You can find instructions on how to do this at:

[https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting](https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting)



### Reference
[https://cloud.google.com/container-engine/docs/tutorials/persistent-disk](https://cloud.google.com/container-engine/docs/tutorials/persistent-disk)