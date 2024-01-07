import logging
import logging.config

from bladecreate.settings import settings


class Logger(object):
    loggers: dict[str, logging.Logger] = {}

    @classmethod
    def get_logger(cls, name: str = "BladeCreate") -> logging.Logger:
        if name in cls.loggers:
            return cls.loggers[name]

        logger = logging.getLogger(name)
        logger.setLevel(settings.logging.level.upper())
        handler = logging.StreamHandler()
        handler.setFormatter(
            logging.Formatter("%(asctime)s : %(levelname)s - %(name)s - %(message)s")
        )
        logger.addHandler(handler)
        logger.propagate = False

        cls.loggers[name] = logger
        logger.info(f"logger is configured: {name}")
        return cls.loggers[name]
