#!/usr/bin/env python
import asyncio
import logging
import os
import sys
from datetime import datetime

APP_LOG_PATH = os.getenv("APP_LOG_PATH") or "/var/log/app/app.log"
SECONDS_BETWEEN_LOGS = 5

file_handler = logging.FileHandler(APP_LOG_PATH, mode="a", encoding="utf8")
stdout_handler = logging.StreamHandler(stream=sys.stdout)
# set up log formatter so that time and level will be included in log
# records
log_formatter = logging.Formatter(
    "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
# register formatter with the handlers
file_handler.setFormatter(log_formatter)
stdout_handler.setFormatter(log_formatter)
logging.basicConfig(level=logging.INFO, handlers=[file_handler, stdout_handler])
logger = logging.getLogger(__name__)


async def print_stupid_log_msg():
    while True:
        logger.info("wow i felt this was very important to report")
        logger.info(f"current time: {datetime.now()}")
        await asyncio.sleep(SECONDS_BETWEEN_LOGS)


if __name__ == "__main__":
    event_loop = asyncio.get_event_loop()
    logger.info("starting up")
    try:
        logging_task = event_loop.create_task(print_stupid_log_msg())
        event_loop.run_until_complete(logging_task)
    except KeyboardInterrupt as e:
        logger.info("exiting due to keyboard interrupt")
        sys.exit(2)
    except asyncio.CanceledError:
        pass
    sys.exit(0)
