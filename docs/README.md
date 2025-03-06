---
layout: home
permalink: index.html

# Please update this with your repository name and project title
repository-name: e20-3yp-Smart-Locker-System
title: Smart Locker System
---

[comment]: # "This is the standard layout for the project, but you can clean this and use your own template"

# Secure X Smart Locker System
<!-- -->
![Secure X Smart Locker System](images/logo.png)



## Team
-  E/20/036, K.G.R.I. Bandara, [email](mailto:e20036@eng.pdn.ac.lk)
-  E/20/212, R.M.S.H. Kumarasinghe , [email](mailto:e20212@eng.pdn.ac.lk)
-  E/20/350, J.P.D.N. Sandamali, [email](mailto:e20350@eng.pdn.ac.lk)
-  E/20/377, V.P.H. Sidantha, [email](mailto:e20377@eng.pdn.ac.lk)

<!-- Image (photo/drawing of the final hardware) should be here -->

<!-- This is a sample image, to show how to add images to your page. To learn more options, please refer [this](https://projects.ce.pdn.ac.lk/docs/faq/how-to-add-an-image/) -->

<!-- ![Sample Image](./images/sample.png) -->

#### Table of Contents
1. [Introduction](#introduction)
2. [Solution Architecture](#solution-architecture )
3. [Hardware & Software Designs](#hardware-and-software-designs)
4. [Testing](#testing)
5. [Detailed budget](#detailed-budget)
6. [Conclusion](#conclusion)
7. [Links](#links)

## Introduction
![Video Title](https://youtu.be/E2n29waAydc))

The SmartSecure Locker System is a versatile and scalable IoT-based solution designed to provide secure and efficient storage in a variety of shared environments such as universities, gyms, offices and libraries. The system connects multiple locker locations, allowing users to check real-time availability via a mobile or web application. If lockers at a preferred location are fully occupied, the system intelligently suggests the nearest alternative location, offering a seamless and flexible user experience.

Access is secured through a figerprint sensor, ensuring safety and convenience. Users can reserve lockers, receive notifications, and navigate to alternative locations with ease. Administrators can manage locker usage and monitor the system through a centralized dashboard. This solution reduces theft risks, optimizes locker utilization, and provides a modern, adaptable storage system suitable for various community-driven environments.


## Solution Architecture

![High level diagram](images/HighLevelArchitecture.jpg)

This architecture integrates Web & Mobile Apps, a Cloud Database, and Locker Hardware to ensure secure and efficient locker management.

- Web App – Allows admins and users to manage lockers, track usage, and register users.
- Mobile App – Enables students to unlock lockers, check availability, and authenticate securely.
- Database (Cloud Storage) – Stores user data, locker status, and authentication credentials, ensuring real-time synchronization.
- Locker System (Hardware) – Equipped with microcontrollers and biometric scanners to authenticate users and unlock lockers.

Workflow

- Users register via the Web or Mobile App.
- The Locker System verifies users via biometrics and communicates with the Database.
- If authenticated, the locker unlocks, updating the status across all systems.

## Hardware and Software Designs

![Technology Stack](images/TechStack.jpg)

## Testing

Testing done on hardware and software, detailed + summarized results

## Time Line
![Timeline](images/Timeline.jpg)

## Detailed budget
<!-- -->
![Detailed budget](images/Budget1.png)


## Conclusion

What was achieved, future developments, commercialization plans

## Links

- [Project Repository](https://github.com/cepdnaclk/e20-3yp-Smart-Locker-System)
- [Project Page](https://cepdnaclk.github.io/e20-3yp-Smart-Locker-System/)
- [Department of Computer Engineering](http://www.ce.pdn.ac.lk/)
- [University of Peradeniya](https://eng.pdn.ac.lk/)

[//]: # (Please refer this to learn more about Markdown syntax)
[//]: # (https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
