package main

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
	"universe.dagger.io/bash"
	"universe.dagger.io/docker"
)

dagger.#Plan & {
	actions: {
		build: {
			checkoutCode: core.#Source & {
				path: "."
			}
			pull: docker.#Pull & {
				source: "node:lts"
			}
			copy: docker.#Copy & {
				input:    pull.output
				contents: checkoutCode.output
			}
			install: bash.#Run & {
				input: copy.output
				script: contents: """
					yarn install
					yarn run build
					yarn run test
					"""
			}
		}
	}
}
