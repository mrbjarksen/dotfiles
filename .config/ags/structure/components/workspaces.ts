import GLib from 'gi://GLib';
import Common from 'structure/common';
import niri, { WorkspaceService, WindowService } from 'services/niri';

const hoverVar = Variable<number | boolean>(false)

const workspaceIcons = {
    '0': '\uEF9F', '1': '\uEFA0', '2': '\uEFA1', '3': '\uEFA2', '4': '\uEFA3',
    '5': '\uEFA4', '6': '\uEFA5', '7': '\uEFA6', '8': '\uEFA7', '9': '\uEFA8',
};

const WindowComponent = (win: WindowService, hover: typeof hoverVar) => Widget.Button({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    onClicked: () => niri.request({ Action: { FocusWindow: { id: win.id } } }),
    className: 'content',
    child: Widget.Box({
        children: [
            Widget.Stack({
                transition: 'crossfade',
                transitionDuration: 200,
                shown: Utils.merge([win.bind('app_id'), win.bind('title'), win.bind('is_focused')], (app_id, title, focused) => {
                    switch (app_id) {
                        case 'kitty': return focused ? 'kittyFocused' : 'kittyUnfocused';
                        case 'steam': return focused ? 'steamFocused' : 'steamUnfocused';
                        case 'mpv': return focused ? 'mpvFocused' : 'mpvUnfocused';
                        case 'org.pwmt.zathura': return focused ? 'zathuraFocused' : 'zathuraUnfocused';
                        case 'firefox':
                            if (title?.endsWith('YouTube')) return focused ? 'youtubeFocused' : 'youtubeUnfocused';
                            if (title?.endsWith('Twitch')) return focused ? 'twitchFocused' : 'twitchUnfocused';
                            if (title?.endsWith('Netflix')) return focused ? 'netflixFocused' : 'netflixUnfocused';
                            if (title?.endsWith('LinkedIn')) return focused ? 'linkedinFocused' : 'linkedinUnfocused';
                            return focused ? 'firefoxFocused' : 'firefoxUnfocused';
                        default: return focused ? 'defaultFocused' : 'defaultUnfocused';
                    }
                }),
                children: {
                    kittyFocused: Widget.Label('\uF1F5'), kittyUnfocused: Widget.Label('\uF1F6'),
                    firefoxFocused: Widget.Label('\uED34'), firefoxUnfocused: Widget.Label('\uED35'),
                    youtubeFocused: Widget.Label('\uF2D4'), youtubeUnfocused: Widget.Label('\uF2D5'),
                    twitchFocused: Widget.Label('\uF238'), twitchUnfocused: Widget.Label('\uF239'),
                    netflixFocused: Widget.Label('\uEF8C'), netflixUnfocused: Widget.Label('\uEF8D'),
                    linkedinFocused: Widget.Label('\uEEB3'), linkedinUnfocused: Widget.Label('\uEEB4'),
                    zathuraFocused: Widget.Label('\uEADA'), zathuraUnfocused: Widget.Label('\uEADB'),
                    steamFocused: Widget.Label('\uF190'), steamUnfocused: Widget.Label('\uF191'),
                    mpvFocused: Widget.Label('\uF008'), mpvUnfocused: Widget.Label('\uF009'),
                    defaultFocused: Widget.Label('\uF2C5'), defaultUnfocused: Widget.Label('\uF2C6'),
                }
            }),
            Widget.Revealer({
                transition: 'slide_left',
                transitionDuration: 200,
                revealChild: Utils.merge([win.bind('is_focused'), hover.bind()], (focused, hover) =>
                    focused || hover
                ),
                child: Widget.Label({
                    className: 'window-title',
                    maxWidthChars: 40,
                    label: win.bind('title').as(title =>
                        (title || '').replace(/ — Mozilla Firefox$/, '')
                    ),
                }),
            })
        ]
    })
});

const WorkspaceComponent = (workspace: WorkspaceService) => Widget.Revealer({
    transition: 'slide_left',
    transitionDuration: 250,
    revealChild: Utils.merge([workspace.bind('is_active'), niri.bind('windows')], (active, windows) =>
        active || windows.some(win => win.workspace_id === workspace.id)
    ),
    child: Widget.Box({
        classNames: workspace.bind('is_active').as(active => active ? ['normal'] : ['normal', 'disabled']),
        child: Widget.Box([
            Widget.Button({
                onClicked: () => niri.request({ Action: { FocusWorkspace: { reference: { Id: workspace.id } } } }),
                child: Common.Icon({
                    className: 'header',
                    label: workspaceIcons[workspace.name || ''] || workspace.idx.toString()
                })
            }),
            Widget.Box({
                children: niri.bind('windows').as(
                    windows => windows
                        .filter(win => win.workspace_id === workspace.id)
                        .map(win => WindowComponent(win, Variable<number | boolean>(false)))
                )
            })
        ])
    })
});

export const WorkspacesComponent = Widget.Box({
    spacing: 6,
    children: niri.bind('workspaces').as(
        workspaces => workspaces
            .map(workspace => WorkspaceComponent(workspace, Variable<number | boolean>(false)))
    )
});
