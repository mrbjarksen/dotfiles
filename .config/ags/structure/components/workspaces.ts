import Common from 'structure/common';
import niri, { WorkspaceService, WindowService } from 'services/niri';

const hover = Variable<null | number>(null)

const workspaceIcons = {
    '0': '\uEF9F', '1': '\uEFA0', '2': '\uEFA1', '3': '\uEFA2', '4': '\uEFA3',
    '5': '\uEFA4', '6': '\uEFA5', '7': '\uEFA6', '8': '\uEFA7', '9': '\uEFA8',
};

const windowIcons = {
    kittyActive: '\uF1F5', kittyInactive: '\uF1F6',
    firefoxActive: '\uED34', firefoxInactive: '\uED35',
    qutebrowserActive: '\uEDCE', qutebrowserInactive: '\uEDCF',
    youtubeActive: '\uF2D4', youtubeInactive: '\uF2D5',
    twitchActive: '\uF238', twitchInactive: '\uF239',
    netflixActive: '\uEF8C', netflixInactive: '\uEF8D',
    linkedinActive: '\uEEB3', linkedinInactive: '\uEEB4',
    zathuraActive: '\uEADA', zathuraInactive: '\uEADB',
    steamActive: '\uF190', steamInactive: '\uF191',
    mpvActive: '\uF008', mpvInactive: '\uF009',
    defaultActive: '\uF2C5', defaultInactive: '\uF2C6',
};

const WindowComponent = (win: WindowService) => Widget.Button({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(win.id))
        .on('leave-notify-event', () => hover.setValue(null)),
    onClicked: () => niri.request({ Action: { FocusWindow: { id: win.id } } }),
    className: 'content',
    child: Widget.Box({
        children: [
            Widget.Stack({
                transition: 'crossfade',
                transitionDuration: 150,
                shown: Utils.merge([win.bind('app_id'), win.bind('title'), win.bind('is_active')], (app_id, title, focused): keyof typeof windowIcons => {
                    const app = app_id?.substring(app_id.lastIndexOf('.') + 1);
                    const focus = focused ? 'Active' : 'Inactive';
                    switch (app) {
                        case 'kitty':
                        case 'steam':
                        case 'mpv':
                        case 'zathura':
                            return `${app}${focus}`;
                        case 'firefox':
                        case 'qutebrowser':
                            const pageTitle = title?.replace(/( — Mozilla Firefox| - qutebrowser)$/, '');
                            if (pageTitle?.endsWith('YouTube')) return `youtube${focus}`;
                            if (pageTitle?.endsWith('Twitch')) return `twitch${focus}`;
                            if (pageTitle?.endsWith('Netflix')) return `netflix${focus}`;
                            if (pageTitle?.endsWith('LinkedIn')) return `linkedin${focus}`;
                            return `${app}${focus}`;
                        default:
                            return `default${focus}`;
                    }
                }),
                children: Object.fromEntries(
                    Object.entries(windowIcons).map(([key, label]) => [key, Widget.Label(label)])
                ),
            }),
            Widget.Revealer({
                transition: 'slide_left',
                transitionDuration: 200,
                revealChild: Utils.merge([win.bind('is_focused'), hover.bind()], (focused, hover) =>
                    focused || hover == win.id
                ),
                child: Widget.Label({
                    className: 'window-title',
                    maxWidthChars: 40,
                    label: win.bind('title').as(title =>
                        title?.replace(/( — Mozilla Firefox| - qutebrowser)$/, '') || '[Unknown]'
                    ),
                }),
            })
        ]
    })
});

//const WorkspaceComponent = (workspace: WorkspaceService) => Widget.Revealer({
//    transition: 'slide_left',
//    transitionDuration: 250,
//    revealChild: Utils.merge([workspace.bind('is_active'), workspace.bind('windows')], (active, windows) =>
//        active || windows.some(win => win.workspace_id === workspace.id)
//    ),
//    child: Widget.Box({
//        classNames: workspace.bind('is_active').as(active => active ? ['normal'] : ['normal', 'disabled']),
//        child: Widget.Box([
//            Widget.Button({
//                onClicked: () => niri.request({ Action: { FocusWorkspace: { reference: { Id: workspace.id } } } }),
//                child: Common.Icon({
//                    className: 'header',
//                    label: workspaceIcons[workspace.name || ''] || workspace.idx.toString()
//                })
//            }),
//            Widget.Box({
//                children: workspace.bind('windows').as(
//                    windows => windows
//                        .filter(win => win.workspace_id === workspace.id)
//                        .map(win => WindowComponent(win, Variable(false)))
//                )
//            })
//        ])
//    })
//});
//
//const workspaces = Variable(niri.workspaces.map(WorkspaceComponent));
//const windows = Variable(niri.windows.map(WindowComponent));
//
//niri.connect('workspace-added', workspace => workspaces.set())
//
//export const WorkspacesComponent = (output: string) => Widget.Box({
//    spacing: 6,
//    children: niri.getOutput(output)?.bind('workspaces').as(
//        workspaces => workspaces.map(WorkspaceComponent)
//    ),
//});

export const WorkspacesComponent = (output: string) => Widget.Label({
    classNames: ['normal', 'content'],
    label: output
})
