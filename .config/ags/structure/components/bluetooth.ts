import GLib from 'gi://GLib'
import Common from 'structure/common'
import { BluetoothDevice } from 'types/service/bluetooth'
const bluetooth = await Service.import('bluetooth')

const hover = Variable<number | boolean>(false)

const icons = {
    'audio-card':        '\uF161',
    'audio-headphones':  '\uEE04',
    'audio-headset':     '\uEE04',
    'camera-photo':      '\uEB2E',
    'camera-video':      '\uF51D',
    'computer':          '\uEBC9',
    'input-gaming':      '\uEDAA',
    'input-keyboard':    '\uEE72',
    'input-mouse':       '\uEF7C',
    'input-tablet':      '\uF1DF',
    'modem':             '\uEFE9',
    'multimedia-player': '\uEA1E',
    'network-wireless':  '\uF09C',
    'phone':             '\uF159',
    'printer':           '\uF028',
    'scanner':           '\uF040',
    'video-display':     '\uF234',
}

const devices = Variable<[BluetoothDevice, ReturnType<typeof Device>][]>([])

bluetooth.connect('device-added', (_, address) => {
    const device = bluetooth.getDevice(address)
    if (device?.paired) {
        const widget = Device(device, Variable<number | boolean>(false))
        const index = devices.value.findIndex(([dev, _]) =>
            dev.icon_name > device.icon_name
                || (dev.icon_name === device.icon_name && dev.address > device.address)
        )
        if (index === -1) devices.value.push([device, widget])
        else devices.value.splice(index, 0, [device, widget])
        devices.setValue(devices.value)
    }
})

bluetooth.connect('device-removed', (_, address) => {
    const index = devices.value.findIndex(([dev, _]) => dev.address === address)
    if (index !== -1) devices.setValue(devices.value.splice(index, 1))
})

const Device = (device: BluetoothDevice, deviceHover: typeof hover) => Widget.Button({
    setup: self => self
        .on('enter-notify-event', () => deviceHover.setValue(Utils.timeout(500, () => deviceHover.setValue(true))))
        .on('leave-notify-event', () => {
            if (typeof deviceHover.value === 'number') GLib.source_remove(deviceHover.value)
            deviceHover.setValue(false)
        }),
    onClicked: () => device.setConnection(!device.connected),
    child: Widget.Revealer({
        classNames: device.bind('connected').as(connected => connected ? ['content'] : ['content', 'inactive']),
        transition: 'slide_left',
        transitionDuration: 250,
        revealChild: Utils.merge(
            [bluetooth.bind('enabled'), hover.bind(), device.bind('connected')],
            (enabled, hover, connected) => enabled && (hover !== false || connected)
        ),
        child: Widget.Box([
            Widget.Stack({
                setup: self => self.hook(device, () => {
                    if (device.connecting) {
                        self.shown = 'circleFull'
                        Utils.timeout(500, () => {
                            self.attribute = Utils.interval(500, () => {
                                if (self.shown === 'circleFull') self.shown = 'circleEmpty'
                                else if (self.shown === 'circleEmpty') self.shown = 'circleFull'
                                else self.shown = 'icon'
                            })
                        })
                    }
                    else {
                        self.shown = 'icon'
                        if (typeof self.attribute === 'number') {
                            GLib.source_remove(self.attribute)
                            self.attribute = null
                        }
                    }
                }, 'notify::connecting'),
                transition: 'crossfade',
                transitionDuration: 250,
                children: {
                    circleFull: Widget.Label('\uF3C1'),
                    circleEmpty: Widget.Label('\uF3C2'),
                    icon: Widget.Label({
                        label: device.bind('icon_name').as(icon_name => icons[icon_name] ?? '\uEC2D')
                    })
                }
            }),
            Widget.Revealer({
                transition: 'slide_left',
                transitionDuration: 250,
                revealChild: deviceHover.bind().as(hover => hover === true),
                child: Widget.Label({
                    className: 'bluetooth-alias',
                    label: device.bind('alias'),
                }),
            })
        ])
    })
})

export const BluetoothComponent = Widget.EventBox({
    setup: self => self
        .on('enter-notify-event', () => {
            if (typeof hover.value === 'number') GLib.source_remove(hover.value)
            hover.setValue(true)
        })
        .on('leave-notify-event', () => hover.setValue(Utils.timeout(1000, () => hover.setValue(false)))),
    classNames: Utils.merge([bluetooth.bind('enabled'), bluetooth.bind('connected_devices')],
        (enabled, connected) => !enabled ? ['normal', 'disabled'] : connected.length == 0 ? ['normal', 'inactive'] : ['normal']
    ),
    child: Widget.Box([
        Widget.Button({
            onClicked: bluetooth.toggle,
            child: Common.Icons({
                shown: bluetooth.bind('connected_devices').as(connected =>
                    connected.length > 0 ? 'connected' : 'disconnected'
                ),
                children: {
                    connected: Widget.Label('\uEAC9'),
                    disconnected: Widget.Label('\uEACB')
                }
            }),
        }),
        Widget.Box({
            children: devices.bind().as(devices => devices.map(([_, widget]) => widget))
        })
    ])
})
