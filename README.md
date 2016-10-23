# triton-sandbox
A Docker image with tools and examples to make it easy to explore Triton

On macOS, with SSH keys and a Triton config in expected places:

```bash
docker run --rm -it -v ~/.ssh:/root/.ssh -v ~/.triton:/root/.triton triton-sandbox bash
```

That will create directories in your macOS home dir/account if they don't exist, so it's safe to run even if you don't have any SSH keys or a configured Triton environment. If you do have any of those configured, it will bring them into the container in read/write mode.
