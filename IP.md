**SYSTEMS AND METHODS FOR DYNAMICALLY PRESENTING INTERFACES ACROSS VARIOUS SENSITIVE INPUTS BASED ON THE INTENDED USER OF THE SYTEM AND INTERFACE FROM AN ASSIGNED IDENTIFIER**

## TECHNICAL FIELD

The present disclosure relates to systems and methods for dynamically presenting interfaces across various sensitive inputs based on the intended user of the system and interface from an assigned identifier. In particular, the present disclosure relates to systems and methods for dynamically presenting interfaces when a user provides a signed payload of an assigned identity. The assigned identity is granted by the system itself, and need not live outside of the system, rather than a user presenting some possessed identifier for who they are. 

## BACKGROUND

In the early days of computing, the interface for computers were shared terminals, often physically located seperately from the computer itself. It quickly became clear there was a need for different users to have state saved for them, and so the login was introduced. Half a century later, we've forgotten that maybe doing things the way we did them in the sixties isn't the acme of human achievement. In 1995, SSH was developed which replaced the user login with asymmetric cryptography at the device level. This has been astonishingly useful as client-server architectures have developed, but when users started carrying around computers in their pockets, we missed the opportunity this presented for a better way.

## SUMMARY

First a consideration as to what constitutes an INTERFACE. Computing machines take INPUT, change state, and in some cases produce OUTPUT. INPUT can be tactile like a keyboard or touchscreen, auditory like voice commands, visual like eye tracking, and presumably olafactory or gustatory though I do not know of existing inputs for those senses. There also exist other sensory inputs like magnetometors, accelerometers, etc. A collection of one or more inputs is an interface.

A very simple example of the need for a MIST is accessibility on phones. A touchscreen doesn't do much good for someone who cannot touch the screen so providing an alternative means of input dynamically changes the interface. Some apps handle this better than others. And often these accessibility settings are at the device level. That makes sense for a personal device like a phone, but presents more challenges the more a device is shared.

Consider a wall-mounted shared family calendar. Is it practical to switch settings back and forth all the time? Is the toggle between touch and no-touch accessible enough that everyone can toggle it? 

Consider a voice-activated home assistant. Is there any way to interface with it without voice? If so, how does one present that as an option without exposing the home to attackers? 

Consider the calendar or message you don't necessarily want your kids to see. How do you ensure that's only accessible by you?

And finally, consider an always on machine in a public place that's somehow useful and protective of privacy. This doesn't exist because it's entirely unsafe to put one's login credentials into a public machine. So much so that it's even ill-advised to login to something at the library. 

All of this is due to one simple architectural design decision. When you login, you present who you are to the system. When you use a MIST, the system assigns to you an identifier within the system that need not map to who you are at all. The only thing needed for this is secure key storage on a personal device. We have that on nearly every phone made today, and more and more embedded boards are being produced with secure modules. 

A MIST can then adapt situationally based on environment and user. It can hold state or forget it after interfaced with. Since it's a system-level change it can change inputs entirely offering accessibility and/or increased ease of use. It opens a whole range of use-cases for home devices and embedded builds. 
