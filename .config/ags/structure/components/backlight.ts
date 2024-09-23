import GLib from 'gi://GLib'
import Common from 'structure/common'
import { backlight } from 'services/backlight'

const hover = Variable<number | boolean>(false)

backlight.connect('notify::brightness', () => {
    if (hover.value === true) return
    if (typeof hover.value === 'number') GLib.source_remove(hover.value)
    hover.setValue(Utils.timeout(4000, () => hover.setValue(false)))
})

export const BacklightComponent = Widget.Button({
    setup: self => self
        .on('enter-notify-event', () => {
            if (typeof hover.value === 'number') GLib.source_remove(hover.value)
            hover.setValue(true)
        })
        .on('leave-notify-event', () => hover.setValue(false)),
    className: 'normal',
    child: Widget.Box([
        Common.Icon('\uEEA6'),
        Widget.Revealer({
            transition: 'slide_left',
            transitionDuration: 250,
            reveal_child: hover.bind().as(hover => hover !== false),
            child: Widget.Slider({
                className: 'slider',
                drawValue: false,
                value: backlight.bind('brightness').as(brightness => brightness),
                onChange: ({ value }) => backlight.brightness = value,
            })
        })
    ])
})
