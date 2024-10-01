import GLib from 'gi://GLib'
import Common from 'structure/common'
const network = await Service.import('network')

const hover = Variable(false)

const WifiIcon = Widget.Button({
    onClicked: network.toggleWifi,
    child: Common.Icons({
        setup: self => self.hook(network.wifi, () => {
            if (!network.wifi.enabled) self.shown = 'none'
            else if (network.connectivity === 'limited' || network.connectivity === 'portal') self.shown = 'alert'
            else if (network.wifi.internet === 'disconnected') self.shown = 'none'
            else if (network.wifi.internet === 'connecting') {
                if (typeof self.attribute === 'number') return
                self.attribute = Utils.interval(500, () => {
                    if (network.wifi.internet === 'connecting') {
                        if (self.shown === 'circleFull') self.shown = 'circleEmpty'
                        else self.shown = 'circleFull'
                    }
                })
            }
            else if (network.wifi.strength >= 80) self.shown = 'full'
            else if (network.wifi.strength >= 60) self.shown = 'good'
            else if (network.wifi.strength >= 40) self.shown = 'okay'
            else if (network.wifi.strength >= 20) self.shown = 'poor'
            else self.shown = 'none'
            if (network.wifi.internet !== 'connecting' && typeof self.attribute === 'number') {
                GLib.source_remove(self.attribute)
                self.attribute = null
            }
        }),
        children: {
            circleFull: Widget.Label('\uF3C1'),
            circleEmpty: Widget.Label('\uF3C2'),
            disabled: Widget.Label('\uF136'),
            alert: Widget.Label('\uF132'),
            none: Widget.Label('\uF134'),
            poor: Widget.Label('\uF12B'),
            okay: Widget.Label('\uF12D'),
            good: Widget.Label('\uF12F'),
            full: Widget.Label('\uF133'),
        }
    })
})

const WifiComponent = Widget.Box({
    classNames: Utils.merge([network.bind('connectivity'), network.wifi.bind('enabled')], (connectivity, enabled) =>
        !enabled ? ['normal', 'disabled']
            : connectivity === 'full' ? ['normal']
            : connectivity === 'portal' ? ['white']
            : ['normal', 'inactive']
    ),
    children: [
        WifiIcon,
        Widget.Revealer({
            transition: 'slide_right',
            transitionDuration: 200,
            reveal_child: hover.bind(),
            child: Widget.Button({
                className: 'content',
                onClicked: () => {
                    if (network.wifi.internet === 'connecting' || network.wifi.ssid === '') return
                    const command = network.wifi.internet == 'disconnected' ? 'up' : 'down'
                    Utils.execAsync(`nmcli connection ${command} ${network.wifi.ssid}`)
                        .catch(console.error)
                },
                child: Widget.Label({
                    className: 'wifi-ssid',
                    label: network.wifi.bind('ssid').as(ssid => ssid == null || ssid === '' ? '\uEA4E' : ssid)
                })
            })
        })
    ]
})

const WiredComponent = Widget.Box({
    classNames: network.bind('connectivity').as(connectivity =>
        connectivity === 'full' ? ['normal']
        : connectivity === 'portal' ? ['white']
        : ['normal', 'inactive']
    ),
    children: [
        Common.Icon('\uEFB8'),
        Widget.Revealer({
            transition: 'slide_right',
            transitionDuration: 200,
            reveal_child: hover.bind(),
            child: Widget.Label({
                className: 'content',
                label: 'Wired Connection',
            })
        })
    ]
})

export const NetworkComponent = Widget.EventBox({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    child: Widget.Box([
        Widget.Stack({
            homogeneous: false,
            transition: 'slide_left_right',
            transitionDuration: 200,
            shown: network.bind('primary').as(primary => primary ?? 'wifi'),
            children: {
                wifi: WifiComponent,
                wired: WiredComponent,
            }
        }),
    ])
})
