import Gdk from 'gi://Gdk?version=3.0';
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';
import * as N from 'model/niri';

Gio._promisify(Gio.DataInputStream.prototype, 'read_upto_async');

const NIRI_SOCKET = GLib.getenv('NIRI_SOCKET');

export class Niri extends Service {
    static {
        Service.register(this, {
        }, {
            'focused-output': ['string'],
            'focused-workspace': ['int'],
            'focused-window': ['int'],
            'outputs': ['jsobject'],
            'workspaces': ['jsobject'],
        });
    }

    private _focused_output: string = '';
    private _focused_workspace: number = -1;
    private _focused_window: number = -1;

    private _outputs: Map<string, N.Output> = new Map();
    private _workspaces: Map<number, N.Workspace> = new Map();
    private _windows: Map<number, N.Window> = new Map();

    private _decoder = new TextDecoder();
    private _encoder = new TextEncoder();

    get focused_output() { return this._focused_output; }
    get focused_workspace() { return this._focused_workspace; }
    get focused_window() { return this._focused_window; }

    get outputs() { return Array.from(this._outputs.values()); }
    get workspaces() { return Array.from(this._workspaces.values()); }
    get windows() { return Array.from(this._windows.values()); }

    readonly getOutput = (name: string) => this._outputs.get(name);
    readonly getWorkspace = (id: number) => this._workspaces.get(id);
    readonly getWindow = (id: number) => this._windows.get(id);

    readonly getGdkMonitor = (name: string) => {
        const output = this._outputs.get(name);
        if (!output?.logical) return null;
        return Gdk.Display.get_default()
            ?.get_monitor_at_point(output?.logical.x, output?.logical.y) || null;
    };

    constructor() {
        if (!NIRI_SOCKET) console.error('Niri is not running');

        super();

        for (const [name, output] of this.message('Outputs') as Map<string, N.Output>)
            this._outputs.set(name, output);

        for (const workspace of this.message('Workspaces') as N.Workspace[]) {
            this._workspaces.set(workspace.id, workspace);
            if (workspace.is_focused) {
                this._focused_workspace = workspace.id;
                if (workspace.output) this._focused_output = workspace.output;
            }
        }

        for (const window of this.message('Windows') as N.Window[]) {
            this._windows.set(window.id, window);
            if (window.is_focused) this._focused_window = window.id;
        }

        this._watchSocket(new Gio.DataInputStream({
            close_base_stream: true,
            base_stream: this._connection().get_input_stream(),
        }));
    }

    private _connection() {
        const socketAddress = new Gio.UnixSocketAddress({ path: NIRI_SOCKET });
        return new Gio.SocketClient().connect(socketAddress, null);
    }

    private _watchSocket(stream: Gio.DataInputStream) {
        stream.read_line_async(0, null, (stream, result) => {
            if (!stream) return console.error('Error reading niri socket');
            const [line] = stream.read_line_finish(result);
            this._onEvent(this._decoder.decode(line));
            this._watchSocket(stream);
        });
    }

    private _socketStream(cmd: string) {
        const connection = this._connection();

        connection
            .get_output_stream()
            .write(this._encoder.encode(cmd), null);

        const stream = new Gio.DataInputStream({
            close_base_stream: true,
            base_stream: connection.get_input_stream(),
        });

        return [connection, stream] as const;
    }

    readonly request = (request: N.Request): N.Reply => {
        const [connection, stream] = this._socketStream(cmd);
        try {
            const [response] = stream.read_upto('\x04', -1, null);
            return JSON.parse(response).Ok[request];
        } catch (error) {
            logError(error);
        } finally {
            connection.close(null);
        }
    };

    readonly requestAsync = async (cmd: N.Request): N.Reply => {
        const [connection, stream] = this._socketStream(cmd);
        try {
            const result = await stream.read_upto_async('\x04', -1, 0, null);
            const [response] = result as unknown as [string, number];
            return response;
        } catch (error) {
            logError(error);
        } finally {
            connection.close(null);
        }
        return '';
    };

    //private async _syncMonitors(notify = true) {
    //    try {
    //        this._outputs = await this.messageAsync('Outputs').then(JSON.parse);
    //        //for (const [name, output] of JSON.parse(msg) as Map<string, Output>)
    //        //    this._outputs.set(name, output);
    //        //}
    //
    //        const focused: Output = await this.messageAsync('FocusedOutput').then(JSON.parse)
    //        this._active.output.update(name, m.name);
    //        this._active.workspace.update(m.activeWorkspace.id, m.activeWorkspace.name);
    //        this._active.monitor.emit('changed');
    //        this._active.workspace.emit('changed');
    //        if (notify) this.notify('outputs');
    //    } catch (error) {
    //        logError(error);
    //    }
    //}
    //
    //private async _syncWorkspaces(notify = true) {
    //    try {
    //        const msg = await this.messageAsync('j/workspaces');
    //        this._workspaces.clear();
    //        for (const ws of JSON.parse(msg) as Array<Workspace>)
    //            this._workspaces.set(ws.id, ws);
    //
    //        if (notify)
    //            this.notify('workspaces');
    //    } catch (error) {
    //        logError(error);
    //    }
    //}
    //
    //private async _syncClients(notify = true) {
    //    try {
    //        const msg = await this.messageAsync('j/clients');
    //        this._clients.clear();
    //        for (const c of JSON.parse(msg) as Array<Client>)
    //            this._clients.set(c.address, c);
    //
    //        if (notify)
    //            this.notify('clients');
    //    } catch (error) {
    //        logError(error);
    //    }
    //}

    private async _onEvent(event: N.Event) {
        if (!event) return;

        //try {
        //}
        //catch (error) {
        //    if (error instanceof Error)
        //        console.error(error.message);
        //}

        //this.emit('event', e, params);
        this.emit('changed');
    }
}

export const niri = new Niri;
export default niri;
