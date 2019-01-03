# HTTProbe
Simple HTTP probe, that will listen idefinetly on the given port and accept any path in request.

## BUILD
- Install stack: https://docs.haskellstack.org/en/stable/install_and_upgrade/
- First time only (globally):
  - ```stack install```
  - ```stack upgrade```
- In project folder:
  - ```stack build```

## RUN LOCALLY
Port 8080, 100% success responses (HTTP 200)
```
stack exec httprobe 8080 200
```

Port 8080, 70% success responses (HTTP 204), 30% error responses (HTTP 500)
```
stack exec httprobe 8080 204 500 30
```
