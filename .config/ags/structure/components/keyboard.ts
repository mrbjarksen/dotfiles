import Common from 'structure/common'
const hyprland = await Service.import('hyprland')

const keyboard = await hyprland.messageAsync('j/devices')
    .then(json => JSON.parse(json).keyboards.find(({ name }) =>
        name === 'at-translated-set-2-keyboard'
    ))
    .catch(_ => undefined)

const layouts = keyboard == undefined ? [] : keyboard.layout.split(',')

const abbreviate = async (keymap: string): Promise<string | undefined> =>
    Utils.execAsync(['grep', '-e', keymap, '/usr/share/X11/xkb/rules/base.lst'])
        .then(line => line.replace(keymap, '').trim().split(/\s+/).at(-1)?.replace(':', ''))
        .catch(() => undefined)

const active = Variable({ current: 0, previous: 0 })

const setActive = (abbr: string | undefined) => active.setValue({
    current: layouts.indexOf(abbr || ''),
    previous: active.getValue().current,
})

if (keyboard != undefined) abbreviate(keyboard.active_keymap).then(setActive)

hyprland.connect('keyboard-layout', (_, keyboard, layoutname) => {
    if (keyboard === 'at-translated-set-2-keyboard')
        abbreviate(layoutname).then(setActive)
})

const hover = Variable(false)

const keymaps = layouts.map((label: string, index: number) =>
    Widget.Revealer({
        transition: active.bind().as(({ current, previous }) =>
            index < current || (index == current && previous > current)
                ? 'slide_right' : 'slide_left'
        ),
        transitionDuration: 200,
        revealChild: Utils.merge([hover.bind(), active.bind()], (hover, { current }) =>
            hover || index === current
        ),
        child: Widget.Button({
            classNames: active.bind().as(({ current }) =>
                index == current ? ['content'] : ['content', 'inactive']
            ),
            onClicked: () =>
                hyprland.messageAsync(`switchxkblayout at-translated-set-2-keyboard ${index}`),
            child: Widget.Label(label.toUpperCase())
        })
    })
)

export const KeyboardComponent = Widget.EventBox({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    className: 'static',
    child: Widget.Box([
        Widget.Revealer({ // Only a revealer because of a bug with EventBox and hover
            revealChild: true,
            child: Common.Icon('\uEE72')
        }),
        ...keymaps
    ])
})
