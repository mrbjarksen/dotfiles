export type ConfiguredMode = {
    width: number,
    height: number,
    refresh: number | null,
};

export type ConfiguredPosition = {
    x: number,
    y: number,
};

export type KeyboardLayouts = {
    names: string[],
    current_idx: number,
};

export type LogicalOutput = {
    x: number,
    y: number,
    width: number,
    height: number,
    scale: number,
    transform: Transform,
};

export type Mode = {
    width: number,
    height: number,
    refresh_rate: number,
    is_preferred: boolean,
};

export type SizeChange
    = { SetFixed: number }
    | { SetProportion: number }
    | { AdjustFixed: number }
    | { AdjustProportion: number };

export type LayoutSwitchTarget = 'Next' | 'Prev';

export type ModeToSet = 'Automatic' | { Specific: ConfiguredMode };
export type PositionToSet = 'Automatic' | { Specific: ConfiguredPosition };
export type ScaleToSet = 'Automatic' | { Specific: number };

export type VrrToSet = {
    vrr: boolean,
    on_demand: boolean,
};

export type Transform
    = 'Normal'
    | '_90'
    | '_180'
    | '_270'
    | 'Flipped'
    | 'Flipped90'
    | 'Flipped180'
    | 'Flipped270';

export type OutputAction
    = 'Off'
    | 'On'
    | { Mode: { mode: ModeToSet } }
    | { Scale: { scale: ScaleToSet } }
    | { Transform: { transform: Transform } }
    | { Position: { position: PositionToSet } }
    | { Vrr: { vrr: VrrToSet } };

export type OutputConfigChanged = 'Applied' | 'OutputWasMissing';

export type Output = {
    name: string,
    make: string,
    model: string,
    serial: string | null,
    physical_size: [number, number] | null,
    modes: Mode[],
    current_mode: number | null,
    vrr_supported: boolean,
    vrr_enabled: boolean,
    logical: LogicalOutput | null,
};

export type Workspace = {
    id: number,
    idx: number,
    name: string | null,
    output: string | null,
    is_active: boolean,
    is_focused: boolean,
    active_window_id: number | null,
};

export type WorkspaceReferenceArg
    = { Id: number }
    | { Index: number }
    | { Name: string };

export type Window = {
    id: number,
    title: string | null,
    app_id: string | null,
    workspace_id: number | null,
    is_focused: boolean,
};

export type Request
    = 'Version'
    | 'Outputs'
    | 'Workspaces'
    | 'Windows'
    | 'KeyboardLayouts'
    | 'FocusedOutput'
    | 'FocusedWindow'
    | { Action: Action }
    | { Output: { output: string, action: OutputAction } }
    | 'EventStream'
    | 'ReturnError';

export type Response
    = 'Handled'
    | { Version: string }
    | { Outputs: { [name: string]: Output } }
    | { Workspaces: Workspace[] }
    | { Windows: Window[] }
    | { KeyboardLayouts: KeyboardLayouts }
    | { FocusedOutput: Output | null }
    | { FocusedWindow: Window | null }
    | { OutputConfigChanged: OutputConfigChanged };

export type Reply
    = { Ok: Response }
    | { Err: string };

export type Event
    = { WorkspacesChanged: { workspaces: Workspace[] } }
    | { WorkspaceActivated: { id: number, focused: boolean } }
    | { WorkspaceActiveWindowChanged: { workspace_id: number, active_window_id: number | null } }
    | { WindowsChanged: { windows: Window[] } }
    | { WindowOpenedOrChanged: { window: Window } }
    | { WindowClosed: { id: number } }
    | { WindowFocusChanged: { id: number | null, } }
    | { KeyboardLayoutsChanged: { keyboard_layouts: KeyboardLayouts } }
    | { KeyboardLayoutSwitched: { idx: number } };

export type Action
    = { Quit: { skip_confirmation: boolean } }
    | { PowerOffMonitors: {} }
    | { Spawn: { command: string[] } }
    | { DoScreenTransition: { delay_ms: number | null } }
    | { Screenshot: {} }
    | { ScreenshotScreen: {} }
    | { ScreenshotWindow: { id: number | null } }
    | { CloseWindow: { id: number | null } }
    | { FullscreenWindow: { id: number | null } }
    | { FocusWindow: { id: number } }
    | { FocusColumnLeft: {} }
    | { FocusColumnRight: {} }
    | { FocusColumnFirst: {} }
    | { FocusColumnLast: {} }
    | { FocusColumnRightOrFirst: {} }
    | { FocusColumnLeftOrLast: {} }
    | { FocusWindowOrMonitorUp: {} }
    | { FocusWindowOrMonitorDown: {} }
    | { FocusColumnOrMonitorLeft: {} }
    | { FocusColumnOrMonitorRight: {} }
    | { FocusWindowDown: {} }
    | { FocusWindowUp: {} }
    | { FocusWindowDownOrColumnLeft: {} }
    | { FocusWindowDownOrColumnRight: {} }
    | { FocusWindowUpOrColumnLeft: {} }
    | { FocusWindowUpOrColumnRight: {} }
    | { FocusWindowOrWorkspaceDown: {} }
    | { FocusWindowOrWorkspaceUp: {} }
    | { MoveColumnLeft: {} }
    | { MoveColumnRight: {} }
    | { MoveColumnToFirst: {} }
    | { MoveColumnToLast: {} }
    | { MoveColumnLeftOrToMonitorLeft: {} }
    | { MoveColumnRightOrToMonitorRight: {} }
    | { MoveWindowDown: {} }
    | { MoveWindowUp: {} }
    | { MoveWindowDownOrToWorkspaceDown: {} }
    | { MoveWindowUpOrToWorkspaceUp: {} }
    | { ConsumeOrExpelWindowLeft: {} }
    | { ConsumeOrExpelWindowRight: {} }
    | { ConsumeWindowIntoColumn: {} }
    | { ExpelWindowFromColumn: {} }
    | { CenterColumn: {} }
    | { FocusWorkspaceDown: {} }
    | { FocusWorkspaceUp: {} }
    | { FocusWorkspace: { reference: WorkspaceReferenceArg } }
    | { FocusWorkspacePrevious: {} }
    | { MoveWindowToWorkspaceDown: {} }
    | { MoveWindowToWorkspaceUp: {} }
    | { MoveWindowToWorkspace: { window_id: number | null, reference: WorkspaceReferenceArg } }
    | { MoveColumnToWorkspaceDown: {} }
    | { MoveColumnToWorkspaceUp: {} }
    | { MoveColumnToWorkspace: { reference: WorkspaceReferenceArg } }
    | { MoveWorkspaceDown: {} }
    | { MoveWorkspaceUp: {} }
    | { FocusMonitorLeft: {} }
    | { FocusMonitorRight: {} }
    | { FocusMonitorDown: {} }
    | { FocusMonitorUp: {} }
    | { MoveWindowToMonitorLeft: {} }
    | { MoveWindowToMonitorRight: {} }
    | { MoveWindowToMonitorDown: {} }
    | { MoveWindowToMonitorUp: {} }
    | { MoveColumnToMonitorLeft: {} }
    | { MoveColumnToMonitorRight: {} }
    | { MoveColumnToMonitorDown: {} }
    | { MoveColumnToMonitorUp: {} }
    | { SetWindowHeight: { id: number | null, change: SizeChange } }
    | { ResetWindowHeight: { id: number | null } }
    | { SwitchPresetColumnWidth: {} }
    | { SwitchPresetWindowHeight: { id: number | null } }
    | { MaximizeColumn: {} }
    | { SetColumnWidth: { change: SizeChange } }
    | { SwitchLayout: { layout: LayoutSwitchTarget } }
    | { ShowHotkeyOverlay: {} }
    | { MoveWorkspaceToMonitorLeft: {} }
    | { MoveWorkspaceToMonitorRight: {} }
    | { MoveWorkspaceToMonitorDown: {} }
    | { MoveWorkspaceToMonitorUp: {} }
    | { ToggleDebugTint: {} }
    | { DebugToggleOpaqueRegions: {} }
    | { DebugToggleDamage: {} };
