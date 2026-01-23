# Assignment 8 - Revisiting topics. Simple Live Server

Your task is to build a simple Live Server which will allow you to instantly see your changes which have been made in your active `.html` file without manual reload.

Consider this as a point of reference: https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer

Core Functionality is the following:

1. You have a target directory which your Live Server will listen to. Every change that was made in this directory will trigger event in your Live Server.
2. You start working with some `.html` file from the target directory.
3. You reach your `.html` file through (for example) `http://localhost:3000/index.html`.
4. Your browser displays your `.html` file but your Live Server has also attached a JavaScript code which will establish a WebSocket connection to your Live Server to listen for messages.
5. You've made some changes in your local `.html` file.
6. Your server notices that something has changed in your target directory and it triggers the _change_ event.
7. After _change_ event is triggered - your WebSocket server sends a message.
8. The script which was attached to your `.html` by Live Server, receives a message which notifies the the current page should be reloaded.
9. The same script attached to your `.html` file by Live Server triggers the page to reload.
10. Return to step 3.

## Tasks

### Implement HTTP server

Implement a simple HTTP server which will send you the requested file from your filesystem (similar to what you've done in Assignment 3).

You can use whatever you like here - either classic `http` package, Express Framework or anything else.

> **NOTE:** Using `http`/`https` module will grant you higher mark as it is considered the more complex approach.

Main purpose of your server is that you can reach any file from the directory you've selected to store your `.html`, `.css`, `.js` files and listen to their changes.

Your routing strategy can be file-based. Means that the path you've specified in your HTTP request will be the exact path to your file.

Example:

```sh
http://localhost:3000/some-dir/some-file.html
```

will return you the file from

```txt
.
├── package-lock.json
├── package.json
├── src
└── target <--- Consider this as a root directory for the files you're going to reach.
    ├── file.html
    └── some-dir
        └── some-file.html <--- This file will be returned
```

#### Send your file using Streams

Send your files directly to the client without fully loading it to your RAM.

Use [`fs.createReadStream`](https://nodejs.org/api/fs.html#filehandlecreatereadstreamoptions) to achieve that. This method will allow your to operate with _readable_ stream. This stream will provide you a method which is called `pipe` so that you can direct your data stream back to the client.

Another useful links to consider:

- [Stream](https://nodejs.org/api/stream.html#stream)
- [readable.pipe()](https://nodejs.org/api/stream.html#readablepipedestination-options)
- [http.ServerResponse](https://nodejs.org/api/http.html#class-httpserverresponse)

### Implement directory observer

Listen for changes in your directory using [`fs.watch`](https://nodejs.org/api/fs.html#fspromiseswatchfilename-options) method.

This method will allow you to set a "listener" on a file or directory. Every time when something is added/modified/deleted/changed it will emit the event.

Your primary focus event name is `change`.

### Establish WS connection between HTML web-page and Node.js server

To create a WebSocket server on your Node.js Live Server - use npm package called [ws](https://www.npmjs.com/package/ws).

To establish a WebSocket connection to your live server from a web-page see: [JS MDN - WebSocket - Examples](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket#examples).

### Inject JavaScript code into your file by works with the data stream

It is expected that you've implemented file upload using Streams.

`pipe` method will allow you to pass additional transformers to your initial data stream.

Your task here is to append your `<script>` section, which will automatically connect to your WebSocket server after the page is loaded in the browser, at the very end of your `<body>` section.

> Hint: while reading you chunk data it is enough check wether it contains `</body>` tag. If yes - add your script directly before it.

#### Useful Links

- [stream.Transform](https://nodejs.org/api/stream.html#class-streamtransform)
- [API for stream implementers](https://nodejs.org/api/stream.html#api-for-stream-implementers)
  - Methods to implement
    - [\_transform()](https://nodejs.org/api/stream.html#transform_transformchunk-encoding-callback)
- [dev.io - Understanding Node.js Streams](https://dev.to/rajeshrenato/understanding-nodejs-streams-readable-writable-transform-with-custom-examples-544j)

## Evaluation criteria

- **Core Functionality**
  - **6 pts** - Your server successfully attaches script with WebSocket server connection. Any changes that were made inside of your target directory instantly triggers your web-page to be automatically reloaded in your browser. HTTP Server is built using core `http`/`https` module.
    - **4 pts** - Everything works as expected but the HTTP Server is implemented not by using `http` or `https` built-in module.
    - **3 pts** - Live Server works but with some issues.
    - **0 pts** - Missing or broken.
- **Streams + Script injection**
  - **2 pts** - Your Node.js relies on Streams to upload your file. Additionally it modifies your file content and adds `<script>` section to your `.html` file on the fly.
    - **1 pts** - Streams are implemented but script injection is missing and/or something works with issues.
    - **0 pts** - Missing or broken.
- **Code Stability & Structure**
  - **2 pts** - Clean, modular, stable and easy to follow.
    - **1 pt** - Acceptable but has inconsistencies.
    - **0 pts** - Disorganized and confusing.

### Penalties

- If you haven't uploaded your assignment before the deadline - your max grade would be **7 pts** + you are allowed to send your work before the next practical lesson. If the work would not be sent before the second deadline - it will be automatically evaluated to **0 pts**.

- If the submitted code is suspected of being artificially generated and/or copy-pasted, the work will be either returned with **0 pts** or the student will be asked to explain their code in detail. If student fails to explain their code, the practical task is considered as failed and will be returned with **0 pts**.
