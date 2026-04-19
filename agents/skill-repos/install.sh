#! /usr/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
SKILLS_DIR="$(dirname "$SCRIPT_DIR")/skills"

# set nvim directory
ln -sf $SCRIPT_DIR/SwiftUI-Agent-Skill/swiftui-pro $SKILLS_DIR/swiftui-pro
ln -sf $SCRIPT_DIR/SwiftData-Agent-Skill/swiftdata-pro $SKILLS_DIR/swiftdata-pro
ln -sf $SCRIPT_DIR/Swift-Concurrency-Agent-Skill/swift-concurrency-pro $SKILLS_DIR/swift-concurrency-pro
ln -sf $SCRIPT_DIR/Swift-Testing-Agent-Skill/swift-testing-pro $SKILLS_DIR/swift-testing-pro
