import Common from 'structure/common'
import { clock } from 'services/clock'
import { twoDigit, withSuffix } from 'utils'

const hover = Variable(false)

const weekdays = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
]

const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
]

const LongDate = Widget.Revealer({
    className: 'content',
    transition: 'slide_right',
    transitionDuration: 250,
    revealChild: hover.bind(),
    child: Widget.Box([
        Widget.Label({ label: clock.bind('weekday').as(weekday => weekdays[weekday]) }),
        Widget.Label(', '),
        Widget.Label({ label: clock.bind('day').as(withSuffix) }),
        Widget.Label(' of '),
        Widget.Label({ label: clock.bind('month').as(month => months[month]) }),
        Widget.Label(', '),
        Widget.Label({ label: clock.bind('year').as(String) })
    ])
})

const ShortDate = Widget.Revealer({
    className: 'content',
    transition: 'slide_right',
    transitionDuration: 250,
    revealChild: hover.bind().as(hover => !hover),
    child: Widget.Box([
        Widget.Label({ label: clock.bind('day').as(twoDigit) }),
        Widget.Label('/'),
        Widget.Label({ label: clock.bind('month').as(month => twoDigit(month+1)) })
    ])
})

export const DateComponent = Widget.Button({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    className: 'static',
    child: Widget.Box([
        Common.Icon('\uEB26'),
        Widget.Box([
            ShortDate,
            LongDate,
        ])
    ])
})
