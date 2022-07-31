Before Start

```shell
mkdir -vp cloudreve/{uploads,avatar} \
&& touch cloudreve/conf.ini \
&& touch cloudreve/cloudreve.db \
&& mkdir -p aria2/config \
&& mkdir -p data/aria2 \
&& chmod -R 777 data/aria2
```

Start

    docker-compose -f cloudreve.yml up -d

Get Password

    docker logs -f cloudreve
