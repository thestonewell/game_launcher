import dbus
import signal
import logging


def handler(sig_num, curr_stack_frame):
    logging.debug("Signal : '{}' received. Proceeding to shutdown.".format(signal.strsignal(sig_num)))


if __name__ == "__main__":
    logging.basicConfig(
        format='%(asctime)s %(levelname)-8s %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        filename='inhibit.log',
        encoding='utf-8',
        level=logging.DEBUG)

    powerManagement = dbus.SessionBus().get_object("org.freedesktop.PowerManagement", "/org/freedesktop/PowerManagement/Inhibit")
    pmIinhibited = powerManagement.Inhibit("game launcher", "enabling system-wide inhibition during game play")

    screenSaver = dbus.SessionBus().get_object("org.freedesktop.ScreenSaver", "/ScreenSaver")
    ssInhibited = screenSaver.Inhibit("game launcher", "enabling system-wide inhibition during game play")

    logging.info("Inhibited Power Management and Screen Saver.")

    # setup signal handler and wait
    signal.signal(signal.SIGINT, handler)
    signal.pause()

    screenSaver.UnInhibit(ssInhibited)
    powerManagement.UnInhibit(pmIinhibited)

    logging.info("Uninhibited Power Management and Screen Saver.")
