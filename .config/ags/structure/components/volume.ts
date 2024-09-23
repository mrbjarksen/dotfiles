import GLib from 'gi://GLib'
import Common from 'structure/common'
const audio = await Service.import('audio')

const hover = Variable<number | boolean>(false)

audio.speaker.connect('notify::volume', () => {
    if (hover.value === true) return
    if (typeof hover.value === 'number') GLib.source_remove(hover.value)
    hover.setValue(Utils.timeout(4000, () => hover.setValue(false)))
})

export const VolumeComponent = Widget.EventBox({
    setup: self => self
        .on('enter-notify-event', () => {
            if (typeof hover.value === 'number') GLib.source_remove(hover.value)
            hover.setValue(true)
        })
        .on('leave-notify-event', () => hover.setValue(false)),
    classNames: Utils.merge([audio.speaker.bind('is_muted'), audio.bind('apps')], (muted, apps) =>
        muted ? ['normal', 'disabled'] : apps.length == 0 ? ['normal', 'inactive'] : ['normal']
    ),
    child: Widget.Box([
        Widget.Button({
            onClicked: () => audio.speaker.is_muted = !audio.speaker.is_muted,
            child: Common.Icons({
                transition: 'slide_left_right',
                transitionDuration: 200,
                shown: Utils.merge([audio.speaker.bind('is_muted'), audio.speaker.bind('volume')], (muted, volume) =>
                    muted
                        ? (volume == 0 ? 'mutedOff' : volume <= 0.5 ? 'mutedLow' : 'mutedHigh')
                        : (volume == 0 ? 'off' : volume <= 0.5 ? 'low' : 'high')
                ),
                children: {
                    mutedOff: Widget.Label('\uF29E'),
                    mutedLow: Widget.Label('\uF29C'),
                    mutedHigh: Widget.Label('\uF2A2'),
                    off: Widget.Label('\uF29D'),
                    low: Widget.Label('\uF29B'),
                    high: Widget.Label('\uF2A1'),
                }
            })
        }),
        Widget.Revealer({
            transition: 'slide_left',
            transitionDuration: 250,
            reveal_child: hover.bind().as(hover => hover !== false),
            child: Widget.Slider({
                className: 'slider',
                drawValue: false,
                value: audio.speaker.bind('volume').as(volume => volume),
                onChange: ({ value }) => audio.speaker.volume = value,
            })
        })
    ])
})
