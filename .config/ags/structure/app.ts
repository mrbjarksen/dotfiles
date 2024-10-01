import Component from 'structure/component'

const upperBar = () => Widget.Window({
    monitor: 0,
    name: 'upper-bar',
    anchor: ['top', 'left', 'right'],
    exclusivity: 'ignore',
    layer: 'overlay',
    child: Widget.CenterBox({
        startWidget: Widget.Box({
            className: 'component-group',
            hpack: 'start',
            spacing: 6,
            children: [
                Component.Workspaces,
            ]
        }),
        endWidget: Widget.Box({
            className: 'component-group',
            hpack: 'end',
            spacing: 6,
            children: [
                Component.Network,
                Component.Bluetooth,
                Component.Volume,
                Component.Microphone,
                Component.Backlight,
                Component.Battery,
                Component.Keyboard,
                Component.Weather,
                Component.Date,
                Component.Time,
                Component.Power,
            ]
        })
    })
})

const lowerBar = () => Widget.Window({
    monitor: 0,
    name: 'lower-bar',
    anchor: ['bottom', 'left', 'right'],
    exclusivity: 'ignore',
    layer: 'overlay',
    child: Widget.Box({
        className: 'component-group',
        hpack: 'end',
        spacing: 6,
        children: [
            Component.Cpu,
            Component.Memory,
            Component.Disk,
        ]
    })
})

export const detach = () => {
    for (const w of App.windows) {
        console.log(`Removing window '${w.name}'`)
        App.removeWindow(w)
    }
}

export const attach = () => {
    App.addWindow(upperBar())
    App.addWindow(lowerBar())
}
