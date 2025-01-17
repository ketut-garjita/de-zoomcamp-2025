## Question 1. Understanding docker first run

Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.

What's the version of pip in the image?

- 24.3.1
- 24.2.1
- 23.3.1
- 23.2.1
  
```
docker pull python:3.12.8
  3.12.8: Pulling from library/python
  fd0410a2d1ae: Pull complete 
  bf571be90f05: Pull complete 
  684a51896c82: Pull complete 
  fbf93b646d6b: Pull complete 
  5f16749b32ba: Pull complete 
  e00350058e07: Pull complete 
  eb52a57aa542: Pull complete 
  Digest: sha256:5893362478144406ee0771bd9c38081a185077fb317ba71d01b7567678a89708
  Status: Downloaded newer image for python:3.12.8
  docker.io/library/python:3.12.8
```

```
docker run -it python:3.12.8 pip --version
  pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)
```
### Answer 1: 24.3.1
