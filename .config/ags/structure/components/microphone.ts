import GLib from 'gi://GLib'
import Common from 'structure/common'
const audio = await Service.import('audio')

const hover = Variable<number | boolean>(false)

audio.connect('microphone-changed', () => {
    if (hover.value === true) return
    if (typeof hover.value === 'number') GLib.source_remove(hover.value)
    hover.setValue(Utils.timeout(4000, () => hover.setValue(false)))
})

export const MicrophoneComponent = Widget.EventBox({
    setup: self => self
        .on('enter-notify-event', () => {
            if (typeof hover.value === 'number') GLib.source_remove(hover.value)
            hover.setValue(true)
        })
        .on('leave-notify-event', () => hover.setValue(false)),
    classNames: Utils.merge([audio.microphone.bind('is_muted'), audio.bind('recorders')], (muted, recorders) =>
        muted ? ['normal', 'disabled'] : recorders.length == 0 ? ['normal', 'inactive'] : ['normal']
    ),
    child: Widget.Box([
        Widget.Button({
            onClicked: () => audio.microphone.is_muted = !audio.microphone.is_muted,
            child: Common.Icons({
                shown: audio.microphone.bind('is_muted').as(muted => muted ? 'off' : 'on'),
                children: {
                    off: Widget.Label('\uEF4E'),
                    on: Widget.Label('\uEF4D'),
                }
            })
        }),
        Widget.Revealer({
            transition: 'slide_left',
            transitionDuration: 250,
            reveal_child: hover.bind().as(hover => hover !== false),
            child: Widget.Label({
                classNames: ['content', 'microphone-name'],
                label: audio.microphone.bind('description').as(desc => desc ?? '[None]'),
            })
        })
    ])
})
