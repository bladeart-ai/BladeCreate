import logging
import logging.config


def logging_setup():
    logging.config.fileConfig(
        "configs/logging.conf", disable_existing_loggers=False
    )
