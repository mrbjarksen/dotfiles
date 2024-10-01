export default {
    Icon: (icon: NonNullable<Parameters<typeof Widget.Label>[0]>) => {
        if (typeof icon === 'string')
            icon = { label: icon }

        return Widget.Label({
            className: 'icon',
            widthRequest: 20,
            heightRequest: 20,
            ...icon
        })
    },
    Icons: (icons: NonNullable<Parameters<typeof Widget.Stack>[0]>) => {
        return Widget.Stack({
            className: 'icon',
            heightRequest: 20,
            widthRequest: 20,
            transition: 'crossfade',
            transitionDuration: 250,
            ...icons
        })
    },
    Inner: (label: string) => Widget.Label({
        className: 'inner',
        label
    }),
}
