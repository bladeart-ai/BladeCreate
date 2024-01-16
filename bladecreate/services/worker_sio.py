# coding=utf-8
import socketio

from bladecreate.logging import Logger

logger = Logger.get_logger(__name__)

sio = socketio.AsyncServer(async_mode="asgi", cors_allowed_origins="*")
app = socketio.ASGIApp(sio)


class ClientSocketIONameSpace(socketio.AsyncNamespace):
    def on_connect(self, sid, environ):
        # TODO: Authentication
        logger.info(f"connected client {sid}")

    def on_disconnect(self, sid):
        logger.info(f"disconnected client {sid}")


class WorkerSocketIONameSpace(socketio.AsyncNamespace):
    def on_connect(self, sid, environ):
        # TODO: Authentication
        logger.info(f"connected worker {sid}")

    def on_disconnect(self, sid):
        logger.info(f"disconnected worker {sid}")

    async def on_worker_event(self, sid, data):
        await sio.emit("worker_event", data, namespace="/client")


sio.register_namespace(ClientSocketIONameSpace("/client"))
sio.register_namespace(WorkerSocketIONameSpace("/worker"))
