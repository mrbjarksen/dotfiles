import Common from 'structure/common'
import { twoDigit } from 'utils'
const battery = await Service.import('battery')

const hover = Variable(false)

const BatteryIcon = Common.Icons({
    shown: Utils.merge([battery.bind('charging'), battery.bind('percent')], (charging, percent) => 
        charging
            ? (percent <= 20 ? 'chargingEmpty' : 'chargingFull')
            : (percent <= 10 ? 'empty' : percent <= 20 ? 'low' : 'full')
    ),
    children: {
        full: Widget.Label('\uEAAF'),
        low: Widget.Label('\uEAB1'),
        empty: Widget.Label('\uEAB0'),
        chargingFull: Widget.Label('\uEAAD'),
        chargingEmpty: Widget.Label('\uEAAE'),
    }
})

const BatteryInfo = Widget.Revealer({
    transition: 'slide_right',
    transitionDuration: 200,
    reveal_child: Utils.merge([hover.bind(), battery.bind('charged')], (hover, charged) =>
        hover || !charged
    ),
    child: Widget.Box({
        className: 'content',
        children: [
            Widget.Label({ label: battery.bind('percent').as(percent => `${percent}%`) }),
            Widget.Revealer({
                transition: 'slide_left',
                transitionDuration: 250,
                reveal_child: Utils.merge([hover.bind(), battery.bind("energy_rate")], (hover, rate) =>
                    hover && rate >= 0.1
                ),
                child: Widget.Box([
                    Common.Inner('\uF212'),
                    Widget.Label({
                        label: battery.bind('time_remaining').as(time =>
                            `${twoDigit(Math.floor(time / 3600))}:${twoDigit(Math.floor(time / 60) % 60)}`
                        )
                    }),
                    Common.Inner('\uED3C'),
                    Widget.Label({ label: battery.bind('energy_rate').as(rate => `${Math.abs(rate).toFixed(1)} W`) }),
                ])
            })
        ]
    })
})

export const BatteryComponent = Widget.EventBox({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    visible: battery.bind('available'),
    className: Utils.merge(
        [battery.bind('charging'), battery.bind('charged'), battery.bind('percent')],
        (charging, charged, percent) =>
            charging || charged ? 'green' : percent > 20 ? 'normal' : percent > 10 ? 'yellow' : 'red'
    ),
    child: Widget.Box([BatteryIcon, BatteryInfo])
})
