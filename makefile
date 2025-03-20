# Copyright 2025 ProntoGUI, LLC.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Makefile to generate all code for .proto files.

# Define the protobuf compiler and the grpc plugin
PROTOC = protoc

all: 
	if [ ! -d "proto" ]; then git clone -b v0.0.3 https://andyhjoseph@github.com/prontogui/proto.git; fi
	mkdir -p lib/src/proto
	$(PROTOC) --dart_out=grpc:lib/src proto/pg.proto

.PHONY: all

clean:
	rm -Rf proto
	rm -f lib/src/proto/*.dart
