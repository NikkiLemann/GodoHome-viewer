# GodoHome viewer

A web viewer for [GodoHome](https://github.com/NikkiLemann/GodoHome) projects on phones, built as a Godot 4 web export and published with GitHub Pages.

> **Experimental.** This repository currently contains only the T04 experiment: a quick test of whether a Godot web export is good enough for the GodoHome v0.2 mobile viewer. The code is throwaway and is not the real viewer.

## What the experiment checks

- **Android (Chrome):** augmented reality through WebXR. A 1 m box is placed in the room and should stay in place while you walk around it.
- **iPhone (Safari):** a virtual view without AR. The phone's orientation turns the camera.
- Hit-testing (pointing at a real surface) and loading a glTF file at runtime.

The task description is [T04 in the GodoHome repository](https://github.com/NikkiLemann/GodoHome/blob/main/tasks/T04-experiment-mobile-web.md). The findings will be in the report `docs/experiments/mobile-web.md` in the GodoHome repository, linked here when it exists.

## Try it

Open the published page on your phone: <https://nikkilemann.github.io/GodoHome-viewer/> (available once the first build has been published).

AR needs an ARCore-capable Android phone with Chrome. WebXR only works on pages served over HTTPS (or `localhost`).

## Building

- Godot 4.7.2 with the web export templates installed.
- The web export is built without thread support, because GitHub Pages cannot send the HTTP headers that threads in the browser need.
- Export with the **Web** preset (*Project → Export*). It writes to `build/`, which git ignores.
- Open the export through a web server, not by opening `index.html` as a file: the browser refuses to load the other files from `file://` ("Failed to fetch"). Godot's *Run in Browser* button starts a local server on port 8060.
- To test on an Android phone over USB, forward the port with `adb reverse tcp:8060 tcp:8060` (USB debugging must be on), then open `http://localhost:8060` in Chrome on the phone. `localhost` counts as a secure context, so WebXR works there.
- Planned: every push to `main` builds the export with GitHub Actions and publishes it to GitHub Pages.

## License

MIT, see [LICENSE](LICENSE).
