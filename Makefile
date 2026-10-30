.DEFAULT_GOAL := help

.PHONY: help install dev dev-web build build-app check check-ts check-rust test test-unit test-ui test-rust validate prepare-services package-macos stop-local clean

node_modules: package.json package-lock.json
	npm install
	@touch -c node_modules

help: ## Display this help message
	@echo "Available Makefile targets for Sectile Tauri:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

install: node_modules ## Install Node.js dependencies

dev: node_modules ## Start desktop app with Tauri in development mode
	npm run tauri dev

dev-web: node_modules ## Start web preview server only
	npm run dev

build: node_modules ## Build frontend assets
	npm run build

build-app: node_modules ## Build standalone desktop application bundle via Tauri
	npx tauri build

check-ts: node_modules ## Run TypeScript type checking
	npm run check

check-rust: ## Run Rust cargo check
	npm run check:rust

check: check-ts check-rust ## Run both TypeScript and Rust static checks

test-unit: node_modules ## Run Node.js unit tests
	npm test

test-ui: node_modules ## Run Vitest UI component tests
	npm run test:ui

test-rust: ## Run Rust cargo tests
	npm run test:rust

test: test-unit test-ui test-rust ## Run all tests (unit, UI, and Rust)

validate: check test build ## Full contributor validation suite (checks, tests, build)

prepare-services: node_modules ## Build and prepare native companion/agent services
	npm run prepare:services

package-macos: node_modules ## Package macOS desktop application
	npm run package:macos

stop-local: node_modules ## Stop running local runtime services
	npm run stop:local

clean: ## Clean build artifacts
	rm -rf dist dist-ssr
	cargo clean --manifest-path src-tauri/Cargo.toml
