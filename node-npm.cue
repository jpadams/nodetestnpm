package main

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
	"universe.dagger.io/bash"
	"universe.dagger.io/docker"
)

_workdir: "/usr/app"

dagger.#Plan & {
	actions: {
		build: {
			checkoutCode: core.#Source & {path: "."}
			run:          docker.#Build & {
				steps: [
					docker.#Pull & {source: "node:lts"},
					docker.#Copy & {
						contents: checkoutCode.output
						dest:     _workdir
					},
					docker.#Set & {config: workdir: _workdir},
					bash.#Run & {
						script: contents: """
                            npm install
                            """
					},
					bash.#Run & {
						always: true
						script: contents: """
                            npm install
                            npm run build
                            npm run test
                            """
					},
				]
			}
		}
	}
}
