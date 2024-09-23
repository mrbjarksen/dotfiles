import GLib from 'gi://GLib'
import Gio from 'gi://Gio'

// Compilation detection

/** @param {String} path */
const time_modified = path => {
    const file = Gio.File.new_for_path(path)
    if (!file?.query_exists(null)) return undefined
    else return file.query_info(
        'time::modified',
        Gio.FileQueryInfoFlags.NONE,
        null
    )?.get_modification_date_time()?.to_unix()
}

/** @param {String} input @param {String} output */
const should_compile = (input, output) => {
    const last_compile = time_modified(output)
    const last_edit = time_modified(input)

    if (!last_edit)
        return false
    if (!last_compile || last_compile < last_edit)
        return true

    return false
}

// Compile TypeScript

const ts_dirs = [`${App.configDir}/structure`, `${App.configDir}/structure/components`, `${App.configDir}/services`]
const ts = `${ts_dirs[0]}/app.ts`
const js = `${GLib.getenv('XDG_DATA_HOME')}/ags/config.js`

let compile_lock = false;
const compile_ts = async (apply = false) => {
    if (compile_lock) return
    compile_lock = true

    let was_compiled = false

    if (ts_dirs.some(dir => should_compile(dir, js))) {
        console.log(`Compiling TypeScript`)
        await Utils.execAsync([
            'bun', 'build', ts,
            '--outfile', js,
            '--external', 'resource://*',
            '--external', 'gi://*',
            '--silent',
        ])
            .then(_ => { was_compiled = true })
            .catch(err => console.error(err))
    }

    if (was_compiled || apply) {
        console.log(`Importing JavaScript`)
        const app = await import(`file://${js}`)
        app.detach()
        app.attach()
    }

    compile_lock = false
}

await compile_ts(true)

// Modules are cached, so this doesn't work
// for the purposes of hot reloading... :(
// I'm still keeping the logic above, just in case,
// even if it is unnecessary.

// Utils.monitorFile(ts_dir, () => compile_ts())

// Compile SCSS

const scss_dirs = [`${App.configDir}/style`, `${App.configDir}/style/themes`]
const scss = `${scss_dirs[0]}/style.scss`
const css = `${GLib.getenv('XDG_DATA_HOME')}/ags/style.css`

const compile_scss = (apply = false) => {
    let was_compiled = false

    if (scss_dirs.some(dir => should_compile(dir, css))) {
        try {
            console.log(`Compiling SCSS`)
            const msg = Utils.exec(`sass --no-source-map ${scss} ${css}`)
            if (msg) throw msg
            was_compiled = true
        }
        catch (error) {
            console.error(error)
        }
    }

    if (was_compiled || apply) {
        console.log("Applying CSS")
        App.resetCss()
        App.applyCss(css)
    }
}

compile_scss(true)
for (const dir of scss_dirs)
    Utils.monitorFile(dir, () => compile_scss())
