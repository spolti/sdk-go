addheaders:
	@command -v addlicense > /dev/null || go install -modfile=tools.mod -v github.com/google/addlicense
	@addlicense -c "The Serverless Workflow Specification Authors" -l apache .

fmt:
	@go vet ./...
	@go fmt ./...

lint:
	@command -v golangci-lint > /dev/null || curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "${GOPATH}/bin"
	make addheaders
	make fmt
	./hack/go-lint.sh

.PHONY: test
coverage="false"
test:
	make lint
	@go test ./...


## Location to install dependencies to
LOCALBIN ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)
DEEPCOPY_GEN ?= $(LOCALBIN)/deepcopy-gen

.PHONY: deepcopy
deepcopy: $(DEEPCOPY_GEN) ## Download deepcopy-gen locally if necessary.
$(DEEPCOPY_GEN): $(LOCALBIN)
	GOBIN=$(LOCALBIN) GO111MODULE=on go install k8s.io/gengo/examples/deepcopy-gen@latest
	#/tmp/$(TOOL) --logtostderr --v=4 -i $$(echo $$PKGS | sed 's/ /,/g') -O zz_generated