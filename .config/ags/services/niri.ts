import GLib from 'gi://GLib';
import Gio from 'gi://Gio';
import * as N from 'model/niri';

Gio._promisify(Gio.DataInputStream.prototype, 'read_upto_async');

const NIRI_SOCKET = GLib.getenv('NIRI_SOCKET');

type KeyOfUnion<T> = T extends T ? keyof T: never;

export class Output extends Service {
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

export class Workspace extends Service {
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

export class Window extends Service {
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

export class KeyboardLayouts extends Service {
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
            //'focused-output': ['string', 'rw'],
            //'focused-workspace': ['int', 'rw'],
            //'focused-window': ['int', 'rw'],
            //'active-workspaces': ['jsobject', 'r'],
            //'outputs': ['jsobject', 'r'],
            'workspaces': ['jsobject', 'r'],
            'windows': ['jsobject', 'r'],
            'keyboard-layouts': ['jsobject', 'r'],
        });
    }

    //#focused_output: string | null = null;
    //#focused_workspace: number | null = null;
    //#focused_window: number | null = null;
    //
    //#active_workspaces: Map<string, number> = new Map();
    //#active_windows: Map<number, number> = new Map();

    //#outputs: Map<string, Output> = new Map();
    #workspaces: Map<number, Workspace> = new Map();
    #windows: Map<number, Window> = new Map();

    #keyboardLayouts: KeyboardLayouts | null = null;

    #decoder = new TextDecoder();
    #encoder = new TextEncoder();

    #socketAddress = new Gio.UnixSocketAddress({ path: NIRI_SOCKET });
    #eventStream: Gio.DataInputStream | null = null;

    //get focused_output() { return this.#focused_output; }
    //get focused_workspace() { return this.#focused_workspace; }
    //get focused_window() { return this.#focused_window; }
    //
    //get active_workspaces() { return this.#active_workspaces; }

    //get outputs() { return Array.from(this.#outputs.values()); }
    get workspaces() { return Array.from(this.#workspaces.values()); }
    get windows() { return Array.from(this.#windows.values()); }

    //readonly getOutput = (name: string) => this.#outputs.get(name);
    readonly getWorkspace = (id: number) => this.#workspaces.get(id);
    readonly getWindow = (id: number) => this.#windows.get(id);

    constructor() {
        if (!NIRI_SOCKET) {
            console.error('Niri is not running');
            return;
        }

        super();

        this.request('EventStream');

        if (this.#eventStream === null) {
            console.error('could not receive event stream')
            return;
        }

        this.#watchEventStream(this.#eventStream);
    }

    #connection() {
        return new Gio.SocketClient().connect(this.#socketAddress, null);
    }

    #watchEventStream(stream: Gio.DataInputStream) {
        stream.read_line_async(0, null, (stream, result) => {
            if (!stream) return console.error('Error reading niri socket');

            const [line] = stream.read_line_finish(result);
            if (line === null) return console.error('could not read from stream');

            const event = JSON.parse(this.#decoder.decode(line))
            this.#onEvent(event);

            this.#watchEventStream(stream);
        });
    }

    #socketStream(message: string) {
        const connection = this.#connection();

        connection.get_output_stream()
            .write(this.#encoder.encode(message), null);

        const stream = new Gio.DataInputStream({
            close_base_stream: true,
            base_stream: connection.get_input_stream(),
        });

        return [connection, stream] as const;
    }

    readonly request = (request: N.Request): N.Response | null => {
        const message = JSON.stringify(request);
        const [connection, stream] = this.#socketStream(message);
        try {
            const [response] = stream.read_line(null);
            if (response === null) throw 'could not read response from stream';

            const reply = JSON.parse(this.#decoder.decode(response)) as N.Reply;
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

    readonly requestAsync = async (request: Exclude<N.Request, 'EventStream'>): Promise<N.Response | null> => {
        const writtenRequest = JSON.stringify(request);
        const [connection, stream] = this.#socketStream(writtenRequest);
        try {
            const result = await stream.read_upto_async('\x04', -1, 0, null);
            const [response] = result as unknown as [string, number];
            if (response === null) throw 'could not read response from stream';

            const reply = JSON.parse(response) as N.Reply;
            if ('Err' in reply) throw `error handling request ${writtenRequest}: ${reply.Err}`;

            return reply.Ok;
        }
        catch (error) {
            logError(error);
        }
        finally {
            connection.close(null);
        }
        return null;
    };

    //#updateOutputs(outputs: { [name: string]: N.Output }, notify = true) {
    //    this.#outputs.clear();
    //    for (const name in outputs)
    //        this.#outputs.set(name, new Output(outputs[name]));
    //    if (notify) this.notify('outputs');
    //}
    //
    //#updateWorkspaces(workspaces: N.Workspace[], notify = true) {
    //    this.#workspaces.clear();
    //    //this.#active_workspaces.clear();
    //    //this.#active_windows.clear();
    //    for (const workspace of workspaces) {
    //        this.#workspaces.set(workspace.id, new Workspace(workspace));
    //        //if (workspace.is_active && workspace.output != null) {
    //        //    this.#active_workspaces.set(workspace.output, workspace.id);
    //        //}
    //        //if (workspace.is_focused) {
    //        //    this.#focused_workspace = workspace.id;
    //        //    if (workspace.output) this.#focused_output = workspace.output;
    //        //}
    //    }
    //    if (notify) this.notify('workspaces');
    //}
    //
    //#updateWindows(windows: N.Window[], notify = true) {
    //    this.#windows.clear();
    //    for (const window of windows) {
    //        this.#windows.set(window.id, new Window(window));
    //        //if (window.is_focused) this.#focused_window = window.id;
    //    }
    //    if (notify) this.notify('workspaces');
    //}

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
                            this.#workspaces.set(workspace.id, new Workspace(workspace));
                        else
                            oldWorkspace.update(workspace);
                    }
                    this.changed('workspace');
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
                    for (const window of args.windows) {
                        const oldWindow = this.#windows.get(window.id);
                        if (oldWindow === undefined)
                            this.#windows.set(window.id, new Window(window));
                        else
                            oldWindow.update(window);
                    }
                    this.changed('windows');
                    break;

                case 'WindowOpenedOrChanged':
                    const window = this.#windows.get(args.window.id);
                    if (window === undefined)
                        this.#windows.set(args.window.id, args.window);
                    else
                        window.update(args.window);
                    if (args.window.is_focused)
                        for (const [id, window] of this.#windows)
                            if (id !== args.window.id)
                                window.is_focused = false;
                    break;

                case 'WindowClosed':
                    const found = this.#windows.delete(args.id);
                    if (!found)
                        throw `error handling event 'WindowClosed': did not find window with id ${args.id}`
                    break;

                case 'WindowFocusChanged':
                    for (const [id, window] of this.#windows)
                        window.is_focused = id === args.id;
                    break;

                case 'KeyboardLayoutsChanged':
                    if (this.#keyboardLayouts === null)
                        this.#keyboardLayouts = new KeyboardLayouts(args.keyboard_layouts);
                    else
                        this.#keyboardLayouts.update(args.keyboard_layouts)
                    this.changed('keyboard-layouts');
                    break;

                case 'KeyboardLayoutSwitched':
                    if (this.#keyboardLayouts === null)
                        throw `error handling event 'KeyboardLayoutSwitched': keyboard layouts have not been set`
                    this.#keyboardLayouts.current_idx = args.idx;
                    break;
            }
            
        }
        catch (e) {
            console.error(e);
        }

        this.emit('event', eventType, args);
        this.emit('changed');
    }
}

export const niri = new Niri;
export default niri;
