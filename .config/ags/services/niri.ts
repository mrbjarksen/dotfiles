import GLib from 'gi://GLib';
import Gio from 'gi://Gio';
import * as N from 'model/niri';

Gio._promisify(Gio.DataInputStream.prototype, 'read_upto_async');

const NIRI_SOCKET = GLib.getenv('NIRI_SOCKET');

type KeyOfUnion<T> = T extends T ? keyof T: never;

export class OutputService extends Service {
    static {
        Service.register(this, {}, {
            'name': ['string', 'r'],
            'make': ['string', 'r'],
            'model': ['string', 'r'],
            'serial': ['string', 'r'],
            'physical-size': ['jsobject', 'r'],
            'modes': ['jsobject', 'r'],
            'current_mode': ['int', 'r'],
            'vrr-supported': ['boolean', 'r'],
            'vrr-enabled': ['boolean', 'r'],
            'logical': ['jsobject', 'r'],
        });
    }

    #output: N.Output;

    constructor(output: N.Output) {
        super();
        this.#output = output;
    }

    get name() { return this.#output.name; }
    get make() { return this.#output.make; }
    get model() { return this.#output.model; }
    get serial() { return this.#output.serial; }
    get physical_size() { return this.#output.physical_size; }
    get modes() { return this.#output.modes; }
    get current_mode() { return this.#output.current_mode; }
    get vrr_supported() { return this.#output.vrr_supported; }
    get vrr_enabled() { return this.#output.vrr_enabled; }
    get logical() { return this.#output.logical; }

    update(output: N.Output) {
        let shouldChange = false;
        for (const prop in output) {
            if (output[prop] === this.#output[prop] ||
                JSON.stringify(output[prop]) === JSON.stringify(this.#output[prop]))
                continue
            this.#output[prop] = output[prop];
            this.notify(prop.replaceAll('_', '-'));
            shouldChange = true;
        }
        if (shouldChange) this.emit('changed');
    }
}

export class WorkspaceService extends Service {
    static {
        Service.register(this, {}, {
            'id': ['int', 'r'],
            'idx': ['int', 'r'],
            'name': ['string', 'r'],
            'output': ['string', 'r'],
            'is-active': ['boolean', 'rw'],
            'is-focused': ['boolean', 'rw'],
            'active-window-id': ['int', 'r'],
        });
    }

    #workspace: N.Workspace;

    constructor(workspace: N.Workspace) {
        super();
        this.#workspace = workspace;
    }

    get id() { return this.#workspace.id; }
    get idx() { return this.#workspace.idx; }
    get name() { return this.#workspace.name; }
    get output() { return this.#workspace.output; }
    get is_active() { return this.#workspace.is_active; }
    get is_focused() { return this.#workspace.is_focused; }
    get active_window_id() { return this.#workspace.active_window_id; }

    set is_active(value: boolean) {
        if (this.#workspace.is_active !== value) {
            this.#workspace.is_active = value;
            this.changed('is-active');
        }
    }

    set is_focused(value: boolean) {
        if (this.#workspace.is_focused !== value) {
            this.#workspace.is_focused = value;
            this.changed('is-focused');
        }
    }

    set active_window_id(value: number | null) {
        if (this.#workspace.active_window_id !== value) {
            this.#workspace.active_window_id = value;
            this.changed('active-window-id');
        }
    }

    update(workspace: N.Workspace) {
        let shouldChange = false;
        for (const prop in workspace) {
            if (workspace[prop] === this.#workspace[prop] ||
                JSON.stringify(workspace[prop]) === JSON.stringify(this.#workspace[prop]))
                continue
            this.#workspace[prop] = workspace[prop];
            this.notify(prop.replaceAll('_', '-'));
            shouldChange = true;
        }
        if (shouldChange) this.emit('changed');
    }
}

export class WindowService extends Service {
    static {
        Service.register(this, {}, {
            'id': ['int', 'r'],
            'title': ['string', 'r'],
            'app_id': ['string', 'r'],
            'workspace_id': ['int', 'r'],
            'is_focused': ['boolean', 'r'],
        });
    }

    #window: N.Window;

    constructor(window: N.Window) {
        super();
        this.#window = window;
    }

    get id() { return this.#window.id; }
    get title() { return this.#window.title; }
    get app_id() { return this.#window.app_id; }
    get workspace_id() { return this.#window.workspace_id; }
    get is_focused() { return this.#window.is_focused; }

    set is_focused(value: boolean) {
        if (this.#window.is_focused !== value) {
            this.#window.is_focused = value;
            this.changed('is-focused')
        }
    }

    update(window: N.Window) {
        let shouldChange = false;
        for (const prop in window) {
            if (window[prop] === this.#window[prop] ||
                JSON.stringify(window[prop]) === JSON.stringify(this.#window[prop]))
                continue
            this.#window[prop] = window[prop];
            this.notify(prop.replaceAll('_', '-'));
            shouldChange = true;
        }
        if (shouldChange) this.emit('changed');
    }
}

export class KeyboardLayoutsService extends Service {
    static {
        Service.register(this, {}, {
            'names': ['jsobject', 'r'],
            'current-idx': ['int', 'rw'],
        });
    }

    #layouts: N.KeyboardLayouts;

    constructor(layouts: N.KeyboardLayouts) {
        super();
        this.#layouts = layouts;
    }

    get names() { return this.#layouts.names; }
    get current_idx() { return this.#layouts.current_idx; }

    set current_idx(value: number) {
        if (this.#layouts.current_idx !== value) {
            this.#layouts.current_idx = value;
            this.changed('current-idx');
        }
    }

    update(layouts: N.KeyboardLayouts) {
        let shouldChange = false;
        for (const prop in layouts) {
            if (layouts[prop] === this.#layouts[prop] ||
                JSON.stringify(layouts[prop]) === JSON.stringify(this.#layouts[prop]))
                continue
            this.#layouts[prop] = layouts[prop];
            this.notify(prop.replaceAll('_', '-'));
            shouldChange = true;
        }
        if (shouldChange) this.emit('changed');
    }
}

export class Niri extends Service {
    static {
        Service.register(this, {
            'event': ['string', 'jsobject'],
        }, {
            'workspaces': ['jsobject', 'r'],
            'windows': ['jsobject', 'r'],
            'keyboard-layouts': ['jsobject', 'r'],
        });
    }

    #workspaces: Map<number, WorkspaceService> = new Map();
    #windows: Map<number, WindowService> = new Map();

    #keyboardLayouts = new KeyboardLayoutsService({
        names: [],
        current_idx: 0,
    });

    #decoder = new TextDecoder();
    #encoder = new TextEncoder();

    #socketAddress = new Gio.UnixSocketAddress({ path: NIRI_SOCKET });
    #eventStream: Gio.DataInputStream | null = null;

    get workspaces() { return Array.from(this.#workspaces.values()).sort((a, b) => a.idx - b.idx); }
    get windows() { return Array.from(this.#windows.values()); }
    get keyboardLayouts() { return this.#keyboardLayouts; }

    readonly getWorkspace = (id: number) => this.#workspaces.get(id);
    readonly getWindow = (id: number) => this.#windows.get(id);

    constructor() {
        if (!NIRI_SOCKET) {
            console.error('Niri is not running');
            return;
        }

        super();

        this.request('EventStream')
            .then(() => {
                if (this.#eventStream === null) {
                    console.error('could not receive event stream')
                    return;
                }
                this.#watchEventStream(this.#eventStream);
            });

    }

    #connection() {
        return new Gio.SocketClient().connect(this.#socketAddress, null);
    }

    #watchEventStream(stream: Gio.DataInputStream) {
        stream.read_line_async(0, null, (stream, result) => {
            if (!stream) return console.error('Error reading niri socket');

            try {
                const [line] = stream.read_line_finish(result);
                if (line === null) throw 'could not read from stream';
                const event = JSON.parse(this.#decoder.decode(line)) as N.Event;
                this.#onEvent(event);
            }
            catch (e) {
                console.error(`error in event handler: ${e}`)
            }

            this.#watchEventStream(stream);
        });
    }

    #socketStream(message: string) {
        if (!message.endsWith('\n')) message += '\n';

        const connection = this.#connection();

        connection.get_output_stream()
            .write(this.#encoder.encode(message), null);

        const stream = new Gio.DataInputStream({
            close_base_stream: true,
            base_stream: connection.get_input_stream(),
        });

        return [connection, stream] as const;
    }

    readonly request = async (request: N.Request): Promise<N.Response | null> => {
        const message = JSON.stringify(request);
        const [connection, stream] = this.#socketStream(message);
        try {
            const result = await stream.read_upto_async('\n', -1, 0, null);
            stream.read_byte(null);

            const [response] = result as unknown as [string, number];
            if (response === null) throw 'could not read response from stream';

            const reply = JSON.parse(response) as N.Reply;
            if ('Err' in reply) throw `error handling request ${message}: ${reply.Err}`;

            if (request === 'EventStream') this.#eventStream = stream;
            return reply.Ok;
        }
        catch (error) {
            logError(error);
        }
        finally {
            if (request !== 'EventStream') connection.close(null);
        }
        return null;
    };

    async #onEvent(event: N.Event) {
        const keys = Object.keys(event || {})
        if (keys.length !== 1) return;
        
        const eventType = keys[0] as KeyOfUnion<N.Event>
        const args = event[eventType];

        try {
            switch (eventType) {
                case 'WorkspacesChanged':
                    for (const workspace of args.workspaces) {
                        const oldWorkspace = this.#workspaces.get(workspace.id);
                        if (oldWorkspace === undefined)
                            this.#workspaces.set(workspace.id, new WorkspaceService(workspace));
                        else
                            oldWorkspace.update(workspace);
                    }
                    this.changed('workspaces');
                    break;

                case 'WorkspaceActivated':
                    const output = this.#workspaces.get(args.id)?.output;
                    if (output === undefined)
                        throw `error handling event 'WorkspaceActivated': did not find workspace with id ${args.id}`;
                    for (const [id, workspace] of this.#workspaces) {
                        const activated = id === args.id;
                        if (workspace.output === output)
                            workspace.is_active = activated;
                        if (args.focused)
                            workspace.is_focused = activated;
                    }
                    break;

                case 'WorkspaceActiveWindowChanged':
                    const workspace =  this.#workspaces.get(args.workspace_id);
                    if (workspace === undefined)
                        throw `error handling event 'WorkspaceActivated': did not find workspace with id ${args.id}`;
                    workspace.active_window_id = args.active_window_id;
                    break;

                case 'WindowsChanged':
                    for (const win of args.windows) {
                        const oldWindow = this.#windows.get(win.id);
                        if (oldWindow === undefined)
                            this.#windows.set(win.id, new WindowService(win));
                        else
                            oldWindow.update(win);
                    }
                    this.changed('windows');
                    break;

                case 'WindowOpenedOrChanged':
                    const win = this.#windows.get(args.window.id);
                    if (win === undefined) {
                        this.#windows.set(args.window.id, new WindowService(args.window));
                        this.changed('windows');
                    }
                    else win.update(args.window);
                    if (args.window.is_focused)
                        for (const [id, w] of this.#windows)
                            if (id !== args.window.id)
                                w.is_focused = false;
                    break;

                case 'WindowClosed':
                    const found = this.#windows.delete(args.id);
                    if (!found)
                        throw `error handling event 'WindowClosed': did not find window with id ${args.id}`
                    break;

                case 'WindowFocusChanged':
                    for (const [id, win] of this.#windows)
                        win.is_focused = id === args.id;
                    break;

                case 'KeyboardLayoutsChanged':
                    this.#keyboardLayouts.update(args.keyboard_layouts)
                    this.changed('keyboard-layouts');
                    break;

                case 'KeyboardLayoutSwitched':
                    if (this.#keyboardLayouts.names.length === 0)
                        throw `error handling event 'KeyboardLayoutSwitched': keyboard layouts have not been set`
                    this.#keyboardLayouts.current_idx = args.idx;
                    break;
            }
            
        }
        catch (e) {
            console.error(e);
        }

        this.emit('event', eventType, args);
    }
}

export const niri = new Niri;
export default niri;
