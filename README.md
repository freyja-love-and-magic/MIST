# MIST (Multi-user Interfacing SysTem)

As conceived, a MIST is the following:

> A Multi-user Interfacing System (MIST) is any computing device that allows multiple users to interface with it without a logging in mechanism nor persistence of the user. If you imagine an iPad app whereby a user can present identifying credentials via cryptography, that app can then construct an interface specific to the user, and the user can interact with the interface via touch or via input through the user's device.

> The MIST could refer to a network of MISTs deployed across a geography. In this way a user's experience could be handled through the cloud or a distributed database and presented to the user upon interfacing with a MIST terminal.

(this was the idea nearly a decade ago as of this writing)

## Motivation

Consider the following scenario: you're listening to a podcast in your kitchen, you head to your car that you share with a partner and want the podcast to continue, and then have that podcast keep playing on some device you keep on your desk so that you aren't using your phone at work. This is a totally reasonable expectation, but unfortunately this experience is often failing around different protocols like bluetooth, or the fact that you turned wifi off on your phone. 

Further, since the phone is serving as the hub of activity and authentication, it often requires us to interface with the phone while doing things we shouldn't be interrupting with screens, like driving, or paying attention to our partners and children. 

For terminology let's call the phone a CASTER and a device that responds to a request from a CASTER a TARGET. So in the above you might have a HomePod, CarPlay system, and a bluetooth speaker. Collectively those would be TARGETs. 

Casters in a MIST would be able to signify the user of the MIST they represent, and targets in a MIST would be able to respond to that information, and adapt themselves accordingly. Consider something as simple as changing the color scheme of a shared television set, to as involved as presenting one's morning routine on a shared display.

When logging in to shared devices, the credentials that provide for authorized activity are stored on those devices. Fine for home, but not great for travel or shared places like the office. By using [Sessionless][sessionless] instead, as soon as the caster is no longer around, the user is no longer represented. 

Because of the need for logins to map to the subsequent UX of the applications being interfaced with, UI/UX tends to be quite comparable between users. More preferences in content are surfaced. With a MIST, the credentials presented don't need to map to a subsequent UX. This allows for interfaces that span across visual and non-visual interfaces, and which can adapt to the specific needs of a user at a level outside of a single application.

As a MIST is a system, and not a device or application so you could imagine a MIST that is responsive to environment. This is somewhat the role that the phone is trying to fulfill, but without a way for the environment to present itself as a "user" the phone's user has to act as the intermediary. This is confusing and frustrating user experience since it presupposes a level of technical sophistication. 


