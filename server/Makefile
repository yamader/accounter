PYTHON      = rye run python
PROTOC      = $(PYTHON) -m grpc_tools.protoc
PROTOL      = rye run protol
PROTOCFLAGS = -I../protos --python_out=pb --pyi_out=pb --grpc_python_out=pb
PROTOLFLAGS = --create-package --in-place -o pb protoc -p ../protos

TARGETS     = greeter

################################################################

.PHONY: all clean run

all: $(TARGETS)

clean:
	rm -rf pb

run:
	$(PYTHON) -m src.server

################################################################

.PHONY: greeter

pb:
	mkdir -p pb

greeter: ../protos/hello.proto pb
	$(PROTOC) $(PROTOCFLAGS) $<
	$(PROTOL) $(PROTOLFLAGS) $<
