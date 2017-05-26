# ELMWEB
Could not manage to add a prefix to the message, thought about taking it from the NewChatMessage received from the server when login in and putting it
in the login attribute in model, but that would just make show everyone the last one logged in and all the messages would be with the last 
logged in prefix. Other option was addin one more property to the message, Command, Content, Prefix, but not sure if that is feasible.

One thing that I encoutered is that every time I refresh the page the server.js crashes, I believe it is something to do with the Encoding 
the input.

Here are the pictures:
<img src="https://image.prntscr.com/image/6ba5204fab1b4799ab4e1de31d33320c.png" width="350"/>
<img src="https://image.prntscr.com/image/7fc4a8b1a9e047699a9d20a34bb0af87.png" width="350"/>
<img src="https://image.prntscr.com/image/35b3d85b5ac546aa9fc4f51508f29b92.png" width="350"/>
