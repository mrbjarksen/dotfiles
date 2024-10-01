import Common from 'structure/common'

const hover = Variable(false)

const Shutdown = Widget.Button({
    classNames: ['red', 'power-button'],
    onClicked: () => Utils.exec('systemctl poweroff'),
    child: Common.Icon('\uF126')
})

const Reboot = Widget.Button({
    classNames: ['yellow', 'power-button'],
    onClicked: () => Utils.exec('systemctl reboot'),
    child: Common.Icon('\uF080')
})

const Logout = Widget.Button({
    classNames: ['green', 'power-button'],
    onClicked: () => Utils.exec('loginctl kill-session self'),
    child: Common.Icon('\uEEDC')
})

const Lock = Widget.Button({
    classNames: ['blue', 'power-button'],
    onClicked: () => Utils.exec('loginctl lock session'),
    child: Common.Icon('\uEC4A')
})

const Suspend = Widget.Button({
    classNames: ['magenta', 'power-button'],
    onClicked: () => Utils.exec('systemctl suspend'),
    child: Common.Icon('\uEF75')
})

export const PowerComponent = Widget.EventBox({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    className: 'power',
    child: Widget.Box({
        children: [
            Widget.Revealer({
                transition: 'slide_left',
                transitionDuration: 200,
                reveal_child: hover.bind(),
                child: Widget.Box({
                    spacing: 2,
                    css: 'padding-right: 2px;',
                    children: [Shutdown, Reboot, Logout, Lock]
                })
            }),
            Suspend
        ]
    })
})
