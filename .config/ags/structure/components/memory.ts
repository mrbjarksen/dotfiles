import { clock } from 'services/clock'
import Common from 'structure/common'
import { withUnits } from 'utils'

const units = ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB', 'RiB', 'QiB']

const memAvailable = Variable(0)
const memTotal = Variable(0)
const swapFree = Variable(0)
const swapTotal = Variable(0)

const swapInUse = Utils.merge([swapFree.bind(), swapTotal.bind()], (free, total) => free !== total)
const color = Utils.merge([memAvailable.bind(), memTotal.bind()], (available, total) => {
    const ratio = available / total
    return ratio >= 0.5 ? 'normal' : ratio >= 0.25 ? 'yellow' : 'red'
})

const updateMemory = async () =>
    Utils.readFileAsync('/proc/meminfo')
        .then(meminfo => {
            meminfo.split('\n').forEach(line => {
                const [key, value, _] = line.split(/\s+/)
                if (key === 'MemTotal:') memTotal.value = Number(value)
                else if (key === 'MemAvailable:') memAvailable.value = Number(value)
                else if (key === 'SwapFree:') swapFree.value = Number(value)
                else if (key === 'SwapTotal:') swapTotal.value = Number(value)
            })
        })
        .catch(console.error)

updateMemory()
clock.connect('notify::second', () => clock.second % 2 == 0 && updateMemory())

const ramHover = Variable(false)

const Ram = Widget.Button({
    setup: self => self
        .on('enter-notify-event', () => ramHover.setValue(true))
        .on('leave-notify-event', () => ramHover.setValue(false)),
    className: 'not-button',
    child: Widget.Box([
        Widget.Revealer({
            transition: 'slide_left',
            transitionDuration: 200,
            reveal_child: swapInUse,
            child: Widget.Label({ className: 'inner-prepend', label: '\uF455' })
        }),
        Widget.Label({
            label: Utils.merge([memAvailable.bind(), memTotal.bind()], (available, total) =>
                withUnits(total - available, 1, 1024, units)
            )
        }),
        Widget.Revealer({
            transition: 'slide_right',
            transitionDuration: 200,
            reveal_child: ramHover.bind(),
            child: Widget.Box([
                Common.Inner('/'),
                Widget.Label({
                    label: memTotal.bind().as(total =>
                        withUnits(total, 1, 1024, units)
                    )
                })
            ])
        })
    ])
})

const swapHover = Variable(false)

const Swap = Widget.Button({
    setup: self => self
        .on('enter-notify-event', () => swapHover.setValue(true))
        .on('leave-notify-event', () => swapHover.setValue(false)),
    className: 'not-button',
    child: Widget.Revealer({
        transition: 'slide_right',
        transitionDuration: 200,
        reveal_child: swapInUse,
        child: Widget.Box([
            Common.Inner('\uF476'),
            Widget.Box([
                Widget.Label({
                    label: Utils.merge([swapFree.bind(), swapTotal.bind()], (free, total) =>
                        withUnits(total - free, 1, 1024, units)
                    )
                }),
                Widget.Revealer({
                    transition: 'slide_right',
                    transitionDuration: 200,
                    reveal_child: swapHover.bind(),
                    child: Widget.Box([
                        Common.Inner('/'),
                        Widget.Label({
                            label: swapTotal.bind().as(total =>
                                withUnits(total, 1, 1024, units)
                            )
                        })
                    ])
                })
            ])
        ])
    })
})

export const MemoryComponent = Widget.EventBox({
    setup: self => self
        .on('enter-notify-event', () => ramHover.setValue(true))
        .on('leave-notify-event', () => ramHover.setValue(false)),
    child: Widget.Box({
        className: color,
        children: [
            Common.Icon('\uF2F6'),
            Widget.Box({
                className: 'content',
                children: [Ram, Swap],
            })
        ]
    })
})
