# Multiplayer Basics Workshop for GodotCon Boston 2025
We will start with a sample 2D top down game, and add multiplayer to it. If you get stuck, see the branch `finished-product`.

## Adding Multiplayer
We start with a player that can move around, but in order to get into the castle we need a friend to join our game and help us open the door.

### 1. Set up our Game Tree
For single player games we usually have the player as a node inside of the level. For multiplayer, we want our game level to be seperate from the player, so that we can spawn multiple players.

### 1a. How to test locally?
In order to test multiplayer with only one computer, you can enable the setting for running multiple instances of your game. In the Godot Editor, in the top left menu, go to Debug > Customize Run Instances. 
Check the box to enable multiple instances and set the number to 2 instances. When you run the game next, two windows of your game should pop up.

Note that this project has the tile-instances addon installed, so the two windows should spawn side by side, helpful for rapid prototyping!
You will also probably want to disable the "Embed Game on Next Play" setting in the Game tab of the Godot Editor. 

### 2. Connect the Computers over the Network
To connect from one computer to the other, we will set up a host & client relationship. Our host will create a ENet server and our client will connect to the host.
[ENet](http://enet.bespin.org/index.html) is a library that provides reliable UDP networking. Godot has [wrappers for the ENet library](https://docs.godotengine.org/en/stable/classes/class_enetconnection.html) in its high level multiplayer features.

We will create a Server Interface node that will be home to all the code related to hosting and connecting to the server. The Server Interface node will connect and manage the logic of it's child nodes.
Create a node named EnetServer and a node named ServerConnector. These two nodes will have the logic for hosting a ENet Server, and connecting to an ENet Server.

When the host wants to start their server, through the EnetServer node they create a ENetMultiplayerPeer and call the `create_server(port, max_players)` function on it. They then store the newly created ENet peer in their `multiplayer` [MultiplayerAPI instance](https://docs.godotengine.org/en/4.4/classes/class_multiplayerapi.html#class-multiplayerapi). 

⚠ NOTE: To allow clients to connect from other networks (not LAN) you will need to port forward the port you are hosting on.

When a client wants to join the server, through the ServerConnector node they also create a ENetMultiplayerPeer and call the peer's `create_client(host_ip, port)` function. Once the multiplayer peer's client is created, the client will start connecting to the host's ip and port. 
