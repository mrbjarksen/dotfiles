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

            //'workspaces': ['jsobject', 'r'],
            //'active-workspace-id': ['int', 'rw'],
        });
    }

    #output: N.Output;
    //#workspaces: Map<number, WorkspaceService> = new Map();
    //#active_workspace_id: number | null = null;

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

    //get workspaces() { return Array.from(this.#workspaces.values()).sort((a, b) => a.idx - b.idx); }
    //get active_workspace_id() { return this.#active_workspace_id; }

    //set active_workspace_id(value: number | null) {
    //    const prev = this.#active_workspace_id;
    //    if (value !== prev) {
    //        if (prev !== null) {
    //            const prevWorkspace = this.#workspaces.get(prev);
    //            if (prevWorkspace !== undefined) prevWorkspace.is_active = false;
    //        }
    //        if (value !== null) {
    //            const newWorkspace = this.#workspaces.get(value);
    //            if (newWorkspace !== undefined) newWorkspace.is_active = true;
    //        }
    //
    //        this.#active_workspace_id = value;
    //        this.changed('active-window-id');
    //    }
    //}

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
            'active-window-id': ['int', 'rw'],

            //'windows': ['jsobject', 'r'],
        });
    }

    #workspace: N.Workspace;
    //#windows: Map<number, WindowService> = new Map();

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

    //get windows() { return Array.from(this.#windows.values()).sort((a, b) => a.id - b.id); }

    set is_focused(value: boolean) {
        if (value !== this.#workspace.is_focused) {
            this.#workspace.is_focused = value;
            this.changed('is-focused');
        }
    }

    set is_active(value: boolean) {
        if (value !== this.#workspace.is_active) {
            this.#workspace.is_active = value;
            this.changed('is-active');
        }
    }

    set active_window_id(value: number | null) {
        const prev = this.#workspace.active_window_id;
        if (value !== prev) {
            //if (prev !== null) {
            //    const prevWindow = this.#windows.get(prev);
            //    if (prevWindow !== undefined) prevWindow.is_active = false;
            //}
            //if (value !== null) {
            //    const newWindow = this.#windows.get(value);
            //    if (newWindow !== undefined) newWindow.is_active = true;
            //}

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
            'app-id': ['string', 'r'],
            'workspace-id': ['int', 'r'],
            'is-focused': ['boolean', 'rw'],

            'is-active': ['boolean', 'rw'],
        });
    }

    #window: N.Window;
    #is_active: boolean = false;

    constructor(window: N.Window) {
        super();
        this.#window = window;
    }

    get id() { return this.#window.id; }
    get title() { return this.#window.title; }
    get app_id() { return this.#window.app_id; }
    get workspace_id() { return this.#window.workspace_id; }
    get is_focused() { return this.#window.is_focused; }

    get is_active() { return this.#is_active; }

    set is_focused(value: boolean) {
        if (value !== this.#window.is_focused) {
            this.#window.is_focused = value;
            this.changed('is-focused');
        }
    }

    set is_active(value: boolean) {
        if (value !== this.#is_active) {
            this.#is_active = value;
            this.changed('is-active');
        }
    }

    update(win: N.Window) {
        let shouldChange = false;
        for (const prop in win) {
            if (win[prop] === this.#window[prop] ||
                JSON.stringify(win[prop]) === JSON.stringify(this.#window[prop]))
                continue
            this.#window[prop] = win[prop];
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
            'workspaces-changed': ['jsobject'],
            'workspace-activated': ['int', 'boolean'],
            'workspace-active-window-changed': ['int', 'int'],
            'windows-changed': ['jsobject'],
            'window-opened-or-changed': ['jsobject'],
            'window-focus-changed': ['int'],
            'keyboard-layouts-changed': ['jsobject'],
            'keyboard-layout-switched': ['int'],

            'workspace-added': ['jsobject'],
            'workspace-removed': ['int'],
            'window-opened': ['jsobject'],
            'window-closed': ['int'],
        }, {
            'outputs': ['jsobject', 'r'],
            'workspaces': ['jsobject', 'r'],
            'windows': ['jsobject', 'r'],
            'keyboard-layouts': ['jsobject', 'r'],
        });
    }

    #outputs: Map<string, OutputService> = new Map();
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

    get outputs() { return Array.from(this.#outputs.values()); }
    get workspaces() { return Array.from(this.#workspaces.values()); }
    get windows() { return Array.from(this.#windows.values()); }
    get keyboardLayouts() { return this.#keyboardLayouts; }

    readonly getOutput = (name: string) => this.#outputs.get(name);
    readonly getWorkspace = (id: number) => this.#workspaces.get(id);
    readonly getWindow = (id: number) => this.#windows.get(id);

    updateActiveWindow(workspaceId: number, windowId: number | null) {
        const workspace = this.#workspaces.get(workspaceId);
        if (workspace === undefined) return;
        if (workspace.active_window_id !== windowId) {
            if (workspace.active_window_id !== null) {
                const oldActiveWindow = this.#workspaces.get(workspace.active_window_id);
                if (oldActiveWindow !== undefined)
                    oldActiveWindow.is_active = false;
            }
            if (windowId !== null) {
                const newActiveWindow = this.#workspaces.get(windowId);
                if (newActiveWindow !== undefined)
                    newActiveWindow.is_active = true;
            }
            workspace.active_window_id = windowId;
        }
    }

    constructor() {
        if (!NIRI_SOCKET) {
            console.error('Niri is not running');
            return;
        }

        super();
        
        this.#initialize();
    }

    async #initialize() {
        const outputs = await this.request('Outputs') as { Outputs: { [name: string]: N.Output } };

        for (const name in outputs.Outputs)
            this.#outputs.set(name, new OutputService(outputs.Outputs[name]));

        await this.request('EventStream');

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

        const errorMessage = `error handling event '${eventType}'`

        try {
            switch (eventType) {
                case 'WorkspacesChanged':
                    for (const [id, _] of this.#workspaces) {
                        if (!args.workspaces.has(id)) {
                            this.#workspaces.delete(id);
                            this.emit('workspace-removed', id);
                        }
                    }
                    for (const workspace of args.workspaces) {
                        const oldWorkspace = this.#workspaces.get(workspace.id);
                        if (oldWorkspace === undefined) {
                            const workspaceService = new WorkspaceService(workspace);
                            this.#workspaces.set(workspace.id, workspaceService);
                            if (workspace.active_window_id !== null) {
                                const activeWindow = this.#windows.get(workspace.active_window_id);
                                if (activeWindow !== undefined)
                                    activeWindow.is_active = true;
                            }
                            this.emit('workspace-added', workspaceService);
                        }
                        else {
                            if (oldWorkspace.active_window_id !== workspace.active_window_id) {
                                if (oldWorkspace.active_window_id !== null) {
                                    const oldActiveWindow = this.#workspaces.get(oldWorkspace.active_window_id);
                                    if (oldActiveWindow !== undefined)
                                        oldActiveWindow.is_active = false;
                                }
                                if (workspace.active_window_id !== null) {
                                    const newActiveWindow = this.#workspaces.get(workspace.active_window_id);
                                    if (newActiveWindow !== undefined)
                                        newActiveWindow.is_active = true;
                                }
                                oldWorkspace.active_window_id = workspace.active_window_id;
                            }
                            oldWorkspace.update(workspace);
                        }
                    }
                    this.changed('workspaces');
                    this.emit('workspaces-changed', args.workspaces);
                    break;

                case 'WorkspaceActivated':
                    const output = this.#workspaces.get(args.id)?.output;
                    if (output === undefined)
                        throw `${errorMessage}: did not find workspace with id ${args.id}`;
                    for (const [id, workspace] of this.#workspaces) {
                        const activated = id === args.id;
                        if (workspace.output === output)
                            workspace.is_active = activated;
                        if (args.focused)
                            workspace.is_focused = activated;
                    }
                    this.emit('workspace-activated', args.id, args.focused);
                    break;

                case 'WorkspaceActiveWindowChanged':
                    const workspace = this.#workspaces.get(args.workspace_id);
                    if (workspace === undefined)
                        throw `${errorMessage}: did not find workspace with id ${args.id}`;
                    workspace.active_window_id = args.active_window_id;
                    this.emit('workspace-active-window-changed', args.workspace_id, args.active_window_id);
                    break;

                case 'WindowsChanged':
                    for (const [id, _] of this.#windows) {
                        if (!args.windows.has(id)) {
                            this.#windows.delete(id);
                            this.emit('window-closed', id);
                        }
                    }
                    for (const win of args.windows) {
                        const oldWindow = this.#windows.get(win.id);
                        if (oldWindow === undefined) {
                            const windowService = new WindowService(win);
                            this.#windows.set(win.id, windowService);
                            this.emit('window-opened', windowService);
                        }
                        else oldWindow.update(win);
                    }
                    this.changed('windows');
                    this.emit('windows-changed', args.windows);
                    break;

                case 'WindowOpenedOrChanged':
                    const win = this.#windows.get(args.window.id);
                    if (win === undefined) {
                        const windowService = new WindowService(args.window);
                        this.#windows.set(args.window.id, windowService);
                        this.emit('window-opened', windowService);
                    }
                    else win.update(args.window);
                    if (args.window.is_focused)
                        for (const [id, w] of this.#windows)
                            if (id !== args.window.id)
                                w.is_focused = false;
                    this.changed('windows');
                    this.emit('window-opened-or-changed', args.window);
                    break;

                case 'WindowClosed':
                    const found = this.#windows.delete(args.id);
                    if (!found)
                        throw `${errorMessage}: did not find window with id ${args.id}`
                    this.emit('window-closed', args.id);
                    this.changed('windows');
                    break;

                case 'WindowFocusChanged':
                    for (const [id, win] of this.#windows)
                        win.is_focused = id === args.id;
                    this.emit('window-focus-changed', args.id);
                    break;

                case 'KeyboardLayoutsChanged':
                    this.#keyboardLayouts.update(args.keyboard_layouts)
                    this.changed('keyboard-layouts');
                    this.emit('keyboard-layouts-changed', args.keyboard_layouts);
                    break;

                case 'KeyboardLayoutSwitched':
                    if (this.#keyboardLayouts.names.length === 0)
                        throw `${errorMessage}: keyboard layouts have not been set`
                    this.#keyboardLayouts.current_idx = args.idx;
                    this.emit('keyboard-layouts-switched', args.idx);
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
