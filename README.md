<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure X Smart Locker System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: rgba(255, 255, 255, 0.95);
            margin-top: 20px;
            margin-bottom: 20px;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            margin: -20px -20px 40px -20px;
        }

        .header h1 {
            font-size: 3rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .logo-placeholder {
            width: 150px;
            height: 150px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            margin: 20px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }

        .team-section {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 15px;
            margin: 30px 0;
            border-left: 5px solid #667eea;
        }

        .team-section h2 {
            color: #667eea;
            margin-bottom: 20px;
            font-size: 2rem;
        }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 15px;
        }

        .team-member {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .team-member:hover {
            transform: translateY(-5px);
        }

        .team-member a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }

        .team-member a:hover {
            text-decoration: underline;
        }

        .toc {
            background: #e3f2fd;
            padding: 25px;
            border-radius: 15px;
            margin: 30px 0;
            border: 2px solid #667eea;
        }

        .toc h4 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }

        .toc ol {
            padding-left: 20px;
        }

        .toc li {
            margin: 8px 0;
        }

        .toc a {
            color: #333;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .toc a:hover {
            color: #667eea;
        }

        .section {
            margin: 40px 0;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
        }

        .section h2 {
            color: #667eea;
            font-size: 2.2rem;
            margin-bottom: 20px;
            border-bottom: 3px solid #667eea;
            padding-bottom: 10px;
        }

        .intro-video {
            text-align: center;
            margin: 30px 0;
        }

        .video-placeholder {
            width: 100%;
            max-width: 600px;
            height: 350px;
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            border-radius: 15px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            text-decoration: none;
            transition: transform 0.3s ease;
            box-shadow: 0 10px 30px rgba(238, 90, 36, 0.3);
        }

        .video-placeholder:hover {
            transform: scale(1.05);
        }

        .architecture-img, .tech-stack-img, .timeline-img, .budget-img {
            width: 100%;
            max-width: 800px;
            height: 400px;
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            margin: 20px auto;
            box-shadow: 0 10px 30px rgba(116, 185, 255, 0.3);
        }

        .workflow {
            background: #f1f3f4;
            padding: 25px;
            border-radius: 10px;
            margin: 20px 0;
        }

        .workflow h3 {
            color: #667eea;
            margin-bottom: 15px;
        }

        .workflow ul {
            padding-left: 20px;
        }

        .workflow li {
            margin: 10px 0;
            color: #555;
        }

        .links-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 15px;
            text-align: center;
        }

        .links-section h2 {
            color: white;
            border-bottom: 3px solid rgba(255, 255, 255, 0.3);
            margin-bottom: 30px;
        }

        .links-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .link-card {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            transition: transform 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .link-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.2);
        }

        .link-card a {
            color: white;
            text-decoration: none;
            font-weight: 500;
        }

        .feature-highlight {
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            padding: 30px;
            border-radius: 15px;
            margin: 20px 0;
            text-align: center;
        }

        .feature-highlight h3 {
            color: #2d3436;
            margin-bottom: 15px;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                padding: 15px;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .team-grid {
                grid-template-columns: 1fr;
            }
            
            .section {
                padding: 20px;
            }
        }

        .fade-in {
            animation: fadeIn 0.8s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container fade-in">
        <header class="header">
            <div class="logo-placeholder">🔐</div>
            <h1>Secure X Smart Locker System</h1>
            <p>IoT-based Secure Storage Solution</p>
        </header>

        <section class="team-section">
            <h2>👥 Team</h2>
            <div class="team-grid">
                <div class="team-member">
                    <strong>K.G.R.I. Bandara</strong><br>
                    E/20/036 | <a href="mailto:e20036@eng.pdn.ac.lk">📧 Email</a>
                </div>
                <div class="team-member">
                    <strong>R.M.S.H. Kumarasinghe</strong><br>
                    E/20/212 | <a href="mailto:e20212@eng.pdn.ac.lk">📧 Email</a>
                </div>
                <div class="team-member">
                    <strong>J.P.D.N. Sandamali</strong><br>
                    E/20/350 | <a href="mailto:e20350@eng.pdn.ac.lk">📧 Email</a>
                </div>
                <div class="team-member">
                    <strong>V.P.H. Sidantha</strong><br>
                    E/20/377 | <a href="mailto:e20377@eng.pdn.ac.lk">📧 Email</a>
                </div>
            </div>
        </section>

        <div class="toc">
            <h4>📋 Table of Contents</h4>
            <ol>
                <li><a href="#introduction">Introduction</a></li>
                <li><a href="#solution-architecture">Solution Architecture</a></li>
                <li><a href="#hardware-and-software-designs">Hardware & Software Designs</a></li>
                <li><a href="#testing">Testing</a></li>
                <li><a href="#detailed-budget">Detailed Budget</a></li>
                <li><a href="#conclusion">Conclusion</a></li>
                <li><a href="#links">Links</a></li>
            </ol>
        </div>

        <section id="introduction" class="section">
            <h2>🚀 Introduction</h2>
            
            <div class="intro-video">
                <a href="https://youtu.be/E2n29waAydc" class="video-placeholder" target="_blank">
                    ▶️ Watch Demo Video<br>
                    <small>Click to view on YouTube</small>
                </a>
            </div>

            <div class="feature-highlight">
                <h3>🎯 Key Features</h3>
                <p>Biometric Security • Real-time Availability • Multi-location Support • Mobile & Web Access</p>
            </div>

            <p>The SmartSecure Locker System is a versatile and scalable IoT-based solution designed to provide secure and efficient storage in a variety of shared environments such as universities, gyms, offices and libraries. The system connects multiple locker locations, allowing users to check real-time availability via a mobile or web application.</p>

            <p>If lockers at a preferred location are fully occupied, the system intelligently suggests the nearest alternative location, offering a seamless and flexible user experience. Access is secured through a fingerprint sensor, ensuring safety and convenience.</p>
        </section>

        <section id="solution-architecture" class="section">
            <h2>🏗️ Solution Architecture</h2>
            
            <div class="architecture-img">
                📊 High Level Architecture Diagram<br>
                <small>(Web App + Mobile App + Cloud Database + Hardware)</small>
            </div>

            <p>This architecture integrates Web & Mobile Apps, a Cloud Database, and Locker Hardware to ensure secure and efficient locker management.</p>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 20px 0;">
                <div style="background: #e8f5e8; padding: 20px; border-radius: 10px;">
                    <h4>🌐 Web App</h4>
                    <p>Admin and user management, usage tracking, user registration</p>
                </div>
                <div style="background: #e8f0ff; padding: 20px; border-radius: 10px;">
                    <h4>📱 Mobile App</h4>
                    <p>Locker unlocking, availability checking, secure authentication</p>
                </div>
                <div style="background: #fff5e6; padding: 20px; border-radius: 10px;">
                    <h4>☁️ Cloud Database</h4>
                    <p>User data, locker status, authentication credentials</p>
                </div>
                <div style="background: #f0e6ff; padding: 20px; border-radius: 10px;">
                    <h4>🔧 Hardware</h4>
                    <p>Microcontrollers, biometric scanners, secure unlocking</p>
                </div>
            </div>

            <div class="workflow">
                <h3>🔄 Workflow</h3>
                <ul>
                    <li>Users register via the Web or Mobile App</li>
                    <li>The Locker System verifies users via biometrics and communicates with the Database</li>
                    <li>If authenticated, the locker unlocks, updating the status across all systems</li>
                </ul>
            </div>
        </section>

        <section id="hardware-and-software-designs" class="section">
            <h2>⚙️ Hardware and Software Designs</h2>
            
            <div class="tech-stack-img">
                💻 Technology Stack Overview<br>
                <small>(Frontend, Backend, Database, Hardware Components)</small>
            </div>

            <p>Our system leverages modern technologies including IoT sensors, cloud computing, and mobile development frameworks to create a comprehensive locker management solution.</p>
        </section>

        <section id="testing" class="section">
            <h2>🧪 Testing</h2>
            <p>Comprehensive testing was conducted on both hardware and software components to ensure reliability, security, and performance. Testing includes unit tests, integration tests, security assessments, and user acceptance testing.</p>
            
            <div class="timeline-img">
                📅 Project Timeline<br>
                <small>(Development phases and milestones)</small>
            </div>
        </section>

        <section id="detailed-budget" class="section">
            <h2>💰 Detailed Budget</h2>
            
            <div class="budget-img">
                💵 Project Budget Breakdown<br>
                <small>(Hardware costs, development expenses, operational costs)</small>
            </div>

            <p>The budget includes hardware components, development tools, cloud services, and operational expenses required for the complete implementation of the Smart Locker System.</p>
        </section>

        <section id="conclusion" class="section">
            <h2>🎯 Conclusion</h2>
            <p>The Smart Locker System successfully demonstrates the integration of IoT technology with secure biometric authentication to solve real-world storage challenges. Future developments include AI-powered usage analytics, enhanced mobile features, and commercialization opportunities for educational institutions and corporate environments.</p>
        </section>

        <section id="links" class="links-section">
            <h2>🔗 Links</h2>
            <div class="links-grid">
                <div class="link-card">
                    <h4>📦 Project Repository</h4>
                    <a href="https://github.com/cepdnaclk/e20-3yp-Smart-Locker-System" target="_blank">View on GitHub</a>
                </div>
                <div class="link-card">
                    <h4>🌐 Project Page</h4>
                    <a href="https://cepdnaclk.github.io/e20-3yp-Smart-Locker-System/" target="_blank">Live Demo</a>
                </div>
                <div class="link-card">
                    <h4>🏛️ Department</h4>
                    <a href="http://www.ce.pdn.ac.lk/" target="_blank">Computer Engineering</a>
                </div>
                <div class="link-card">
                    <h4>🎓 University</h4>
                    <a href="https://eng.pdn.ac.lk/" target="_blank">University of Peradeniya</a>
                </div>
            </div>
        </section>
    </div>

    <script>
        // Add smooth scrolling for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Add fade-in animation on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        document.querySelectorAll('.section').forEach(section => {
            section.style.opacity = '0';
            section.style.transform = 'translateY(20px)';
            section.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(section);
        });
    </script>
</body>
</html>
