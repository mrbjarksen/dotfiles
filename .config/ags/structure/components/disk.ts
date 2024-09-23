import Gio from 'gi://Gio'
import { clock } from 'services/clock'
import Common from 'structure/common'
import { withUnits } from 'utils'

const hover = Variable(false)

const free = Variable(0)
const size = Variable(0)

const getFilesystemInfo = async (file: Gio.File) =>
    file.query_filesystem_info('filesystem::free,filesystem::size', null)

const root = Gio.file_new_for_path('/')
const updateDisk = async () =>
    getFilesystemInfo(root)
        .then(info => {
            const fsFree = info.get_attribute_uint64('filesystem::free')
            const fsSize = info.get_attribute_uint64('filesystem::size')
            if (fsFree != free.value) free.setValue(fsFree)
            if (fsSize != size.value) size.setValue(fsSize)
        })
        .catch(console.error)

updateDisk()
clock.connect('notify::second', () => clock.second % 2 == 0 && updateDisk())

const units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB', 'RB', 'QB']

const Size = Widget.Revealer({
    transition: 'slide_right',
    transitionDuration: 200,
    reveal_child: hover.bind(),
    child: Widget.Box({
        children: [
            Common.Inner('/'),
            Widget.Label({
                label: size.bind().as(size =>
                    withUnits(size, 0, 1000, units)
                )
            })
        ]
    })
})

export const DiskComponent = Widget.Button({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    className: free.bind().as(free =>
        free < 64 ? 'red' : free < 128 ? 'yellow' : 'normal'
    ),
    child: Widget.Box([
        Common.Icon('\uEDFA'),
        Widget.Box({
            className: 'content',
            children: [
                Widget.Label({
                    label: free.bind().as(free =>
                        withUnits(free, 0, 1000, units)
                    )
                }),
                Size
            ]
        })
    ])
})
