import Common from 'structure/common'
import { clock } from 'services/clock'
import { twoDigit } from 'utils'

const hover = Variable(false)

const Seconds = Widget.Revealer({
    transition: 'slide_right',
    transitionDuration: 200,
    revealChild: hover.bind(),
    child: Widget.Box({
        widthRequest: 18,
        children: [
            Widget.Label(':'),
            Widget.Label({
                justification: 'left',
                label: clock.bind('second').as(twoDigit)
            })
        ]
    })
})

export const TimeComponent = Widget.Button({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    className: 'static',
    child: Widget.Box([
        Common.Icon('\uF20E'),
        Widget.Box({
            className: 'content',
            children: [
                Widget.Label({ label: clock.bind('hour').as(twoDigit) }),
                Widget.Label(':'),
                Widget.Label({ label: clock.bind('minute').as(twoDigit) }),
                Seconds
            ]
        })
    ])
})
