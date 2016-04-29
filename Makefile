all: test

deps:
	go get -d -v github.com/NYTimes/gizmo/...

updatedeps:
	go get -d -v -u -f github.com/NYTimes/gizmo/...

testdeps:
	go get -d -v -t github.com/NYTimes/gizmo/...

updatetestdeps:
	go get -d -v -t -u -f github.com/NYTimes/gizmo/...

build: deps
	go build github.com/NYTimes/gizmo/...

install: deps
	go install github.com/NYTimes/gizmo/...

lint: testdeps
	go get -v github.com/golang/lint/golint
	for file in $$(find . -name '*.go' | grep -v '\.pb\.go\|\.pb\.gw\.go\|examples\|pubsub\/awssub_test\.go'); do \
		golint $${file}; \
		if [ -n "$$(golint $${file})" ]; then \
			exit 1; \
		fi; \
	done

vet: testdeps
	go vet github.com/NYTimes/gizmo/...

errcheck: testdeps
	go get -v github.com/kisielk/errcheck
	errcheck -ignoretests github.com/NYTimes/gizmo/...

pretest: lint vet # errcheck

test: testdeps pretest
	for dir in $$(go list ./... | grep -v 'examples\/servers\/appengine\|examples\/servers\/datastore-saved-items\|.git'); do \
		go test $${dir}; \
	done
	# app engine bits
	# goapp test ./examples/servers/appengine
	# goapp test ./examples/servers/datastore-saved-items

clean:
	go clean -i github.com/NYTimes/gizmo/...

coverage: testdeps
	./coverage.sh --coveralls

.PHONY: \
	all \
	deps \
	updatedeps \
	testdeps \
	updatetestdeps \
	build \
	install \
	lint \
	vet \
	errcheck \
	pretest \
	test \
	clean \
	coverage
