import asyncio
import logging

import grpc

import pb.hello_pb2
import pb.hello_pb2_grpc

_cleanup_coroutines = []


class Greeter(pb.hello_pb2_grpc.GreeterServicer):
    async def SayHello(
        self,
        request: pb.hello_pb2.HelloRequest,
        context: grpc.ServicerContext,
    ) -> pb.hello_pb2.HelloReply:
        return pb.hello_pb2.HelloReply(message="Hello, %s!" % request.name)


async def serve():
    server = grpc.aio.server()
    pb.hello_pb2_grpc.add_GreeterServicer_to_server(Greeter(), server)
    listen_addr = "[::]:50051"
    server.add_insecure_port(listen_addr)
    logging.info("Starting server on %s", listen_addr)
    await server.start()

    async def server_graceful_shutdown():
        logging.info("Starting graceful shutdown...")
        await server.stop(5)

    _cleanup_coroutines.append(server_graceful_shutdown())
    await server.wait_for_termination()


if __name__ == "__main__":
    logging.basicConfig()
    loop = asyncio.get_event_loop()
    try:
        loop.run_until_complete(serve())
    finally:
        loop.run_until_complete(*_cleanup_coroutines)
        loop.close()
