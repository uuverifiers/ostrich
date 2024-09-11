#!/usr/bin/env python3
import sys
import asyncio
from pathlib import Path
import os
import signal
import shutil
import socket
from contextlib import contextmanager


JAVA = "java"
JAVA_OPTIONS = ["-Xss20000k", "-Xmx1500m"]
WORK_PATH = Path("~/.ostrich").expanduser()  # TODO decide on something
PID_FILE = WORK_PATH / "ostrich.pid"
TOKEN_FILE = WORK_PATH / "ostrich.cookie"
PORT_FILE = WORK_PATH / "ostrich.port"
NO_OP_SIGNAL = 0

STARTUP_TIMEOUT_S = 2.0


def store_details(pid, port, token):
    for thing, path in zip([pid, port, token], [PID_FILE, PORT_FILE, TOKEN_FILE]):
        with path.open("w") as fp:
            fp.write(str(thing))


def read_details():
    result = []
    for path in [PID_FILE, PORT_FILE, TOKEN_FILE]:
        with path.open() as fp:
            result.append(fp.read())

    result[0] = int(result[0])
    result[1] = int(result[1])
    return result


def cleanup_details():
    for path in [PID_FILE, PORT_FILE, TOKEN_FILE]:
        if path.is_file():
            os.remove(path)


def take_startup_lock():
    # TODO
    pass


def release_startup_lock():
    # TODO
    pass


def find_jarfile(scala_version="*"):
    thisdir = Path(__file__).parent
    jar_glob_pattern = f"target/scala-{scala_version}/ostrich-assembly-*.jar"
    jarfiles = list(thisdir.glob(jar_glob_pattern))
    if not jarfiles:
        raise RuntimeError(
            "Error: No ostrich assembly file found in"
            f" {thisdir.absolute()} matching {jar_glob_pattern}."
            " Did you forget to run `sbt assembly`?"
        )
    used_jar = jarfiles[0]
    if len(jarfiles) > 1:
        print(f"W: multiple Ostrich jar files found, using {used_jar}")

    return used_jar


async def start_daemon(scala_version="*"):
    take_startup_lock()
    try:
        jarfile = find_jarfile(scala_version)
        proc = await asyncio.create_subprocess_exec(
            JAVA,
            *JAVA_OPTIONS,
            "-cp",
            jarfile,
            "ap.ServerMain",
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )

        port = int(
            await asyncio.wait_for(proc.stdout.readline(), timeout=STARTUP_TIMEOUT_S)
        )
        token = (
            (await asyncio.wait_for(proc.stdout.readline(), timeout=STARTUP_TIMEOUT_S))
            .decode("utf-8")
            .strip()
        )
        return proc.pid, port, token
    finally:
        release_startup_lock()


def stop_daemon():
    try:
        pid, _, _ = read_details()
        os.kill(pid, signal.SIGTERM)
        os.kill(pid, signal.SIGKILL)
        print(
            f"Waiting for Ostrich pid {pid} to terminate....", file=sys.stderr, end=""
        )
        # TODO ensure that the process is actually dead
        print("done", file=sys.stderr)
    finally:
        cleanup_details()


def cmd_stop_daemon():
    if not is_running():
        print("Ostrich is not running!", file=sys.stderr)
        return 1
    stop_daemon()
    return 0


@contextmanager
def ostrich_session(port, token):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect(("localhost", port))
    with s:
        # Authenticate the session
        challenge(s, token)
        yield s


def challenge(session, cmd):
    print(f"> {cmd}")
    sent = session.send(f"{cmd}\n".encode())
    if sent == 0:
        raise RuntimeError("socket connection broken")


def response(session):
    """
    Fetch a response from a socket. This is a generator which yields a line
    whenever it becomes available.

    Assumes that the socket is closed when the transmission is done, and will
    block until it is.
    """
    chunks = []

    # TODO Do this with timeout and periodically inject pings, but that will
    # require dipping into async Python.
    while True:
        chunk = session.recv(2048)
        if chunk == b"":
            break
        if b"\n" in chunk:
            lines = chunk.split(b"\n")
            lines[0] = b"".join([*chunks, lines[0]])
            for line in lines[:-1]:
                yield line.decode("utf-8")
            chunks = [lines[-1]]
        else:
            chunks.append(chunk)
    if chunks:
        yield b"".join(chunks).decode("utf-8")


def send_ping(session):
    return challenge(session, "PING")


def is_running():
    try:
        pid, port, token = read_details()
        os.kill(pid, NO_OP_SIGNAL)  # Warning: will terminate process on Windows!
        # with ostrich_session(port, token) as sess:
        #    send_ping(sess)
    except (FileNotFoundError, OSError, RuntimeError) as e:
        return False
    return True


def start_ostrich(scala_version="*"):
    pid, port, token = asyncio.run(start_daemon(scala_version))
    store_details(pid, port, token)
    return pid, port, token


def cmd_start_daemon(scala_version="*"):
    if is_running():
        print(f"Ostrich already running as {read_details()[0]}!", file=sys.stderr)
        return 1

    pid, port, token = start_ostrich(scala_version)
    print(f"Started Ostrich as PID {pid}", file=sys.stderr)
    return 0


def is_error(output_line):
    return "(error" in output_line or "ERROR:" in output_line


def cmd_execute_script(input_files, cli_options=None, ostrich_options=None):
    # Python is very dumb with lists used as default arguments so we need to
    # use None and override here
    cli_options = [] if cli_options is None else cli_options
    ostrich_option_str = "" if ostrich_options is None else ",".join(ostrich_options)

    if not is_running():
        print(f"Ostrich is not running. Starting...", file=sys.stderr)
        _, port, token = start_ostrich()
    else:
        _, port, token = read_details()

    with ostrich_session(port, token) as session:
        # TODO think about whether to individually wait for file output or do all files
        # (maybe we need to make the sockets async as well...)
        # echo all command line options
        # TODO parse out the ostrich parameters; eager, forward, length=*
        for opt in cli_options:
            challenge(session, opt)
        challenge(
            session, f"-stringSolver=ostrich.OstrichStringTheory:{ostrich_option_str}"
        )
        for f in input_files:
            challenge(session, f)
        challenge(session, "PROVE_AND_EXIT")

        error_state = False

        for line in response(session):
            print(line)
            if is_error(line):
                error_state = True

        # TODO do we need to do something for timeouts?

        return 1 if error_state else 0


def main():
    # TODO command parser
    arguments = sys.argv[1:] if sys.argv[1:] else ["-help"]
    if arguments[0] == "start":
        scala_version = "*" if len(arguments) < 2 else arguments[1]
        sys.exit(cmd_start_daemon(scala_version))
    if arguments == ["stop"]:
        sys.exit(cmd_stop_daemon())

    sys.exit(cmd_execute_script(input_files=arguments))


if __name__ == "__main__":
    main()
