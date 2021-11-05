#!/usr/bin/env python3
import asyncio
import swaybar
import datetime
import dbus
import inflection
from typing import Optional, cast
import pulsectl_asyncio as pctl
from pulsectl_asyncio.pulsectl_async import PulseSinkInfo

class Time(swaybar.Module):
    def __init__(self, bar: swaybar.Bar):
        super().__init__(bar)
        self.current_format = 0
        self.formats = [
            '%R',
            '%R %d/%m/%Y'
        ]

    def print(self):
        time = datetime.datetime.now()
        super().print(
            time.strftime(self.formats[self.current_format])
        )

    async def run(self):
        while True:
            self.print()
            await asyncio.sleep(60)

    async def mouse_event(self, _evt: swaybar.ClickEvent):
        self.current_format += 1
        if self.current_format >= len(self.formats):
            self.current_format = 0
        self.print()

class DBusProxy:
    def __init__(self, obj, type, bus):
        if isinstance(obj, dbus.ObjectPath):
            self.obj = bus.get_object('org.bluez', obj)
        else:
            self.obj = obj
        self.dbus = bus
        self.type = type
    
    def get(self, key):
        prop = None
        try:
            prop = self.prop
                   
        except AttributeError:
            self.prop = dbus.Interface(self.obj, 'org.freedesktop.DBus.Properties')
            return self.get(key)

        try:
            return prop.Get(self.type, inflection.camelize(key))
        except dbus.exceptions.DBusException as e:
            if e.get_dbus_name() != 'org.freedesktop.DBus.Error.InvalidArgs':
                raise e from None

    def call(self, method: str, args: tuple):
        try:
            self.actor[inflection.underscore(method)](*args)
        except AttributeError:
            self.actor = dbus.Interface(self.obj, self.type)
            return self.call(method, args)


    def dup(self, type=None):
        if type is None:
            type = self.type
        return DBusProxy(self.obj, type, self.dbus)

class Device:
    MAX_SIZE = 4
    def __init__(self, dev: DBusProxy):
        self.dev = dev
        self.battery = dev.dup('org.bluez.Battery1')
        self.battery_cache: Optional[str] = None
        self.name: str = 'Unnamed'
        self.get_name()

    def _get_and_set(self, name, value):
        if value is not None:
            self.__dict__[name] = value
        return self.__dict__[name]

    def is_connected(self) -> bool:
        return self.dev.get('connected') or False

    def get_battery(self) -> Optional[str]:
        return self._get_and_set('battery_cache', self.battery.get('percentage'))

    def get_name(self) -> str:
        return self._get_and_set('name', self.dev.get('name'))

    def __repr__(self):
        name = self.name[:Device.MAX_SIZE]
        return f'{name}: {self.battery_cache}%'


def list_bluetooth_devices() -> list[Device]:
    def proxyobj(bus, path, interface):
        """ Commodity to apply an interface to a proxy object """
        obj = bus.get_object('org.bluez', path)
        return dbus.Interface(obj, interface)


    def filter_by_interface(objects: dict, interface_name):
        """ filters the objects based on their support
            for the specified interface """
        result = []
        for path in objects.keys():
            interfaces = objects[path]
            for interface in interfaces.keys():
                if interface == interface_name:
                    result.append(path)
        return result

    bus = dbus.SystemBus()

    # we need a dbus object manager
    manager = proxyobj(bus, "/", "org.freedesktop.DBus.ObjectManager")
    objects = manager.GetManagedObjects()

    # once we get the objects we have to pick the bluetooth devices.
    # They support the org.bluez.Device1 interface
    devices = filter_by_interface(objects, "org.bluez.Device1")

    # now we are ready to get the informations we need
    bt_devices = []
    for device in devices:
        obj = DBusProxy(bus=bus, obj=device, type='org.bluez.Device1')
        bt_devices.append(Device(obj))

    return bt_devices

class BatteryIndicator(swaybar.Module):
    def __init__(self, bus):
        super().__init__(bus)
        self.devs = list_bluetooth_devices()
        self.hidden = False

    def is_any_connected(self) -> bool:
        return any(map(lambda dev: dev.is_connected(), self.devs))

    def hide(self, sync=False):
        super().hide(sync)
        self.hidden = True 

    def print(self, text):
        super().print(text)
        self.hidden = False

    def get_battery_devices(self) -> list[Device]:
        return [dev for dev in self.devs if dev.get_battery() is not None]

    async def wait_for_connect(self):
        self.print('Looking for devices...')
        while not self.is_any_connected():
            if not self.hidden:
                self.print('No devices found.')
                await asyncio.sleep(5)
                self.hide(sync=True)
            await asyncio.sleep(10)
            # Refresh the device list
            self.devs = list_bluetooth_devices()

    async def show_connected(self):
        while True:
            batdevs = self.get_battery_devices()
            if len(batdevs) == 0:
                print(batdevs)
                return
            self.print(batdevs)
            await asyncio.sleep(10)

    async def run(self):
        while True:
            await self.wait_for_connect()
            await self.show_connected()

class Volume(swaybar.Module):
    NAME_MAX=16

    def show_volume(self, sink):
        name = sink.description[:type(self).NAME_MAX]
        percentage = sink.volume.value_flat*100
        self.print(f"{name}: {percentage:0.0f}%")

    async def update_server_info(self, pulse: pctl.PulseAsync):
        self.server_info = await pulse.server_info()
        self.sink = await pulse.get_sink_by_name(self.server_info.default_sink_name)

    async def run(self):
        self.i = getattr(self, 'i', 0)+1
        async with pctl.PulseAsync('listener' + self._id) as pulse:
            await self.update_server_info(pulse)

            self.show_volume(self.sink)
            default_sink_id = self.sink.index
            async for evt in pulse.subscribe_events('sink'):
                try:
                    if evt.t == 'change':
                        sink = await pulse.sink_info(evt.index)
                        if sink.index == default_sink_id:
                            self.show_volume(sink)
                        else:
                            await self.update_server_info(pulse)
                            self.print('evt:' + str(evt))
                        
                except Exception as e:
                    self.print(str(e))
                    await self.update_server_info(pulse)

def main():
    import sys
    bar = swaybar.Bar()
    bar.add_module(Volume)
    bar.add_module(Time)
    bar.run()
    pass

if __name__ == '__main__':
    main()
