import { clock } from 'services/clock'
import Common from 'structure/common'
import { withUnits } from 'utils'

const prev = {}

const percentage = Variable(0)
const coresUsed = Variable(0)
const cpufreq = Variable(0)

const updateCpu = async () =>
    Utils.readFileAsync('/proc/stat')
        .then(stat => {
            let coresWithHighUsage = 0
            let maxFreq = 0

            for (const line of stat.split('\n')) {
                const [key, ...values] = line.split(/\s+/)
                if (!key.startsWith('cpu')) continue

                if (prev[key] == null) prev[key] = { total: 0, idle: 0 }
                let [curTotal, curIdle] = [0, 0]
                values.forEach((val, i) => {
                    const time = Number(val)
                    curTotal += Number(time)
                    if (i == 3 || i == 4) curIdle += Number(time)
                })

                const total = curTotal - prev[key].total
                const idle = curIdle - prev[key].idle
                prev[key].total = curTotal
                prev[key].idle = curIdle

                const usage = 1 - idle / total

                if (key === 'cpu') percentage.value = Math.floor(100 * usage)
                else {
                    if (usage >= 0.9) coresWithHighUsage++
                    const freq = Utils.readFile(`/sys/devices/system/cpu/cpufreq/policy${key.slice(3)}/scaling_cur_freq`)
                    maxFreq = Math.max(maxFreq, Number(freq))
                }

                coresUsed.value = coresWithHighUsage
                cpufreq.value = maxFreq
            }
        })
        .catch(console.error)

updateCpu()
clock.connect('notify::second', () => clock.second % 2 == 0 && updateCpu())

const hover = Variable(false)

const Percentage = Widget.Label({
    widthRequest: 18,
    justification: 'right',
    label: percentage.bind().as(perc => `${perc}%`)
})

const CoresUsed = Widget.Revealer({
    transition: 'slide_right',
    transitionDuration: 200,
    reveal_child: coresUsed.bind().as(cores => cores > 0),
    child: Widget.Box({
        className: 'inner-append',
        children: [
            Widget.Label('\uEF4B'),
            Widget.Label({
                className: 'inner-append',
                visible: coresUsed.bind().as(cores => cores > 1),
                label: coresUsed.bind().as(String),
            })
        ]
    })
})

const units = ['KHz', 'MHz', 'GHz', 'THz', 'PHz', 'EHz', 'ZHz', 'YHz', 'RHz', 'QHz']

const Frequency = Widget.Revealer({
    transition: 'slide_right',
    transitionDuration: 200,
    reveal_child: hover.bind(),
    child: Widget.Box([
        Common.Inner('\uEA83'),
        Widget.Label({ label: cpufreq.bind().as(freq => withUnits(freq, 1, 1000, units)) })
    ])
})

export const CpuComponent = Widget.Button({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    className: coresUsed.bind().as(cores => cores == Object.keys(prev).length - 1 ? 'red' : cores > 0 ? 'yellow' : 'normal'),
    child: Widget.Box([
        Common.Icon('\uEBEF'),
        Widget.Box({
            className: 'content',
            children: [Percentage, CoresUsed, Frequency]
        })
    ])
})
