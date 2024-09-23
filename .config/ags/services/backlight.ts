export class Backlight extends Service {
    static {
        Service.register(this, {}, { 'brightness': ['float', 'rw'] })
    }

    #interface = Utils.exec("sh -c 'ls -w1 /sys/class/backlight | head -1'")

    #brightness = 0
    #max = Number(Utils.exec('brightnessctl max'))

    get brightness() {
        return this.#brightness
    }

    set brightness(percent) {
        if (percent < 0) percent = 0
        if (percent > 1) percent = 1
        Utils.execAsync(`brightnessctl set ${percent * 100}% -q`)
    }

    constructor() {
        super()

        const brightness = `/sys/class/backlight/${this.#interface}/brightness`
        Utils.monitorFile(brightness, () => this.#onChange())

        this.#onChange();
    }

    #onChange() {
        this.#brightness = Number(Utils.exec('brightnessctl get')) / this.#max
        this.changed('brightness')
    }
}

export const backlight = new Backlight()

export default Backlight
