# docker-s3sync

An example call might look like:

```
sudo docker run -d -v /sync/ver003/:/sync/ -e "S3_BUCKET=commapps-test" docker.cucloud.net/s3sync
```

The environment variable S3_BUCKET is used to set the bucket to sync to.  When running the container map a volume to the conrainers /sync
directory will have a bi-directional sync to s3.

**need to assign I am role to the instance in cloud config for auth
