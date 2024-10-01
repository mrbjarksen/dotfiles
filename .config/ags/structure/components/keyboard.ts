import Common from 'structure/common';
import niri from 'services/niri';
//const hyprland = await Service.import('hyprland').catch(_ => undefined)

//const keyboard = await hyprland?.messageAsync('j/devices')
//    .then(json => JSON.parse(json).keyboards.find(({ name }) =>
//        name === 'at-translated-set-2-keyboard'
//    ))
//
//const layouts = keyboard == null ? [] : keyboard.layout.split(',')

const abbreviate = (keymap: string): string | undefined =>
    Utils.exec(['grep', '-e', keymap, '/usr/share/X11/xkb/rules/base.lst'])
        .replace(keymap, '').trim().split(/\s+/).at(-1)?.replace(':', '');

const hover = Variable(false);

const KeyboardLayout = (label: string, index: number) => Widget.Revealer({
    //transition: niri.keyboardLayouts.bind('current_idx').as(current =>
    //    index < current || (index == current && previous > current)
    //        ? 'slide_right' : 'slide_left'
    //),
    transition: 'slide_right',
    transitionDuration: 200,
    revealChild: Utils.merge([hover.bind(), niri.keyboardLayouts.bind('current_idx')], (hover, current) =>
        hover || index === current
    ),
    child: Widget.Button({
        classNames: niri.keyboardLayouts.bind('current_idx').as(current =>
            index == current ? ['content'] : ['content', 'inactive']
        ),
        onClicked: async () => {
            while (niri.keyboardLayouts.current_idx !== index)
                await niri.request({ Action: { SwitchLayout: { layout: 'Next' } } })
        },
        child: Widget.Label(label.toUpperCase())
    })
});

export const KeyboardComponent = Widget.EventBox({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    className: 'static',
    visible: niri.keyboardLayouts.bind('names').as(names => names.length !== 0),
    child: Widget.Box([
        Widget.Revealer({ // Only a revealer because of a bug with EventBox and hover
            revealChild: true,
            child: Common.Icon('\uEE72')
        }),
        Widget.Box({
            children: niri.keyboardLayouts.bind('names').as(names =>
                names.map((name, index) => KeyboardLayout(abbreviate(name) || name, index))
            )
        })
    ])
})
