export class Clock extends Service {
    static {
        Service.register(this, {}, {
            timestamp: ['int', 'r'],
            second:    ['int', 'r'],
            minute:    ['int', 'r'],
            hour:      ['int', 'r'],
            day:       ['int', 'r'],
            weekday:   ['int', 'r'],
            month:     ['int', 'r'],
            year:      ['int', 'r'],
        });
    }

    #fields = {
        timestamp: 0,
        second:    0,
        minute:    0,
        hour:      0,
        day:       1,
        weekday:   4,
        month:     0,
        year:   1970,
    }

    get timestamp() { return this.#fields.timestamp }
    get second()    { return this.#fields.second    }
    get minute()    { return this.#fields.minute    }
    get hour()      { return this.#fields.hour      }
    get day()       { return this.#fields.day       }
    get weekday()   { return this.#fields.weekday   }
    get month()     { return this.#fields.month     }
    get year()      { return this.#fields.year      }

    #check(prop: string, val: number): boolean {
        if (this.#fields[prop] === val)
            return false
        this.#fields[prop] = val
        this.notify(prop)
        return true
    }

    #update() {
        const date = new Date()

        if (this.#check('timestamp', Math.floor(date.getTime() / 1000)))
            this.emit('changed')

        this.#check('second',  date.getSeconds())
        this.#check('minute',  date.getMinutes())
        this.#check('hour',    date.getHours())
        this.#check('day',     date.getDate())
        this.#check('weekday', date.getDay())
        this.#check('month',   date.getMonth())
        this.#check('year',    date.getFullYear())

        return 1000 - date.getMilliseconds()
    }

    constructor() {
        super()
        const schedule = () =>
            Utils.timeout(this.#update(), schedule)
        schedule()
    }
}

export const clock = new Clock()

export default clock
