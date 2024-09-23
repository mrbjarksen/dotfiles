import GLib from 'gi://GLib'
import Common from 'structure/common'
import { clock } from 'services/clock'

type WeatherInfo = {
    time: number,
    interval: number,
    temperature_2m: number,
    wind_speed_10m: number,
    wind_direction_10m: number,
    is_day: number,
    weathercode: number,
}

const weatherCache = `${GLib.getenv('XDG_DATA_HOME')}/ags/weather.json`
const url = [
    `https://api.open-meteo.com/v1/forecast`,
    [
        'latitude=64.1123',
        'longitude=-21.913',
        'timeformat=unixtime',
        'wind_speed_unit=ms',
        'current=temperature_2m,wind_speed_10m,wind_direction_10m,is_day,weathercode'
    ].join('&')
].join('?')

const weather = Variable<WeatherInfo | null>(null)

const updateWeather = async () => {
    let last = weather.getValue()
    let now = clock.timestamp

    if (last == null)
        last = await Utils.readFileAsync(weatherCache).then(JSON.parse).catch(() => null)

    if (last?.time != null && last?.interval != null && now <= last.time + 10_800)
        weather.setValue(last)
    else
        weather.setValue(null)

    if (last?.time == null || last?.interval == null || now >= last.time + last.interval)
        Utils.fetch(url)
            .then(response => response.ok ? response.json() : Promise.reject(response))
            .then(json => {
                if (!json?.current) return
                weather.setValue(json.current)
                Utils.writeFile(JSON.stringify(json.current), weatherCache)
            })
            .catch(() => {})
}

updateWeather()

clock.connect('notify::minute', updateWeather)

// <WMO weather code>: [<Night icon>, <Day icon>, <Description>]
const weatherCodes = {
     0: ['\uEF72', '\uF1BC', 'Clear sky'],
     1: ['\uEF72', '\uF1BC', 'Mainly clear'],
     2: ['\uEF70', '\uF1BA', 'Partly cloudy'],
     3: ['\uEBA4', '\uEBA4', 'Overcast'],
    45: ['\uEF73', '\uF1BD', 'Foggy'],
    48: ['\uEF73', '\uF1BD', 'Depositing rime fog'],
    51: ['\uEC67', '\uEC67', 'Light drizzle'],
    53: ['\uF121', '\uF121', 'Moderate drizzle'],
    55: ['\uEE14', '\uEE14', 'Dense drizzle'],
    56: ['\uEC67', '\uEC67', 'Slight freezing drizzle'],
    57: ['\uEE14', '\uEE14', 'Dense freezing drizzle'],
    61: ['\uEC69', '\uEC69', 'Slight rain'],
    63: ['\uEC69', '\uEC69', 'Moderate rain'],
    65: ['\uEC69', '\uEC69', 'Heavy rain'],
    66: ['\uEC69', '\uEC69', 'Light freezing rain'],
    67: ['\uEC69', '\uEC69', 'Heavy freezing rain'],
    71: ['\uF512', '\uF512', 'Slight snow fall'],
    73: ['\uF512', '\uF512', 'Moderate snow fall'],
    75: ['\uF512', '\uF512', 'Heavy snow fall'],
    77: ['\uF512', '\uF512', 'Snow grains'],
    80: ['\uF121', '\uF121', 'Slight rain showers'],
    81: ['\uEE14', '\uEE14', 'Moderate rain showers'],
    82: ['\uEC69', '\uEC69', 'Violent rain showers'],
    85: ['\uF512', '\uF512', 'Slight snow showers'],
    86: ['\uF512', '\uF512', 'Heavy snow showers'],
    95: ['\uED3C', '\uED3C', 'Thunderstorm'],
    96: ['\uED3C', '\uED3C', 'Thunderstorm with slight hail'],
    99: ['\uED3C', '\uED3C', 'Thunderstorm with heavy hail'],
}

const hover = Variable(false)

const WeatherIcon = Common.Icon({
    tooltipText: weather.bind().as(weather =>
        weather?.weathercode == null || weatherCodes[weather.weathercode] == null ? null
            : weatherCodes[weather.weathercode][2]
    ),
    label: weather.bind().as(weather => {
        if (weather?.weathercode == null) return '\uEBA5' // cloudy-line
        if (weatherCodes[weather.weathercode] == null)
            return weather.is_day ? '\uF1BF' : '\uEF75' // sun-line, moon-line
        return weatherCodes[weather.weathercode][weather.is_day]
    })
})

const Weather = Widget.Revealer({
    transition: 'slide_right',
    transitionDuration: 200,
    revealChild: weather.bind().as(weather => weather?.temperature_2m != null),
    child: Widget.Box([
        WeatherIcon,
        Widget.Label({
            className: 'content',
            label: weather.bind().as(weather =>
                `${weather?.temperature_2m.toFixed(1)}°C`
            )
        })
    ])
})

const WindIcon = Widget.Overlay({
    tooltipText: weather.bind().as(weather => {
        const speed = weather?.wind_speed_10m
        if (speed == null) return ''
        if (speed <=  0.2) return 'Calm'
        if (speed <=  1.5) return 'Light air'
        if (speed <=  3.3) return 'Light breeze'
        if (speed <=  5.4) return 'Gentle breeze'
        if (speed <=  7.9) return 'Moderate breeze'
        if (speed <= 10.7) return 'Fresh breeze'
        if (speed <= 13.8) return 'Strong breeze'
        if (speed <= 17.1) return 'Moderate gale'
        if (speed <= 20.7) return 'Gale'
        if (speed <= 24.4) return 'Strong gale'
        if (speed <= 28.4) return 'Storm'
        if (speed <= 32.6) return 'Violent storm'
        else return 'Hurricane'

    }),
    child: Widget.Box({
        heightRequest: 20,
        widthRequest: 10,
    }),
    overlay: Widget.Label({
        className: 'arrow',
        angle: weather.bind().as(weather =>
            weather?.wind_speed_10m == null || weather.wind_speed_10m > 10.7 ? 0
                : (360 - weather.wind_direction_10m) % 360
        ),
        hpack: 'center',
        vpack: 'center',
        label: weather.bind().as(weather => {
            const speed = weather?.wind_speed_10m
            if (speed == null) return '·'
            if (speed <= 10.7) return '\uEA4B' // arrow-down-fill
            if (speed <= 17.1) return '\uF2C9' // windy-fill
            else return '\uF21C' // tornado-fill
        })
    })
})

const Wind = Widget.Revealer({
    transition: 'slide_left',
    transitionDuration: 200,
    revealChild: Utils.merge([hover.bind(), weather.bind()], (hover, weather) => {
        const speed = weather?.wind_speed_10m
        if (speed == null) return false
        if (speed <= 10.7) return hover
        return true
    }),
    child: Widget.Box([
        WindIcon,
        Widget.Label({
            className: 'content',
            label: weather.bind().as(weather =>
                `${weather?.wind_speed_10m.toFixed(1)} m/s`
            )
        })
    ])
})

export const WeatherComponent = Widget.EventBox({
    setup: self => self
        .on('enter-notify-event', () => hover.setValue(true))
        .on('leave-notify-event', () => hover.setValue(false)),
    classNames: Utils.merge([weather.bind(), clock.bind('timestamp')], ((weather, timestamp) => {
        const speed = weather?.wind_speed_10m
        const type = speed == null || speed <= 10.7 ? 'static' : speed <= 17.1 ? 'yellow' : 'red'

        if (weather?.time == null || weather?.interval == null)
            return [type, 'disabled']

        const age = timestamp - weather.time
        if (age >= weather.interval) return [type, 'inactive']

        return [type]

    })),
    child: Widget.Box([Weather, Wind])
})
