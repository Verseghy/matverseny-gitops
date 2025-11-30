# matverseny-gitops

# Setup instructions

Create a digital ocean "Spaces Object Storage" and reconfigure terraform backends to use the new bucket.

```shell
export DIGITALOCEAN_TOKEN=$(op read "op://Private/digitalocean tokens/password")
export AWS_ACCESS_KEY_ID=$(op read "op://Private/digitalocean tokens/aws_key_id")
export AWS_SECRET_ACCESS_KEY=$(op read "op://Private/digitalocean tokens/aws_key")
```