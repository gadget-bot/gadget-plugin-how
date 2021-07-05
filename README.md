# Gadget Plugin for How Questions

This is a [Gadget](https://github.com/gadget-bot/gadget) plugin to allow asking "How do I...?" type questions.

Note that Gadget -- and therefore any plugin for Gadget -- is still very much a **work in progress**, so please don't use it in production yet (or if you do, don't complain).

## How do I use this plugin?

In your `main.go` for using Gadget, your `main()` function should instruct you bot, which is created using `gadget.Setup()` needs to be instructed to `Router.AddMentionRoutes(how.GetMentionRoutes())`. This _usually_ looks like this:

```golang
package main

import (
	gadget "github.com/gadget-bot/gadget/core"
	how "github.com/gadget-bot/gadget-plugin-how"
)

func main() {
	// This is the Gadget bot
	myBot := gadget.Setup()

	// Add your custom plugins here
	myBot.Router.AddMentionRoutes(how.GetMentionRoutes())

	// This launches your bot
	myBot.Run()
}
```

## What can this plugin do?

In your chat, you can perform the following actions:

* `how do I ...?` - Looks up a short answer to your question using wikihow.
	* Parameters: `...` above is any question you might want to ask, such as `how do I get rich?` where `...` is replaced with `get rich`.
