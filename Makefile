REPO           := blockdox/pandas
STAGES         := lock alpine slim jupyter latest

.PHONY: default clean clobber push check_vars

default: $(STAGES)

check_vars:
	@test $${PANDAS_VERSION?Please set environment variable PANDAS_VERSION}
	@test $${PYTHON_VERSION?Please set environment variable PYTHON_VERSION}

.docker:
	mkdir -p $@

.docker/lock:    Pipfile
.docker/alpine:  .docker/lock Pipfile.lock
.docker/slim:    .docker/alpine
.docker/jupyter: .docker/slim
.docker/latest:  .docker/jupyter
.docker/%:     | .docker
	docker build --build-arg PANDAS_VERSION=$(PANDAS_VERSION) --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --iidfile $@ --tag $(REPO):$* --target $* .

Pipfile.lock: .docker/lock
	docker run --rm --entrypoint cat $$(cat $<) $@ > $@

clean:
	rm -rf .docker

clobber: clean
	docker image ls $(REPO) --quiet | uniq | xargs docker image rm --force

push: default
	docker image push $(REPO):alpine
	docker image push $(REPO):slim
	docker image push $(REPO):jupyter
	docker image push $(REPO):latest
	docker image push $(REPO):$(PANDAS_VERSION)-alpine
	docker image push $(REPO):$(PANDAS_VERSION)-slim
	docker image push $(REPO):$(PANDAS_VERSION)-jupyter
	docker image push $(REPO):$(PANDAS_VERSION)

alpine slim jupyter: check_vars
	docker image tag $(REPO):$* $(REPO):$(PANDAS_VERSION)-py$(PYTHON_VERSION)-$*

latest:
	docker image tag $(REPO):$* $(REPO):$(PANDAS_VERSION)

lock: Pipfile.lock

$(STAGES): %: check_vars .docker/%
