"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import symbol_database as _symbol_database
from google.protobuf.internal import builder as _builder
_sym_db = _symbol_database.Default()
DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x0bhello.proto\x12\x05hello"\x1c\n\x0cHelloRequest\x12\x0c\n\x04name\x18\x01 \x01(\t"\x1d\n\nHelloReply\x12\x0f\n\x07message\x18\x01 \x01(\t2?\n\x07Greeter\x124\n\x08SayHello\x12\x13.hello.HelloRequest\x1a\x11.hello.HelloReply"\x00b\x06proto3')
_globals = globals()
_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, _globals)
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'hello_pb2', _globals)
if _descriptor._USE_C_DESCRIPTORS == False:
    DESCRIPTOR._options = None
    _globals['_HELLOREQUEST']._serialized_start = 22
    _globals['_HELLOREQUEST']._serialized_end = 50
    _globals['_HELLOREPLY']._serialized_start = 52
    _globals['_HELLOREPLY']._serialized_end = 81
    _globals['_GREETER']._serialized_start = 83
    _globals['_GREETER']._serialized_end = 146